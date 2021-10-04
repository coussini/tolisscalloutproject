    --+=======================+
    --| BASE CLASS DEFINITION |
    --+=======================+
    ----------------
    -- ATTRIBUTES --
    ----------------
    local BaseClass = {balance = 0}
    
    -----------------
    -- CONSTRUCTOR --
    -----------------
    function BaseClass:new (o)
      local o = o or {}
      setmetatable(o, self)
      self.__index = self
      return o
    end
    
    -------------
    -- METHODS --
    -------------
    function BaseClass:deposit (v)
      self.balance = self.balance + v
    end
    function BaseClass:withdraw (v)
      self.balance = self.balance - v
    end

    --+======================+
    --| SUB CLASS DEFINITION |
    --+======================+
    ----------------
    -- ATTRIBUTES --
    ----------------
    local SpecialAccount = BaseClass:new({limit=100})
    --SpecialAccount.limit=100
     
    -----------------
    -- CONSTRUCTOR --
    -----------------
    function SpecialAccount:new (o)
        o = o or BaseClass:new(o,coordinates)
        setmetatable(o, self)
        self.__index = self
        return o
    end

    -------------
    -- METHODS --
    -------------
    function SpecialAccount:validate ()
      print(self.zaza ~= nil and "zaza ="..self.zaza or "zaza = vide")
      return self
    end
    function SpecialAccount:deposit (v)
      print("depot de "..v.."$")
      BaseClass:deposit(v) -- appel à une méthode de la classe de base
      SpecialAccount:getActual() -- appel à une méthode de l'instance
    end
   function SpecialAccount:withdraw (v)
      print("retrait de = "..v.."$")
        BaseClass:withdraw(v) -- appel à une méthode de la classe de base
        SpecialAccount:getActual()
    end
    function SpecialAccount:getActual ()
      print("---> balance = "..self.balance.."$")
    end

    -- USING BASE CLASS
    print(" ")
    print("BaseClass")
    print("=========")
    local parm = {
        zozo=33,
        zaza=11,
        balance=100,
        coordinates=27

    }
    s = BaseClass:new(parm)
    s:deposit(20)
    print("---> balance = "..s.balance.."$")
    s:withdraw(10)
    print("---> balance = "..s.balance.."$")
    s:deposit(20)
    print("---> balance = "..s.balance.."$")
    s:deposit(20)
    print("---> balance = "..s.balance.."$")
    s:withdraw(10)
    print("---> balance = "..s.balance.."$")
    s:deposit(20)
    print("---> balance = "..s.balance.."$")
    s:withdraw(10)
    print("---> balance = "..s.balance.."$")
    s:deposit(20)
    print("---> balance = "..s.balance.."$")
    s:withdraw(10)
    print("---> balance = "..s.balance.."$")
    s:withdraw(10)
    print("---> balance = "..s.balance.."$")
    s:withdraw(1)
    print("---> balance = "..s.balance.."$")
    print(" ")
    print("zozo = "..s.zozo)
    print("zaza = "..s.zaza)
    print("coordinates = "..s.coordinates)    
    print(" ")
    print("Sub Class")
    print("=========")
    -- USING SUB CLASS
    local parm = {
        zozo=53,
        balance=300,
        zaza=37,
        coordinates=57
    }

    s = SpecialAccount:validate(SpecialAccount:new(parm))
    s:deposit(20)
    s:withdraw(10)
    s:deposit(20)
    s:deposit(20)
    s:deposit(20)
    s:withdraw(10)
    s:deposit(20)
    s:withdraw(10)
    s:deposit(20)
    s:withdraw(10)
    s:withdraw(10)
    s:withdraw(1)
    print("balance = "..s.balance)
    print("limit = "..s.limit)
    print("zaza = "..s.zaza)
    print("coordinates = "..s.coordinates)