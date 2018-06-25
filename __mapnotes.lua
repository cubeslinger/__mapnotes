--
-- Addon       __map_notes.lua
-- Author      marcob@marcob.org
-- StartDate   06/05/2018
--
-- manonotesdb = {
--    Meridian = {
--                {
--                   category = "default",
--                   idx = 4,
--                   playerpos = {
--                      x = 5988.4799804688,
--                      y = 912.72998046875,
--                      z = 5258.6997070312,
--                      locationName = "The Manufactory",
--                      name = "Bouncingblaze",
--                      radius = 0.52499997615814,
--                      zone = "z6BA3E574E9564149",
--                      zoneid = "z6BA3E574E9564149",
--                      zonename = "Meridian"
--                   },
--                   text = "Pipap Normale",
--                   timestamp = 1529408609
--                }
--              }
--              }

-- t  =  {  idx         =  newnote.idx or self.lastidx,
--          label       =  newnote.label,
--          text        =  newnote.text,
--          category    =  newnote.category,
--          playerpos   =  playerpos,
--                         y              =  tbl.y or nil,
--                         x              =  tbl.x,
--                         z              =  tbl.z,
--                         locationName   =  tbl.location or nil,
--                         name           =  "forums",
--                         radius         =  self.default.radius,
--                         zoneid         =  tbl.zoneid or  self.extdbhandler.zonename2id[zonename],
--                         zonename       =  zonename,
--                         },
--          timestamp   =  newnote.timestamp or os.time(),
--       }
--
local addon, mano = ...
--
function __map_notes(basedb)

   local self =   {
                  notes          =  {},
                  lastidx        =  0,
                  lastnegativeidx=  0,
--                   extdbhandler   =  __externaldbs(),
                  default        =  {  radius   =  0.5,  },
                  db             =  {},
                  initialized    =  false,
                  }

   local function tablemerge(a, b)
      if type(a) == 'table' and type(b) == 'table' then
         for k,v in pairs(b) do
--             if type(v)=='table' and type(a[k] or false)=='table' then
--                tablemerge(a[k],v) else a[k]=v
--             end
            if type(v)=='table' then
               if type(a[k])  == 'table' then
                  tablemerge(a[k],v)
               else
                  if a[k] == nil then
                     a[k] = v
                  else
                     tables.insert(a[k], v)
                  end
               end
            end
         end
      end

      return a
   end

   local function countarray(array)

      local k, v  =  nil, nil
      local count =  0
      local t     =  array

      if array then
         for k, v in pairs(array) do count = count +1 end
      end

      return count
   end

   local function loaddb(db)

      if db ~= nil and next(db) ~= nil then
         self.notes     =  db
      else
         self.notes     =  {}
      end

      -- Seek lastidx used (highest)
      local tbl, idx = {}, nil
      for _, tbl in pairs(self.notes) do
         for _, b in pairs(tbl) do
            if b.idx ~= nil then
               print(string.format("__map_notes.loaddb: zone=%s: (%s)", b.playerpos.zonename, b.label))
               print(string.format("__map_notes.loaddb: lastidx=%s, tbl.idx=%s", self.lastidx, b.idx))

--                print("__map_notes.loaddb: dump(b):", mano.f.dumptable(b))

               self.lastidx         =  math.max(self.lastidx, b.idx)
               self.lastnegativeidx =  math.min(self.lastnegativeidx, b.idx)
            end
         end
      end

      return
   end


   local function getplayerposition()

      local t  =  {}
      local bool, playerdata = pcall(Inspect.Unit.Detail, "player")


      if bool  then
         t.x              = playerdata.coordX
         t.y              = playerdata.coordY
         t.z              = playerdata.coordZ
         t.zone           = playerdata.zone
         t.locationName   = playerdata.locationName
         t.radius         = playerdata.radius
         t.name           = playerdata.name

         local bool, zonedata = pcall(Inspect.Zone.Detail, t.zone)

         t.zonename  =  (zonedata.name or nil)
         t.zoneid    =  (zonedata.id   or nil)
         t.zonetype  =  (zonedata.type or nil)
      else
         print("getplayerposition(): ERROR: pcall(Inspect.Unit.Detail, \"player\") FAILED!")
      end

      return t
   end

   function self.getzonedata(zonename)

      local t  =  {}

