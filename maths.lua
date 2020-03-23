
_Vec2 = {
    x=0,
    y=0,
    new = function(self,x,y)
        o = {}
        setmetatable(o,{
            __index=self,
            __sub=function(lhs,rhs)
                return _Vec2:new(lhs.x-rhs.x,lhs.y-rhs.y)
            end
        })
        o.x = x or self.x
        o.y = y or self.y
        return o
    end,
    Distance = function(vector1,vector2)
        return math.abs(math.sqrt( math.pow((vector1.x-vector2.x),2)+math.pow((vector1.y-vector2.y),2)))
    end
}
function math.normalize(x,y) local l=(x*x+y*y)^.5 if l==0 then return 0,0,0 else return x/l,y/l,l end end