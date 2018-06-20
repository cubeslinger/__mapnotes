--
-- Addon       __map_notes.lua
-- Author      marcob@marcob.org
-- StartDate   06/05/2018
--
local addon, mano = ...

-- manonotesdb = {
--    Meridian = {
--                {
--                   category = "default",
--                   idx = 4,
--                   playerpos = {
--                      coordX = 5988.4799804688,
--                      coordY = 912.72998046875,
--                      coordZ = 5258.6997070312,
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


--
function __map_notes(basedb)

   local self =   {
                  notes          =  {},
                  extnotes       =  {},
                  lastidx        =  0,
                  lastnegativeidx=  0,
                  extdbhandler   =  __externaldbs(),
                  default        =  {  radius   =  0.5,  }
                  }

   local function tablemerge(a, b)
      if type(a) == 'table' and type(b) == 'table' then
         for k,v in pairs(b) do
            if type(v)=='table' and type(a[k] or false)=='table' then
               merge(a[k],v) else a[k]=v
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

   local function fillextdb()

      local localdb  =  {}
      local index    =  0

      for _, table in pairs({ self.extdbhandler.cairns, self.extdbhandler.puzzles}) do
         for zonename, tbl in pairs(table) do

            index  =  index - 1

            local noterecord     =  self.new( { label       =  tbl.label,
                                                text        =  tbl.text,
                                                category    =  tbl.category,
                                                playerpos   =  {  coordX         =  tbl.x,
                                                                  coordY         =  tbl.y or nil,
                                                                  coordZ         =  tbl.z,
                                                                  locationName   =  tbl.location or nil,
                                                                  name           =  "forums",
                                                                  radius         =  self.default.radius,
                                                                  zoneid         =  tbl.zoneid or  self.extdbhandler.zonename2id[zonename],
                                                                  zonename       =  zonename,
                                                               },
                                                idx         =  index,
                                                timestamp   =  os.time()
                                             }
                                          )
--             table.insert(localdb, noterecord)
            print(string.format("fillextdb: index=(%s) label=(%s)", index, tbl.label))
         end
      end

--       return   localdb
      return
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
               print(string.format("__map_notes.loaddb: b=%s", b))
               print(string.format("__map_notes.loaddb: lastidx=%s, tbl.idx=%s", self.lastidx, b.idx))

--                print("__map_notes.loaddb: dump(b):", mano.f.dumptable(b))

               self.lastidx         =  math.max(self.lastidx, b.idx)
               self.lastnegativeidx =  math.min(self.lastnegativeidx, b.idx)
            end
         end
      end

      if self.lastnegativeidx > -1	then
         fillextdb()
      end

      return
   end


   local function getplayerposition()

      local t  =  {}
      local bool, playerdata = pcall(Inspect.Unit.Detail, "player")


      if bool  then
         t.coordX         = playerdata.coordX
         t.coordY         = playerdata.coordY
         t.coordZ         = playerdata.coordZ
         t.zone           = playerdata.zone
         t.locationName   = playerdata.locationName
         t.radius         = playerdata.radius
         t.name           = playerdata.name

         local bool, zonedata = pcall(Inspect.Zone.Detail, t.zone)

         t.zonename  =  (zonedata.name or nil)
         t.zoneid    =  (zonedata.id   or nil)
         t.zonetype  =  (zonedata.type or nil)
      end

      return t
   end

   function self.getzonedata(zonename)
--       print(string.format("self.getzonedata(%s)", zonename))
      local t  =  {}

--       print("self.getzonedata:", mano.f.dumptable(self.notes))

      if zonename ~= nil then
         if self.notes[zonename] ~= nil then
            t  =  self.notes[zonename]
--             print(string.format("self.getzonedata(%s) returning (%s) notes", zonename, countarray(t)))
--             print("", mano.f.dumptable(t))
         else
            print(string.format("self.getzonedata(%s) is == nil", zonename))
         end

         if self.extnotes[zonename] ~= nil then
         end
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

--    function self.new(notetext, notecategory)
   -- t = { label=, text=, category=, palyerpos={}, idx=n, timestamp }
   function self.new(newnote)

      print("mapnote.new: ", mano.f.dumptable(newnote))

      local t  =  {}

      if self.notes  == nil or not next(self.notes) then
         loaddb()
      end

      if t ~= nil or next(t) ~= nil then
         local label, text, category, playerpos, idx, timestamp   =  unpack(newnote)


         if playerpos == nil or next(playerpos) == nil then
            playerpos   =  getplayerposition()
         end

         if next(playerpos) then

            if idx == nil then
               self.lastidx   =  self.lastidx   +  1
            end

            if text ~= nil then

               if not self.notes[playerpos.zonename]  then
                  self.notes[playerpos.zonename]   =  {}
               end

               t  =  {  idx         =  idx or self.lastidx,
                        text        =  text or "Lorem Ipsum",
                        category    =  category,
                        playerpos   =  playerpos,
                        timestamp   =  timestamp or os.time(),
                     }

               if idx   >  0  then
                  table.insert(self.notes[playerposition.zonename], t)
               else
                  table.insert(self.extnotes[playerposition.zonename], t)
               end

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

   loaddb(basedb or nil)

   -- return the class instance
   return self

end

