return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.3",
  orientation = "orthogonal",
  renderorder = "left-down",
  width = 25,
  height = 11,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 13,
  nextobjectid = 19,
  properties = {},
  tilesets = {
    {
      name = "sol1",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 6,
      image = "../Graphs/sol1.png",
      imagewidth = 192,
      imageheight = 224,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 42,
      tiles = {
        {
          id = 33,
          animation = {
            {
              tileid = 33,
              duration = 100
            },
            {
              tileid = 34,
              duration = 100
            },
            {
              tileid = 35,
              duration = 100
            }
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 11,
      name = "sol",
      x = 0,
      y = 0,
      width = 25,
      height = 11,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 0, 21, 21, 21, 21, 21, 21, 21, 21, 21, 0,
        0, 21, 25, 26, 26, 26, 27, 21, 25, 26, 26, 26, 27, 21, 0, 21, 25, 26, 26, 26, 26, 26, 27, 21, 0,
        0, 21, 31, 32, 32, 32, 33, 21, 31, 32, 32, 32, 33, 21, 0, 21, 37, 38, 38, 38, 38, 38, 39, 21, 0,
        0, 21, 37, 38, 38, 38, 39, 21, 37, 38, 38, 38, 39, 21, 0, 21, 21, 21, 21, 21, 21, 21, 21, 21, 0,
        0, 21, 21, 21, 21, 21, 21, 10, 21, 21, 21, 21, 21, 21, 0, 21, 21, 21, 21, 21, 21, 0, 0, 0, 0,
        0, 21, 25, 26, 26, 26, 27, 21, 25, 26, 26, 26, 27, 21, 0, 21, 25, 26, 26, 27, 21, 0, 0, 0, 0,
        0, 21, 31, 32, 32, 32, 33, 21, 31, 32, 32, 32, 33, 21, 0, 21, 31, 32, 21, 33, 21, 0, 0, 0, 0,
        0, 21, 37, 38, 38, 38, 39, 21, 37, 38, 38, 38, 39, 21, 0, 21, 37, 38, 38, 39, 21, 0, 0, 0, 0,
        0, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 0, 21, 21, 21, 21, 21, 21, 21, 21, 21, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 12,
      name = "mur",
      x = 0,
      y = 0,
      width = 25,
      height = 11,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22,
        22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22,
        22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22,
        22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22,
        22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22,
        22, 0, 0, 0, 0, 0, 0, 34, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 22, 22, 22, 22,
        22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 21, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0,
        22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0,
        22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 22, 22, 22, 22,
        22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22,
        22, 22, 22, 22, 22, 22, 22, 0, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22
      }
    },
    {
      type = "objectgroup",
      id = 2,
      name = "collisions",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "collide",
          shape = "rectangle",
          x = 32,
          y = 0,
          width = 416,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "collide",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 32,
          height = 352,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "collide",
          shape = "rectangle",
          x = 448,
          y = 0,
          width = 32,
          height = 192,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "collide",
          shape = "rectangle",
          x = 32,
          y = 320,
          width = 192,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "collide",
          shape = "rectangle",
          x = 256,
          y = 320,
          width = 192,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "collide",
          shape = "rectangle",
          x = 224,
          y = 160,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 448,
          y = 224,
          width = 32,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 0,
          width = 320,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 768,
          y = 32,
          width = 32,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 672,
          y = 160,
          width = 128,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "",
          type = "",
          shape = "rectangle",
          x = 672,
          y = 192,
          width = 32,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 672,
          y = 256,
          width = 128,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 768,
          y = 288,
          width = 32,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 320,
          width = 288,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      id = 8,
      name = "triggers",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 6,
          name = "door",
          type = "trigger",
          shape = "rectangle",
          x = 224,
          y = 320,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "trigger",
          shape = "rectangle",
          x = 224,
          y = 192,
          width = 32,
          height = 96,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
