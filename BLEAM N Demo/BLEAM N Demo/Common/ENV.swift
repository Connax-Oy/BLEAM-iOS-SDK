//
//  ENV.swift
//  BLEAM N Demo
//
//  Created by Aleksei Zaikin on 25.10.2020.
//  Copyright © 2020 Connax Oy. All rights reserved.
//

enum ENV {
   static var appID: String {
#if DEBUG
      return "08b3a9ca-5a65-4e1b-a590-7ccb154d0a00"
#else
      return "f03b4cf4-c55d-44cc-b5d1-f9dca2ae5585"
#endif
   }

   static var appSecret: String {
#if DEBUG
      return "Kn7lDKNQJJIdUoZvDOYXL5SFXyNP7shu3PjuCxRcy0IclyrY11v11FbeMbtl9s1O"
#else
      return "d8jFmUWR188VD4BKoKt8rTIYvd2Y2OfiElL4vNltbeDe5eLRCqian1EYbn0xqqcW"
#endif
   }

   static var useDebugURL: Bool {
#if DEBUG
      return true
#else
      return false
#endif
   }
}
