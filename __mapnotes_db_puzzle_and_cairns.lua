--
-- Addon       _mano_db_puzzles_cairns.lua
-- Author      marcob@marcob.org
-- StartDate   29/05/2018
--
-- Expansion:  Mathosia
-- Source:     http://www.kfguides.com/rift/puzzlesguide.php
-- Credits:    Krinadon and Faiona, or KFGuides (Support@KFGuides.com)
--
-- Expansion:  Storm Legion - Cairns
-- Source:     http://archive.riftscene.com/guides/achievements/cairn-do-too-storm-legion-cairns/
-- Credits:    Cupcakes
--
-- Data:       Storm Legion - Puzzles
-- Source:     http://tmrguides.blogspot.com/
--
-- Format:     {
--                label="puzzle/cairn name",
--                location="zone Name",
--                location=["es.: Lake of Solace"],
--                x=nn,
--                z=nn,
--                y=[nn],
--                text=["...mi favourite fishing spot..."]
--             }
--
--             ONLY fields between [] may be missing.
--
-- local addon, mano = ...

function __externaldbs()
   -- the new instance
   local self =   {
--                      index       =  -1,
                     id2zonename =  {},
                     zonename2id =  {},
                     puzzles     =  {},
                     cairns      =  {},
                  }
      -- public fields go in the instance table

   self.zonename2id  =  {  ["Meridian"]               =  'z6BA3E574E9564149',
                           ["Morban"]                 =  'z39095BA75AD7DC03',
                           ["Silverwood"]             =  'z0000000CB7B53FD7',
                           ["Gloamwood"]              =  'z0000001B2BB9E10E',
                           ["Scarlet Gorge"]          =  'z019595DB11E70F58',
                           ["Freemarch"]              =  'z00000013CAF21BE3',
                           ["Stonefield"]             =  'z585230E5F68EA919',
                           ["Scarwood Reach"]         =  'z000000142C649218',
                           ["Droughtlands"]           =  'z1416248E485F6684',
                           ["Iron Pine Peak"]         =  'z00000016EB9ECBA5',
                           ["Shimmersand"]            =  'z000000069C1F0227',
                           ["Stillmoor"]              =  'z0000001A4AF8CD7A',
                           ["Ember Isle"]             =  'z76C88A5A51A38D90',
                           ["Ardent Domain"]          =  'z563CB77E4A32233F',
                           ["City Core"]              =  'z754553DD46F46371',
                           ["Eastern Holdings"]       =  'z48530386ED2EA5AD',
                           ["Seratos"]                =  'z59124F7DD7F15825',
                           ["Kingsward"]              =  'z4D8820D7EF52685C',
                           ["The Dendrome"]           =  'z10D7E74AB6D7B293',
                           ["Moonshade Highlands"]    =  'z0000001804F56C61',
                           ["Cape Jule"]              =  'z698CB7B72B3D69E9',
                           ["Ashora"]                 =  'z2F1E4708BEC6A608',
                           ["Kingdom of Pelladane"]   =  'z1C938C07F41C83CC',
                           ["Steppes of Infinity"]    =  'z2F9C9E1FF91F9293',
                        }

   self.id2zonename  =  {  ['z6BA3E574E9564149']      =  "Meridian",
                           ['z39095BA75AD7DC03']      =  "Morban",
                           ['z0000000CB7B53FD7']      =  "Silverwood",
                           ['z0000001B2BB9E10E']      =  "Gloamwood",
                           ['z019595DB11E70F58']      =  "Scarlet Gorge",
                           ['z00000013CAF21BE3']      =  "Freemarch",
                           ['z585230E5F68EA919']      =  "Stonefield",
                           ['z000000142C649218']      =  "Scarwood Reach",
                           ['z1416248E485F6684']      =  "Droughtlands",
                           ['z00000016EB9ECBA5']      =  "Iron Pine Peak",
                           ['z000000069C1F0227']      =  "Shimmersand",
                           ['z0000001A4AF8CD7A']      =  "Stillmoor",
                           ['z76C88A5A51A38D90']      =  "Ember Isle",
                           ['z563CB77E4A32233F']      =  "Ardent Domain",
                           ['z754553DD46F46371']      =  "City Core",
                           ['z48530386ED2EA5AD']      =  "Eastern Holdings",
                           ['z59124F7DD7F15825']      =  "Seratos",
                           ['z4D8820D7EF52685C']      =  "Kingsward",
                           ['z10D7E74AB6D7B293']      =  "The Dendrome",
                           ['z0000001804F56C61']      =  "Moonshade Highlands",
                           ['z698CB7B72B3D69E9']      =  "Cape Jule",
                           ['z2F1E4708BEC6A608']      =  "Ashora",
                           ['z1C938C07F41C83CC']      =  "Kingdom of Pelladane",
                           ['z2F9C9E1FF91F9293']      =  "Steppes of Infinity",
                        }

   self.puzzles   =  {  ["Silverwood"]       =  {  label="Puzzled at the Top of the World",  category="Puzzles",	y=0,	x=6515,  z=3080   },
                        ["Gloamwood"]        =  {  label="Shield Wall",                      category="Puzzles",	y=0,	x=4540,  z=2382   },
                        ["Scarlet Gorge"]    =  {  label="A Barrel of Laughs",               category="Puzzles",	y=0,	x=3619,  z=2775   },
                        ["Freemarch"]        =  {  label="Lake Solace",                      category="Puzzles",	y=0,	x=5998,  z=6141   },
                        ["Stonefield"]       =  {  label="Spinning Plates",                  category="Puzzles",	y=0,	x=4577,  z=4974   },
                        ["Scarwood Reach"]   =  {  label="Scarwood by Torchlight",           category="Puzzles",	y=0,	x=3123,  z=4426   },
                        ["Droughtlands"]     =  {  label="Don’t be Cagey",                   category="Puzzles",	y=0,	x=8335,  z=6200   },
                        ["Iron Pine Peak"]   =  {  label="Tracks in the Snow",               category="Puzzles",	y=0,	x=3760,  z=2266   },
                        ["Shimmersand"]      =  {  label="The Peg Solitaire",                category="Puzzles",	y=0,	x=6414,  z=7714   },
                        ["Stillmoor"]        =  {  label="Herding Bats",                     category="Puzzles",	y=0,	x=1705,  z=2310   },
                        ["Ember Isle"]       =  {  label="Emerald Enigma",                   category="Puzzles",	y=0,	x=12823, z=3857   },
                        ["Ardent Domain"]    =  {  label="Circuit Diagrams",                 category="Puzzles",	y=0,	x=5988,  z=10744,
                                                   text="Artifact Set Required: Circuit Diagrams (12)",        },
                        ["City Core"]        =  {  label="A Knight's Tour",                  category="Puzzles",	y=0,	x=6984,  z=10036,
                                                   text="Artifact Set Required: A Knight's Tour (6)",          },
                        ["Eastern Holdings"] =  {  label="M'doidoi Dolls",                   category="Puzzles",	y=0,	x=8800,  z=8750,
                                                   text="Artifact Set Required: M'doidoi Dolls (9) (bottom of the pond has a portal)", },
                        ["Seratos"]          =  {  label="Seeing Dots",                      category="Puzzles",	y=0,	x=11400, z=6280,
                                                   text="Artifact Set Required: Seeing Dots, 3 Blob of Ectoplasm (found in NW Ardent Domain)",  },
                        ["Kingsward"]        =  {  label="Queen's Gambit",                   category="Puzzles",	y=0,	x=4813,  z=8675,
                                                   text="Artifact Set Required: Queen's Gambit (12)",          },
                        ["Morban"]           =  {  label="Black Box",                        category="Puzzles",	y=0,	x=12700, z=7450,
                                                   text="Artifact Set Required: Black Box",                    },
                        ["The Dendrome"]     =  {  label="Snake Eyes",                       category="Puzzles",	y=0,	x=4410,  z=4240,
                                                   text="Artifact Set Required: Snake Eyes, 10 Glowing Rootballs (attained from watching puppet shows in Hailol)",   },
                     }


   self.cairns =   { ["Freemarch"]  =  {  label="Discarded Strongbox",     location="Lake of Solace",  category="Cairns",	y=0,	x=5626, z=5685 },
                     ["Freemarch"]  =  {  label="Forgotten Casket",        location="Lake of Solace",  category="Cairns",	y=0,	x=5449, z=6009 },
                     ["Freemarch"]  =  {  label="Plundered Safe",          location="Lake of Solace",  category="Cairns",	y=0,	x=5560, z=6233 },
                     ["Freemarch"]  =  {  label="Lost Soul",               location="Lake of Solace",  category="Cairns",	y=0,	x=5872, z=6223 },
                     ["Freemarch"]  =  {  label="Weed Covered Vase",       location="Lake of Solace",  category="Cairns",	y=0,	x=6029, z=6509,   text="DO THIS ONE LAST!" },
                     ["Freemarch"]  =  {  label="Heavy Metal Barrel",      location="Lake of Solace",  category="Cairns",	y=0,	x=6311, z=6228 },
                     ["Freemarch"]  =  {  label="Sunken Cargo",            location="Lake of Solace",  category="Cairns",	y=0,	x=6708, z=5987 },
                     ["Freemarch"]  =  {  label="Old Chest",               location="Lake of Solace",  category="Cairns",	y=0,	x=6430, z=6430 },
                     ["Stonefied"]  =  {  label="Cairn of Bahar Farwind",                              category="Cairns",	y=0,	x=5898, z=5033,
                                          text="This is considered a Freemarch Cairn. It caps at Level 30" },
                     ["Stonefied"]  =  {  label="Cairn of Nasreen Tahleed",            category="Cairns",	y=0,	x=5327, z=5364 },
                     ["Stonefied"]  =  {  label="Cairn of Valta Cliftswind",           category="Cairns",	y=0,	x=4664, z=5006 },
                     ["Glomwood"]           =  {  label="Cairn of Nylaan Starhearth", category="Cairns",	y=0,	x=5576, z=3210 },
                     ["Scarlet Gorge"]      =  {  label="Cairn of Faraz Massi",       category="Cairns",	y=0,	x=4654, z=3097 },
                     ["Scarwood Reach"]     =  {  label="Cairn of Engel Malik",       category="Cairns",	y=0,	x=4075, z=4443 },
                     ["Moonshade Highlands"]=  {  label="Cairn of Roma Ga",           category="Cairns",	y=0,	x=5348, z=2239 },
                     ["Droughtlands"]       =  {  label="Cairn of Mongo Vachir",      category="Cairns",	y=0,	x=9161, z=6927 },
                     ["Iron Pine Peak"]     =  {  label="Cairn of Harwin Kalmar",     category="Cairns",	y=0,	x=4980, z=1865 },
                     ["Shimmersand"]        =  {  label="Cairn of Qara Chuluun",      category="Cairns",	y=0,	x=7535, z=7170 },
                     ["Stillmoor"]          =  {  label="Cairn of Thera Valnir",      category="Cairns",	y=0,	x=1585, z=1862 },
                     ["Cape Jule"]          =  {  label="Ina'eme Sarus",              category="Cairns",	y=0,	x=7438,  z=12194 },
                     ["Cape Jule"]          =  {  label="Queny Sulgar",               category="Cairns",	y=0,	x=7765,  z=11041 },
                     ["Cape Jule"]          =  {  label="Asha Tonavar",               category="Cairns",	y=0,	x=6436,  z=11015 },
                     ["City Core"]          =  {  label="Nunmemph Batshinshi",        category="Cairns",	y=0,	x=7266,  z=9340 },
                     ["City Core"]          =  {  label="Warsul Icero",               category="Cairns",	y=0,	x=7096,  z=8585 },
                     ["City Core"]          =  {  label="Irque Guemech",              category="Cairns",	y=0,	x=7168,  z=8303 },
                     ["Eastern Holdings"]   =  {  label="Oryp Namap",                 category="Cairns",	y=0,	x=7534,  z=8879 },
                     ["Eastern Holdings"]   =  {  label="Tathon I'rilgar",            category="Cairns",	y=0,	x=8090,  z=9626 },
                     ["Eastern Holdings"]   =  {  label="Banald Warver",              category="Cairns",	y=0,	x=9096,  z=8384 },
                     ["Ardent Domain"]      =  {  label="Yer'shyi Att",               category="Cairns",	y=0,	x=5844,  z=9834 },
                     ["Ardent Domain"]      =  {  label="Riduf Enthurn",              category="Cairns",	y=0,	x=4830,  z=10189 },
                     ["Kingsward"]          =  {  label="Niey Tiran",                 category="Cairns",	y=0,	x=6231,  z=7240 },
                     ["Kingsward"]          =  {  label="Isbur Oughverund",           category="Cairns",	y=0,	x=5601,  z=8070 },
                     ["Kingsward"]          =  {  label="Skeltorard Perdyn",          category="Cairns",	y=0,	x=4066,  z=9072 },
                     ["Ashora"]             =  {  label="Okalu Prev",                 category="Cairns",	y=0,	x=4063,  z=7123 },
                     ["Ashora"]             =  {  label="Omoosi Itnal",               category="Cairns",	y=0,	x=2678,  z=7117 },
                     ["Ashora"]             =  {  label="Orn Tonall",                 category="Cairns",	y=0,	x=2083,  z=6035 },
                     ["The Dendrome"]       =  {  label="Morbur Atl Itther",          category="Cairns",	y=0,	x=2960,  z=4555 },
                     ["The Dendrome"]       =  {  label="Uomu Tonig",                 category="Cairns",	y=0,	x=3988,  z=5925 },
                     ["The Dendrome"]       =  {  label="Ildbur Reled",               category="Cairns",	y=0,	x=4539,  z=4273 },
                     ["Kingdom of Pelladane"]= {  label="Omight Tonig",               category="Cairns",	y=0,	x=8484,  z=5896 },
                     ["Kingdom of Pelladane"]= {  label="Tirror Awaya",               category="Cairns",	y=0,	x=7455,  z=4077 },
                     ["Seratos"]            =  {  label="Vesdar Doc",                 category="Cairns",	y=0,	x=10593, z=4800 },
                     ["Seratos"]            =  {  label="Sayiss Vernys",              category="Cairns",	y=0,	x=11257, z=3610 },
                     ["Morban"]             =  {  label="Osm",                        category="Cairns",	y=0,	x=12333, z=4715 },
                     ["Morban"]             =  {  label="Urari Urari",                category="Cairns",	y=0,	x=12641, z=7346 },
                     ["Morban"]             =  {  label="Lunibe",                     category="Cairns",	y=0,	x=15702, z=6066 },
                     ["Steppes of Infinity"]=  {  label="Fevok Beleen",               category="Cairns",	y=0,	x=15592, z=7395 },
                  }

--    function self.filldbs()
--
--       local localdb  =  {}
--
--       for _, table in pairs({ self.cairns, self.puzzles}) do
--          for zonename, tbl in pairs(table) do
--             local noterecord     =  mano.mapnote.new( {  label       =  tbl.label,
--                                                          text        =  tbl.text,
--                                                          category    =  tbl.category,
--                                                          playerpos   =  {  coordX         =  tbl.x,
--                                                                            coordY         =  tbl.y or nil,
--                                                                            coordZ         =  tbl.z,
--                                                                            locationName   =  tbl.location or nil,
--                                                                            name           =  "forums",
--                                                                            radius         =  mano.default.radius,
--                                                                            zoneid         =  tbl.zoneid or  mano.db.zonename2id[zonename],
--                                                                            zonename       =  zonename,
--                                                                         },
--                                                          idx         =  self.index,
--                                                          timestamp   =  os.time(),
--                                                       }
--                                                    )
--             self.index  =  self.index - 1
--
--             table.insert(localdb, noterecord)
--          end
--       end
--
--       return
--    end

   return self
end
