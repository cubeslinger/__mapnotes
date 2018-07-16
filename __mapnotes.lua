--
-- Addon       __map_notes.lua
-- Author      marcob@marcob.org
-- StartDate   06/05/2018
--
-- manonotesdb = {
--
-- t  =  {  idx         =  newnote.idx or self.lastidx,
--          label       =  newnote.label,
--          text        =  newnote.text,
--          category    =  newnote.category,
--          playerpos   =  {,
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
function __map_notes(basedb, customtbl)

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
--                print(string.format("__map_notes.loaddb: zone=%s: (%s)", b.playerpos.zonename, b.label))
--                print(string.format("__map_notes.loaddb: lastidx=%s, tbl.idx=%s", self.lastidx, b.idx))

--                print("__map_notes.loaddb: dump(b):", mano.f.dumptable(b))

               self.lastidx         =  math.max(self.lastidx, b.idx)
               self.lastnegativeidx =  math.min(self.lastnegativeidx, b.idx)
            end
         end
      end

      return
   end


--    local function getplayerposition()
   function self.getplayerposition()

      local t  =  {}
      local bool, playerdata = pcall(Inspect.Unit.Detail, "player")


      if bool  then
         t.x              = mano.f.rounddecimal(playerdata.coordX, 2)
         t.y              = mano.f.rounddecimal(playerdata.coordY, 2)
         t.z              = mano.f.rounddecimal(playerdata.coordZ, 2)
--          t.zone           = playerdata.zone
         t.locationName   = playerdata.locationName
         t.radius         = playerdata.radius
         t.name           = playerdata.name

--          local bool, zonedata = pcall(Inspect.Zone.Detail, t.zone)

         local bool, zonedata = pcall(Inspect.Zone.Detail, playerdata.zone)

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

--       print("getzonedata:\n", mano.f.dumptable(t))

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

   function self.getnotebyzoneandidx(zone, idx)

      local t  =  {}
--       if zone ~= nil and idx ~= nil and  self.notes[zonename] ~= nil and  next(self.notes[zonename]) then

      if zone ~= nil and idx ~= nil then

         local tbl   =  {}

         for _, tbl in pairs(self.notes[zone]) do
            print("getnotebyzoneandidx tbl:\n", mano.f.dumptable(tbl))
            if tbl.idx  == idx   then
               t  =  tbl
               print("getnotebyzoneandidx tbl:\n", mano.f.dumptable(t))
            end
         end
      end

      return t
   end

   function self.modify(zone2modify, idx, newdata)

      print(string.format("NOTE MODIFY: landing...: zone2modify=%s idx=%s newdata=%s", zone2modify, idx, newdata))

      local TBL  =  {}

      if zone2modify ~= nil and idx ~= nil then

         if self.notes[zone2modify] ~= nil and next(self.notes[zone2modify]) ~= nil then

            local note        =  {}

            for _, note in pairs(self.notes[zone2modify]) do

               print(string.format("MODIFY: zonename=%s note.idx=%s", zone2modify, note.idx))


               print(string.format("if %s == %s", note.idx, idx))

               -- MODIFY/DELETE
               if note.idx == idx then

                  -- modify, delete if newdata is empty
                  if newdata ~= nil and next(newdata) ~= nil then
--                      table.insert(TBL, { newdata })
                     table.insert(TBL, newdata)
                     print("IT IS our IDX, adding to TBL modifyed")
                  else
                     print("DELETING")
                  end

               else
                  print("not our IDX, adding to tTBL")
--                   table.insert(TBL, { note })
                  table.insert(TBL, note)
               end

            end

            print("new TBL:\n", mano.f.dumptable(TBL))

            if next(TBL) ~= nil then
               print("NEW DATA for zone " ..zone2modify.." INJECTED")
               self.notes[zone2modify] = TBL
            end

         end
      end

      return newdata
   end

   function self.delete(zone2modify, idx)

      print("NOTE DELETE: landing...")

      local t  =  self.modify(zone2modify, idx, nil)

      return t
   end

   -- newnote = { label, text, category, playerpos={}, idx, timestamp }
   function self.new(newnote, customtbl)

      local t  =  {}

      if newnote ~= nil or next(newnote) ~= nil then

         if newnote.playerpos == nil or next(newnote.playerpos) == nil then
            playerpos   =  self.getplayerposition()
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
                        customtbl   =  customtbl,
                     }

               table.insert(self.notes[playerpos.zonename], t)

--                print(string.format("-- POST\n label=%s\n text=%s\n category=%s\n playerpos=%s\n idx=%s\n timestamp=%s\n zone=%s",
--                                     t.label, t.text, t.category, t.playerpos, t.idx, t.timestamp, t.playerpos.zonename))

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

