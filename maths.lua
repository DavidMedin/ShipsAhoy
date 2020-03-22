
_Vec2 = {
    x=0,
    y=0,
    new = function(self,x,y)
        o = {}
        setmetatable(o,{__index=self})
        o.x = x or self.x
        o.y = y or self.y
        return o
    end,
    Distance = function(vector1,vector2)
        return math.sqrt( math.pow((vector1.x-vector2.x),2)+math.pow((vector1.y-vector2.y),2))
    end
}