--       print("self.getzonedata:", mano.f.dumptable(self.notes))

      if zonename ~= nil then
         
         -- User Notes
         if self.notes[zonename] ~= nil  and next(self.notes[zonename]) ~= nil then t  =  self.notes[zonename] end

--          -- Puzzles
--          if self.db.puzzles.db[zonename] ~= nil and next(self.db.puzzles.db[zonename]) ~= nil then
-- 
--             local dummy, tbl = nil, {}
--             for dummy, tbl in ipairs(self.db.puzzles.db[zonename]) do   table.insert(t, tbl) end
--             print("self.db.puzzles.db[".. zonename .."]\n", mano.f.dumptable(self.db.puzzles.db[zonename]))
--          end
-- 
--          if self.db.cairns.db[zonename] ~= nil and next(self.db.cairns.db[zonename]) ~= nil then
--             
--             local dummy, tbl = nil, {}
--             for dummy, tbl in ipairs(self.db.cairns.db[zonename]) do    table.insert(t, tbl) end
--             print("self.db.cairns.db[".. zonename .."]\n", mano.f.dumptable(self.db.cairns.db[zonename]))
--          end
      else
         print("self.getzonedata:zonename: zonename is nil!")
      end

      return t
   end

   function self.getzonedatabyid(zoneid)
--       print(string.format("self.getzonedatabyid(%s)", zoneid))
      local t   =  {}

      if zoneid ~= nil then
         local zone  =  Inspect.Zone.Detail(zoneid)
         t           =  self.getzonedata(zone.name)
      end

      return   t
   end

   -- t = { label=, text=, category=, playerpos={}, idx=n, timestamp }
   function self.new(newnote)

      local t  =  {}

      if newnote ~= nil or next(newnote) ~= nil then
         print(string.format("-- PRE\n label=%s\n text=%s\n category=%s\n playerpos=%s\n idx=%s\n timestamp=%s", newnote.label, newnote.text, newnote.category, newnote.playerpos, newnote.idx, newnote.timestamp))


         if newnote.playerpos == nil or next(newnote.playerpos) == nil then
            playerpos   =  getplayerposition()
         else
            playerpos   =  newnote.playerpos
         end

         if next(playerpos) then

            if newnote.idx == nil then
               self.lastidx   =  self.lastidx   +  1
            end

            if newnote.label ~= nil or newnote.text ~=nil then

               if not self.notes[playerpos.zonename]  then
                  self.notes[playerpos.zonename]   =  {}
               end

               t  =  {  idx         =  newnote.idx or self.lastidx,
                        label       =  newnote.label,
                        text        =  newnote.text,
                        category    =  newnote.category,
                        playerpos   =  playerpos,
                        timestamp   =  newnote.timestamp or os.time(),
                     }

               table.insert(self.notes[playerpos.zonename], t)

               print(string.format("-- POST\n label=%s\n text=%s\n category=%s\n playerpos=%s\n idx=%s\n timestamp=%s\n zone=%s",
                                    t.label, t.text, t.category, t.playerpos, t.idx, t.timestamp, t.playerpos.zonename))

            end

         else
            print("__map_notes ERROR: can't determinate Player position, skipping note.")
         end
      else
         print("__map_notes.new(newnote) ERROR: newnote is empty or nil")
      end

--       return self.lastidx
      return t
   end

   if not self.initialized then
      loaddb(basedb or nil)
--       self.db.puzzles   =  __puzzles()
--       self.db.cairns    =  __cairns()
      self.initialized  =  true
   end

   -- return the class instance
   return self

end

