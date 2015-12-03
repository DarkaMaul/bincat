module Make(D1: Domain.T)(D2: Domain.T with module Asm = D1.Asm) =
struct

  module Asm = D1.Asm
  type t    = D1.t * D2.t
  let name  = "(" ^ D1.name ^ " x " ^ D2.name ^ ")"
 
  let subset (v11, v12) (v21, v22)            = D1.subset v11 v21 && D2.subset v12 v22
  let to_string (v1, v2)                      = (D1.to_string v1) @ (D2.to_string v2)
  let remove_register r (v1, v2)     	      = D1.remove_register r v1             , D2.remove_register r v2
  let set_register r e c (v1, v2)    	      = D1.set_register r e c v1            , D2.set_register r e c v2
  let taint_register_from_config r c (v1, v2) = D1.taint_register_from_config r c v1, D2.taint_register_from_config r c v2
  let taint_memory_from_config a c (v1, v2)   = D1.taint_memory_from_config a c v1  , D2.taint_memory_from_config a c v2
  let set_memory dst sz src c (v1, v2)        = D1.set_memory dst sz src c v1       , D2.set_memory dst sz src c v2
  let join (v11, v12) (v21, v22)              = D1.join v11 v21                     , D2.join v12 v22
  let from_registers (v1, v2)                 = D1.from_registers v1                , D2.from_registers v2
  let set_memory_from_config a c (v1, v2)     = D1.set_memory_from_config a c v1    , D2.set_memory_from_config a c v2
  let set_register_from_config a c (v1, v2)   = D1.set_register_from_config a c v1  , D2.set_register_from_config a c v2
  let init ()    			      = D1.init ()                          , D2.init ()
  let mem_to_addresses m sz (v1, v2) =
    try
      let a1' = D1.mem_to_addresses m sz v1 in
	try
	  let a2' = D2.mem_to_addresses m sz v2 in
	  Asm.Address.Set.inter a1' a2'
	with
	  Utils.Enum_failure -> a1'
    with
      Utils.Enum_failure -> D2.mem_to_addresses m sz v2

  let exp_to_addresses (v1, v2) e =
    (* TODO factorize with mem_to_addresses *)
    try
      let a1' = D1.exp_to_addresses v1 e in
	try
	  let a2' = D2.exp_to_addresses v2 e in
	  Asm.Address.Set.inter a1' a2'
	with
	  Utils.Enum_failure -> a1'
    with
      Utils.Enum_failure -> D2.exp_to_addresses v2 e
end
