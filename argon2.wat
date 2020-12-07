(module
  ;; 0-64 reserved for param block
  (func $i32.log (import "debug" "log") (param i32))
  (func $i32.log_tee (import "debug" "log_tee") (param i32) (result i32))
  ;; No i64 interop with JS yet - but maybe coming with WebAssembly BigInt
  ;; So we can instead fake this by splitting the i64 into two i32 limbs,
  ;; however these are WASM functions using i32x2.log:
  (func $i32x2.log (import "debug" "log") (param i32) (param i32))
  (func $f32.log (import "debug" "log") (param f32))
  (func $f32.log_tee (import "debug" "log_tee") (param f32) (result f32))
  (func $f64.log (import "debug" "log") (param f64))
  (func $f64.log_tee (import "debug" "log_tee") (param f64) (result f64))  

  (global $register0 (mut i64) (i64.const 0))
  (global $register1 (mut i64) (i64.const 0))
  (global $register2 (mut i64) (i64.const 0))
  (global $register3 (mut i64) (i64.const 0))
  
  (func $i64.log
    (param $0 i64)
    (call $i32x2.log
      ;; Upper limb
      (i32.wrap/i64
        (i64.shr_s (get_local $0)
          (i64.const 32)))
      ;; Lower limb
      (i32.wrap/i64 (get_local $0))))

  (func $i64.log_tee
    (param $0 i64)
    (result i64)
    (call $i64.log (get_local $0))
    (return (get_local $0)))

  (memory (export "memory") 32767)

(func (export "argon2_init") (param $ptr i32) (param $memory_blocks i32) (param $tag_length i32) (param $iterations i32)
    ;; b array: 0-128
    (i32.store offset=0  (get_local $ptr) (i32.const 1))
    (i32.store offset=4  (get_local $ptr) (get_local $tag_length))
    (i32.store offset=8  (get_local $ptr) (get_local $memory_blocks))
    (i32.store offset=12 (get_local $ptr) (get_local $iterations))
    (i32.store offset=16 (get_local $ptr) (i32.const 0x13))
    (i32.store offset=20 (get_local $ptr) (i32.const 0x1))
    (i32.store offset=24 (get_local $ptr) (i32.add (get_local $ptr) (i32.const 8192)))
    (i32.store offset=28 (get_local $ptr) (i32.const 0))
    ;; pseudo_rands 32..1056
    (call $init_block (i32.add (get_local $ptr) (i32.const 32)))
    
    ;; input_block  1056..2080
    (call $init_block (i32.add (get_local $ptr) (i32.const 1056)))
    ;; 1056..1064   pass
    ;; 1064..1072   lane
    ;; 1072..1080   slice
    ;; 1080..1088   memory blocks
    ;; 1088..1096   passes
    ;; 1096..1104   type: starts as 1 -> argon2i
    ;; 1104..1112   initialise counter
    (i64.store offset=8  (i32.const 1056) (i64.const 0))
    (i32.store offset=24 (i32.const 1056) (get_local $memory_blocks))
    (i32.store offset=32 (i32.const 1056) (get_local $iterations))
    (i32.store offset=40 (i32.const 1056) (i32.const 1))
    (i64.store offset=48 (i32.const 1056) (i64.const 0))
    
    ;; tmp block  2080..3104
    (call $init_block (i32.add (get_local $ptr) (i32.const 2080)))
    
    ;; zero block  3104..4128
    (call $init_block (i32.add (get_local $ptr) (i32.const 3104)))

    ;; H0 string 4128..4192
    (i64.store offset=4128 (get_local $ptr) (i64.const 0))
    (i64.store offset=4136 (get_local $ptr) (i64.const 0))
    (i64.store offset=4144 (get_local $ptr) (i64.const 0))
    (i64.store offset=4152 (get_local $ptr) (i64.const 0))
    (i64.store offset=4160 (get_local $ptr) (i64.const 0))
    (i64.store offset=4168 (get_local $ptr) (i64.const 0))
    (i64.store offset=4176 (get_local $ptr) (i64.const 0))
    (i64.store offset=4184 (get_local $ptr) (i64.const 0))
    (i64.store offset=4192 (get_local $ptr) (i64.const 0))

    ;; blake2b internal states 4200..4736
    (i64.store offset=4200 (get_local $ptr) (i64.const 0))
    (i64.store offset=4208 (get_local $ptr) (i64.const 0))
    (i64.store offset=4216 (get_local $ptr) (i64.const 0))
    (i64.store offset=4224 (get_local $ptr) (i64.const 0))
    (i64.store offset=4232 (get_local $ptr) (i64.const 0))
    (i64.store offset=4240 (get_local $ptr) (i64.const 0))
    (i64.store offset=4248 (get_local $ptr) (i64.const 0))
    (i64.store offset=4256 (get_local $ptr) (i64.const 0))
    (i64.store offset=4264 (get_local $ptr) (i64.const 0))
    (i64.store offset=4272 (get_local $ptr) (i64.const 0))
    (i64.store offset=4280 (get_local $ptr) (i64.const 0))
    (i64.store offset=4288 (get_local $ptr) (i64.const 0))
    (i64.store offset=4296 (get_local $ptr) (i64.const 0))
    (i64.store offset=4304 (get_local $ptr) (i64.const 0))
    (i64.store offset=4312 (get_local $ptr) (i64.const 0))
    (i64.store offset=4320 (get_local $ptr) (i64.const 0))
    (i64.store offset=4328 (get_local $ptr) (i64.const 0))
    (i64.store offset=4336 (get_local $ptr) (i64.const 0))
    (i64.store offset=4344 (get_local $ptr) (i64.const 0))
    (i64.store offset=4352 (get_local $ptr) (i64.const 0))
    (i64.store offset=4360 (get_local $ptr) (i64.const 0))
    (i64.store offset=4368 (get_local $ptr) (i64.const 0))
    (i64.store offset=4376 (get_local $ptr) (i64.const 0))
    (i64.store offset=4384 (get_local $ptr) (i64.const 0))
    (i64.store offset=4392 (get_local $ptr) (i64.const 0))
    (i64.store offset=4400 (get_local $ptr) (i64.const 0))
    (i64.store offset=4408 (get_local $ptr) (i64.const 0))
    (i64.store offset=4416 (get_local $ptr) (i64.const 0))
    (i64.store offset=4424 (get_local $ptr) (i64.const 0))
    (i64.store offset=4432 (get_local $ptr) (i64.const 0))
    (i64.store offset=4440 (get_local $ptr) (i64.const 0))
    (i64.store offset=4448 (get_local $ptr) (i64.const 0))
    (i64.store offset=4456 (get_local $ptr) (i64.const 0))
    (i64.store offset=4464 (get_local $ptr) (i64.const 0))
    (i64.store offset=4472 (get_local $ptr) (i64.const 0))
    (i64.store offset=4480 (get_local $ptr) (i64.const 0))
    (i64.store offset=4488 (get_local $ptr) (i64.const 0))
    (i64.store offset=4496 (get_local $ptr) (i64.const 0))
    (i64.store offset=4504 (get_local $ptr) (i64.const 0))
    (i64.store offset=4512 (get_local $ptr) (i64.const 0))
    (i64.store offset=4520 (get_local $ptr) (i64.const 0))
    (i64.store offset=4528 (get_local $ptr) (i64.const 0))
    (i64.store offset=4536 (get_local $ptr) (i64.const 0))
    (i64.store offset=4544 (get_local $ptr) (i64.const 0))
    (i64.store offset=4552 (get_local $ptr) (i64.const 0))
    (i64.store offset=4560 (get_local $ptr) (i64.const 0))
    (i64.store offset=4568 (get_local $ptr) (i64.const 0))
    (i64.store offset=4576 (get_local $ptr) (i64.const 0))
    (i64.store offset=4584 (get_local $ptr) (i64.const 0))
    (i64.store offset=4592 (get_local $ptr) (i64.const 0))
    (i64.store offset=4600 (get_local $ptr) (i64.const 0))
    (i64.store offset=4608 (get_local $ptr) (i64.const 0))
    (i64.store offset=4616 (get_local $ptr) (i64.const 0))
    (i64.store offset=4624 (get_local $ptr) (i64.const 0))
    (i64.store offset=4632 (get_local $ptr) (i64.const 0))
    (i64.store offset=4640 (get_local $ptr) (i64.const 0))
    (i64.store offset=4648 (get_local $ptr) (i64.const 0))
    (i64.store offset=4656 (get_local $ptr) (i64.const 0))
    (i64.store offset=4664 (get_local $ptr) (i64.const 0))
    (i64.store offset=4672 (get_local $ptr) (i64.const 0))
    (i64.store offset=4680 (get_local $ptr) (i64.const 0))
    (i64.store offset=4688 (get_local $ptr) (i64.const 0))
    (i64.store offset=4696 (get_local $ptr) (i64.const 0))
    (i64.store offset=4704 (get_local $ptr) (i64.const 0))
    (i64.store offset=4712 (get_local $ptr) (i64.const 0))
    (i64.store offset=4720 (get_local $ptr) (i64.const 0))
    (i64.store offset=4728 (get_local $ptr) (i64.const 0)))

  (func $argon2_hash (export "argon2_hash") (param $ctx i32) (param $input i32) (param $input_len i32)
    (local $hash_ctx i32)
    (local $pass i32)
    (local $passes i32)
    (local $memory i32)
    (local $memory_end i32)
    (local $last_block i32)
    (local $head i32)

    (get_local $input)
    (set_local $head)

    (i32.load offset=12 (get_local $ctx))
    (set_local $passes)

    (get_local $ctx)
    (i32.const 4192)
    (i32.add)
    (set_local $hash_ctx)

    (get_local $ctx)
    (i32.const 8192)
    (i32.add)
    (tee_local $memory)
    (i32.load offset=8 (get_local $ctx))
    (i32.const 1024)
    (i32.mul)
    (i32.add)
    (set_local $last_block)

    (i32.load offset=8  (get_local $ctx))
    (i32.const 1024)
    (i32.mul)
    (get_local $memory)
    (i32.add)
    (set_local $memory_end)

    (i32.store8 offset=0 (get_local $hash_ctx) (i32.const 64))
    (i32.store8 offset=1 (get_local $hash_ctx) (i32.const 0))
    (i32.store8 offset=2 (get_local $hash_ctx) (i32.const 1))
    (i32.store8 offset=3 (get_local $hash_ctx) (i32.const 1))

    (call $blake2b_init (get_local $hash_ctx) (i32.const 64))
    (call $blake2b_update (get_local $hash_ctx) (get_local $ctx) (i32.add (i32.const 24) (get_local $ctx)))
    (call $blake2b_update (get_local $hash_ctx) (get_local $input) (get_local $input_len))
    (call $blake2b_final (get_local $hash_ctx))

    ;; clear inputs
    (block $done
      (loop $sanitize
      (get_local $input)
      (get_local $input_len)
      (i32.ge_u)
      (br_if $done)

      (i64.store offset=0   (get_local $input) (i64.const 0))
      (i64.store offset=8   (get_local $input) (i64.const 0))
      (i64.store offset=16  (get_local $input) (i64.const 0))
      (i64.store offset=24  (get_local $input) (i64.const 0))
      (i64.store offset=32  (get_local $input) (i64.const 0))
      (i64.store offset=40  (get_local $input) (i64.const 0))
      (i64.store offset=48  (get_local $input) (i64.const 0))
      (i64.store offset=56  (get_local $input) (i64.const 0))
      (i64.store offset=64  (get_local $input) (i64.const 0))
      (i64.store offset=72  (get_local $input) (i64.const 0))
      (i64.store offset=80  (get_local $input) (i64.const 0))
      (i64.store offset=88  (get_local $input) (i64.const 0))
      (i64.store offset=96  (get_local $input) (i64.const 0))
      (i64.store offset=104 (get_local $input) (i64.const 0))
      (i64.store offset=112 (get_local $input) (i64.const 0))
      (i64.store offset=120 (get_local $input) (i64.const 0))

      (get_local $input)
      (i32.const 128)
      (i32.add)
      (set_local $input)
      (br $sanitize)))

    (i64.store offset=4128 (get_local $ctx) (i64.load offset=128 (get_local $hash_ctx)))
    (i64.store offset=4136 (get_local $ctx) (i64.load offset=136 (get_local $hash_ctx)))
    (i64.store offset=4144 (get_local $ctx) (i64.load offset=144 (get_local $hash_ctx)))
    (i64.store offset=4152 (get_local $ctx) (i64.load offset=152 (get_local $hash_ctx)))
    (i64.store offset=4160 (get_local $ctx) (i64.load offset=160 (get_local $hash_ctx)))
    (i64.store offset=4168 (get_local $ctx) (i64.load offset=168 (get_local $hash_ctx)))
    (i64.store offset=4176 (get_local $ctx) (i64.load offset=176 (get_local $hash_ctx)))
    (i64.store offset=4184 (get_local $ctx) (i64.load offset=184 (get_local $hash_ctx)))

    (call $fill_initial_blocks (get_local $ctx) (i32.add (get_local $ctx) (i32.const 4128)) (get_local $memory))

    (block $done
      (loop $start
        (get_local $pass)
        (get_local $passes)
        (i32.eq)
        (br_if $done)

        (get_local $ctx)
        (get_local $pass)
        (call $fill_memory_blocks)

        (get_local $pass)
        (i32.const 1)
        (i32.add)
        (set_local $pass)

        (br $start)))

    (get_local $memory)
    (i32.load offset=8  (get_local $ctx))
    (i32.const 1024)
    (i32.mul)
    (i32.add)
    (set_local $memory_end)

    ;; finalize
    (get_local $hash_ctx)
    (get_local $memory_end)
    (i32.const 1024)
    (i32.sub)
    (get_local $memory_end)
    (i32.load offset=4 (get_local $ctx))
    (get_local $head)
    (call $blake2b_long))

  (func $generate_addresses (param $ctx i32) (param $pass i32) (param $slice i32)
    (local $memory_blocks i32)
    (local $passes i32)
    (local $type i32)

    (local $zero_block i32)
    (local $tmp_block i32)
    (local $input_block i32)
    (local $pseudo_rand_block i32)

    (set_local $pseudo_rand_block (i32.add (get_local $ctx (i32.const 32))))
    (set_local $input_block (i32.add (get_local $ctx (i32.const 1056))))
    (set_local $tmp_block (i32.add (get_local $ctx (i32.const 2080))))
    (set_local $zero_block (i32.add (get_local $ctx (i32.const 3104))))

    (call $init_block (get_local $input_block))
    (call $init_block (get_local $zero_block))
    (call $init_block (get_local $tmp_block))
    (call $init_block (get_local $pseudo_rand_block))

    ;; reset counter
    (i32.load offset=16 (get_local $input_block))
    (get_local $slice)
    (i32.ne)
    (if (then
      (get_local $input_block)
      (i64.const 0)
      (i64.store offset=48)))

    (i32.load offset=8 (get_local $ctx))
    (set_local $memory_blocks)

    (i32.load offset=12 (get_local $ctx))
    (set_local $passes)

    (i32.load offset=16 (get_local $ctx))
    (set_local $type)

    (i32.store offset=0 (get_local $input_block) (get_local $pass))
    (i32.store offset=16 (get_local $input_block) (get_local $slice))
    (i32.store offset=24 (get_local $input_block) (get_local $memory_blocks))
    (i32.store offset=32 (get_local $input_block) (get_local $passes))
    (i32.store offset=40 (get_local $input_block) (i32.const 1))
    
    ;; increment counter
    (get_local $input_block)
    (get_local $input_block)
    (i64.load offset=48)
    (i64.const 1)
    (i64.add)
    (i64.store offset=48)

    (call $fill_block (get_local $zero_block) (get_local $input_block) (get_local $tmp_block) (i32.const 1))
    (call $fill_block (get_local $zero_block) (get_local $tmp_block) (get_local $pseudo_rand_block) (i32.const 1)))

  (func $fill_memory_blocks (param $ctx i32) (param $pass i32)
    (local $segment i32)

    (block $end
      (loop $next_segment
        (get_local $segment)
        (i32.const 4)
        (i32.eq)
        (br_if $end)

        (get_local $ctx)
        (get_local $segment)
        (get_local $pass)
        (call $fill_segment)

        (get_local $segment)
        (i32.const 1)
        (i32.add)
        (set_local $segment)
        (br $next_segment))))

  (func $fill_initial_blocks (param $ctx i32) (param $h0 i32) (param $memory i32)
    (i64.store  offset=64 (get_local $h0) (i64.const 0))

    (i32.add (get_local $ctx) (i32.const 4200))
    (get_local $h0)
    (i32.add (get_local $h0) (i32.const 72))
    (i32.const 1024)
    (get_local $memory)
    (call $blake2b_long)

    (i32.store (i32.add (get_local $h0) (i32.const 64)) (i32.const 1))

    (i32.add (get_local $ctx) (i32.const 4200))
    (get_local $h0)
    (i32.add (get_local $h0) (i32.const 72))
    (i32.const 1024)
    (i32.add (i32.const 1024) (get_local $memory))
    (call $blake2b_long))

  (func $relative_position (param $pseudo_rand i64) (param $area i64)
    (result i32)

    (local $j1 i64)
    (local $j2 i64)
    
    (local $next_index i64)

    (get_local $pseudo_rand)
    (i64.const 0xffffffff)
    (i64.and)
    (set_local $j1)

    (set_local $next_index (i64.shr_u (i64.mul (get_local $j1) (get_local $j1)) (i64.const 32)))
    (set_local $next_index (i64.shr_u (i64.mul (get_local $area) (get_local $next_index)) (i64.const 32)))
    (i64.sub (i64.sub (get_local $area) (i64.const 1)) (get_local $next_index))
    (i32.wrap/i64))

  (func $reference_block_pos (param $lane_length i32) (param $pos i32) (param $pass i32) (param $pseudo_rand i64)
    (result i32)

    (local $start_pos i32)
    (local $area i32)
    (local $segment_length i32)

    (get_local $lane_length)
    (i32.const 2)
    (i32.shr_u)
    (set_local $segment_length)

    (set_local $start_pos (i32.const 0))

    (block $fi
        ;; first pass
        (get_local $pass)
        (i32.const 0)
        (i32.eq)
        (if (then
            (get_local $pos)
            (i32.const 1)
            (i32.sub)
            (set_local $area)
            (br $fi)))

        ;; subsequent passes
        ;; area = 3 segments + prev blocks in this segment
        (get_local $lane_length)
        (get_local $segment_length)
        (i32.sub)
        (get_local $pos)
        (get_local $segment_length)
        (i32.rem_u)
        (i32.add)
        (i32.const 1)
        (i32.sub)
        (set_local $area)

        ;; start pos is beginning of next segment
        (get_local $pos)
        (get_local $segment_length)
        (i32.div_u)
        (i32.const 1)
        (i32.add)
        (i32.const 4)
        (i32.rem_u)
        (get_local $segment_length)
        (i32.mul)
        (set_local $start_pos))

    (get_local $start_pos)
    (call $relative_position (get_local $pseudo_rand) (i64.extend_u/i32 (get_local $area)))
    (i32.add)
    (get_local $lane_length)
    (i32.rem_u))

  (func $fill_segment (param $ctx i32) (param $slice_index i32) (param $pass i32)
    (local $pseudo_rand i64)
    (local $starting_index i32)
    (local $lane_length i32)
    (local $segment_length i32)
    (local $curr_offset i32)
    (local $prev_offset i32)
    (local $ref_offset i32)
    (local $memory_offset i32)
    (local $i i32)

    (i32.load offset=8 (get_local $ctx))
    (tee_local $lane_length)
    (i32.const 2)
    (i32.shr_u)
    (set_local $segment_length)

    (i32.const 0)
    (set_local $starting_index)

    (get_local $pass)
    (get_local $slice_index)
    (i32.add)
    (i32.const 0)
    (i32.eq)
    (if (then
        (i32.const 2)
        (set_local $starting_index)))

    (call $generate_addresses (get_local $ctx) (get_local $pass) (get_local $slice_index))

    (get_local $slice_index)
    (get_local $segment_length)
    (i32.mul)
    (get_local $starting_index)
    (i32.add)
    (get_local $lane_length) ;; one lane, offset is modulo lane_length
    (i32.rem_u)
    (set_local $curr_offset)

    (get_local $curr_offset)
    (i32.const 1)
    (i32.sub)
    (set_local $prev_offset)

    (get_local $curr_offset)
    (i32.const 0)
    (i32.eq)
    (if (then
        (get_local $prev_offset)
        (get_local $lane_length)
        (i32.add)
        (set_local $prev_offset)))
    
    (get_local $starting_index)
    (set_local $i)

    (block $end
        (loop $start
            (get_local $i)
            (get_local $segment_length)
            (i32.eq)
            (br_if $end)

            (get_local $curr_offset)
            (i32.const 0x7f)
            (i32.and)
            (i32.const 0)
            (i32.eq)
            (if (then
              (call $generate_addresses (get_local $ctx) (get_local $pass) (get_local $slice_index))))

            (get_local $ctx)
            (get_local  $curr_offset)
            (get_local $segment_length)
            (i32.rem_u)
            (i32.const 0x7f)
            (i32.and)
            (i32.add)
            (i32.const 8)
            (i32.mul)
            (i64.load offset=32)
            (set_local $pseudo_rand)

            (get_local $curr_offset)
            (i32.const 1)
            (i32.eq)
            (if (then
                (get_local $curr_offset)
                (i32.const 1)
                (i32.sub)
                (set_local $prev_offset)))

            (call $reference_block_pos (get_local $lane_length) (get_local $curr_offset) (get_local $pass) (get_local $pseudo_rand))
            (set_local $ref_offset)

            (i32.load offset=24 (get_local $ctx))
            (set_local $memory_offset)
            
            (i32.add (get_local $memory_offset) (i32.shl (get_local $prev_offset) (i32.const 10)))
            (i32.add (get_local $memory_offset) (i32.shl (get_local $ref_offset)  (i32.const 10)))
            (i32.add (get_local $memory_offset) (i32.shl (get_local $curr_offset) (i32.const 10)))
            (get_local $pass)
            (call $fill_block)

            (get_local $i)
            (i32.const 1)
            (i32.add)
            (set_local $i)

            (get_local $curr_offset)
            (i32.const 1)
            (i32.add)
            (get_local $lane_length)
            (i32.rem_u)
            (set_local $curr_offset)

            (get_local $prev_offset)
            (i32.const 1)
            (i32.add)
            (set_local $prev_offset)

            (br $start))))

    (func $blake2b_init (param $ptr i32) (param $outlen i32)
    ;; b array: 0-128
    ;; (i64.store offset=0 (get_local $ptr) (i64.const 0))
    (i64.store offset=8 (get_local $ptr) (i64.const 0))
    (i64.store offset=16 (get_local $ptr) (i64.const 0))
    (i64.store offset=24 (get_local $ptr) (i64.const 0))
    (i64.store offset=32 (get_local $ptr) (i64.const 0))
    (i64.store offset=40 (get_local $ptr) (i64.const 0))
    (i64.store offset=48 (get_local $ptr) (i64.const 0))
    (i64.store offset=56 (get_local $ptr) (i64.const 0))
    (i64.store offset=64 (get_local $ptr) (i64.const 0))
    (i64.store offset=72 (get_local $ptr) (i64.const 0))
    (i64.store offset=80 (get_local $ptr) (i64.const 0))
    (i64.store offset=88 (get_local $ptr) (i64.const 0))
    (i64.store offset=96 (get_local $ptr) (i64.const 0))
    (i64.store offset=104 (get_local $ptr) (i64.const 0))
    (i64.store offset=112 (get_local $ptr) (i64.const 0))
    (i64.store offset=120 (get_local $ptr) (i64.const 0))

    ;; h array: 128-192, (8 * i64)
    ;; TODO: support xor against param block and stuff, for now just xor against length

    (i64.store offset=128 (get_local $ptr) (i64.xor (i64.const 0x6a09e667f3bcc908) (i64.load offset=0  (get_local $ptr))))
    (i64.store offset=136 (get_local $ptr) (i64.xor (i64.const 0xbb67ae8584caa73b) (i64.load offset=8  (get_local $ptr))))
    (i64.store offset=144 (get_local $ptr) (i64.xor (i64.const 0x3c6ef372fe94f82b) (i64.load offset=16 (get_local $ptr))))
    (i64.store offset=152 (get_local $ptr) (i64.xor (i64.const 0xa54ff53a5f1d36f1) (i64.load offset=24 (get_local $ptr))))
    (i64.store offset=160 (get_local $ptr) (i64.xor (i64.const 0x510e527fade682d1) (i64.load offset=32 (get_local $ptr))))
    (i64.store offset=168 (get_local $ptr) (i64.xor (i64.const 0x9b05688c2b3e6c1f) (i64.load offset=40 (get_local $ptr))))
    (i64.store offset=176 (get_local $ptr) (i64.xor (i64.const 0x1f83d9abfb41bd6b) (i64.load offset=48 (get_local $ptr))))
    (i64.store offset=184 (get_local $ptr) (i64.xor (i64.const 0x5be0cd19137e2179) (i64.load offset=56 (get_local $ptr))))

    ;; t int.64: 192-200
    (i64.store offset=192 (get_local $ptr) (i64.const 0))

    ;; c int.64: 200-208
    (i64.store offset=200 (get_local $ptr) (i64.const 0))

    ;; f int.64: 208-216
    (i64.store offset=208 (get_local $ptr) (i64.const 0)))


  (func $blake2b_update (export "blake2b_update") (param $ctx i32) (param $input i32) (param $input_end i32)
    (local $t i32)
    (local $c i32)
    (local $i i32)

    ;; load ctx.t, ctx.c
    (set_local $t (i32.add (get_local $ctx) (i32.const 192)))
    (set_local $c (i32.add (get_local $ctx) (i32.const 200)))

    ;; i = ctx.c
    (set_local $i (i32.wrap/i64 (i64.load (get_local $c))))

    (block $end
      (loop $start
        (br_if $end (i32.eq (get_local $input) (get_local $input_end)))

        (if (i32.eq (get_local $i) (i32.const 128))
          (then
            (i64.store (get_local $t) (i64.add (i64.load (get_local $t)) (i64.extend_u/i32 (get_local $i))))
            (set_local $i (i32.const 0))

            (call $blake2b_compress (get_local $ctx))
          )
        )

        (i32.store8 (i32.add (get_local $ctx) (get_local $i)) (i32.load8_u (get_local $input)))
        (set_local $i (i32.add (get_local $i) (i32.const 1)))
        (set_local $input (i32.add (get_local $input) (i32.const 1)))

        (br $start)
      )
    )

    (i64.store (get_local $c) (i64.extend_u/i32 (get_local $i)))
  )

  (func $blake2b_final (export "blake2b_final") (param $ctx i32)
    (local $t i32)
    (local $c i32)
    (local $i i32)

    ;; load ctx.t, ctx.c
    (set_local $t (i32.add (get_local $ctx) (i32.const 192)))
    (set_local $c (i32.add (get_local $ctx) (i32.const 200)))

    ;; ctx.t += ctx.c
    (i64.store (get_local $t) (i64.add (i64.load (get_local $t)) (i64.load (get_local $c))))

    ;; set ctx.f to last_block
    (i64.store offset=208 (get_local $ctx) (i64.const 0xffffffffffffffff))

    ;; i = ctx.c
    (set_local $i (i32.wrap/i64 (i64.load (get_local $c))))

    ;; zero out remaining, i..128
    (block $end
      (loop $start
        (br_if $end (i32.eq (get_local $i) (i32.const 128)))
        (i32.store8 (i32.add (get_local $ctx) (get_local $i)) (i32.const 0))
        (set_local $i (i32.add (get_local $i) (i32.const 1)))
        (br $start)
      )
    )

    ;; ctx.c = i (for good meassure)
    (i64.store (get_local $c) (i64.extend_u/i32 (get_local $i)))

    (call $blake2b_compress (get_local $ctx))
  )

  (func $blake2b_long (export "blake2b_long") (param $ctx i32) (param $input i32) (param $input_end i32) (param $len i32) (param $out i32)
    (local $r i32)
    (local $ctx2 i32)
    (local $tmp i32)

    (i32.store offset=0 (i32.const 28) (get_local $len))
    (set_local $r (i32.sub (i32.shr_u (get_local $len) (i32.const 5)) (i32.const 2)))
    (set_local $ctx2 (i32.add (get_local $ctx) (i32.const 216)))

    (i64.store (get_local $ctx) (i64.const 0))
    (i32.store8 offset=0 (get_local $ctx) (i32.const 64))
    (i32.store8 offset=1 (get_local $ctx) (i32.const 0))
    (i32.store8 offset=2 (get_local $ctx) (i32.const 1))
    (i32.store8 offset=3 (get_local $ctx) (i32.const 1))

    (call $blake2b_init (get_local $ctx) (i32.const 64))
    (call $blake2b_update (get_local $ctx) (i32.const 28) (i32.const  32))
    (call $blake2b_update (get_local $ctx) (get_local $input) (get_local $input_end))
    (call $blake2b_final (get_local $ctx))

    (i64.store offset=0  (get_local $out) (i64.load offset=128 (get_local $ctx)))
    (i64.store offset=8  (get_local $out) (i64.load offset=136 (get_local $ctx)))
    (i64.store offset=16 (get_local $out) (i64.load offset=144 (get_local $ctx)))
    (i64.store offset=24 (get_local $out) (i64.load offset=152 (get_local $ctx)))

    (set_local $out (i32.add (get_local $out) (i32.const 32)))

    (block $end
      (loop $start
        (i32.eq (get_local $r) (i32.const 0))
        (br_if $end)

        (i64.store (get_local $ctx2) (i64.const 0))
        (i32.store8 offset=0 (get_local $ctx2) (i32.const 64))
        (i32.store8 offset=1 (get_local $ctx2) (i32.const 0))
        (i32.store8 offset=2 (get_local $ctx2) (i32.const 1))
        (i32.store8 offset=3 (get_local $ctx2) (i32.const 1))

        (call $blake2b_init (get_local $ctx2) (i32.const 64))
        (call $blake2b_update (get_local $ctx2) (i32.add (get_local $ctx) (i32.const 128)) (i32.add (get_local $ctx) (i32.const 192)))
        (call $blake2b_final (get_local $ctx2))

        (i64.store offset=0  (get_local $out) (i64.load offset=128 (get_local $ctx2)))
        (i64.store offset=8  (get_local $out) (i64.load offset=136 (get_local $ctx2)))
        (i64.store offset=16 (get_local $out) (i64.load offset=144 (get_local $ctx2)))
        (i64.store offset=24 (get_local $out) (i64.load offset=152 (get_local $ctx2)))

        (set_local $out (i32.add (get_local $out) (i32.const 32)))
        (set_local $r (i32.sub (get_local $r) (i32.const 1)))

        (set_local $tmp (get_local $ctx2))
        (set_local $ctx2 (get_local $ctx))
        (set_local $ctx (get_local $tmp))
        (br $start)))

    (i64.store offset=0  (get_local $out) (i64.load offset=160 (get_local $ctx)))
    (i64.store offset=8  (get_local $out) (i64.load offset=168 (get_local $ctx)))
    (i64.store offset=16 (get_local $out) (i64.load offset=176 (get_local $ctx)))
    (i64.store offset=24 (get_local $out) (i64.load offset=184 (get_local $ctx))))

  (func $init_block (param $ptr i32)
    (i64.store offset=0    (get_local $ptr) (i64.const 0))
    (i64.store offset=8    (get_local $ptr) (i64.const 0))
    (i64.store offset=16   (get_local $ptr) (i64.const 0))
    (i64.store offset=24   (get_local $ptr) (i64.const 0))
    (i64.store offset=32   (get_local $ptr) (i64.const 0))
    (i64.store offset=40   (get_local $ptr) (i64.const 0))
    (i64.store offset=48   (get_local $ptr) (i64.const 0))
    (i64.store offset=56   (get_local $ptr) (i64.const 0))
    (i64.store offset=64   (get_local $ptr) (i64.const 0))
    (i64.store offset=72   (get_local $ptr) (i64.const 0))
    (i64.store offset=80   (get_local $ptr) (i64.const 0))
    (i64.store offset=88   (get_local $ptr) (i64.const 0))
    (i64.store offset=96   (get_local $ptr) (i64.const 0))
    (i64.store offset=104  (get_local $ptr) (i64.const 0))
    (i64.store offset=112  (get_local $ptr) (i64.const 0))
    (i64.store offset=120  (get_local $ptr) (i64.const 0))
    (i64.store offset=128  (get_local $ptr) (i64.const 0))
    (i64.store offset=136  (get_local $ptr) (i64.const 0))
    (i64.store offset=144  (get_local $ptr) (i64.const 0))
    (i64.store offset=152  (get_local $ptr) (i64.const 0))
    (i64.store offset=160  (get_local $ptr) (i64.const 0))
    (i64.store offset=168  (get_local $ptr) (i64.const 0))
    (i64.store offset=176  (get_local $ptr) (i64.const 0))
    (i64.store offset=184  (get_local $ptr) (i64.const 0))
    (i64.store offset=192  (get_local $ptr) (i64.const 0))
    (i64.store offset=200  (get_local $ptr) (i64.const 0))
    (i64.store offset=208  (get_local $ptr) (i64.const 0))
    (i64.store offset=216  (get_local $ptr) (i64.const 0))
    (i64.store offset=224  (get_local $ptr) (i64.const 0))
    (i64.store offset=232  (get_local $ptr) (i64.const 0))
    (i64.store offset=240  (get_local $ptr) (i64.const 0))
    (i64.store offset=248  (get_local $ptr) (i64.const 0))
    (i64.store offset=256  (get_local $ptr) (i64.const 0))
    (i64.store offset=264  (get_local $ptr) (i64.const 0))
    (i64.store offset=272  (get_local $ptr) (i64.const 0))
    (i64.store offset=280  (get_local $ptr) (i64.const 0))
    (i64.store offset=288  (get_local $ptr) (i64.const 0))
    (i64.store offset=296  (get_local $ptr) (i64.const 0))
    (i64.store offset=304  (get_local $ptr) (i64.const 0))
    (i64.store offset=312  (get_local $ptr) (i64.const 0))
    (i64.store offset=320  (get_local $ptr) (i64.const 0))
    (i64.store offset=328  (get_local $ptr) (i64.const 0))
    (i64.store offset=336  (get_local $ptr) (i64.const 0))
    (i64.store offset=344  (get_local $ptr) (i64.const 0))
    (i64.store offset=352  (get_local $ptr) (i64.const 0))
    (i64.store offset=360  (get_local $ptr) (i64.const 0))
    (i64.store offset=368  (get_local $ptr) (i64.const 0))
    (i64.store offset=376  (get_local $ptr) (i64.const 0))
    (i64.store offset=384  (get_local $ptr) (i64.const 0))
    (i64.store offset=392  (get_local $ptr) (i64.const 0))
    (i64.store offset=400  (get_local $ptr) (i64.const 0))
    (i64.store offset=408  (get_local $ptr) (i64.const 0))
    (i64.store offset=416  (get_local $ptr) (i64.const 0))
    (i64.store offset=424  (get_local $ptr) (i64.const 0))
    (i64.store offset=432  (get_local $ptr) (i64.const 0))
    (i64.store offset=440  (get_local $ptr) (i64.const 0))
    (i64.store offset=448  (get_local $ptr) (i64.const 0))
    (i64.store offset=456  (get_local $ptr) (i64.const 0))
    (i64.store offset=464  (get_local $ptr) (i64.const 0))
    (i64.store offset=472  (get_local $ptr) (i64.const 0))
    (i64.store offset=480  (get_local $ptr) (i64.const 0))
    (i64.store offset=488  (get_local $ptr) (i64.const 0))
    (i64.store offset=496  (get_local $ptr) (i64.const 0))
    (i64.store offset=504  (get_local $ptr) (i64.const 0))
    (i64.store offset=512  (get_local $ptr) (i64.const 0))
    (i64.store offset=520  (get_local $ptr) (i64.const 0))
    (i64.store offset=528  (get_local $ptr) (i64.const 0))
    (i64.store offset=536  (get_local $ptr) (i64.const 0))
    (i64.store offset=544  (get_local $ptr) (i64.const 0))
    (i64.store offset=552  (get_local $ptr) (i64.const 0))
    (i64.store offset=560  (get_local $ptr) (i64.const 0))
    (i64.store offset=568  (get_local $ptr) (i64.const 0))
    (i64.store offset=576  (get_local $ptr) (i64.const 0))
    (i64.store offset=584  (get_local $ptr) (i64.const 0))
    (i64.store offset=592  (get_local $ptr) (i64.const 0))
    (i64.store offset=600  (get_local $ptr) (i64.const 0))
    (i64.store offset=608  (get_local $ptr) (i64.const 0))
    (i64.store offset=616  (get_local $ptr) (i64.const 0))
    (i64.store offset=624  (get_local $ptr) (i64.const 0))
    (i64.store offset=632  (get_local $ptr) (i64.const 0))
    (i64.store offset=640  (get_local $ptr) (i64.const 0))
    (i64.store offset=648  (get_local $ptr) (i64.const 0))
    (i64.store offset=656  (get_local $ptr) (i64.const 0))
    (i64.store offset=664  (get_local $ptr) (i64.const 0))
    (i64.store offset=672  (get_local $ptr) (i64.const 0))
    (i64.store offset=680  (get_local $ptr) (i64.const 0))
    (i64.store offset=688  (get_local $ptr) (i64.const 0))
    (i64.store offset=696  (get_local $ptr) (i64.const 0))
    (i64.store offset=704  (get_local $ptr) (i64.const 0))
    (i64.store offset=712  (get_local $ptr) (i64.const 0))
    (i64.store offset=720  (get_local $ptr) (i64.const 0))
    (i64.store offset=728  (get_local $ptr) (i64.const 0))
    (i64.store offset=736  (get_local $ptr) (i64.const 0))
    (i64.store offset=744  (get_local $ptr) (i64.const 0))
    (i64.store offset=752  (get_local $ptr) (i64.const 0))
    (i64.store offset=760  (get_local $ptr) (i64.const 0))
    (i64.store offset=768  (get_local $ptr) (i64.const 0))
    (i64.store offset=776  (get_local $ptr) (i64.const 0))
    (i64.store offset=784  (get_local $ptr) (i64.const 0))
    (i64.store offset=792  (get_local $ptr) (i64.const 0))
    (i64.store offset=800  (get_local $ptr) (i64.const 0))
    (i64.store offset=808  (get_local $ptr) (i64.const 0))
    (i64.store offset=816  (get_local $ptr) (i64.const 0))
    (i64.store offset=824  (get_local $ptr) (i64.const 0))
    (i64.store offset=832  (get_local $ptr) (i64.const 0))
    (i64.store offset=840  (get_local $ptr) (i64.const 0))
    (i64.store offset=848  (get_local $ptr) (i64.const 0))
    (i64.store offset=856  (get_local $ptr) (i64.const 0))
    (i64.store offset=864  (get_local $ptr) (i64.const 0))
    (i64.store offset=872  (get_local $ptr) (i64.const 0))
    (i64.store offset=880  (get_local $ptr) (i64.const 0))
    (i64.store offset=888  (get_local $ptr) (i64.const 0))
    (i64.store offset=896  (get_local $ptr) (i64.const 0))
    (i64.store offset=904  (get_local $ptr) (i64.const 0))
    (i64.store offset=912  (get_local $ptr) (i64.const 0))
    (i64.store offset=920  (get_local $ptr) (i64.const 0))
    (i64.store offset=928  (get_local $ptr) (i64.const 0))
    (i64.store offset=936  (get_local $ptr) (i64.const 0))
    (i64.store offset=944  (get_local $ptr) (i64.const 0))
    (i64.store offset=952  (get_local $ptr) (i64.const 0))
    (i64.store offset=960  (get_local $ptr) (i64.const 0))
    (i64.store offset=968  (get_local $ptr) (i64.const 0))
    (i64.store offset=976  (get_local $ptr) (i64.const 0))
    (i64.store offset=984  (get_local $ptr) (i64.const 0))
    (i64.store offset=992  (get_local $ptr) (i64.const 0))
    (i64.store offset=1000 (get_local $ptr) (i64.const 0))
    (i64.store offset=1008 (get_local $ptr) (i64.const 0))
    (i64.store offset=1016 (get_local $ptr) (i64.const 0)))

  (func $fill_block (param $prev_block i32) (param $ref_block i32) (param $next_block i32) (param $xor i32)
    (local $tmp i64)

    (local $b0   i64) (local $b1   i64) (local $b2   i64) (local $b3   i64)
    (local $b4   i64) (local $b5   i64) (local $b6   i64) (local $b7   i64)
    (local $b8   i64) (local $b9   i64) (local $b10  i64) (local $b11  i64)
    (local $b12  i64) (local $b13  i64) (local $b14  i64) (local $b15  i64)
    (local $b16  i64) (local $b17  i64) (local $b18  i64) (local $b19  i64)
    (local $b20  i64) (local $b21  i64) (local $b22  i64) (local $b23  i64)
    (local $b24  i64) (local $b25  i64) (local $b26  i64) (local $b27  i64)
    (local $b28  i64) (local $b29  i64) (local $b30  i64) (local $b31  i64)
    (local $b32  i64) (local $b33  i64) (local $b34  i64) (local $b35  i64)
    (local $b36  i64) (local $b37  i64) (local $b38  i64) (local $b39  i64)
    (local $b40  i64) (local $b41  i64) (local $b42  i64) (local $b43  i64)
    (local $b44  i64) (local $b45  i64) (local $b46  i64) (local $b47  i64)
    (local $b48  i64) (local $b49  i64) (local $b50  i64) (local $b51  i64)
    (local $b52  i64) (local $b53  i64) (local $b54  i64) (local $b55  i64)
    (local $b56  i64) (local $b57  i64) (local $b58  i64) (local $b59  i64)
    (local $b60  i64) (local $b61  i64) (local $b62  i64) (local $b63  i64)
    (local $b64  i64) (local $b65  i64) (local $b66  i64) (local $b67  i64)
    (local $b68  i64) (local $b69  i64) (local $b70  i64) (local $b71  i64)
    (local $b72  i64) (local $b73  i64) (local $b74  i64) (local $b75  i64)
    (local $b76  i64) (local $b77  i64) (local $b78  i64) (local $b79  i64)
    (local $b80  i64) (local $b81  i64) (local $b82  i64) (local $b83  i64)
    (local $b84  i64) (local $b85  i64) (local $b86  i64) (local $b87  i64)
    (local $b88  i64) (local $b89  i64) (local $b90  i64) (local $b91  i64)
    (local $b92  i64) (local $b93  i64) (local $b94  i64) (local $b95  i64)
    (local $b96  i64) (local $b97  i64) (local $b98  i64) (local $b99  i64)
    (local $b100 i64) (local $b101 i64) (local $b102 i64) (local $b103 i64)
    (local $b104 i64) (local $b105 i64) (local $b106 i64) (local $b107 i64)
    (local $b108 i64) (local $b109 i64) (local $b110 i64) (local $b111 i64)
    (local $b112 i64) (local $b113 i64) (local $b114 i64) (local $b115 i64)
    (local $b116 i64) (local $b117 i64) (local $b118 i64) (local $b119 i64)
    (local $b120 i64) (local $b121 i64) (local $b122 i64) (local $b123 i64)
    (local $b124 i64) (local $b125 i64) (local $b126 i64) (local $b127 i64)

    (local $tmp0   i64) (local $tmp1   i64) (local $tmp2   i64) (local $tmp3   i64)
    (local $tmp4   i64) (local $tmp5   i64) (local $tmp6   i64) (local $tmp7   i64)
    (local $tmp8   i64) (local $tmp9   i64) (local $tmp10  i64) (local $tmp11  i64)
    (local $tmp12  i64) (local $tmp13  i64) (local $tmp14  i64) (local $tmp15  i64)
    (local $tmp16  i64) (local $tmp17  i64) (local $tmp18  i64) (local $tmp19  i64)
    (local $tmp20  i64) (local $tmp21  i64) (local $tmp22  i64) (local $tmp23  i64)
    (local $tmp24  i64) (local $tmp25  i64) (local $tmp26  i64) (local $tmp27  i64)
    (local $tmp28  i64) (local $tmp29  i64) (local $tmp30  i64) (local $tmp31  i64)
    (local $tmp32  i64) (local $tmp33  i64) (local $tmp34  i64) (local $tmp35  i64)
    (local $tmp36  i64) (local $tmp37  i64) (local $tmp38  i64) (local $tmp39  i64)
    (local $tmp40  i64) (local $tmp41  i64) (local $tmp42  i64) (local $tmp43  i64)
    (local $tmp44  i64) (local $tmp45  i64) (local $tmp46  i64) (local $tmp47  i64)
    (local $tmp48  i64) (local $tmp49  i64) (local $tmp50  i64) (local $tmp51  i64)
    (local $tmp52  i64) (local $tmp53  i64) (local $tmp54  i64) (local $tmp55  i64)
    (local $tmp56  i64) (local $tmp57  i64) (local $tmp58  i64) (local $tmp59  i64)
    (local $tmp60  i64) (local $tmp61  i64) (local $tmp62  i64) (local $tmp63  i64)
    (local $tmp64  i64) (local $tmp65  i64) (local $tmp66  i64) (local $tmp67  i64)
    (local $tmp68  i64) (local $tmp69  i64) (local $tmp70  i64) (local $tmp71  i64)
    (local $tmp72  i64) (local $tmp73  i64) (local $tmp74  i64) (local $tmp75  i64)
    (local $tmp76  i64) (local $tmp77  i64) (local $tmp78  i64) (local $tmp79  i64)
    (local $tmp80  i64) (local $tmp81  i64) (local $tmp82  i64) (local $tmp83  i64)
    (local $tmp84  i64) (local $tmp85  i64) (local $tmp86  i64) (local $tmp87  i64)
    (local $tmp88  i64) (local $tmp89  i64) (local $tmp90  i64) (local $tmp91  i64)
    (local $tmp92  i64) (local $tmp93  i64) (local $tmp94  i64) (local $tmp95  i64)
    (local $tmp96  i64) (local $tmp97  i64) (local $tmp98  i64) (local $tmp99  i64)
    (local $tmp100 i64) (local $tmp101 i64) (local $tmp102 i64) (local $tmp103 i64)
    (local $tmp104 i64) (local $tmp105 i64) (local $tmp106 i64) (local $tmp107 i64)
    (local $tmp108 i64) (local $tmp109 i64) (local $tmp110 i64) (local $tmp111 i64)
    (local $tmp112 i64) (local $tmp113 i64) (local $tmp114 i64) (local $tmp115 i64)
    (local $tmp116 i64) (local $tmp117 i64) (local $tmp118 i64) (local $tmp119 i64)
    (local $tmp120 i64) (local $tmp121 i64) (local $tmp122 i64) (local $tmp123 i64)
    (local $tmp124 i64) (local $tmp125 i64) (local $tmp126 i64) (local $tmp127 i64)

    (set_local $b0    (i64.load offset=0    (get_local $ref_block)))
    (set_local $b1    (i64.load offset=8    (get_local $ref_block)))
    (set_local $b2    (i64.load offset=16   (get_local $ref_block)))
    (set_local $b3    (i64.load offset=24   (get_local $ref_block)))
    (set_local $b4    (i64.load offset=32   (get_local $ref_block)))
    (set_local $b5    (i64.load offset=40   (get_local $ref_block)))
    (set_local $b6    (i64.load offset=48   (get_local $ref_block)))
    (set_local $b7    (i64.load offset=56   (get_local $ref_block)))
    (set_local $b8    (i64.load offset=64   (get_local $ref_block)))
    (set_local $b9    (i64.load offset=72   (get_local $ref_block)))
    (set_local $b10   (i64.load offset=80   (get_local $ref_block)))
    (set_local $b11   (i64.load offset=88   (get_local $ref_block)))
    (set_local $b12   (i64.load offset=96   (get_local $ref_block)))
    (set_local $b13   (i64.load offset=104  (get_local $ref_block)))
    (set_local $b14   (i64.load offset=112  (get_local $ref_block)))
    (set_local $b15   (i64.load offset=120  (get_local $ref_block)))
    (set_local $b16   (i64.load offset=128  (get_local $ref_block)))
    (set_local $b17   (i64.load offset=136  (get_local $ref_block)))
    (set_local $b18   (i64.load offset=144  (get_local $ref_block)))
    (set_local $b19   (i64.load offset=152  (get_local $ref_block)))
    (set_local $b20   (i64.load offset=160  (get_local $ref_block)))
    (set_local $b21   (i64.load offset=168  (get_local $ref_block)))
    (set_local $b22   (i64.load offset=176  (get_local $ref_block)))
    (set_local $b23   (i64.load offset=184  (get_local $ref_block)))
    (set_local $b24   (i64.load offset=192  (get_local $ref_block)))
    (set_local $b25   (i64.load offset=200  (get_local $ref_block)))
    (set_local $b26   (i64.load offset=208  (get_local $ref_block)))
    (set_local $b27   (i64.load offset=216  (get_local $ref_block)))
    (set_local $b28   (i64.load offset=224  (get_local $ref_block)))
    (set_local $b29   (i64.load offset=232  (get_local $ref_block)))
    (set_local $b30   (i64.load offset=240  (get_local $ref_block)))
    (set_local $b31   (i64.load offset=248  (get_local $ref_block)))
    (set_local $b32   (i64.load offset=256  (get_local $ref_block)))
    (set_local $b33   (i64.load offset=264  (get_local $ref_block)))
    (set_local $b34   (i64.load offset=272  (get_local $ref_block)))
    (set_local $b35   (i64.load offset=280  (get_local $ref_block)))
    (set_local $b36   (i64.load offset=288  (get_local $ref_block)))
    (set_local $b37   (i64.load offset=296  (get_local $ref_block)))
    (set_local $b38   (i64.load offset=304  (get_local $ref_block)))
    (set_local $b39   (i64.load offset=312  (get_local $ref_block)))
    (set_local $b40   (i64.load offset=320  (get_local $ref_block)))
    (set_local $b41   (i64.load offset=328  (get_local $ref_block)))
    (set_local $b42   (i64.load offset=336  (get_local $ref_block)))
    (set_local $b43   (i64.load offset=344  (get_local $ref_block)))
    (set_local $b44   (i64.load offset=352  (get_local $ref_block)))
    (set_local $b45   (i64.load offset=360  (get_local $ref_block)))
    (set_local $b46   (i64.load offset=368  (get_local $ref_block)))
    (set_local $b47   (i64.load offset=376  (get_local $ref_block)))
    (set_local $b48   (i64.load offset=384  (get_local $ref_block)))
    (set_local $b49   (i64.load offset=392  (get_local $ref_block)))
    (set_local $b50   (i64.load offset=400  (get_local $ref_block)))
    (set_local $b51   (i64.load offset=408  (get_local $ref_block)))
    (set_local $b52   (i64.load offset=416  (get_local $ref_block)))
    (set_local $b53   (i64.load offset=424  (get_local $ref_block)))
    (set_local $b54   (i64.load offset=432  (get_local $ref_block)))
    (set_local $b55   (i64.load offset=440  (get_local $ref_block)))
    (set_local $b56   (i64.load offset=448  (get_local $ref_block)))
    (set_local $b57   (i64.load offset=456  (get_local $ref_block)))
    (set_local $b58   (i64.load offset=464  (get_local $ref_block)))
    (set_local $b59   (i64.load offset=472  (get_local $ref_block)))
    (set_local $b60   (i64.load offset=480  (get_local $ref_block)))
    (set_local $b61   (i64.load offset=488  (get_local $ref_block)))
    (set_local $b62   (i64.load offset=496  (get_local $ref_block)))
    (set_local $b63   (i64.load offset=504  (get_local $ref_block)))
    (set_local $b64   (i64.load offset=512  (get_local $ref_block)))
    (set_local $b65   (i64.load offset=520  (get_local $ref_block)))
    (set_local $b66   (i64.load offset=528  (get_local $ref_block)))
    (set_local $b67   (i64.load offset=536  (get_local $ref_block)))
    (set_local $b68   (i64.load offset=544  (get_local $ref_block)))
    (set_local $b69   (i64.load offset=552  (get_local $ref_block)))
    (set_local $b70   (i64.load offset=560  (get_local $ref_block)))
    (set_local $b71   (i64.load offset=568  (get_local $ref_block)))
    (set_local $b72   (i64.load offset=576  (get_local $ref_block)))
    (set_local $b73   (i64.load offset=584  (get_local $ref_block)))
    (set_local $b74   (i64.load offset=592  (get_local $ref_block)))
    (set_local $b75   (i64.load offset=600  (get_local $ref_block)))
    (set_local $b76   (i64.load offset=608  (get_local $ref_block)))
    (set_local $b77   (i64.load offset=616  (get_local $ref_block)))
    (set_local $b78   (i64.load offset=624  (get_local $ref_block)))
    (set_local $b79   (i64.load offset=632  (get_local $ref_block)))
    (set_local $b80   (i64.load offset=640  (get_local $ref_block)))
    (set_local $b81   (i64.load offset=648  (get_local $ref_block)))
    (set_local $b82   (i64.load offset=656  (get_local $ref_block)))
    (set_local $b83   (i64.load offset=664  (get_local $ref_block)))
    (set_local $b84   (i64.load offset=672  (get_local $ref_block)))
    (set_local $b85   (i64.load offset=680  (get_local $ref_block)))
    (set_local $b86   (i64.load offset=688  (get_local $ref_block)))
    (set_local $b87   (i64.load offset=696  (get_local $ref_block)))
    (set_local $b88   (i64.load offset=704  (get_local $ref_block)))
    (set_local $b89   (i64.load offset=712  (get_local $ref_block)))
    (set_local $b90   (i64.load offset=720  (get_local $ref_block)))
    (set_local $b91   (i64.load offset=728  (get_local $ref_block)))
    (set_local $b92   (i64.load offset=736  (get_local $ref_block)))
    (set_local $b93   (i64.load offset=744  (get_local $ref_block)))
    (set_local $b94   (i64.load offset=752  (get_local $ref_block)))
    (set_local $b95   (i64.load offset=760  (get_local $ref_block)))
    (set_local $b96   (i64.load offset=768  (get_local $ref_block)))
    (set_local $b97   (i64.load offset=776  (get_local $ref_block)))
    (set_local $b98   (i64.load offset=784  (get_local $ref_block)))
    (set_local $b99   (i64.load offset=792  (get_local $ref_block)))
    (set_local $b100  (i64.load offset=800  (get_local $ref_block)))
    (set_local $b101  (i64.load offset=808  (get_local $ref_block)))
    (set_local $b102  (i64.load offset=816  (get_local $ref_block)))
    (set_local $b103  (i64.load offset=824  (get_local $ref_block)))
    (set_local $b104  (i64.load offset=832  (get_local $ref_block)))
    (set_local $b105  (i64.load offset=840  (get_local $ref_block)))
    (set_local $b106  (i64.load offset=848  (get_local $ref_block)))
    (set_local $b107  (i64.load offset=856  (get_local $ref_block)))
    (set_local $b108  (i64.load offset=864  (get_local $ref_block)))
    (set_local $b109  (i64.load offset=872  (get_local $ref_block)))
    (set_local $b110  (i64.load offset=880  (get_local $ref_block)))
    (set_local $b111  (i64.load offset=888  (get_local $ref_block)))
    (set_local $b112  (i64.load offset=896  (get_local $ref_block)))
    (set_local $b113  (i64.load offset=904  (get_local $ref_block)))
    (set_local $b114  (i64.load offset=912  (get_local $ref_block)))
    (set_local $b115  (i64.load offset=920  (get_local $ref_block)))
    (set_local $b116  (i64.load offset=928  (get_local $ref_block)))
    (set_local $b117  (i64.load offset=936  (get_local $ref_block)))
    (set_local $b118  (i64.load offset=944  (get_local $ref_block)))
    (set_local $b119  (i64.load offset=952  (get_local $ref_block)))
    (set_local $b120  (i64.load offset=960  (get_local $ref_block)))
    (set_local $b121  (i64.load offset=968  (get_local $ref_block)))
    (set_local $b122  (i64.load offset=976  (get_local $ref_block)))
    (set_local $b123  (i64.load offset=984  (get_local $ref_block)))
    (set_local $b124  (i64.load offset=992  (get_local $ref_block)))
    (set_local $b125  (i64.load offset=1000 (get_local $ref_block)))
    (set_local $b126  (i64.load offset=1008 (get_local $ref_block)))
    (set_local $b127  (i64.load offset=1016 (get_local $ref_block)))

    (set_local $b0   (i64.xor (get_local $b0  ) (i64.load offset=0    (get_local $prev_block))))
    (set_local $b1   (i64.xor (get_local $b1  ) (i64.load offset=8    (get_local $prev_block))))
    (set_local $b2   (i64.xor (get_local $b2  ) (i64.load offset=16   (get_local $prev_block))))
    (set_local $b3   (i64.xor (get_local $b3  ) (i64.load offset=24   (get_local $prev_block))))
    (set_local $b4   (i64.xor (get_local $b4  ) (i64.load offset=32   (get_local $prev_block))))
    (set_local $b5   (i64.xor (get_local $b5  ) (i64.load offset=40   (get_local $prev_block))))
    (set_local $b6   (i64.xor (get_local $b6  ) (i64.load offset=48   (get_local $prev_block))))
    (set_local $b7   (i64.xor (get_local $b7  ) (i64.load offset=56   (get_local $prev_block))))
    (set_local $b8   (i64.xor (get_local $b8  ) (i64.load offset=64   (get_local $prev_block))))
    (set_local $b9   (i64.xor (get_local $b9  ) (i64.load offset=72   (get_local $prev_block))))
    (set_local $b10  (i64.xor (get_local $b10 ) (i64.load offset=80   (get_local $prev_block))))
    (set_local $b11  (i64.xor (get_local $b11 ) (i64.load offset=88   (get_local $prev_block))))
    (set_local $b12  (i64.xor (get_local $b12 ) (i64.load offset=96   (get_local $prev_block))))
    (set_local $b13  (i64.xor (get_local $b13 ) (i64.load offset=104  (get_local $prev_block))))
    (set_local $b14  (i64.xor (get_local $b14 ) (i64.load offset=112  (get_local $prev_block))))
    (set_local $b15  (i64.xor (get_local $b15 ) (i64.load offset=120  (get_local $prev_block))))
    (set_local $b16  (i64.xor (get_local $b16 ) (i64.load offset=128  (get_local $prev_block))))
    (set_local $b17  (i64.xor (get_local $b17 ) (i64.load offset=136  (get_local $prev_block))))
    (set_local $b18  (i64.xor (get_local $b18 ) (i64.load offset=144  (get_local $prev_block))))
    (set_local $b19  (i64.xor (get_local $b19 ) (i64.load offset=152  (get_local $prev_block))))
    (set_local $b20  (i64.xor (get_local $b20 ) (i64.load offset=160  (get_local $prev_block))))
    (set_local $b21  (i64.xor (get_local $b21 ) (i64.load offset=168  (get_local $prev_block))))
    (set_local $b22  (i64.xor (get_local $b22 ) (i64.load offset=176  (get_local $prev_block))))
    (set_local $b23  (i64.xor (get_local $b23 ) (i64.load offset=184  (get_local $prev_block))))
    (set_local $b24  (i64.xor (get_local $b24 ) (i64.load offset=192  (get_local $prev_block))))
    (set_local $b25  (i64.xor (get_local $b25 ) (i64.load offset=200  (get_local $prev_block))))
    (set_local $b26  (i64.xor (get_local $b26 ) (i64.load offset=208  (get_local $prev_block))))
    (set_local $b27  (i64.xor (get_local $b27 ) (i64.load offset=216  (get_local $prev_block))))
    (set_local $b28  (i64.xor (get_local $b28 ) (i64.load offset=224  (get_local $prev_block))))
    (set_local $b29  (i64.xor (get_local $b29 ) (i64.load offset=232  (get_local $prev_block))))
    (set_local $b30  (i64.xor (get_local $b30 ) (i64.load offset=240  (get_local $prev_block))))
    (set_local $b31  (i64.xor (get_local $b31 ) (i64.load offset=248  (get_local $prev_block))))
    (set_local $b32  (i64.xor (get_local $b32 ) (i64.load offset=256  (get_local $prev_block))))
    (set_local $b33  (i64.xor (get_local $b33 ) (i64.load offset=264  (get_local $prev_block))))
    (set_local $b34  (i64.xor (get_local $b34 ) (i64.load offset=272  (get_local $prev_block))))
    (set_local $b35  (i64.xor (get_local $b35 ) (i64.load offset=280  (get_local $prev_block))))
    (set_local $b36  (i64.xor (get_local $b36 ) (i64.load offset=288  (get_local $prev_block))))
    (set_local $b37  (i64.xor (get_local $b37 ) (i64.load offset=296  (get_local $prev_block))))
    (set_local $b38  (i64.xor (get_local $b38 ) (i64.load offset=304  (get_local $prev_block))))
    (set_local $b39  (i64.xor (get_local $b39 ) (i64.load offset=312  (get_local $prev_block))))
    (set_local $b40  (i64.xor (get_local $b40 ) (i64.load offset=320  (get_local $prev_block))))
    (set_local $b41  (i64.xor (get_local $b41 ) (i64.load offset=328  (get_local $prev_block))))
    (set_local $b42  (i64.xor (get_local $b42 ) (i64.load offset=336  (get_local $prev_block))))
    (set_local $b43  (i64.xor (get_local $b43 ) (i64.load offset=344  (get_local $prev_block))))
    (set_local $b44  (i64.xor (get_local $b44 ) (i64.load offset=352  (get_local $prev_block))))
    (set_local $b45  (i64.xor (get_local $b45 ) (i64.load offset=360  (get_local $prev_block))))
    (set_local $b46  (i64.xor (get_local $b46 ) (i64.load offset=368  (get_local $prev_block))))
    (set_local $b47  (i64.xor (get_local $b47 ) (i64.load offset=376  (get_local $prev_block))))
    (set_local $b48  (i64.xor (get_local $b48 ) (i64.load offset=384  (get_local $prev_block))))
    (set_local $b49  (i64.xor (get_local $b49 ) (i64.load offset=392  (get_local $prev_block))))
    (set_local $b50  (i64.xor (get_local $b50 ) (i64.load offset=400  (get_local $prev_block))))
    (set_local $b51  (i64.xor (get_local $b51 ) (i64.load offset=408  (get_local $prev_block))))
    (set_local $b52  (i64.xor (get_local $b52 ) (i64.load offset=416  (get_local $prev_block))))
    (set_local $b53  (i64.xor (get_local $b53 ) (i64.load offset=424  (get_local $prev_block))))
    (set_local $b54  (i64.xor (get_local $b54 ) (i64.load offset=432  (get_local $prev_block))))
    (set_local $b55  (i64.xor (get_local $b55 ) (i64.load offset=440  (get_local $prev_block))))
    (set_local $b56  (i64.xor (get_local $b56 ) (i64.load offset=448  (get_local $prev_block))))
    (set_local $b57  (i64.xor (get_local $b57 ) (i64.load offset=456  (get_local $prev_block))))
    (set_local $b58  (i64.xor (get_local $b58 ) (i64.load offset=464  (get_local $prev_block))))
    (set_local $b59  (i64.xor (get_local $b59 ) (i64.load offset=472  (get_local $prev_block))))
    (set_local $b60  (i64.xor (get_local $b60 ) (i64.load offset=480  (get_local $prev_block))))
    (set_local $b61  (i64.xor (get_local $b61 ) (i64.load offset=488  (get_local $prev_block))))
    (set_local $b62  (i64.xor (get_local $b62 ) (i64.load offset=496  (get_local $prev_block))))
    (set_local $b63  (i64.xor (get_local $b63 ) (i64.load offset=504  (get_local $prev_block))))
    (set_local $b64  (i64.xor (get_local $b64 ) (i64.load offset=512  (get_local $prev_block))))
    (set_local $b65  (i64.xor (get_local $b65 ) (i64.load offset=520  (get_local $prev_block))))
    (set_local $b66  (i64.xor (get_local $b66 ) (i64.load offset=528  (get_local $prev_block))))
    (set_local $b67  (i64.xor (get_local $b67 ) (i64.load offset=536  (get_local $prev_block))))
    (set_local $b68  (i64.xor (get_local $b68 ) (i64.load offset=544  (get_local $prev_block))))
    (set_local $b69  (i64.xor (get_local $b69 ) (i64.load offset=552  (get_local $prev_block))))
    (set_local $b70  (i64.xor (get_local $b70 ) (i64.load offset=560  (get_local $prev_block))))
    (set_local $b71  (i64.xor (get_local $b71 ) (i64.load offset=568  (get_local $prev_block))))
    (set_local $b72  (i64.xor (get_local $b72 ) (i64.load offset=576  (get_local $prev_block))))
    (set_local $b73  (i64.xor (get_local $b73 ) (i64.load offset=584  (get_local $prev_block))))
    (set_local $b74  (i64.xor (get_local $b74 ) (i64.load offset=592  (get_local $prev_block))))
    (set_local $b75  (i64.xor (get_local $b75 ) (i64.load offset=600  (get_local $prev_block))))
    (set_local $b76  (i64.xor (get_local $b76 ) (i64.load offset=608  (get_local $prev_block))))
    (set_local $b77  (i64.xor (get_local $b77 ) (i64.load offset=616  (get_local $prev_block))))
    (set_local $b78  (i64.xor (get_local $b78 ) (i64.load offset=624  (get_local $prev_block))))
    (set_local $b79  (i64.xor (get_local $b79 ) (i64.load offset=632  (get_local $prev_block))))
    (set_local $b80  (i64.xor (get_local $b80 ) (i64.load offset=640  (get_local $prev_block))))
    (set_local $b81  (i64.xor (get_local $b81 ) (i64.load offset=648  (get_local $prev_block))))
    (set_local $b82  (i64.xor (get_local $b82 ) (i64.load offset=656  (get_local $prev_block))))
    (set_local $b83  (i64.xor (get_local $b83 ) (i64.load offset=664  (get_local $prev_block))))
    (set_local $b84  (i64.xor (get_local $b84 ) (i64.load offset=672  (get_local $prev_block))))
    (set_local $b85  (i64.xor (get_local $b85 ) (i64.load offset=680  (get_local $prev_block))))
    (set_local $b86  (i64.xor (get_local $b86 ) (i64.load offset=688  (get_local $prev_block))))
    (set_local $b87  (i64.xor (get_local $b87 ) (i64.load offset=696  (get_local $prev_block))))
    (set_local $b88  (i64.xor (get_local $b88 ) (i64.load offset=704  (get_local $prev_block))))
    (set_local $b89  (i64.xor (get_local $b89 ) (i64.load offset=712  (get_local $prev_block))))
    (set_local $b90  (i64.xor (get_local $b90 ) (i64.load offset=720  (get_local $prev_block))))
    (set_local $b91  (i64.xor (get_local $b91 ) (i64.load offset=728  (get_local $prev_block))))
    (set_local $b92  (i64.xor (get_local $b92 ) (i64.load offset=736  (get_local $prev_block))))
    (set_local $b93  (i64.xor (get_local $b93 ) (i64.load offset=744  (get_local $prev_block))))
    (set_local $b94  (i64.xor (get_local $b94 ) (i64.load offset=752  (get_local $prev_block))))
    (set_local $b95  (i64.xor (get_local $b95 ) (i64.load offset=760  (get_local $prev_block))))
    (set_local $b96  (i64.xor (get_local $b96 ) (i64.load offset=768  (get_local $prev_block))))
    (set_local $b97  (i64.xor (get_local $b97 ) (i64.load offset=776  (get_local $prev_block))))
    (set_local $b98  (i64.xor (get_local $b98 ) (i64.load offset=784  (get_local $prev_block))))
    (set_local $b99  (i64.xor (get_local $b99 ) (i64.load offset=792  (get_local $prev_block))))
    (set_local $b100 (i64.xor (get_local $b100) (i64.load offset=800  (get_local $prev_block))))
    (set_local $b101 (i64.xor (get_local $b101) (i64.load offset=808  (get_local $prev_block))))
    (set_local $b102 (i64.xor (get_local $b102) (i64.load offset=816  (get_local $prev_block))))
    (set_local $b103 (i64.xor (get_local $b103) (i64.load offset=824  (get_local $prev_block))))
    (set_local $b104 (i64.xor (get_local $b104) (i64.load offset=832  (get_local $prev_block))))
    (set_local $b105 (i64.xor (get_local $b105) (i64.load offset=840  (get_local $prev_block))))
    (set_local $b106 (i64.xor (get_local $b106) (i64.load offset=848  (get_local $prev_block))))
    (set_local $b107 (i64.xor (get_local $b107) (i64.load offset=856  (get_local $prev_block))))
    (set_local $b108 (i64.xor (get_local $b108) (i64.load offset=864  (get_local $prev_block))))
    (set_local $b109 (i64.xor (get_local $b109) (i64.load offset=872  (get_local $prev_block))))
    (set_local $b110 (i64.xor (get_local $b110) (i64.load offset=880  (get_local $prev_block))))
    (set_local $b111 (i64.xor (get_local $b111) (i64.load offset=888  (get_local $prev_block))))
    (set_local $b112 (i64.xor (get_local $b112) (i64.load offset=896  (get_local $prev_block))))
    (set_local $b113 (i64.xor (get_local $b113) (i64.load offset=904  (get_local $prev_block))))
    (set_local $b114 (i64.xor (get_local $b114) (i64.load offset=912  (get_local $prev_block))))
    (set_local $b115 (i64.xor (get_local $b115) (i64.load offset=920  (get_local $prev_block))))
    (set_local $b116 (i64.xor (get_local $b116) (i64.load offset=928  (get_local $prev_block))))
    (set_local $b117 (i64.xor (get_local $b117) (i64.load offset=936  (get_local $prev_block))))
    (set_local $b118 (i64.xor (get_local $b118) (i64.load offset=944  (get_local $prev_block))))
    (set_local $b119 (i64.xor (get_local $b119) (i64.load offset=952  (get_local $prev_block))))
    (set_local $b120 (i64.xor (get_local $b120) (i64.load offset=960  (get_local $prev_block))))
    (set_local $b121 (i64.xor (get_local $b121) (i64.load offset=968  (get_local $prev_block))))
    (set_local $b122 (i64.xor (get_local $b122) (i64.load offset=976  (get_local $prev_block))))
    (set_local $b123 (i64.xor (get_local $b123) (i64.load offset=984  (get_local $prev_block))))
    (set_local $b124 (i64.xor (get_local $b124) (i64.load offset=992  (get_local $prev_block))))
    (set_local $b125 (i64.xor (get_local $b125) (i64.load offset=1000 (get_local $prev_block))))
    (set_local $b126 (i64.xor (get_local $b126) (i64.load offset=1008 (get_local $prev_block))))
    (set_local $b127 (i64.xor (get_local $b127) (i64.load offset=1016 (get_local $prev_block))))

    (set_local $tmp0   (get_local $b0))
    (set_local $tmp1   (get_local $b1))
    (set_local $tmp2   (get_local $b2))
    (set_local $tmp3   (get_local $b3))
    (set_local $tmp4   (get_local $b4))
    (set_local $tmp5   (get_local $b5))
    (set_local $tmp6   (get_local $b6))
    (set_local $tmp7   (get_local $b7))
    (set_local $tmp8   (get_local $b8))
    (set_local $tmp9   (get_local $b9))
    (set_local $tmp10  (get_local $b10))
    (set_local $tmp11  (get_local $b11))
    (set_local $tmp12  (get_local $b12))
    (set_local $tmp13  (get_local $b13))
    (set_local $tmp14  (get_local $b14))
    (set_local $tmp15  (get_local $b15))
    (set_local $tmp16  (get_local $b16))
    (set_local $tmp17  (get_local $b17))
    (set_local $tmp18  (get_local $b18))
    (set_local $tmp19  (get_local $b19))
    (set_local $tmp20  (get_local $b20))
    (set_local $tmp21  (get_local $b21))
    (set_local $tmp22  (get_local $b22))
    (set_local $tmp23  (get_local $b23))
    (set_local $tmp24  (get_local $b24))
    (set_local $tmp25  (get_local $b25))
    (set_local $tmp26  (get_local $b26))
    (set_local $tmp27  (get_local $b27))
    (set_local $tmp28  (get_local $b28))
    (set_local $tmp29  (get_local $b29))
    (set_local $tmp30  (get_local $b30))
    (set_local $tmp31  (get_local $b31))
    (set_local $tmp32  (get_local $b32))
    (set_local $tmp33  (get_local $b33))
    (set_local $tmp34  (get_local $b34))
    (set_local $tmp35  (get_local $b35))
    (set_local $tmp36  (get_local $b36))
    (set_local $tmp37  (get_local $b37))
    (set_local $tmp38  (get_local $b38))
    (set_local $tmp39  (get_local $b39))
    (set_local $tmp40  (get_local $b40))
    (set_local $tmp41  (get_local $b41))
    (set_local $tmp42  (get_local $b42))
    (set_local $tmp43  (get_local $b43))
    (set_local $tmp44  (get_local $b44))
    (set_local $tmp45  (get_local $b45))
    (set_local $tmp46  (get_local $b46))
    (set_local $tmp47  (get_local $b47))
    (set_local $tmp48  (get_local $b48))
    (set_local $tmp49  (get_local $b49))
    (set_local $tmp50  (get_local $b50))
    (set_local $tmp51  (get_local $b51))
    (set_local $tmp52  (get_local $b52))
    (set_local $tmp53  (get_local $b53))
    (set_local $tmp54  (get_local $b54))
    (set_local $tmp55  (get_local $b55))
    (set_local $tmp56  (get_local $b56))
    (set_local $tmp57  (get_local $b57))
    (set_local $tmp58  (get_local $b58))
    (set_local $tmp59  (get_local $b59))
    (set_local $tmp60  (get_local $b60))
    (set_local $tmp61  (get_local $b61))
    (set_local $tmp62  (get_local $b62))
    (set_local $tmp63  (get_local $b63))
    (set_local $tmp64  (get_local $b64))
    (set_local $tmp65  (get_local $b65))
    (set_local $tmp66  (get_local $b66))
    (set_local $tmp67  (get_local $b67))
    (set_local $tmp68  (get_local $b68))
    (set_local $tmp69  (get_local $b69))
    (set_local $tmp70  (get_local $b70))
    (set_local $tmp71  (get_local $b71))
    (set_local $tmp72  (get_local $b72))
    (set_local $tmp73  (get_local $b73))
    (set_local $tmp74  (get_local $b74))
    (set_local $tmp75  (get_local $b75))
    (set_local $tmp76  (get_local $b76))
    (set_local $tmp77  (get_local $b77))
    (set_local $tmp78  (get_local $b78))
    (set_local $tmp79  (get_local $b79))
    (set_local $tmp80  (get_local $b80))
    (set_local $tmp81  (get_local $b81))
    (set_local $tmp82  (get_local $b82))
    (set_local $tmp83  (get_local $b83))
    (set_local $tmp84  (get_local $b84))
    (set_local $tmp85  (get_local $b85))
    (set_local $tmp86  (get_local $b86))
    (set_local $tmp87  (get_local $b87))
    (set_local $tmp88  (get_local $b88))
    (set_local $tmp89  (get_local $b89))
    (set_local $tmp90  (get_local $b90))
    (set_local $tmp91  (get_local $b91))
    (set_local $tmp92  (get_local $b92))
    (set_local $tmp93  (get_local $b93))
    (set_local $tmp94  (get_local $b94))
    (set_local $tmp95  (get_local $b95))
    (set_local $tmp96  (get_local $b96))
    (set_local $tmp97  (get_local $b97))
    (set_local $tmp98  (get_local $b98))
    (set_local $tmp99  (get_local $b99))
    (set_local $tmp100 (get_local $b100))
    (set_local $tmp101 (get_local $b101))
    (set_local $tmp102 (get_local $b102))
    (set_local $tmp103 (get_local $b103))
    (set_local $tmp104 (get_local $b104))
    (set_local $tmp105 (get_local $b105))
    (set_local $tmp106 (get_local $b106))
    (set_local $tmp107 (get_local $b107))
    (set_local $tmp108 (get_local $b108))
    (set_local $tmp109 (get_local $b109))
    (set_local $tmp110 (get_local $b110))
    (set_local $tmp111 (get_local $b111))
    (set_local $tmp112 (get_local $b112))
    (set_local $tmp113 (get_local $b113))
    (set_local $tmp114 (get_local $b114))
    (set_local $tmp115 (get_local $b115))
    (set_local $tmp116 (get_local $b116))
    (set_local $tmp117 (get_local $b117))
    (set_local $tmp118 (get_local $b118))
    (set_local $tmp119 (get_local $b119))
    (set_local $tmp120 (get_local $b120))
    (set_local $tmp121 (get_local $b121))
    (set_local $tmp122 (get_local $b122))
    (set_local $tmp123 (get_local $b123))
    (set_local $tmp124 (get_local $b124))
    (set_local $tmp125 (get_local $b125))
    (set_local $tmp126 (get_local $b126))
    (set_local $tmp127 (get_local $b127))

    (get_local $xor)
    (i32.const 0)
    (i32.ne)
    (if (then
        (set_local $tmp0   (i64.xor (get_local $tmp0  ) (i64.load offset=0    (get_local $next_block))))
        (set_local $tmp1   (i64.xor (get_local $tmp1  ) (i64.load offset=8    (get_local $next_block))))
        (set_local $tmp2   (i64.xor (get_local $tmp2  ) (i64.load offset=16   (get_local $next_block))))
        (set_local $tmp3   (i64.xor (get_local $tmp3  ) (i64.load offset=24   (get_local $next_block))))
        (set_local $tmp4   (i64.xor (get_local $tmp4  ) (i64.load offset=32   (get_local $next_block))))
        (set_local $tmp5   (i64.xor (get_local $tmp5  ) (i64.load offset=40   (get_local $next_block))))
        (set_local $tmp6   (i64.xor (get_local $tmp6  ) (i64.load offset=48   (get_local $next_block))))
        (set_local $tmp7   (i64.xor (get_local $tmp7  ) (i64.load offset=56   (get_local $next_block))))
        (set_local $tmp8   (i64.xor (get_local $tmp8  ) (i64.load offset=64   (get_local $next_block))))
        (set_local $tmp9   (i64.xor (get_local $tmp9  ) (i64.load offset=72   (get_local $next_block))))
        (set_local $tmp10  (i64.xor (get_local $tmp10 ) (i64.load offset=80   (get_local $next_block))))
        (set_local $tmp11  (i64.xor (get_local $tmp11 ) (i64.load offset=88   (get_local $next_block))))
        (set_local $tmp12  (i64.xor (get_local $tmp12 ) (i64.load offset=96   (get_local $next_block))))
        (set_local $tmp13  (i64.xor (get_local $tmp13 ) (i64.load offset=104  (get_local $next_block))))
        (set_local $tmp14  (i64.xor (get_local $tmp14 ) (i64.load offset=112  (get_local $next_block))))
        (set_local $tmp15  (i64.xor (get_local $tmp15 ) (i64.load offset=120  (get_local $next_block))))
        (set_local $tmp16  (i64.xor (get_local $tmp16 ) (i64.load offset=128  (get_local $next_block))))
        (set_local $tmp17  (i64.xor (get_local $tmp17 ) (i64.load offset=136  (get_local $next_block))))
        (set_local $tmp18  (i64.xor (get_local $tmp18 ) (i64.load offset=144  (get_local $next_block))))
        (set_local $tmp19  (i64.xor (get_local $tmp19 ) (i64.load offset=152  (get_local $next_block))))
        (set_local $tmp20  (i64.xor (get_local $tmp20 ) (i64.load offset=160  (get_local $next_block))))
        (set_local $tmp21  (i64.xor (get_local $tmp21 ) (i64.load offset=168  (get_local $next_block))))
        (set_local $tmp22  (i64.xor (get_local $tmp22 ) (i64.load offset=176  (get_local $next_block))))
        (set_local $tmp23  (i64.xor (get_local $tmp23 ) (i64.load offset=184  (get_local $next_block))))
        (set_local $tmp24  (i64.xor (get_local $tmp24 ) (i64.load offset=192  (get_local $next_block))))
        (set_local $tmp25  (i64.xor (get_local $tmp25 ) (i64.load offset=200  (get_local $next_block))))
        (set_local $tmp26  (i64.xor (get_local $tmp26 ) (i64.load offset=208  (get_local $next_block))))
        (set_local $tmp27  (i64.xor (get_local $tmp27 ) (i64.load offset=216  (get_local $next_block))))
        (set_local $tmp28  (i64.xor (get_local $tmp28 ) (i64.load offset=224  (get_local $next_block))))
        (set_local $tmp29  (i64.xor (get_local $tmp29 ) (i64.load offset=232  (get_local $next_block))))
        (set_local $tmp30  (i64.xor (get_local $tmp30 ) (i64.load offset=240  (get_local $next_block))))
        (set_local $tmp31  (i64.xor (get_local $tmp31 ) (i64.load offset=248  (get_local $next_block))))
        (set_local $tmp32  (i64.xor (get_local $tmp32 ) (i64.load offset=256  (get_local $next_block))))
        (set_local $tmp33  (i64.xor (get_local $tmp33 ) (i64.load offset=264  (get_local $next_block))))
        (set_local $tmp34  (i64.xor (get_local $tmp34 ) (i64.load offset=272  (get_local $next_block))))
        (set_local $tmp35  (i64.xor (get_local $tmp35 ) (i64.load offset=280  (get_local $next_block))))
        (set_local $tmp36  (i64.xor (get_local $tmp36 ) (i64.load offset=288  (get_local $next_block))))
        (set_local $tmp37  (i64.xor (get_local $tmp37 ) (i64.load offset=296  (get_local $next_block))))
        (set_local $tmp38  (i64.xor (get_local $tmp38 ) (i64.load offset=304  (get_local $next_block))))
        (set_local $tmp39  (i64.xor (get_local $tmp39 ) (i64.load offset=312  (get_local $next_block))))
        (set_local $tmp40  (i64.xor (get_local $tmp40 ) (i64.load offset=320  (get_local $next_block))))
        (set_local $tmp41  (i64.xor (get_local $tmp41 ) (i64.load offset=328  (get_local $next_block))))
        (set_local $tmp42  (i64.xor (get_local $tmp42 ) (i64.load offset=336  (get_local $next_block))))
        (set_local $tmp43  (i64.xor (get_local $tmp43 ) (i64.load offset=344  (get_local $next_block))))
        (set_local $tmp44  (i64.xor (get_local $tmp44 ) (i64.load offset=352  (get_local $next_block))))
        (set_local $tmp45  (i64.xor (get_local $tmp45 ) (i64.load offset=360  (get_local $next_block))))
        (set_local $tmp46  (i64.xor (get_local $tmp46 ) (i64.load offset=368  (get_local $next_block))))
        (set_local $tmp47  (i64.xor (get_local $tmp47 ) (i64.load offset=376  (get_local $next_block))))
        (set_local $tmp48  (i64.xor (get_local $tmp48 ) (i64.load offset=384  (get_local $next_block))))
        (set_local $tmp49  (i64.xor (get_local $tmp49 ) (i64.load offset=392  (get_local $next_block))))
        (set_local $tmp50  (i64.xor (get_local $tmp50 ) (i64.load offset=400  (get_local $next_block))))
        (set_local $tmp51  (i64.xor (get_local $tmp51 ) (i64.load offset=408  (get_local $next_block))))
        (set_local $tmp52  (i64.xor (get_local $tmp52 ) (i64.load offset=416  (get_local $next_block))))
        (set_local $tmp53  (i64.xor (get_local $tmp53 ) (i64.load offset=424  (get_local $next_block))))
        (set_local $tmp54  (i64.xor (get_local $tmp54 ) (i64.load offset=432  (get_local $next_block))))
        (set_local $tmp55  (i64.xor (get_local $tmp55 ) (i64.load offset=440  (get_local $next_block))))
        (set_local $tmp56  (i64.xor (get_local $tmp56 ) (i64.load offset=448  (get_local $next_block))))
        (set_local $tmp57  (i64.xor (get_local $tmp57 ) (i64.load offset=456  (get_local $next_block))))
        (set_local $tmp58  (i64.xor (get_local $tmp58 ) (i64.load offset=464  (get_local $next_block))))
        (set_local $tmp59  (i64.xor (get_local $tmp59 ) (i64.load offset=472  (get_local $next_block))))
        (set_local $tmp60  (i64.xor (get_local $tmp60 ) (i64.load offset=480  (get_local $next_block))))
        (set_local $tmp61  (i64.xor (get_local $tmp61 ) (i64.load offset=488  (get_local $next_block))))
        (set_local $tmp62  (i64.xor (get_local $tmp62 ) (i64.load offset=496  (get_local $next_block))))
        (set_local $tmp63  (i64.xor (get_local $tmp63 ) (i64.load offset=504  (get_local $next_block))))
        (set_local $tmp64  (i64.xor (get_local $tmp64 ) (i64.load offset=512  (get_local $next_block))))
        (set_local $tmp65  (i64.xor (get_local $tmp65 ) (i64.load offset=520  (get_local $next_block))))
        (set_local $tmp66  (i64.xor (get_local $tmp66 ) (i64.load offset=528  (get_local $next_block))))
        (set_local $tmp67  (i64.xor (get_local $tmp67 ) (i64.load offset=536  (get_local $next_block))))
        (set_local $tmp68  (i64.xor (get_local $tmp68 ) (i64.load offset=544  (get_local $next_block))))
        (set_local $tmp69  (i64.xor (get_local $tmp69 ) (i64.load offset=552  (get_local $next_block))))
        (set_local $tmp70  (i64.xor (get_local $tmp70 ) (i64.load offset=560  (get_local $next_block))))
        (set_local $tmp71  (i64.xor (get_local $tmp71 ) (i64.load offset=568  (get_local $next_block))))
        (set_local $tmp72  (i64.xor (get_local $tmp72 ) (i64.load offset=576  (get_local $next_block))))
        (set_local $tmp73  (i64.xor (get_local $tmp73 ) (i64.load offset=584  (get_local $next_block))))
        (set_local $tmp74  (i64.xor (get_local $tmp74 ) (i64.load offset=592  (get_local $next_block))))
        (set_local $tmp75  (i64.xor (get_local $tmp75 ) (i64.load offset=600  (get_local $next_block))))
        (set_local $tmp76  (i64.xor (get_local $tmp76 ) (i64.load offset=608  (get_local $next_block))))
        (set_local $tmp77  (i64.xor (get_local $tmp77 ) (i64.load offset=616  (get_local $next_block))))
        (set_local $tmp78  (i64.xor (get_local $tmp78 ) (i64.load offset=624  (get_local $next_block))))
        (set_local $tmp79  (i64.xor (get_local $tmp79 ) (i64.load offset=632  (get_local $next_block))))
        (set_local $tmp80  (i64.xor (get_local $tmp80 ) (i64.load offset=640  (get_local $next_block))))
        (set_local $tmp81  (i64.xor (get_local $tmp81 ) (i64.load offset=648  (get_local $next_block))))
        (set_local $tmp82  (i64.xor (get_local $tmp82 ) (i64.load offset=656  (get_local $next_block))))
        (set_local $tmp83  (i64.xor (get_local $tmp83 ) (i64.load offset=664  (get_local $next_block))))
        (set_local $tmp84  (i64.xor (get_local $tmp84 ) (i64.load offset=672  (get_local $next_block))))
        (set_local $tmp85  (i64.xor (get_local $tmp85 ) (i64.load offset=680  (get_local $next_block))))
        (set_local $tmp86  (i64.xor (get_local $tmp86 ) (i64.load offset=688  (get_local $next_block))))
        (set_local $tmp87  (i64.xor (get_local $tmp87 ) (i64.load offset=696  (get_local $next_block))))
        (set_local $tmp88  (i64.xor (get_local $tmp88 ) (i64.load offset=704  (get_local $next_block))))
        (set_local $tmp89  (i64.xor (get_local $tmp89 ) (i64.load offset=712  (get_local $next_block))))
        (set_local $tmp90  (i64.xor (get_local $tmp90 ) (i64.load offset=720  (get_local $next_block))))
        (set_local $tmp91  (i64.xor (get_local $tmp91 ) (i64.load offset=728  (get_local $next_block))))
        (set_local $tmp92  (i64.xor (get_local $tmp92 ) (i64.load offset=736  (get_local $next_block))))
        (set_local $tmp93  (i64.xor (get_local $tmp93 ) (i64.load offset=744  (get_local $next_block))))
        (set_local $tmp94  (i64.xor (get_local $tmp94 ) (i64.load offset=752  (get_local $next_block))))
        (set_local $tmp95  (i64.xor (get_local $tmp95 ) (i64.load offset=760  (get_local $next_block))))
        (set_local $tmp96  (i64.xor (get_local $tmp96 ) (i64.load offset=768  (get_local $next_block))))
        (set_local $tmp97  (i64.xor (get_local $tmp97 ) (i64.load offset=776  (get_local $next_block))))
        (set_local $tmp98  (i64.xor (get_local $tmp98 ) (i64.load offset=784  (get_local $next_block))))
        (set_local $tmp99  (i64.xor (get_local $tmp99 ) (i64.load offset=792  (get_local $next_block))))
        (set_local $tmp100 (i64.xor (get_local $tmp100) (i64.load offset=800  (get_local $next_block))))
        (set_local $tmp101 (i64.xor (get_local $tmp101) (i64.load offset=808  (get_local $next_block))))
        (set_local $tmp102 (i64.xor (get_local $tmp102) (i64.load offset=816  (get_local $next_block))))
        (set_local $tmp103 (i64.xor (get_local $tmp103) (i64.load offset=824  (get_local $next_block))))
        (set_local $tmp104 (i64.xor (get_local $tmp104) (i64.load offset=832  (get_local $next_block))))
        (set_local $tmp105 (i64.xor (get_local $tmp105) (i64.load offset=840  (get_local $next_block))))
        (set_local $tmp106 (i64.xor (get_local $tmp106) (i64.load offset=848  (get_local $next_block))))
        (set_local $tmp107 (i64.xor (get_local $tmp107) (i64.load offset=856  (get_local $next_block))))
        (set_local $tmp108 (i64.xor (get_local $tmp108) (i64.load offset=864  (get_local $next_block))))
        (set_local $tmp109 (i64.xor (get_local $tmp109) (i64.load offset=872  (get_local $next_block))))
        (set_local $tmp110 (i64.xor (get_local $tmp110) (i64.load offset=880  (get_local $next_block))))
        (set_local $tmp111 (i64.xor (get_local $tmp111) (i64.load offset=888  (get_local $next_block))))
        (set_local $tmp112 (i64.xor (get_local $tmp112) (i64.load offset=896  (get_local $next_block))))
        (set_local $tmp113 (i64.xor (get_local $tmp113) (i64.load offset=904  (get_local $next_block))))
        (set_local $tmp114 (i64.xor (get_local $tmp114) (i64.load offset=912  (get_local $next_block))))
        (set_local $tmp115 (i64.xor (get_local $tmp115) (i64.load offset=920  (get_local $next_block))))
        (set_local $tmp116 (i64.xor (get_local $tmp116) (i64.load offset=928  (get_local $next_block))))
        (set_local $tmp117 (i64.xor (get_local $tmp117) (i64.load offset=936  (get_local $next_block))))
        (set_local $tmp118 (i64.xor (get_local $tmp118) (i64.load offset=944  (get_local $next_block))))
        (set_local $tmp119 (i64.xor (get_local $tmp119) (i64.load offset=952  (get_local $next_block))))
        (set_local $tmp120 (i64.xor (get_local $tmp120) (i64.load offset=960  (get_local $next_block))))
        (set_local $tmp121 (i64.xor (get_local $tmp121) (i64.load offset=968  (get_local $next_block))))
        (set_local $tmp122 (i64.xor (get_local $tmp122) (i64.load offset=976  (get_local $next_block))))
        (set_local $tmp123 (i64.xor (get_local $tmp123) (i64.load offset=984  (get_local $next_block))))
        (set_local $tmp124 (i64.xor (get_local $tmp124) (i64.load offset=992  (get_local $next_block))))
        (set_local $tmp125 (i64.xor (get_local $tmp125) (i64.load offset=1000 (get_local $next_block))))
        (set_local $tmp126 (i64.xor (get_local $tmp126) (i64.load offset=1008 (get_local $next_block))))
        (set_local $tmp127 (i64.xor (get_local $tmp127) (i64.load offset=1016 (get_local $next_block))))))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b0) (i64.const 0xffffffff)) (i64.and (get_local $b4) (i64.const 0xffffffff)))))
    (set_local $b0 (i64.add (get_local $b0) (i64.add (get_local $b4) (get_local $tmp))))
    (set_local $b12 (i64.rotr (i64.xor (get_local $b12) (get_local $b0)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b8) (i64.const 0xffffffff)) (i64.and (get_local $b12) (i64.const 0xffffffff)))))
    (set_local $b8 (i64.add (get_local $b8) (i64.add (get_local $b12) (get_local $tmp))))
    (set_local $b4 (i64.rotr (i64.xor (get_local $b4) (get_local $b8)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b0) (i64.const 0xffffffff)) (i64.and (get_local $b4) (i64.const 0xffffffff)))))
    (set_local $b0 (i64.add (get_local $b0) (i64.add (get_local $b4) (get_local $tmp))))
    (set_local $b12 (i64.rotr (i64.xor (get_local $b12) (get_local $b0)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b8) (i64.const 0xffffffff)) (i64.and (get_local $b12) (i64.const 0xffffffff)))))
    (set_local $b8 (i64.add (get_local $b8) (i64.add (get_local $b12) (get_local $tmp))))
    (set_local $b4 (i64.rotr (i64.xor (get_local $b4) (get_local $b8)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b1) (i64.const 0xffffffff)) (i64.and (get_local $b5) (i64.const 0xffffffff)))))
    (set_local $b1 (i64.add (get_local $b1) (i64.add (get_local $b5) (get_local $tmp))))
    (set_local $b13 (i64.rotr (i64.xor (get_local $b13) (get_local $b1)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b9) (i64.const 0xffffffff)) (i64.and (get_local $b13) (i64.const 0xffffffff)))))
    (set_local $b9 (i64.add (get_local $b9) (i64.add (get_local $b13) (get_local $tmp))))
    (set_local $b5 (i64.rotr (i64.xor (get_local $b5) (get_local $b9)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b1) (i64.const 0xffffffff)) (i64.and (get_local $b5) (i64.const 0xffffffff)))))
    (set_local $b1 (i64.add (get_local $b1) (i64.add (get_local $b5) (get_local $tmp))))
    (set_local $b13 (i64.rotr (i64.xor (get_local $b13) (get_local $b1)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b9) (i64.const 0xffffffff)) (i64.and (get_local $b13) (i64.const 0xffffffff)))))
    (set_local $b9 (i64.add (get_local $b9) (i64.add (get_local $b13) (get_local $tmp))))
    (set_local $b5 (i64.rotr (i64.xor (get_local $b5) (get_local $b9)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b2) (i64.const 0xffffffff)) (i64.and (get_local $b6) (i64.const 0xffffffff)))))
    (set_local $b2 (i64.add (get_local $b2) (i64.add (get_local $b6) (get_local $tmp))))
    (set_local $b14 (i64.rotr (i64.xor (get_local $b14) (get_local $b2)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b10) (i64.const 0xffffffff)) (i64.and (get_local $b14) (i64.const 0xffffffff)))))
    (set_local $b10 (i64.add (get_local $b10) (i64.add (get_local $b14) (get_local $tmp))))
    (set_local $b6 (i64.rotr (i64.xor (get_local $b6) (get_local $b10)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b2) (i64.const 0xffffffff)) (i64.and (get_local $b6) (i64.const 0xffffffff)))))
    (set_local $b2 (i64.add (get_local $b2) (i64.add (get_local $b6) (get_local $tmp))))
    (set_local $b14 (i64.rotr (i64.xor (get_local $b14) (get_local $b2)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b10) (i64.const 0xffffffff)) (i64.and (get_local $b14) (i64.const 0xffffffff)))))
    (set_local $b10 (i64.add (get_local $b10) (i64.add (get_local $b14) (get_local $tmp))))
    (set_local $b6 (i64.rotr (i64.xor (get_local $b6) (get_local $b10)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b3) (i64.const 0xffffffff)) (i64.and (get_local $b7) (i64.const 0xffffffff)))))
    (set_local $b3 (i64.add (get_local $b3) (i64.add (get_local $b7) (get_local $tmp))))
    (set_local $b15 (i64.rotr (i64.xor (get_local $b15) (get_local $b3)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b11) (i64.const 0xffffffff)) (i64.and (get_local $b15) (i64.const 0xffffffff)))))
    (set_local $b11 (i64.add (get_local $b11) (i64.add (get_local $b15) (get_local $tmp))))
    (set_local $b7 (i64.rotr (i64.xor (get_local $b7) (get_local $b11)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b3) (i64.const 0xffffffff)) (i64.and (get_local $b7) (i64.const 0xffffffff)))))
    (set_local $b3 (i64.add (get_local $b3) (i64.add (get_local $b7) (get_local $tmp))))
    (set_local $b15 (i64.rotr (i64.xor (get_local $b15) (get_local $b3)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b11) (i64.const 0xffffffff)) (i64.and (get_local $b15) (i64.const 0xffffffff)))))
    (set_local $b11 (i64.add (get_local $b11) (i64.add (get_local $b15) (get_local $tmp))))
    (set_local $b7 (i64.rotr (i64.xor (get_local $b7) (get_local $b11)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b0) (i64.const 0xffffffff)) (i64.and (get_local $b5) (i64.const 0xffffffff)))))
    (set_local $b0 (i64.add (get_local $b0) (i64.add (get_local $b5) (get_local $tmp))))
    (set_local $b15 (i64.rotr (i64.xor (get_local $b15) (get_local $b0)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b10) (i64.const 0xffffffff)) (i64.and (get_local $b15) (i64.const 0xffffffff)))))
    (set_local $b10 (i64.add (get_local $b10) (i64.add (get_local $b15) (get_local $tmp))))
    (set_local $b5 (i64.rotr (i64.xor (get_local $b5) (get_local $b10)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b0) (i64.const 0xffffffff)) (i64.and (get_local $b5) (i64.const 0xffffffff)))))
    (set_local $b0 (i64.add (get_local $b0) (i64.add (get_local $b5) (get_local $tmp))))
    (set_local $b15 (i64.rotr (i64.xor (get_local $b15) (get_local $b0)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b10) (i64.const 0xffffffff)) (i64.and (get_local $b15) (i64.const 0xffffffff)))))
    (set_local $b10 (i64.add (get_local $b10) (i64.add (get_local $b15) (get_local $tmp))))
    (set_local $b5 (i64.rotr (i64.xor (get_local $b5) (get_local $b10)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b1) (i64.const 0xffffffff)) (i64.and (get_local $b6) (i64.const 0xffffffff)))))
    (set_local $b1 (i64.add (get_local $b1) (i64.add (get_local $b6) (get_local $tmp))))
    (set_local $b12 (i64.rotr (i64.xor (get_local $b12) (get_local $b1)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b11) (i64.const 0xffffffff)) (i64.and (get_local $b12) (i64.const 0xffffffff)))))
    (set_local $b11 (i64.add (get_local $b11) (i64.add (get_local $b12) (get_local $tmp))))
    (set_local $b6 (i64.rotr (i64.xor (get_local $b6) (get_local $b11)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b1) (i64.const 0xffffffff)) (i64.and (get_local $b6) (i64.const 0xffffffff)))))
    (set_local $b1 (i64.add (get_local $b1) (i64.add (get_local $b6) (get_local $tmp))))
    (set_local $b12 (i64.rotr (i64.xor (get_local $b12) (get_local $b1)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b11) (i64.const 0xffffffff)) (i64.and (get_local $b12) (i64.const 0xffffffff)))))
    (set_local $b11 (i64.add (get_local $b11) (i64.add (get_local $b12) (get_local $tmp))))
    (set_local $b6 (i64.rotr (i64.xor (get_local $b6) (get_local $b11)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b2) (i64.const 0xffffffff)) (i64.and (get_local $b7) (i64.const 0xffffffff)))))
    (set_local $b2 (i64.add (get_local $b2) (i64.add (get_local $b7) (get_local $tmp))))
    (set_local $b13 (i64.rotr (i64.xor (get_local $b13) (get_local $b2)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b8) (i64.const 0xffffffff)) (i64.and (get_local $b13) (i64.const 0xffffffff)))))
    (set_local $b8 (i64.add (get_local $b8) (i64.add (get_local $b13) (get_local $tmp))))
    (set_local $b7 (i64.rotr (i64.xor (get_local $b7) (get_local $b8)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b2) (i64.const 0xffffffff)) (i64.and (get_local $b7) (i64.const 0xffffffff)))))
    (set_local $b2 (i64.add (get_local $b2) (i64.add (get_local $b7) (get_local $tmp))))
    (set_local $b13 (i64.rotr (i64.xor (get_local $b13) (get_local $b2)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b8) (i64.const 0xffffffff)) (i64.and (get_local $b13) (i64.const 0xffffffff)))))
    (set_local $b8 (i64.add (get_local $b8) (i64.add (get_local $b13) (get_local $tmp))))
    (set_local $b7 (i64.rotr (i64.xor (get_local $b7) (get_local $b8)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b3) (i64.const 0xffffffff)) (i64.and (get_local $b4) (i64.const 0xffffffff)))))
    (set_local $b3 (i64.add (get_local $b3) (i64.add (get_local $b4) (get_local $tmp))))
    (set_local $b14 (i64.rotr (i64.xor (get_local $b14) (get_local $b3)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b9) (i64.const 0xffffffff)) (i64.and (get_local $b14) (i64.const 0xffffffff)))))
    (set_local $b9 (i64.add (get_local $b9) (i64.add (get_local $b14) (get_local $tmp))))
    (set_local $b4 (i64.rotr (i64.xor (get_local $b4) (get_local $b9)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b3) (i64.const 0xffffffff)) (i64.and (get_local $b4) (i64.const 0xffffffff)))))
    (set_local $b3 (i64.add (get_local $b3) (i64.add (get_local $b4) (get_local $tmp))))
    (set_local $b14 (i64.rotr (i64.xor (get_local $b14) (get_local $b3)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b9) (i64.const 0xffffffff)) (i64.and (get_local $b14) (i64.const 0xffffffff)))))
    (set_local $b9 (i64.add (get_local $b9) (i64.add (get_local $b14) (get_local $tmp))))
    (set_local $b4 (i64.rotr (i64.xor (get_local $b4) (get_local $b9)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b16) (i64.const 0xffffffff)) (i64.and (get_local $b20) (i64.const 0xffffffff)))))
    (set_local $b16 (i64.add (get_local $b16) (i64.add (get_local $b20) (get_local $tmp))))
    (set_local $b28 (i64.rotr (i64.xor (get_local $b28) (get_local $b16)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b24) (i64.const 0xffffffff)) (i64.and (get_local $b28) (i64.const 0xffffffff)))))
    (set_local $b24 (i64.add (get_local $b24) (i64.add (get_local $b28) (get_local $tmp))))
    (set_local $b20 (i64.rotr (i64.xor (get_local $b20) (get_local $b24)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b16) (i64.const 0xffffffff)) (i64.and (get_local $b20) (i64.const 0xffffffff)))))
    (set_local $b16 (i64.add (get_local $b16) (i64.add (get_local $b20) (get_local $tmp))))
    (set_local $b28 (i64.rotr (i64.xor (get_local $b28) (get_local $b16)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b24) (i64.const 0xffffffff)) (i64.and (get_local $b28) (i64.const 0xffffffff)))))
    (set_local $b24 (i64.add (get_local $b24) (i64.add (get_local $b28) (get_local $tmp))))
    (set_local $b20 (i64.rotr (i64.xor (get_local $b20) (get_local $b24)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b17) (i64.const 0xffffffff)) (i64.and (get_local $b21) (i64.const 0xffffffff)))))
    (set_local $b17 (i64.add (get_local $b17) (i64.add (get_local $b21) (get_local $tmp))))
    (set_local $b29 (i64.rotr (i64.xor (get_local $b29) (get_local $b17)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b25) (i64.const 0xffffffff)) (i64.and (get_local $b29) (i64.const 0xffffffff)))))
    (set_local $b25 (i64.add (get_local $b25) (i64.add (get_local $b29) (get_local $tmp))))
    (set_local $b21 (i64.rotr (i64.xor (get_local $b21) (get_local $b25)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b17) (i64.const 0xffffffff)) (i64.and (get_local $b21) (i64.const 0xffffffff)))))
    (set_local $b17 (i64.add (get_local $b17) (i64.add (get_local $b21) (get_local $tmp))))
    (set_local $b29 (i64.rotr (i64.xor (get_local $b29) (get_local $b17)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b25) (i64.const 0xffffffff)) (i64.and (get_local $b29) (i64.const 0xffffffff)))))
    (set_local $b25 (i64.add (get_local $b25) (i64.add (get_local $b29) (get_local $tmp))))
    (set_local $b21 (i64.rotr (i64.xor (get_local $b21) (get_local $b25)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b18) (i64.const 0xffffffff)) (i64.and (get_local $b22) (i64.const 0xffffffff)))))
    (set_local $b18 (i64.add (get_local $b18) (i64.add (get_local $b22) (get_local $tmp))))
    (set_local $b30 (i64.rotr (i64.xor (get_local $b30) (get_local $b18)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b26) (i64.const 0xffffffff)) (i64.and (get_local $b30) (i64.const 0xffffffff)))))
    (set_local $b26 (i64.add (get_local $b26) (i64.add (get_local $b30) (get_local $tmp))))
    (set_local $b22 (i64.rotr (i64.xor (get_local $b22) (get_local $b26)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b18) (i64.const 0xffffffff)) (i64.and (get_local $b22) (i64.const 0xffffffff)))))
    (set_local $b18 (i64.add (get_local $b18) (i64.add (get_local $b22) (get_local $tmp))))
    (set_local $b30 (i64.rotr (i64.xor (get_local $b30) (get_local $b18)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b26) (i64.const 0xffffffff)) (i64.and (get_local $b30) (i64.const 0xffffffff)))))
    (set_local $b26 (i64.add (get_local $b26) (i64.add (get_local $b30) (get_local $tmp))))
    (set_local $b22 (i64.rotr (i64.xor (get_local $b22) (get_local $b26)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b19) (i64.const 0xffffffff)) (i64.and (get_local $b23) (i64.const 0xffffffff)))))
    (set_local $b19 (i64.add (get_local $b19) (i64.add (get_local $b23) (get_local $tmp))))
    (set_local $b31 (i64.rotr (i64.xor (get_local $b31) (get_local $b19)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b27) (i64.const 0xffffffff)) (i64.and (get_local $b31) (i64.const 0xffffffff)))))
    (set_local $b27 (i64.add (get_local $b27) (i64.add (get_local $b31) (get_local $tmp))))
    (set_local $b23 (i64.rotr (i64.xor (get_local $b23) (get_local $b27)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b19) (i64.const 0xffffffff)) (i64.and (get_local $b23) (i64.const 0xffffffff)))))
    (set_local $b19 (i64.add (get_local $b19) (i64.add (get_local $b23) (get_local $tmp))))
    (set_local $b31 (i64.rotr (i64.xor (get_local $b31) (get_local $b19)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b27) (i64.const 0xffffffff)) (i64.and (get_local $b31) (i64.const 0xffffffff)))))
    (set_local $b27 (i64.add (get_local $b27) (i64.add (get_local $b31) (get_local $tmp))))
    (set_local $b23 (i64.rotr (i64.xor (get_local $b23) (get_local $b27)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b16) (i64.const 0xffffffff)) (i64.and (get_local $b21) (i64.const 0xffffffff)))))
    (set_local $b16 (i64.add (get_local $b16) (i64.add (get_local $b21) (get_local $tmp))))
    (set_local $b31 (i64.rotr (i64.xor (get_local $b31) (get_local $b16)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b26) (i64.const 0xffffffff)) (i64.and (get_local $b31) (i64.const 0xffffffff)))))
    (set_local $b26 (i64.add (get_local $b26) (i64.add (get_local $b31) (get_local $tmp))))
    (set_local $b21 (i64.rotr (i64.xor (get_local $b21) (get_local $b26)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b16) (i64.const 0xffffffff)) (i64.and (get_local $b21) (i64.const 0xffffffff)))))
    (set_local $b16 (i64.add (get_local $b16) (i64.add (get_local $b21) (get_local $tmp))))
    (set_local $b31 (i64.rotr (i64.xor (get_local $b31) (get_local $b16)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b26) (i64.const 0xffffffff)) (i64.and (get_local $b31) (i64.const 0xffffffff)))))
    (set_local $b26 (i64.add (get_local $b26) (i64.add (get_local $b31) (get_local $tmp))))
    (set_local $b21 (i64.rotr (i64.xor (get_local $b21) (get_local $b26)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b17) (i64.const 0xffffffff)) (i64.and (get_local $b22) (i64.const 0xffffffff)))))
    (set_local $b17 (i64.add (get_local $b17) (i64.add (get_local $b22) (get_local $tmp))))
    (set_local $b28 (i64.rotr (i64.xor (get_local $b28) (get_local $b17)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b27) (i64.const 0xffffffff)) (i64.and (get_local $b28) (i64.const 0xffffffff)))))
    (set_local $b27 (i64.add (get_local $b27) (i64.add (get_local $b28) (get_local $tmp))))
    (set_local $b22 (i64.rotr (i64.xor (get_local $b22) (get_local $b27)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b17) (i64.const 0xffffffff)) (i64.and (get_local $b22) (i64.const 0xffffffff)))))
    (set_local $b17 (i64.add (get_local $b17) (i64.add (get_local $b22) (get_local $tmp))))
    (set_local $b28 (i64.rotr (i64.xor (get_local $b28) (get_local $b17)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b27) (i64.const 0xffffffff)) (i64.and (get_local $b28) (i64.const 0xffffffff)))))
    (set_local $b27 (i64.add (get_local $b27) (i64.add (get_local $b28) (get_local $tmp))))
    (set_local $b22 (i64.rotr (i64.xor (get_local $b22) (get_local $b27)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b18) (i64.const 0xffffffff)) (i64.and (get_local $b23) (i64.const 0xffffffff)))))
    (set_local $b18 (i64.add (get_local $b18) (i64.add (get_local $b23) (get_local $tmp))))
    (set_local $b29 (i64.rotr (i64.xor (get_local $b29) (get_local $b18)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b24) (i64.const 0xffffffff)) (i64.and (get_local $b29) (i64.const 0xffffffff)))))
    (set_local $b24 (i64.add (get_local $b24) (i64.add (get_local $b29) (get_local $tmp))))
    (set_local $b23 (i64.rotr (i64.xor (get_local $b23) (get_local $b24)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b18) (i64.const 0xffffffff)) (i64.and (get_local $b23) (i64.const 0xffffffff)))))
    (set_local $b18 (i64.add (get_local $b18) (i64.add (get_local $b23) (get_local $tmp))))
    (set_local $b29 (i64.rotr (i64.xor (get_local $b29) (get_local $b18)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b24) (i64.const 0xffffffff)) (i64.and (get_local $b29) (i64.const 0xffffffff)))))
    (set_local $b24 (i64.add (get_local $b24) (i64.add (get_local $b29) (get_local $tmp))))
    (set_local $b23 (i64.rotr (i64.xor (get_local $b23) (get_local $b24)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b19) (i64.const 0xffffffff)) (i64.and (get_local $b20) (i64.const 0xffffffff)))))
    (set_local $b19 (i64.add (get_local $b19) (i64.add (get_local $b20) (get_local $tmp))))
    (set_local $b30 (i64.rotr (i64.xor (get_local $b30) (get_local $b19)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b25) (i64.const 0xffffffff)) (i64.and (get_local $b30) (i64.const 0xffffffff)))))
    (set_local $b25 (i64.add (get_local $b25) (i64.add (get_local $b30) (get_local $tmp))))
    (set_local $b20 (i64.rotr (i64.xor (get_local $b20) (get_local $b25)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b19) (i64.const 0xffffffff)) (i64.and (get_local $b20) (i64.const 0xffffffff)))))
    (set_local $b19 (i64.add (get_local $b19) (i64.add (get_local $b20) (get_local $tmp))))
    (set_local $b30 (i64.rotr (i64.xor (get_local $b30) (get_local $b19)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b25) (i64.const 0xffffffff)) (i64.and (get_local $b30) (i64.const 0xffffffff)))))
    (set_local $b25 (i64.add (get_local $b25) (i64.add (get_local $b30) (get_local $tmp))))
    (set_local $b20 (i64.rotr (i64.xor (get_local $b20) (get_local $b25)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b32) (i64.const 0xffffffff)) (i64.and (get_local $b36) (i64.const 0xffffffff)))))
    (set_local $b32 (i64.add (get_local $b32) (i64.add (get_local $b36) (get_local $tmp))))
    (set_local $b44 (i64.rotr (i64.xor (get_local $b44) (get_local $b32)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b40) (i64.const 0xffffffff)) (i64.and (get_local $b44) (i64.const 0xffffffff)))))
    (set_local $b40 (i64.add (get_local $b40) (i64.add (get_local $b44) (get_local $tmp))))
    (set_local $b36 (i64.rotr (i64.xor (get_local $b36) (get_local $b40)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b32) (i64.const 0xffffffff)) (i64.and (get_local $b36) (i64.const 0xffffffff)))))
    (set_local $b32 (i64.add (get_local $b32) (i64.add (get_local $b36) (get_local $tmp))))
    (set_local $b44 (i64.rotr (i64.xor (get_local $b44) (get_local $b32)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b40) (i64.const 0xffffffff)) (i64.and (get_local $b44) (i64.const 0xffffffff)))))
    (set_local $b40 (i64.add (get_local $b40) (i64.add (get_local $b44) (get_local $tmp))))
    (set_local $b36 (i64.rotr (i64.xor (get_local $b36) (get_local $b40)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b33) (i64.const 0xffffffff)) (i64.and (get_local $b37) (i64.const 0xffffffff)))))
    (set_local $b33 (i64.add (get_local $b33) (i64.add (get_local $b37) (get_local $tmp))))
    (set_local $b45 (i64.rotr (i64.xor (get_local $b45) (get_local $b33)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b41) (i64.const 0xffffffff)) (i64.and (get_local $b45) (i64.const 0xffffffff)))))
    (set_local $b41 (i64.add (get_local $b41) (i64.add (get_local $b45) (get_local $tmp))))
    (set_local $b37 (i64.rotr (i64.xor (get_local $b37) (get_local $b41)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b33) (i64.const 0xffffffff)) (i64.and (get_local $b37) (i64.const 0xffffffff)))))
    (set_local $b33 (i64.add (get_local $b33) (i64.add (get_local $b37) (get_local $tmp))))
    (set_local $b45 (i64.rotr (i64.xor (get_local $b45) (get_local $b33)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b41) (i64.const 0xffffffff)) (i64.and (get_local $b45) (i64.const 0xffffffff)))))
    (set_local $b41 (i64.add (get_local $b41) (i64.add (get_local $b45) (get_local $tmp))))
    (set_local $b37 (i64.rotr (i64.xor (get_local $b37) (get_local $b41)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b34) (i64.const 0xffffffff)) (i64.and (get_local $b38) (i64.const 0xffffffff)))))
    (set_local $b34 (i64.add (get_local $b34) (i64.add (get_local $b38) (get_local $tmp))))
    (set_local $b46 (i64.rotr (i64.xor (get_local $b46) (get_local $b34)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b42) (i64.const 0xffffffff)) (i64.and (get_local $b46) (i64.const 0xffffffff)))))
    (set_local $b42 (i64.add (get_local $b42) (i64.add (get_local $b46) (get_local $tmp))))
    (set_local $b38 (i64.rotr (i64.xor (get_local $b38) (get_local $b42)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b34) (i64.const 0xffffffff)) (i64.and (get_local $b38) (i64.const 0xffffffff)))))
    (set_local $b34 (i64.add (get_local $b34) (i64.add (get_local $b38) (get_local $tmp))))
    (set_local $b46 (i64.rotr (i64.xor (get_local $b46) (get_local $b34)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b42) (i64.const 0xffffffff)) (i64.and (get_local $b46) (i64.const 0xffffffff)))))
    (set_local $b42 (i64.add (get_local $b42) (i64.add (get_local $b46) (get_local $tmp))))
    (set_local $b38 (i64.rotr (i64.xor (get_local $b38) (get_local $b42)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b35) (i64.const 0xffffffff)) (i64.and (get_local $b39) (i64.const 0xffffffff)))))
    (set_local $b35 (i64.add (get_local $b35) (i64.add (get_local $b39) (get_local $tmp))))
    (set_local $b47 (i64.rotr (i64.xor (get_local $b47) (get_local $b35)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b43) (i64.const 0xffffffff)) (i64.and (get_local $b47) (i64.const 0xffffffff)))))
    (set_local $b43 (i64.add (get_local $b43) (i64.add (get_local $b47) (get_local $tmp))))
    (set_local $b39 (i64.rotr (i64.xor (get_local $b39) (get_local $b43)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b35) (i64.const 0xffffffff)) (i64.and (get_local $b39) (i64.const 0xffffffff)))))
    (set_local $b35 (i64.add (get_local $b35) (i64.add (get_local $b39) (get_local $tmp))))
    (set_local $b47 (i64.rotr (i64.xor (get_local $b47) (get_local $b35)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b43) (i64.const 0xffffffff)) (i64.and (get_local $b47) (i64.const 0xffffffff)))))
    (set_local $b43 (i64.add (get_local $b43) (i64.add (get_local $b47) (get_local $tmp))))
    (set_local $b39 (i64.rotr (i64.xor (get_local $b39) (get_local $b43)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b32) (i64.const 0xffffffff)) (i64.and (get_local $b37) (i64.const 0xffffffff)))))
    (set_local $b32 (i64.add (get_local $b32) (i64.add (get_local $b37) (get_local $tmp))))
    (set_local $b47 (i64.rotr (i64.xor (get_local $b47) (get_local $b32)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b42) (i64.const 0xffffffff)) (i64.and (get_local $b47) (i64.const 0xffffffff)))))
    (set_local $b42 (i64.add (get_local $b42) (i64.add (get_local $b47) (get_local $tmp))))
    (set_local $b37 (i64.rotr (i64.xor (get_local $b37) (get_local $b42)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b32) (i64.const 0xffffffff)) (i64.and (get_local $b37) (i64.const 0xffffffff)))))
    (set_local $b32 (i64.add (get_local $b32) (i64.add (get_local $b37) (get_local $tmp))))
    (set_local $b47 (i64.rotr (i64.xor (get_local $b47) (get_local $b32)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b42) (i64.const 0xffffffff)) (i64.and (get_local $b47) (i64.const 0xffffffff)))))
    (set_local $b42 (i64.add (get_local $b42) (i64.add (get_local $b47) (get_local $tmp))))
    (set_local $b37 (i64.rotr (i64.xor (get_local $b37) (get_local $b42)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b33) (i64.const 0xffffffff)) (i64.and (get_local $b38) (i64.const 0xffffffff)))))
    (set_local $b33 (i64.add (get_local $b33) (i64.add (get_local $b38) (get_local $tmp))))
    (set_local $b44 (i64.rotr (i64.xor (get_local $b44) (get_local $b33)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b43) (i64.const 0xffffffff)) (i64.and (get_local $b44) (i64.const 0xffffffff)))))
    (set_local $b43 (i64.add (get_local $b43) (i64.add (get_local $b44) (get_local $tmp))))
    (set_local $b38 (i64.rotr (i64.xor (get_local $b38) (get_local $b43)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b33) (i64.const 0xffffffff)) (i64.and (get_local $b38) (i64.const 0xffffffff)))))
    (set_local $b33 (i64.add (get_local $b33) (i64.add (get_local $b38) (get_local $tmp))))
    (set_local $b44 (i64.rotr (i64.xor (get_local $b44) (get_local $b33)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b43) (i64.const 0xffffffff)) (i64.and (get_local $b44) (i64.const 0xffffffff)))))
    (set_local $b43 (i64.add (get_local $b43) (i64.add (get_local $b44) (get_local $tmp))))
    (set_local $b38 (i64.rotr (i64.xor (get_local $b38) (get_local $b43)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b34) (i64.const 0xffffffff)) (i64.and (get_local $b39) (i64.const 0xffffffff)))))
    (set_local $b34 (i64.add (get_local $b34) (i64.add (get_local $b39) (get_local $tmp))))
    (set_local $b45 (i64.rotr (i64.xor (get_local $b45) (get_local $b34)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b40) (i64.const 0xffffffff)) (i64.and (get_local $b45) (i64.const 0xffffffff)))))
    (set_local $b40 (i64.add (get_local $b40) (i64.add (get_local $b45) (get_local $tmp))))
    (set_local $b39 (i64.rotr (i64.xor (get_local $b39) (get_local $b40)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b34) (i64.const 0xffffffff)) (i64.and (get_local $b39) (i64.const 0xffffffff)))))
    (set_local $b34 (i64.add (get_local $b34) (i64.add (get_local $b39) (get_local $tmp))))
    (set_local $b45 (i64.rotr (i64.xor (get_local $b45) (get_local $b34)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b40) (i64.const 0xffffffff)) (i64.and (get_local $b45) (i64.const 0xffffffff)))))
    (set_local $b40 (i64.add (get_local $b40) (i64.add (get_local $b45) (get_local $tmp))))
    (set_local $b39 (i64.rotr (i64.xor (get_local $b39) (get_local $b40)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b35) (i64.const 0xffffffff)) (i64.and (get_local $b36) (i64.const 0xffffffff)))))
    (set_local $b35 (i64.add (get_local $b35) (i64.add (get_local $b36) (get_local $tmp))))
    (set_local $b46 (i64.rotr (i64.xor (get_local $b46) (get_local $b35)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b41) (i64.const 0xffffffff)) (i64.and (get_local $b46) (i64.const 0xffffffff)))))
    (set_local $b41 (i64.add (get_local $b41) (i64.add (get_local $b46) (get_local $tmp))))
    (set_local $b36 (i64.rotr (i64.xor (get_local $b36) (get_local $b41)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b35) (i64.const 0xffffffff)) (i64.and (get_local $b36) (i64.const 0xffffffff)))))
    (set_local $b35 (i64.add (get_local $b35) (i64.add (get_local $b36) (get_local $tmp))))
    (set_local $b46 (i64.rotr (i64.xor (get_local $b46) (get_local $b35)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b41) (i64.const 0xffffffff)) (i64.and (get_local $b46) (i64.const 0xffffffff)))))
    (set_local $b41 (i64.add (get_local $b41) (i64.add (get_local $b46) (get_local $tmp))))
    (set_local $b36 (i64.rotr (i64.xor (get_local $b36) (get_local $b41)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b48) (i64.const 0xffffffff)) (i64.and (get_local $b52) (i64.const 0xffffffff)))))
    (set_local $b48 (i64.add (get_local $b48) (i64.add (get_local $b52) (get_local $tmp))))
    (set_local $b60 (i64.rotr (i64.xor (get_local $b60) (get_local $b48)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b56) (i64.const 0xffffffff)) (i64.and (get_local $b60) (i64.const 0xffffffff)))))
    (set_local $b56 (i64.add (get_local $b56) (i64.add (get_local $b60) (get_local $tmp))))
    (set_local $b52 (i64.rotr (i64.xor (get_local $b52) (get_local $b56)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b48) (i64.const 0xffffffff)) (i64.and (get_local $b52) (i64.const 0xffffffff)))))
    (set_local $b48 (i64.add (get_local $b48) (i64.add (get_local $b52) (get_local $tmp))))
    (set_local $b60 (i64.rotr (i64.xor (get_local $b60) (get_local $b48)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b56) (i64.const 0xffffffff)) (i64.and (get_local $b60) (i64.const 0xffffffff)))))
    (set_local $b56 (i64.add (get_local $b56) (i64.add (get_local $b60) (get_local $tmp))))
    (set_local $b52 (i64.rotr (i64.xor (get_local $b52) (get_local $b56)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b49) (i64.const 0xffffffff)) (i64.and (get_local $b53) (i64.const 0xffffffff)))))
    (set_local $b49 (i64.add (get_local $b49) (i64.add (get_local $b53) (get_local $tmp))))
    (set_local $b61 (i64.rotr (i64.xor (get_local $b61) (get_local $b49)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b57) (i64.const 0xffffffff)) (i64.and (get_local $b61) (i64.const 0xffffffff)))))
    (set_local $b57 (i64.add (get_local $b57) (i64.add (get_local $b61) (get_local $tmp))))
    (set_local $b53 (i64.rotr (i64.xor (get_local $b53) (get_local $b57)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b49) (i64.const 0xffffffff)) (i64.and (get_local $b53) (i64.const 0xffffffff)))))
    (set_local $b49 (i64.add (get_local $b49) (i64.add (get_local $b53) (get_local $tmp))))
    (set_local $b61 (i64.rotr (i64.xor (get_local $b61) (get_local $b49)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b57) (i64.const 0xffffffff)) (i64.and (get_local $b61) (i64.const 0xffffffff)))))
    (set_local $b57 (i64.add (get_local $b57) (i64.add (get_local $b61) (get_local $tmp))))
    (set_local $b53 (i64.rotr (i64.xor (get_local $b53) (get_local $b57)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b50) (i64.const 0xffffffff)) (i64.and (get_local $b54) (i64.const 0xffffffff)))))
    (set_local $b50 (i64.add (get_local $b50) (i64.add (get_local $b54) (get_local $tmp))))
    (set_local $b62 (i64.rotr (i64.xor (get_local $b62) (get_local $b50)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b58) (i64.const 0xffffffff)) (i64.and (get_local $b62) (i64.const 0xffffffff)))))
    (set_local $b58 (i64.add (get_local $b58) (i64.add (get_local $b62) (get_local $tmp))))
    (set_local $b54 (i64.rotr (i64.xor (get_local $b54) (get_local $b58)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b50) (i64.const 0xffffffff)) (i64.and (get_local $b54) (i64.const 0xffffffff)))))
    (set_local $b50 (i64.add (get_local $b50) (i64.add (get_local $b54) (get_local $tmp))))
    (set_local $b62 (i64.rotr (i64.xor (get_local $b62) (get_local $b50)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b58) (i64.const 0xffffffff)) (i64.and (get_local $b62) (i64.const 0xffffffff)))))
    (set_local $b58 (i64.add (get_local $b58) (i64.add (get_local $b62) (get_local $tmp))))
    (set_local $b54 (i64.rotr (i64.xor (get_local $b54) (get_local $b58)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b51) (i64.const 0xffffffff)) (i64.and (get_local $b55) (i64.const 0xffffffff)))))
    (set_local $b51 (i64.add (get_local $b51) (i64.add (get_local $b55) (get_local $tmp))))
    (set_local $b63 (i64.rotr (i64.xor (get_local $b63) (get_local $b51)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b59) (i64.const 0xffffffff)) (i64.and (get_local $b63) (i64.const 0xffffffff)))))
    (set_local $b59 (i64.add (get_local $b59) (i64.add (get_local $b63) (get_local $tmp))))
    (set_local $b55 (i64.rotr (i64.xor (get_local $b55) (get_local $b59)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b51) (i64.const 0xffffffff)) (i64.and (get_local $b55) (i64.const 0xffffffff)))))
    (set_local $b51 (i64.add (get_local $b51) (i64.add (get_local $b55) (get_local $tmp))))
    (set_local $b63 (i64.rotr (i64.xor (get_local $b63) (get_local $b51)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b59) (i64.const 0xffffffff)) (i64.and (get_local $b63) (i64.const 0xffffffff)))))
    (set_local $b59 (i64.add (get_local $b59) (i64.add (get_local $b63) (get_local $tmp))))
    (set_local $b55 (i64.rotr (i64.xor (get_local $b55) (get_local $b59)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b48) (i64.const 0xffffffff)) (i64.and (get_local $b53) (i64.const 0xffffffff)))))
    (set_local $b48 (i64.add (get_local $b48) (i64.add (get_local $b53) (get_local $tmp))))
    (set_local $b63 (i64.rotr (i64.xor (get_local $b63) (get_local $b48)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b58) (i64.const 0xffffffff)) (i64.and (get_local $b63) (i64.const 0xffffffff)))))
    (set_local $b58 (i64.add (get_local $b58) (i64.add (get_local $b63) (get_local $tmp))))
    (set_local $b53 (i64.rotr (i64.xor (get_local $b53) (get_local $b58)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b48) (i64.const 0xffffffff)) (i64.and (get_local $b53) (i64.const 0xffffffff)))))
    (set_local $b48 (i64.add (get_local $b48) (i64.add (get_local $b53) (get_local $tmp))))
    (set_local $b63 (i64.rotr (i64.xor (get_local $b63) (get_local $b48)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b58) (i64.const 0xffffffff)) (i64.and (get_local $b63) (i64.const 0xffffffff)))))
    (set_local $b58 (i64.add (get_local $b58) (i64.add (get_local $b63) (get_local $tmp))))
    (set_local $b53 (i64.rotr (i64.xor (get_local $b53) (get_local $b58)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b49) (i64.const 0xffffffff)) (i64.and (get_local $b54) (i64.const 0xffffffff)))))
    (set_local $b49 (i64.add (get_local $b49) (i64.add (get_local $b54) (get_local $tmp))))
    (set_local $b60 (i64.rotr (i64.xor (get_local $b60) (get_local $b49)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b59) (i64.const 0xffffffff)) (i64.and (get_local $b60) (i64.const 0xffffffff)))))
    (set_local $b59 (i64.add (get_local $b59) (i64.add (get_local $b60) (get_local $tmp))))
    (set_local $b54 (i64.rotr (i64.xor (get_local $b54) (get_local $b59)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b49) (i64.const 0xffffffff)) (i64.and (get_local $b54) (i64.const 0xffffffff)))))
    (set_local $b49 (i64.add (get_local $b49) (i64.add (get_local $b54) (get_local $tmp))))
    (set_local $b60 (i64.rotr (i64.xor (get_local $b60) (get_local $b49)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b59) (i64.const 0xffffffff)) (i64.and (get_local $b60) (i64.const 0xffffffff)))))
    (set_local $b59 (i64.add (get_local $b59) (i64.add (get_local $b60) (get_local $tmp))))
    (set_local $b54 (i64.rotr (i64.xor (get_local $b54) (get_local $b59)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b50) (i64.const 0xffffffff)) (i64.and (get_local $b55) (i64.const 0xffffffff)))))
    (set_local $b50 (i64.add (get_local $b50) (i64.add (get_local $b55) (get_local $tmp))))
    (set_local $b61 (i64.rotr (i64.xor (get_local $b61) (get_local $b50)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b56) (i64.const 0xffffffff)) (i64.and (get_local $b61) (i64.const 0xffffffff)))))
    (set_local $b56 (i64.add (get_local $b56) (i64.add (get_local $b61) (get_local $tmp))))
    (set_local $b55 (i64.rotr (i64.xor (get_local $b55) (get_local $b56)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b50) (i64.const 0xffffffff)) (i64.and (get_local $b55) (i64.const 0xffffffff)))))
    (set_local $b50 (i64.add (get_local $b50) (i64.add (get_local $b55) (get_local $tmp))))
    (set_local $b61 (i64.rotr (i64.xor (get_local $b61) (get_local $b50)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b56) (i64.const 0xffffffff)) (i64.and (get_local $b61) (i64.const 0xffffffff)))))
    (set_local $b56 (i64.add (get_local $b56) (i64.add (get_local $b61) (get_local $tmp))))
    (set_local $b55 (i64.rotr (i64.xor (get_local $b55) (get_local $b56)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b51) (i64.const 0xffffffff)) (i64.and (get_local $b52) (i64.const 0xffffffff)))))
    (set_local $b51 (i64.add (get_local $b51) (i64.add (get_local $b52) (get_local $tmp))))
    (set_local $b62 (i64.rotr (i64.xor (get_local $b62) (get_local $b51)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b57) (i64.const 0xffffffff)) (i64.and (get_local $b62) (i64.const 0xffffffff)))))
    (set_local $b57 (i64.add (get_local $b57) (i64.add (get_local $b62) (get_local $tmp))))
    (set_local $b52 (i64.rotr (i64.xor (get_local $b52) (get_local $b57)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b51) (i64.const 0xffffffff)) (i64.and (get_local $b52) (i64.const 0xffffffff)))))
    (set_local $b51 (i64.add (get_local $b51) (i64.add (get_local $b52) (get_local $tmp))))
    (set_local $b62 (i64.rotr (i64.xor (get_local $b62) (get_local $b51)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b57) (i64.const 0xffffffff)) (i64.and (get_local $b62) (i64.const 0xffffffff)))))
    (set_local $b57 (i64.add (get_local $b57) (i64.add (get_local $b62) (get_local $tmp))))
    (set_local $b52 (i64.rotr (i64.xor (get_local $b52) (get_local $b57)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b64) (i64.const 0xffffffff)) (i64.and (get_local $b68) (i64.const 0xffffffff)))))
    (set_local $b64 (i64.add (get_local $b64) (i64.add (get_local $b68) (get_local $tmp))))
    (set_local $b76 (i64.rotr (i64.xor (get_local $b76) (get_local $b64)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b72) (i64.const 0xffffffff)) (i64.and (get_local $b76) (i64.const 0xffffffff)))))
    (set_local $b72 (i64.add (get_local $b72) (i64.add (get_local $b76) (get_local $tmp))))
    (set_local $b68 (i64.rotr (i64.xor (get_local $b68) (get_local $b72)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b64) (i64.const 0xffffffff)) (i64.and (get_local $b68) (i64.const 0xffffffff)))))
    (set_local $b64 (i64.add (get_local $b64) (i64.add (get_local $b68) (get_local $tmp))))
    (set_local $b76 (i64.rotr (i64.xor (get_local $b76) (get_local $b64)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b72) (i64.const 0xffffffff)) (i64.and (get_local $b76) (i64.const 0xffffffff)))))
    (set_local $b72 (i64.add (get_local $b72) (i64.add (get_local $b76) (get_local $tmp))))
    (set_local $b68 (i64.rotr (i64.xor (get_local $b68) (get_local $b72)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b65) (i64.const 0xffffffff)) (i64.and (get_local $b69) (i64.const 0xffffffff)))))
    (set_local $b65 (i64.add (get_local $b65) (i64.add (get_local $b69) (get_local $tmp))))
    (set_local $b77 (i64.rotr (i64.xor (get_local $b77) (get_local $b65)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b73) (i64.const 0xffffffff)) (i64.and (get_local $b77) (i64.const 0xffffffff)))))
    (set_local $b73 (i64.add (get_local $b73) (i64.add (get_local $b77) (get_local $tmp))))
    (set_local $b69 (i64.rotr (i64.xor (get_local $b69) (get_local $b73)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b65) (i64.const 0xffffffff)) (i64.and (get_local $b69) (i64.const 0xffffffff)))))
    (set_local $b65 (i64.add (get_local $b65) (i64.add (get_local $b69) (get_local $tmp))))
    (set_local $b77 (i64.rotr (i64.xor (get_local $b77) (get_local $b65)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b73) (i64.const 0xffffffff)) (i64.and (get_local $b77) (i64.const 0xffffffff)))))
    (set_local $b73 (i64.add (get_local $b73) (i64.add (get_local $b77) (get_local $tmp))))
    (set_local $b69 (i64.rotr (i64.xor (get_local $b69) (get_local $b73)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b66) (i64.const 0xffffffff)) (i64.and (get_local $b70) (i64.const 0xffffffff)))))
    (set_local $b66 (i64.add (get_local $b66) (i64.add (get_local $b70) (get_local $tmp))))
    (set_local $b78 (i64.rotr (i64.xor (get_local $b78) (get_local $b66)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b74) (i64.const 0xffffffff)) (i64.and (get_local $b78) (i64.const 0xffffffff)))))
    (set_local $b74 (i64.add (get_local $b74) (i64.add (get_local $b78) (get_local $tmp))))
    (set_local $b70 (i64.rotr (i64.xor (get_local $b70) (get_local $b74)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b66) (i64.const 0xffffffff)) (i64.and (get_local $b70) (i64.const 0xffffffff)))))
    (set_local $b66 (i64.add (get_local $b66) (i64.add (get_local $b70) (get_local $tmp))))
    (set_local $b78 (i64.rotr (i64.xor (get_local $b78) (get_local $b66)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b74) (i64.const 0xffffffff)) (i64.and (get_local $b78) (i64.const 0xffffffff)))))
    (set_local $b74 (i64.add (get_local $b74) (i64.add (get_local $b78) (get_local $tmp))))
    (set_local $b70 (i64.rotr (i64.xor (get_local $b70) (get_local $b74)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b67) (i64.const 0xffffffff)) (i64.and (get_local $b71) (i64.const 0xffffffff)))))
    (set_local $b67 (i64.add (get_local $b67) (i64.add (get_local $b71) (get_local $tmp))))
    (set_local $b79 (i64.rotr (i64.xor (get_local $b79) (get_local $b67)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b75) (i64.const 0xffffffff)) (i64.and (get_local $b79) (i64.const 0xffffffff)))))
    (set_local $b75 (i64.add (get_local $b75) (i64.add (get_local $b79) (get_local $tmp))))
    (set_local $b71 (i64.rotr (i64.xor (get_local $b71) (get_local $b75)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b67) (i64.const 0xffffffff)) (i64.and (get_local $b71) (i64.const 0xffffffff)))))
    (set_local $b67 (i64.add (get_local $b67) (i64.add (get_local $b71) (get_local $tmp))))
    (set_local $b79 (i64.rotr (i64.xor (get_local $b79) (get_local $b67)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b75) (i64.const 0xffffffff)) (i64.and (get_local $b79) (i64.const 0xffffffff)))))
    (set_local $b75 (i64.add (get_local $b75) (i64.add (get_local $b79) (get_local $tmp))))
    (set_local $b71 (i64.rotr (i64.xor (get_local $b71) (get_local $b75)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b64) (i64.const 0xffffffff)) (i64.and (get_local $b69) (i64.const 0xffffffff)))))
    (set_local $b64 (i64.add (get_local $b64) (i64.add (get_local $b69) (get_local $tmp))))
    (set_local $b79 (i64.rotr (i64.xor (get_local $b79) (get_local $b64)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b74) (i64.const 0xffffffff)) (i64.and (get_local $b79) (i64.const 0xffffffff)))))
    (set_local $b74 (i64.add (get_local $b74) (i64.add (get_local $b79) (get_local $tmp))))
    (set_local $b69 (i64.rotr (i64.xor (get_local $b69) (get_local $b74)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b64) (i64.const 0xffffffff)) (i64.and (get_local $b69) (i64.const 0xffffffff)))))
    (set_local $b64 (i64.add (get_local $b64) (i64.add (get_local $b69) (get_local $tmp))))
    (set_local $b79 (i64.rotr (i64.xor (get_local $b79) (get_local $b64)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b74) (i64.const 0xffffffff)) (i64.and (get_local $b79) (i64.const 0xffffffff)))))
    (set_local $b74 (i64.add (get_local $b74) (i64.add (get_local $b79) (get_local $tmp))))
    (set_local $b69 (i64.rotr (i64.xor (get_local $b69) (get_local $b74)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b65) (i64.const 0xffffffff)) (i64.and (get_local $b70) (i64.const 0xffffffff)))))
    (set_local $b65 (i64.add (get_local $b65) (i64.add (get_local $b70) (get_local $tmp))))
    (set_local $b76 (i64.rotr (i64.xor (get_local $b76) (get_local $b65)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b75) (i64.const 0xffffffff)) (i64.and (get_local $b76) (i64.const 0xffffffff)))))
    (set_local $b75 (i64.add (get_local $b75) (i64.add (get_local $b76) (get_local $tmp))))
    (set_local $b70 (i64.rotr (i64.xor (get_local $b70) (get_local $b75)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b65) (i64.const 0xffffffff)) (i64.and (get_local $b70) (i64.const 0xffffffff)))))
    (set_local $b65 (i64.add (get_local $b65) (i64.add (get_local $b70) (get_local $tmp))))
    (set_local $b76 (i64.rotr (i64.xor (get_local $b76) (get_local $b65)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b75) (i64.const 0xffffffff)) (i64.and (get_local $b76) (i64.const 0xffffffff)))))
    (set_local $b75 (i64.add (get_local $b75) (i64.add (get_local $b76) (get_local $tmp))))
    (set_local $b70 (i64.rotr (i64.xor (get_local $b70) (get_local $b75)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b66) (i64.const 0xffffffff)) (i64.and (get_local $b71) (i64.const 0xffffffff)))))
    (set_local $b66 (i64.add (get_local $b66) (i64.add (get_local $b71) (get_local $tmp))))
    (set_local $b77 (i64.rotr (i64.xor (get_local $b77) (get_local $b66)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b72) (i64.const 0xffffffff)) (i64.and (get_local $b77) (i64.const 0xffffffff)))))
    (set_local $b72 (i64.add (get_local $b72) (i64.add (get_local $b77) (get_local $tmp))))
    (set_local $b71 (i64.rotr (i64.xor (get_local $b71) (get_local $b72)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b66) (i64.const 0xffffffff)) (i64.and (get_local $b71) (i64.const 0xffffffff)))))
    (set_local $b66 (i64.add (get_local $b66) (i64.add (get_local $b71) (get_local $tmp))))
    (set_local $b77 (i64.rotr (i64.xor (get_local $b77) (get_local $b66)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b72) (i64.const 0xffffffff)) (i64.and (get_local $b77) (i64.const 0xffffffff)))))
    (set_local $b72 (i64.add (get_local $b72) (i64.add (get_local $b77) (get_local $tmp))))
    (set_local $b71 (i64.rotr (i64.xor (get_local $b71) (get_local $b72)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b67) (i64.const 0xffffffff)) (i64.and (get_local $b68) (i64.const 0xffffffff)))))
    (set_local $b67 (i64.add (get_local $b67) (i64.add (get_local $b68) (get_local $tmp))))
    (set_local $b78 (i64.rotr (i64.xor (get_local $b78) (get_local $b67)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b73) (i64.const 0xffffffff)) (i64.and (get_local $b78) (i64.const 0xffffffff)))))
    (set_local $b73 (i64.add (get_local $b73) (i64.add (get_local $b78) (get_local $tmp))))
    (set_local $b68 (i64.rotr (i64.xor (get_local $b68) (get_local $b73)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b67) (i64.const 0xffffffff)) (i64.and (get_local $b68) (i64.const 0xffffffff)))))
    (set_local $b67 (i64.add (get_local $b67) (i64.add (get_local $b68) (get_local $tmp))))
    (set_local $b78 (i64.rotr (i64.xor (get_local $b78) (get_local $b67)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b73) (i64.const 0xffffffff)) (i64.and (get_local $b78) (i64.const 0xffffffff)))))
    (set_local $b73 (i64.add (get_local $b73) (i64.add (get_local $b78) (get_local $tmp))))
    (set_local $b68 (i64.rotr (i64.xor (get_local $b68) (get_local $b73)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b80) (i64.const 0xffffffff)) (i64.and (get_local $b84) (i64.const 0xffffffff)))))
    (set_local $b80 (i64.add (get_local $b80) (i64.add (get_local $b84) (get_local $tmp))))
    (set_local $b92 (i64.rotr (i64.xor (get_local $b92) (get_local $b80)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b88) (i64.const 0xffffffff)) (i64.and (get_local $b92) (i64.const 0xffffffff)))))
    (set_local $b88 (i64.add (get_local $b88) (i64.add (get_local $b92) (get_local $tmp))))
    (set_local $b84 (i64.rotr (i64.xor (get_local $b84) (get_local $b88)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b80) (i64.const 0xffffffff)) (i64.and (get_local $b84) (i64.const 0xffffffff)))))
    (set_local $b80 (i64.add (get_local $b80) (i64.add (get_local $b84) (get_local $tmp))))
    (set_local $b92 (i64.rotr (i64.xor (get_local $b92) (get_local $b80)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b88) (i64.const 0xffffffff)) (i64.and (get_local $b92) (i64.const 0xffffffff)))))
    (set_local $b88 (i64.add (get_local $b88) (i64.add (get_local $b92) (get_local $tmp))))
    (set_local $b84 (i64.rotr (i64.xor (get_local $b84) (get_local $b88)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b81) (i64.const 0xffffffff)) (i64.and (get_local $b85) (i64.const 0xffffffff)))))
    (set_local $b81 (i64.add (get_local $b81) (i64.add (get_local $b85) (get_local $tmp))))
    (set_local $b93 (i64.rotr (i64.xor (get_local $b93) (get_local $b81)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b89) (i64.const 0xffffffff)) (i64.and (get_local $b93) (i64.const 0xffffffff)))))
    (set_local $b89 (i64.add (get_local $b89) (i64.add (get_local $b93) (get_local $tmp))))
    (set_local $b85 (i64.rotr (i64.xor (get_local $b85) (get_local $b89)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b81) (i64.const 0xffffffff)) (i64.and (get_local $b85) (i64.const 0xffffffff)))))
    (set_local $b81 (i64.add (get_local $b81) (i64.add (get_local $b85) (get_local $tmp))))
    (set_local $b93 (i64.rotr (i64.xor (get_local $b93) (get_local $b81)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b89) (i64.const 0xffffffff)) (i64.and (get_local $b93) (i64.const 0xffffffff)))))
    (set_local $b89 (i64.add (get_local $b89) (i64.add (get_local $b93) (get_local $tmp))))
    (set_local $b85 (i64.rotr (i64.xor (get_local $b85) (get_local $b89)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b82) (i64.const 0xffffffff)) (i64.and (get_local $b86) (i64.const 0xffffffff)))))
    (set_local $b82 (i64.add (get_local $b82) (i64.add (get_local $b86) (get_local $tmp))))
    (set_local $b94 (i64.rotr (i64.xor (get_local $b94) (get_local $b82)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b90) (i64.const 0xffffffff)) (i64.and (get_local $b94) (i64.const 0xffffffff)))))
    (set_local $b90 (i64.add (get_local $b90) (i64.add (get_local $b94) (get_local $tmp))))
    (set_local $b86 (i64.rotr (i64.xor (get_local $b86) (get_local $b90)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b82) (i64.const 0xffffffff)) (i64.and (get_local $b86) (i64.const 0xffffffff)))))
    (set_local $b82 (i64.add (get_local $b82) (i64.add (get_local $b86) (get_local $tmp))))
    (set_local $b94 (i64.rotr (i64.xor (get_local $b94) (get_local $b82)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b90) (i64.const 0xffffffff)) (i64.and (get_local $b94) (i64.const 0xffffffff)))))
    (set_local $b90 (i64.add (get_local $b90) (i64.add (get_local $b94) (get_local $tmp))))
    (set_local $b86 (i64.rotr (i64.xor (get_local $b86) (get_local $b90)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b83) (i64.const 0xffffffff)) (i64.and (get_local $b87) (i64.const 0xffffffff)))))
    (set_local $b83 (i64.add (get_local $b83) (i64.add (get_local $b87) (get_local $tmp))))
    (set_local $b95 (i64.rotr (i64.xor (get_local $b95) (get_local $b83)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b91) (i64.const 0xffffffff)) (i64.and (get_local $b95) (i64.const 0xffffffff)))))
    (set_local $b91 (i64.add (get_local $b91) (i64.add (get_local $b95) (get_local $tmp))))
    (set_local $b87 (i64.rotr (i64.xor (get_local $b87) (get_local $b91)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b83) (i64.const 0xffffffff)) (i64.and (get_local $b87) (i64.const 0xffffffff)))))
    (set_local $b83 (i64.add (get_local $b83) (i64.add (get_local $b87) (get_local $tmp))))
    (set_local $b95 (i64.rotr (i64.xor (get_local $b95) (get_local $b83)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b91) (i64.const 0xffffffff)) (i64.and (get_local $b95) (i64.const 0xffffffff)))))
    (set_local $b91 (i64.add (get_local $b91) (i64.add (get_local $b95) (get_local $tmp))))
    (set_local $b87 (i64.rotr (i64.xor (get_local $b87) (get_local $b91)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b80) (i64.const 0xffffffff)) (i64.and (get_local $b85) (i64.const 0xffffffff)))))
    (set_local $b80 (i64.add (get_local $b80) (i64.add (get_local $b85) (get_local $tmp))))
    (set_local $b95 (i64.rotr (i64.xor (get_local $b95) (get_local $b80)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b90) (i64.const 0xffffffff)) (i64.and (get_local $b95) (i64.const 0xffffffff)))))
    (set_local $b90 (i64.add (get_local $b90) (i64.add (get_local $b95) (get_local $tmp))))
    (set_local $b85 (i64.rotr (i64.xor (get_local $b85) (get_local $b90)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b80) (i64.const 0xffffffff)) (i64.and (get_local $b85) (i64.const 0xffffffff)))))
    (set_local $b80 (i64.add (get_local $b80) (i64.add (get_local $b85) (get_local $tmp))))
    (set_local $b95 (i64.rotr (i64.xor (get_local $b95) (get_local $b80)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b90) (i64.const 0xffffffff)) (i64.and (get_local $b95) (i64.const 0xffffffff)))))
    (set_local $b90 (i64.add (get_local $b90) (i64.add (get_local $b95) (get_local $tmp))))
    (set_local $b85 (i64.rotr (i64.xor (get_local $b85) (get_local $b90)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b81) (i64.const 0xffffffff)) (i64.and (get_local $b86) (i64.const 0xffffffff)))))
    (set_local $b81 (i64.add (get_local $b81) (i64.add (get_local $b86) (get_local $tmp))))
    (set_local $b92 (i64.rotr (i64.xor (get_local $b92) (get_local $b81)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b91) (i64.const 0xffffffff)) (i64.and (get_local $b92) (i64.const 0xffffffff)))))
    (set_local $b91 (i64.add (get_local $b91) (i64.add (get_local $b92) (get_local $tmp))))
    (set_local $b86 (i64.rotr (i64.xor (get_local $b86) (get_local $b91)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b81) (i64.const 0xffffffff)) (i64.and (get_local $b86) (i64.const 0xffffffff)))))
    (set_local $b81 (i64.add (get_local $b81) (i64.add (get_local $b86) (get_local $tmp))))
    (set_local $b92 (i64.rotr (i64.xor (get_local $b92) (get_local $b81)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b91) (i64.const 0xffffffff)) (i64.and (get_local $b92) (i64.const 0xffffffff)))))
    (set_local $b91 (i64.add (get_local $b91) (i64.add (get_local $b92) (get_local $tmp))))
    (set_local $b86 (i64.rotr (i64.xor (get_local $b86) (get_local $b91)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b82) (i64.const 0xffffffff)) (i64.and (get_local $b87) (i64.const 0xffffffff)))))
    (set_local $b82 (i64.add (get_local $b82) (i64.add (get_local $b87) (get_local $tmp))))
    (set_local $b93 (i64.rotr (i64.xor (get_local $b93) (get_local $b82)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b88) (i64.const 0xffffffff)) (i64.and (get_local $b93) (i64.const 0xffffffff)))))
    (set_local $b88 (i64.add (get_local $b88) (i64.add (get_local $b93) (get_local $tmp))))
    (set_local $b87 (i64.rotr (i64.xor (get_local $b87) (get_local $b88)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b82) (i64.const 0xffffffff)) (i64.and (get_local $b87) (i64.const 0xffffffff)))))
    (set_local $b82 (i64.add (get_local $b82) (i64.add (get_local $b87) (get_local $tmp))))
    (set_local $b93 (i64.rotr (i64.xor (get_local $b93) (get_local $b82)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b88) (i64.const 0xffffffff)) (i64.and (get_local $b93) (i64.const 0xffffffff)))))
    (set_local $b88 (i64.add (get_local $b88) (i64.add (get_local $b93) (get_local $tmp))))
    (set_local $b87 (i64.rotr (i64.xor (get_local $b87) (get_local $b88)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b83) (i64.const 0xffffffff)) (i64.and (get_local $b84) (i64.const 0xffffffff)))))
    (set_local $b83 (i64.add (get_local $b83) (i64.add (get_local $b84) (get_local $tmp))))
    (set_local $b94 (i64.rotr (i64.xor (get_local $b94) (get_local $b83)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b89) (i64.const 0xffffffff)) (i64.and (get_local $b94) (i64.const 0xffffffff)))))
    (set_local $b89 (i64.add (get_local $b89) (i64.add (get_local $b94) (get_local $tmp))))
    (set_local $b84 (i64.rotr (i64.xor (get_local $b84) (get_local $b89)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b83) (i64.const 0xffffffff)) (i64.and (get_local $b84) (i64.const 0xffffffff)))))
    (set_local $b83 (i64.add (get_local $b83) (i64.add (get_local $b84) (get_local $tmp))))
    (set_local $b94 (i64.rotr (i64.xor (get_local $b94) (get_local $b83)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b89) (i64.const 0xffffffff)) (i64.and (get_local $b94) (i64.const 0xffffffff)))))
    (set_local $b89 (i64.add (get_local $b89) (i64.add (get_local $b94) (get_local $tmp))))
    (set_local $b84 (i64.rotr (i64.xor (get_local $b84) (get_local $b89)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b96) (i64.const 0xffffffff)) (i64.and (get_local $b100) (i64.const 0xffffffff)))))
    (set_local $b96 (i64.add (get_local $b96) (i64.add (get_local $b100) (get_local $tmp))))
    (set_local $b108 (i64.rotr (i64.xor (get_local $b108) (get_local $b96)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b104) (i64.const 0xffffffff)) (i64.and (get_local $b108) (i64.const 0xffffffff)))))
    (set_local $b104 (i64.add (get_local $b104) (i64.add (get_local $b108) (get_local $tmp))))
    (set_local $b100 (i64.rotr (i64.xor (get_local $b100) (get_local $b104)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b96) (i64.const 0xffffffff)) (i64.and (get_local $b100) (i64.const 0xffffffff)))))
    (set_local $b96 (i64.add (get_local $b96) (i64.add (get_local $b100) (get_local $tmp))))
    (set_local $b108 (i64.rotr (i64.xor (get_local $b108) (get_local $b96)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b104) (i64.const 0xffffffff)) (i64.and (get_local $b108) (i64.const 0xffffffff)))))
    (set_local $b104 (i64.add (get_local $b104) (i64.add (get_local $b108) (get_local $tmp))))
    (set_local $b100 (i64.rotr (i64.xor (get_local $b100) (get_local $b104)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b97) (i64.const 0xffffffff)) (i64.and (get_local $b101) (i64.const 0xffffffff)))))
    (set_local $b97 (i64.add (get_local $b97) (i64.add (get_local $b101) (get_local $tmp))))
    (set_local $b109 (i64.rotr (i64.xor (get_local $b109) (get_local $b97)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b105) (i64.const 0xffffffff)) (i64.and (get_local $b109) (i64.const 0xffffffff)))))
    (set_local $b105 (i64.add (get_local $b105) (i64.add (get_local $b109) (get_local $tmp))))
    (set_local $b101 (i64.rotr (i64.xor (get_local $b101) (get_local $b105)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b97) (i64.const 0xffffffff)) (i64.and (get_local $b101) (i64.const 0xffffffff)))))
    (set_local $b97 (i64.add (get_local $b97) (i64.add (get_local $b101) (get_local $tmp))))
    (set_local $b109 (i64.rotr (i64.xor (get_local $b109) (get_local $b97)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b105) (i64.const 0xffffffff)) (i64.and (get_local $b109) (i64.const 0xffffffff)))))
    (set_local $b105 (i64.add (get_local $b105) (i64.add (get_local $b109) (get_local $tmp))))
    (set_local $b101 (i64.rotr (i64.xor (get_local $b101) (get_local $b105)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b98) (i64.const 0xffffffff)) (i64.and (get_local $b102) (i64.const 0xffffffff)))))
    (set_local $b98 (i64.add (get_local $b98) (i64.add (get_local $b102) (get_local $tmp))))
    (set_local $b110 (i64.rotr (i64.xor (get_local $b110) (get_local $b98)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b106) (i64.const 0xffffffff)) (i64.and (get_local $b110) (i64.const 0xffffffff)))))
    (set_local $b106 (i64.add (get_local $b106) (i64.add (get_local $b110) (get_local $tmp))))
    (set_local $b102 (i64.rotr (i64.xor (get_local $b102) (get_local $b106)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b98) (i64.const 0xffffffff)) (i64.and (get_local $b102) (i64.const 0xffffffff)))))
    (set_local $b98 (i64.add (get_local $b98) (i64.add (get_local $b102) (get_local $tmp))))
    (set_local $b110 (i64.rotr (i64.xor (get_local $b110) (get_local $b98)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b106) (i64.const 0xffffffff)) (i64.and (get_local $b110) (i64.const 0xffffffff)))))
    (set_local $b106 (i64.add (get_local $b106) (i64.add (get_local $b110) (get_local $tmp))))
    (set_local $b102 (i64.rotr (i64.xor (get_local $b102) (get_local $b106)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b99) (i64.const 0xffffffff)) (i64.and (get_local $b103) (i64.const 0xffffffff)))))
    (set_local $b99 (i64.add (get_local $b99) (i64.add (get_local $b103) (get_local $tmp))))
    (set_local $b111 (i64.rotr (i64.xor (get_local $b111) (get_local $b99)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b107) (i64.const 0xffffffff)) (i64.and (get_local $b111) (i64.const 0xffffffff)))))
    (set_local $b107 (i64.add (get_local $b107) (i64.add (get_local $b111) (get_local $tmp))))
    (set_local $b103 (i64.rotr (i64.xor (get_local $b103) (get_local $b107)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b99) (i64.const 0xffffffff)) (i64.and (get_local $b103) (i64.const 0xffffffff)))))
    (set_local $b99 (i64.add (get_local $b99) (i64.add (get_local $b103) (get_local $tmp))))
    (set_local $b111 (i64.rotr (i64.xor (get_local $b111) (get_local $b99)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b107) (i64.const 0xffffffff)) (i64.and (get_local $b111) (i64.const 0xffffffff)))))
    (set_local $b107 (i64.add (get_local $b107) (i64.add (get_local $b111) (get_local $tmp))))
    (set_local $b103 (i64.rotr (i64.xor (get_local $b103) (get_local $b107)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b96) (i64.const 0xffffffff)) (i64.and (get_local $b101) (i64.const 0xffffffff)))))
    (set_local $b96 (i64.add (get_local $b96) (i64.add (get_local $b101) (get_local $tmp))))
    (set_local $b111 (i64.rotr (i64.xor (get_local $b111) (get_local $b96)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b106) (i64.const 0xffffffff)) (i64.and (get_local $b111) (i64.const 0xffffffff)))))
    (set_local $b106 (i64.add (get_local $b106) (i64.add (get_local $b111) (get_local $tmp))))
    (set_local $b101 (i64.rotr (i64.xor (get_local $b101) (get_local $b106)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b96) (i64.const 0xffffffff)) (i64.and (get_local $b101) (i64.const 0xffffffff)))))
    (set_local $b96 (i64.add (get_local $b96) (i64.add (get_local $b101) (get_local $tmp))))
    (set_local $b111 (i64.rotr (i64.xor (get_local $b111) (get_local $b96)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b106) (i64.const 0xffffffff)) (i64.and (get_local $b111) (i64.const 0xffffffff)))))
    (set_local $b106 (i64.add (get_local $b106) (i64.add (get_local $b111) (get_local $tmp))))
    (set_local $b101 (i64.rotr (i64.xor (get_local $b101) (get_local $b106)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b97) (i64.const 0xffffffff)) (i64.and (get_local $b102) (i64.const 0xffffffff)))))
    (set_local $b97 (i64.add (get_local $b97) (i64.add (get_local $b102) (get_local $tmp))))
    (set_local $b108 (i64.rotr (i64.xor (get_local $b108) (get_local $b97)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b107) (i64.const 0xffffffff)) (i64.and (get_local $b108) (i64.const 0xffffffff)))))
    (set_local $b107 (i64.add (get_local $b107) (i64.add (get_local $b108) (get_local $tmp))))
    (set_local $b102 (i64.rotr (i64.xor (get_local $b102) (get_local $b107)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b97) (i64.const 0xffffffff)) (i64.and (get_local $b102) (i64.const 0xffffffff)))))
    (set_local $b97 (i64.add (get_local $b97) (i64.add (get_local $b102) (get_local $tmp))))
    (set_local $b108 (i64.rotr (i64.xor (get_local $b108) (get_local $b97)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b107) (i64.const 0xffffffff)) (i64.and (get_local $b108) (i64.const 0xffffffff)))))
    (set_local $b107 (i64.add (get_local $b107) (i64.add (get_local $b108) (get_local $tmp))))
    (set_local $b102 (i64.rotr (i64.xor (get_local $b102) (get_local $b107)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b98) (i64.const 0xffffffff)) (i64.and (get_local $b103) (i64.const 0xffffffff)))))
    (set_local $b98 (i64.add (get_local $b98) (i64.add (get_local $b103) (get_local $tmp))))
    (set_local $b109 (i64.rotr (i64.xor (get_local $b109) (get_local $b98)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b104) (i64.const 0xffffffff)) (i64.and (get_local $b109) (i64.const 0xffffffff)))))
    (set_local $b104 (i64.add (get_local $b104) (i64.add (get_local $b109) (get_local $tmp))))
    (set_local $b103 (i64.rotr (i64.xor (get_local $b103) (get_local $b104)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b98) (i64.const 0xffffffff)) (i64.and (get_local $b103) (i64.const 0xffffffff)))))
    (set_local $b98 (i64.add (get_local $b98) (i64.add (get_local $b103) (get_local $tmp))))
    (set_local $b109 (i64.rotr (i64.xor (get_local $b109) (get_local $b98)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b104) (i64.const 0xffffffff)) (i64.and (get_local $b109) (i64.const 0xffffffff)))))
    (set_local $b104 (i64.add (get_local $b104) (i64.add (get_local $b109) (get_local $tmp))))
    (set_local $b103 (i64.rotr (i64.xor (get_local $b103) (get_local $b104)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b99) (i64.const 0xffffffff)) (i64.and (get_local $b100) (i64.const 0xffffffff)))))
    (set_local $b99 (i64.add (get_local $b99) (i64.add (get_local $b100) (get_local $tmp))))
    (set_local $b110 (i64.rotr (i64.xor (get_local $b110) (get_local $b99)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b105) (i64.const 0xffffffff)) (i64.and (get_local $b110) (i64.const 0xffffffff)))))
    (set_local $b105 (i64.add (get_local $b105) (i64.add (get_local $b110) (get_local $tmp))))
    (set_local $b100 (i64.rotr (i64.xor (get_local $b100) (get_local $b105)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b99) (i64.const 0xffffffff)) (i64.and (get_local $b100) (i64.const 0xffffffff)))))
    (set_local $b99 (i64.add (get_local $b99) (i64.add (get_local $b100) (get_local $tmp))))
    (set_local $b110 (i64.rotr (i64.xor (get_local $b110) (get_local $b99)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b105) (i64.const 0xffffffff)) (i64.and (get_local $b110) (i64.const 0xffffffff)))))
    (set_local $b105 (i64.add (get_local $b105) (i64.add (get_local $b110) (get_local $tmp))))
    (set_local $b100 (i64.rotr (i64.xor (get_local $b100) (get_local $b105)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b112) (i64.const 0xffffffff)) (i64.and (get_local $b116) (i64.const 0xffffffff)))))
    (set_local $b112 (i64.add (get_local $b112) (i64.add (get_local $b116) (get_local $tmp))))
    (set_local $b124 (i64.rotr (i64.xor (get_local $b124) (get_local $b112)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b120) (i64.const 0xffffffff)) (i64.and (get_local $b124) (i64.const 0xffffffff)))))
    (set_local $b120 (i64.add (get_local $b120) (i64.add (get_local $b124) (get_local $tmp))))
    (set_local $b116 (i64.rotr (i64.xor (get_local $b116) (get_local $b120)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b112) (i64.const 0xffffffff)) (i64.and (get_local $b116) (i64.const 0xffffffff)))))
    (set_local $b112 (i64.add (get_local $b112) (i64.add (get_local $b116) (get_local $tmp))))
    (set_local $b124 (i64.rotr (i64.xor (get_local $b124) (get_local $b112)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b120) (i64.const 0xffffffff)) (i64.and (get_local $b124) (i64.const 0xffffffff)))))
    (set_local $b120 (i64.add (get_local $b120) (i64.add (get_local $b124) (get_local $tmp))))
    (set_local $b116 (i64.rotr (i64.xor (get_local $b116) (get_local $b120)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b113) (i64.const 0xffffffff)) (i64.and (get_local $b117) (i64.const 0xffffffff)))))
    (set_local $b113 (i64.add (get_local $b113) (i64.add (get_local $b117) (get_local $tmp))))
    (set_local $b125 (i64.rotr (i64.xor (get_local $b125) (get_local $b113)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b121) (i64.const 0xffffffff)) (i64.and (get_local $b125) (i64.const 0xffffffff)))))
    (set_local $b121 (i64.add (get_local $b121) (i64.add (get_local $b125) (get_local $tmp))))
    (set_local $b117 (i64.rotr (i64.xor (get_local $b117) (get_local $b121)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b113) (i64.const 0xffffffff)) (i64.and (get_local $b117) (i64.const 0xffffffff)))))
    (set_local $b113 (i64.add (get_local $b113) (i64.add (get_local $b117) (get_local $tmp))))
    (set_local $b125 (i64.rotr (i64.xor (get_local $b125) (get_local $b113)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b121) (i64.const 0xffffffff)) (i64.and (get_local $b125) (i64.const 0xffffffff)))))
    (set_local $b121 (i64.add (get_local $b121) (i64.add (get_local $b125) (get_local $tmp))))
    (set_local $b117 (i64.rotr (i64.xor (get_local $b117) (get_local $b121)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b114) (i64.const 0xffffffff)) (i64.and (get_local $b118) (i64.const 0xffffffff)))))
    (set_local $b114 (i64.add (get_local $b114) (i64.add (get_local $b118) (get_local $tmp))))
    (set_local $b126 (i64.rotr (i64.xor (get_local $b126) (get_local $b114)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b122) (i64.const 0xffffffff)) (i64.and (get_local $b126) (i64.const 0xffffffff)))))
    (set_local $b122 (i64.add (get_local $b122) (i64.add (get_local $b126) (get_local $tmp))))
    (set_local $b118 (i64.rotr (i64.xor (get_local $b118) (get_local $b122)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b114) (i64.const 0xffffffff)) (i64.and (get_local $b118) (i64.const 0xffffffff)))))
    (set_local $b114 (i64.add (get_local $b114) (i64.add (get_local $b118) (get_local $tmp))))
    (set_local $b126 (i64.rotr (i64.xor (get_local $b126) (get_local $b114)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b122) (i64.const 0xffffffff)) (i64.and (get_local $b126) (i64.const 0xffffffff)))))
    (set_local $b122 (i64.add (get_local $b122) (i64.add (get_local $b126) (get_local $tmp))))
    (set_local $b118 (i64.rotr (i64.xor (get_local $b118) (get_local $b122)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b115) (i64.const 0xffffffff)) (i64.and (get_local $b119) (i64.const 0xffffffff)))))
    (set_local $b115 (i64.add (get_local $b115) (i64.add (get_local $b119) (get_local $tmp))))
    (set_local $b127 (i64.rotr (i64.xor (get_local $b127) (get_local $b115)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b123) (i64.const 0xffffffff)) (i64.and (get_local $b127) (i64.const 0xffffffff)))))
    (set_local $b123 (i64.add (get_local $b123) (i64.add (get_local $b127) (get_local $tmp))))
    (set_local $b119 (i64.rotr (i64.xor (get_local $b119) (get_local $b123)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b115) (i64.const 0xffffffff)) (i64.and (get_local $b119) (i64.const 0xffffffff)))))
    (set_local $b115 (i64.add (get_local $b115) (i64.add (get_local $b119) (get_local $tmp))))
    (set_local $b127 (i64.rotr (i64.xor (get_local $b127) (get_local $b115)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b123) (i64.const 0xffffffff)) (i64.and (get_local $b127) (i64.const 0xffffffff)))))
    (set_local $b123 (i64.add (get_local $b123) (i64.add (get_local $b127) (get_local $tmp))))
    (set_local $b119 (i64.rotr (i64.xor (get_local $b119) (get_local $b123)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b112) (i64.const 0xffffffff)) (i64.and (get_local $b117) (i64.const 0xffffffff)))))
    (set_local $b112 (i64.add (get_local $b112) (i64.add (get_local $b117) (get_local $tmp))))
    (set_local $b127 (i64.rotr (i64.xor (get_local $b127) (get_local $b112)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b122) (i64.const 0xffffffff)) (i64.and (get_local $b127) (i64.const 0xffffffff)))))
    (set_local $b122 (i64.add (get_local $b122) (i64.add (get_local $b127) (get_local $tmp))))
    (set_local $b117 (i64.rotr (i64.xor (get_local $b117) (get_local $b122)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b112) (i64.const 0xffffffff)) (i64.and (get_local $b117) (i64.const 0xffffffff)))))
    (set_local $b112 (i64.add (get_local $b112) (i64.add (get_local $b117) (get_local $tmp))))
    (set_local $b127 (i64.rotr (i64.xor (get_local $b127) (get_local $b112)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b122) (i64.const 0xffffffff)) (i64.and (get_local $b127) (i64.const 0xffffffff)))))
    (set_local $b122 (i64.add (get_local $b122) (i64.add (get_local $b127) (get_local $tmp))))
    (set_local $b117 (i64.rotr (i64.xor (get_local $b117) (get_local $b122)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b113) (i64.const 0xffffffff)) (i64.and (get_local $b118) (i64.const 0xffffffff)))))
    (set_local $b113 (i64.add (get_local $b113) (i64.add (get_local $b118) (get_local $tmp))))
    (set_local $b124 (i64.rotr (i64.xor (get_local $b124) (get_local $b113)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b123) (i64.const 0xffffffff)) (i64.and (get_local $b124) (i64.const 0xffffffff)))))
    (set_local $b123 (i64.add (get_local $b123) (i64.add (get_local $b124) (get_local $tmp))))
    (set_local $b118 (i64.rotr (i64.xor (get_local $b118) (get_local $b123)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b113) (i64.const 0xffffffff)) (i64.and (get_local $b118) (i64.const 0xffffffff)))))
    (set_local $b113 (i64.add (get_local $b113) (i64.add (get_local $b118) (get_local $tmp))))
    (set_local $b124 (i64.rotr (i64.xor (get_local $b124) (get_local $b113)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b123) (i64.const 0xffffffff)) (i64.and (get_local $b124) (i64.const 0xffffffff)))))
    (set_local $b123 (i64.add (get_local $b123) (i64.add (get_local $b124) (get_local $tmp))))
    (set_local $b118 (i64.rotr (i64.xor (get_local $b118) (get_local $b123)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b114) (i64.const 0xffffffff)) (i64.and (get_local $b119) (i64.const 0xffffffff)))))
    (set_local $b114 (i64.add (get_local $b114) (i64.add (get_local $b119) (get_local $tmp))))
    (set_local $b125 (i64.rotr (i64.xor (get_local $b125) (get_local $b114)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b120) (i64.const 0xffffffff)) (i64.and (get_local $b125) (i64.const 0xffffffff)))))
    (set_local $b120 (i64.add (get_local $b120) (i64.add (get_local $b125) (get_local $tmp))))
    (set_local $b119 (i64.rotr (i64.xor (get_local $b119) (get_local $b120)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b114) (i64.const 0xffffffff)) (i64.and (get_local $b119) (i64.const 0xffffffff)))))
    (set_local $b114 (i64.add (get_local $b114) (i64.add (get_local $b119) (get_local $tmp))))
    (set_local $b125 (i64.rotr (i64.xor (get_local $b125) (get_local $b114)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b120) (i64.const 0xffffffff)) (i64.and (get_local $b125) (i64.const 0xffffffff)))))
    (set_local $b120 (i64.add (get_local $b120) (i64.add (get_local $b125) (get_local $tmp))))
    (set_local $b119 (i64.rotr (i64.xor (get_local $b119) (get_local $b120)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b115) (i64.const 0xffffffff)) (i64.and (get_local $b116) (i64.const 0xffffffff)))))
    (set_local $b115 (i64.add (get_local $b115) (i64.add (get_local $b116) (get_local $tmp))))
    (set_local $b126 (i64.rotr (i64.xor (get_local $b126) (get_local $b115)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b121) (i64.const 0xffffffff)) (i64.and (get_local $b126) (i64.const 0xffffffff)))))
    (set_local $b121 (i64.add (get_local $b121) (i64.add (get_local $b126) (get_local $tmp))))
    (set_local $b116 (i64.rotr (i64.xor (get_local $b116) (get_local $b121)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b115) (i64.const 0xffffffff)) (i64.and (get_local $b116) (i64.const 0xffffffff)))))
    (set_local $b115 (i64.add (get_local $b115) (i64.add (get_local $b116) (get_local $tmp))))
    (set_local $b126 (i64.rotr (i64.xor (get_local $b126) (get_local $b115)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b121) (i64.const 0xffffffff)) (i64.and (get_local $b126) (i64.const 0xffffffff)))))
    (set_local $b121 (i64.add (get_local $b121) (i64.add (get_local $b126) (get_local $tmp))))
    (set_local $b116 (i64.rotr (i64.xor (get_local $b116) (get_local $b121)) (i64.const 63)))



    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b0) (i64.const 0xffffffff)) (i64.and (get_local $b32) (i64.const 0xffffffff)))))
    (set_local $b0 (i64.add (get_local $b0) (i64.add (get_local $b32) (get_local $tmp))))
    (set_local $b96 (i64.rotr (i64.xor (get_local $b96) (get_local $b0)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b64) (i64.const 0xffffffff)) (i64.and (get_local $b96) (i64.const 0xffffffff)))))
    (set_local $b64 (i64.add (get_local $b64) (i64.add (get_local $b96) (get_local $tmp))))
    (set_local $b32 (i64.rotr (i64.xor (get_local $b32) (get_local $b64)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b0) (i64.const 0xffffffff)) (i64.and (get_local $b32) (i64.const 0xffffffff)))))
    (set_local $b0 (i64.add (get_local $b0) (i64.add (get_local $b32) (get_local $tmp))))
    (set_local $b96 (i64.rotr (i64.xor (get_local $b96) (get_local $b0)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b64) (i64.const 0xffffffff)) (i64.and (get_local $b96) (i64.const 0xffffffff)))))
    (set_local $b64 (i64.add (get_local $b64) (i64.add (get_local $b96) (get_local $tmp))))
    (set_local $b32 (i64.rotr (i64.xor (get_local $b32) (get_local $b64)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b1) (i64.const 0xffffffff)) (i64.and (get_local $b33) (i64.const 0xffffffff)))))
    (set_local $b1 (i64.add (get_local $b1) (i64.add (get_local $b33) (get_local $tmp))))
    (set_local $b97 (i64.rotr (i64.xor (get_local $b97) (get_local $b1)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b65) (i64.const 0xffffffff)) (i64.and (get_local $b97) (i64.const 0xffffffff)))))
    (set_local $b65 (i64.add (get_local $b65) (i64.add (get_local $b97) (get_local $tmp))))
    (set_local $b33 (i64.rotr (i64.xor (get_local $b33) (get_local $b65)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b1) (i64.const 0xffffffff)) (i64.and (get_local $b33) (i64.const 0xffffffff)))))
    (set_local $b1 (i64.add (get_local $b1) (i64.add (get_local $b33) (get_local $tmp))))
    (set_local $b97 (i64.rotr (i64.xor (get_local $b97) (get_local $b1)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b65) (i64.const 0xffffffff)) (i64.and (get_local $b97) (i64.const 0xffffffff)))))
    (set_local $b65 (i64.add (get_local $b65) (i64.add (get_local $b97) (get_local $tmp))))
    (set_local $b33 (i64.rotr (i64.xor (get_local $b33) (get_local $b65)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b16) (i64.const 0xffffffff)) (i64.and (get_local $b48) (i64.const 0xffffffff)))))
    (set_local $b16 (i64.add (get_local $b16) (i64.add (get_local $b48) (get_local $tmp))))
    (set_local $b112 (i64.rotr (i64.xor (get_local $b112) (get_local $b16)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b80) (i64.const 0xffffffff)) (i64.and (get_local $b112) (i64.const 0xffffffff)))))
    (set_local $b80 (i64.add (get_local $b80) (i64.add (get_local $b112) (get_local $tmp))))
    (set_local $b48 (i64.rotr (i64.xor (get_local $b48) (get_local $b80)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b16) (i64.const 0xffffffff)) (i64.and (get_local $b48) (i64.const 0xffffffff)))))
    (set_local $b16 (i64.add (get_local $b16) (i64.add (get_local $b48) (get_local $tmp))))
    (set_local $b112 (i64.rotr (i64.xor (get_local $b112) (get_local $b16)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b80) (i64.const 0xffffffff)) (i64.and (get_local $b112) (i64.const 0xffffffff)))))
    (set_local $b80 (i64.add (get_local $b80) (i64.add (get_local $b112) (get_local $tmp))))
    (set_local $b48 (i64.rotr (i64.xor (get_local $b48) (get_local $b80)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b17) (i64.const 0xffffffff)) (i64.and (get_local $b49) (i64.const 0xffffffff)))))
    (set_local $b17 (i64.add (get_local $b17) (i64.add (get_local $b49) (get_local $tmp))))
    (set_local $b113 (i64.rotr (i64.xor (get_local $b113) (get_local $b17)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b81) (i64.const 0xffffffff)) (i64.and (get_local $b113) (i64.const 0xffffffff)))))
    (set_local $b81 (i64.add (get_local $b81) (i64.add (get_local $b113) (get_local $tmp))))
    (set_local $b49 (i64.rotr (i64.xor (get_local $b49) (get_local $b81)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b17) (i64.const 0xffffffff)) (i64.and (get_local $b49) (i64.const 0xffffffff)))))
    (set_local $b17 (i64.add (get_local $b17) (i64.add (get_local $b49) (get_local $tmp))))
    (set_local $b113 (i64.rotr (i64.xor (get_local $b113) (get_local $b17)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b81) (i64.const 0xffffffff)) (i64.and (get_local $b113) (i64.const 0xffffffff)))))
    (set_local $b81 (i64.add (get_local $b81) (i64.add (get_local $b113) (get_local $tmp))))
    (set_local $b49 (i64.rotr (i64.xor (get_local $b49) (get_local $b81)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b0) (i64.const 0xffffffff)) (i64.and (get_local $b33) (i64.const 0xffffffff)))))
    (set_local $b0 (i64.add (get_local $b0) (i64.add (get_local $b33) (get_local $tmp))))
    (set_local $b113 (i64.rotr (i64.xor (get_local $b113) (get_local $b0)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b80) (i64.const 0xffffffff)) (i64.and (get_local $b113) (i64.const 0xffffffff)))))
    (set_local $b80 (i64.add (get_local $b80) (i64.add (get_local $b113) (get_local $tmp))))
    (set_local $b33 (i64.rotr (i64.xor (get_local $b33) (get_local $b80)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b0) (i64.const 0xffffffff)) (i64.and (get_local $b33) (i64.const 0xffffffff)))))
    (set_local $b0 (i64.add (get_local $b0) (i64.add (get_local $b33) (get_local $tmp))))
    (set_local $b113 (i64.rotr (i64.xor (get_local $b113) (get_local $b0)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b80) (i64.const 0xffffffff)) (i64.and (get_local $b113) (i64.const 0xffffffff)))))
    (set_local $b80 (i64.add (get_local $b80) (i64.add (get_local $b113) (get_local $tmp))))
    (set_local $b33 (i64.rotr (i64.xor (get_local $b33) (get_local $b80)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b1) (i64.const 0xffffffff)) (i64.and (get_local $b48) (i64.const 0xffffffff)))))
    (set_local $b1 (i64.add (get_local $b1) (i64.add (get_local $b48) (get_local $tmp))))
    (set_local $b96 (i64.rotr (i64.xor (get_local $b96) (get_local $b1)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b81) (i64.const 0xffffffff)) (i64.and (get_local $b96) (i64.const 0xffffffff)))))
    (set_local $b81 (i64.add (get_local $b81) (i64.add (get_local $b96) (get_local $tmp))))
    (set_local $b48 (i64.rotr (i64.xor (get_local $b48) (get_local $b81)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b1) (i64.const 0xffffffff)) (i64.and (get_local $b48) (i64.const 0xffffffff)))))
    (set_local $b1 (i64.add (get_local $b1) (i64.add (get_local $b48) (get_local $tmp))))
    (set_local $b96 (i64.rotr (i64.xor (get_local $b96) (get_local $b1)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b81) (i64.const 0xffffffff)) (i64.and (get_local $b96) (i64.const 0xffffffff)))))
    (set_local $b81 (i64.add (get_local $b81) (i64.add (get_local $b96) (get_local $tmp))))
    (set_local $b48 (i64.rotr (i64.xor (get_local $b48) (get_local $b81)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b16) (i64.const 0xffffffff)) (i64.and (get_local $b49) (i64.const 0xffffffff)))))
    (set_local $b16 (i64.add (get_local $b16) (i64.add (get_local $b49) (get_local $tmp))))
    (set_local $b97 (i64.rotr (i64.xor (get_local $b97) (get_local $b16)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b64) (i64.const 0xffffffff)) (i64.and (get_local $b97) (i64.const 0xffffffff)))))
    (set_local $b64 (i64.add (get_local $b64) (i64.add (get_local $b97) (get_local $tmp))))
    (set_local $b49 (i64.rotr (i64.xor (get_local $b49) (get_local $b64)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b16) (i64.const 0xffffffff)) (i64.and (get_local $b49) (i64.const 0xffffffff)))))
    (set_local $b16 (i64.add (get_local $b16) (i64.add (get_local $b49) (get_local $tmp))))
    (set_local $b97 (i64.rotr (i64.xor (get_local $b97) (get_local $b16)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b64) (i64.const 0xffffffff)) (i64.and (get_local $b97) (i64.const 0xffffffff)))))
    (set_local $b64 (i64.add (get_local $b64) (i64.add (get_local $b97) (get_local $tmp))))
    (set_local $b49 (i64.rotr (i64.xor (get_local $b49) (get_local $b64)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b17) (i64.const 0xffffffff)) (i64.and (get_local $b32) (i64.const 0xffffffff)))))
    (set_local $b17 (i64.add (get_local $b17) (i64.add (get_local $b32) (get_local $tmp))))
    (set_local $b112 (i64.rotr (i64.xor (get_local $b112) (get_local $b17)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b65) (i64.const 0xffffffff)) (i64.and (get_local $b112) (i64.const 0xffffffff)))))
    (set_local $b65 (i64.add (get_local $b65) (i64.add (get_local $b112) (get_local $tmp))))
    (set_local $b32 (i64.rotr (i64.xor (get_local $b32) (get_local $b65)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b17) (i64.const 0xffffffff)) (i64.and (get_local $b32) (i64.const 0xffffffff)))))
    (set_local $b17 (i64.add (get_local $b17) (i64.add (get_local $b32) (get_local $tmp))))
    (set_local $b112 (i64.rotr (i64.xor (get_local $b112) (get_local $b17)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b65) (i64.const 0xffffffff)) (i64.and (get_local $b112) (i64.const 0xffffffff)))))
    (set_local $b65 (i64.add (get_local $b65) (i64.add (get_local $b112) (get_local $tmp))))
    (set_local $b32 (i64.rotr (i64.xor (get_local $b32) (get_local $b65)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b2) (i64.const 0xffffffff)) (i64.and (get_local $b34) (i64.const 0xffffffff)))))
    (set_local $b2 (i64.add (get_local $b2) (i64.add (get_local $b34) (get_local $tmp))))
    (set_local $b98 (i64.rotr (i64.xor (get_local $b98) (get_local $b2)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b66) (i64.const 0xffffffff)) (i64.and (get_local $b98) (i64.const 0xffffffff)))))
    (set_local $b66 (i64.add (get_local $b66) (i64.add (get_local $b98) (get_local $tmp))))
    (set_local $b34 (i64.rotr (i64.xor (get_local $b34) (get_local $b66)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b2) (i64.const 0xffffffff)) (i64.and (get_local $b34) (i64.const 0xffffffff)))))
    (set_local $b2 (i64.add (get_local $b2) (i64.add (get_local $b34) (get_local $tmp))))
    (set_local $b98 (i64.rotr (i64.xor (get_local $b98) (get_local $b2)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b66) (i64.const 0xffffffff)) (i64.and (get_local $b98) (i64.const 0xffffffff)))))
    (set_local $b66 (i64.add (get_local $b66) (i64.add (get_local $b98) (get_local $tmp))))
    (set_local $b34 (i64.rotr (i64.xor (get_local $b34) (get_local $b66)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b3) (i64.const 0xffffffff)) (i64.and (get_local $b35) (i64.const 0xffffffff)))))
    (set_local $b3 (i64.add (get_local $b3) (i64.add (get_local $b35) (get_local $tmp))))
    (set_local $b99 (i64.rotr (i64.xor (get_local $b99) (get_local $b3)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b67) (i64.const 0xffffffff)) (i64.and (get_local $b99) (i64.const 0xffffffff)))))
    (set_local $b67 (i64.add (get_local $b67) (i64.add (get_local $b99) (get_local $tmp))))
    (set_local $b35 (i64.rotr (i64.xor (get_local $b35) (get_local $b67)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b3) (i64.const 0xffffffff)) (i64.and (get_local $b35) (i64.const 0xffffffff)))))
    (set_local $b3 (i64.add (get_local $b3) (i64.add (get_local $b35) (get_local $tmp))))
    (set_local $b99 (i64.rotr (i64.xor (get_local $b99) (get_local $b3)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b67) (i64.const 0xffffffff)) (i64.and (get_local $b99) (i64.const 0xffffffff)))))
    (set_local $b67 (i64.add (get_local $b67) (i64.add (get_local $b99) (get_local $tmp))))
    (set_local $b35 (i64.rotr (i64.xor (get_local $b35) (get_local $b67)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b18) (i64.const 0xffffffff)) (i64.and (get_local $b50) (i64.const 0xffffffff)))))
    (set_local $b18 (i64.add (get_local $b18) (i64.add (get_local $b50) (get_local $tmp))))
    (set_local $b114 (i64.rotr (i64.xor (get_local $b114) (get_local $b18)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b82) (i64.const 0xffffffff)) (i64.and (get_local $b114) (i64.const 0xffffffff)))))
    (set_local $b82 (i64.add (get_local $b82) (i64.add (get_local $b114) (get_local $tmp))))
    (set_local $b50 (i64.rotr (i64.xor (get_local $b50) (get_local $b82)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b18) (i64.const 0xffffffff)) (i64.and (get_local $b50) (i64.const 0xffffffff)))))
    (set_local $b18 (i64.add (get_local $b18) (i64.add (get_local $b50) (get_local $tmp))))
    (set_local $b114 (i64.rotr (i64.xor (get_local $b114) (get_local $b18)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b82) (i64.const 0xffffffff)) (i64.and (get_local $b114) (i64.const 0xffffffff)))))
    (set_local $b82 (i64.add (get_local $b82) (i64.add (get_local $b114) (get_local $tmp))))
    (set_local $b50 (i64.rotr (i64.xor (get_local $b50) (get_local $b82)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b19) (i64.const 0xffffffff)) (i64.and (get_local $b51) (i64.const 0xffffffff)))))
    (set_local $b19 (i64.add (get_local $b19) (i64.add (get_local $b51) (get_local $tmp))))
    (set_local $b115 (i64.rotr (i64.xor (get_local $b115) (get_local $b19)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b83) (i64.const 0xffffffff)) (i64.and (get_local $b115) (i64.const 0xffffffff)))))
    (set_local $b83 (i64.add (get_local $b83) (i64.add (get_local $b115) (get_local $tmp))))
    (set_local $b51 (i64.rotr (i64.xor (get_local $b51) (get_local $b83)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b19) (i64.const 0xffffffff)) (i64.and (get_local $b51) (i64.const 0xffffffff)))))
    (set_local $b19 (i64.add (get_local $b19) (i64.add (get_local $b51) (get_local $tmp))))
    (set_local $b115 (i64.rotr (i64.xor (get_local $b115) (get_local $b19)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b83) (i64.const 0xffffffff)) (i64.and (get_local $b115) (i64.const 0xffffffff)))))
    (set_local $b83 (i64.add (get_local $b83) (i64.add (get_local $b115) (get_local $tmp))))
    (set_local $b51 (i64.rotr (i64.xor (get_local $b51) (get_local $b83)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b2) (i64.const 0xffffffff)) (i64.and (get_local $b35) (i64.const 0xffffffff)))))
    (set_local $b2 (i64.add (get_local $b2) (i64.add (get_local $b35) (get_local $tmp))))
    (set_local $b115 (i64.rotr (i64.xor (get_local $b115) (get_local $b2)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b82) (i64.const 0xffffffff)) (i64.and (get_local $b115) (i64.const 0xffffffff)))))
    (set_local $b82 (i64.add (get_local $b82) (i64.add (get_local $b115) (get_local $tmp))))
    (set_local $b35 (i64.rotr (i64.xor (get_local $b35) (get_local $b82)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b2) (i64.const 0xffffffff)) (i64.and (get_local $b35) (i64.const 0xffffffff)))))
    (set_local $b2 (i64.add (get_local $b2) (i64.add (get_local $b35) (get_local $tmp))))
    (set_local $b115 (i64.rotr (i64.xor (get_local $b115) (get_local $b2)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b82) (i64.const 0xffffffff)) (i64.and (get_local $b115) (i64.const 0xffffffff)))))
    (set_local $b82 (i64.add (get_local $b82) (i64.add (get_local $b115) (get_local $tmp))))
    (set_local $b35 (i64.rotr (i64.xor (get_local $b35) (get_local $b82)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b3) (i64.const 0xffffffff)) (i64.and (get_local $b50) (i64.const 0xffffffff)))))
    (set_local $b3 (i64.add (get_local $b3) (i64.add (get_local $b50) (get_local $tmp))))
    (set_local $b98 (i64.rotr (i64.xor (get_local $b98) (get_local $b3)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b83) (i64.const 0xffffffff)) (i64.and (get_local $b98) (i64.const 0xffffffff)))))
    (set_local $b83 (i64.add (get_local $b83) (i64.add (get_local $b98) (get_local $tmp))))
    (set_local $b50 (i64.rotr (i64.xor (get_local $b50) (get_local $b83)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b3) (i64.const 0xffffffff)) (i64.and (get_local $b50) (i64.const 0xffffffff)))))
    (set_local $b3 (i64.add (get_local $b3) (i64.add (get_local $b50) (get_local $tmp))))
    (set_local $b98 (i64.rotr (i64.xor (get_local $b98) (get_local $b3)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b83) (i64.const 0xffffffff)) (i64.and (get_local $b98) (i64.const 0xffffffff)))))
    (set_local $b83 (i64.add (get_local $b83) (i64.add (get_local $b98) (get_local $tmp))))
    (set_local $b50 (i64.rotr (i64.xor (get_local $b50) (get_local $b83)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b18) (i64.const 0xffffffff)) (i64.and (get_local $b51) (i64.const 0xffffffff)))))
    (set_local $b18 (i64.add (get_local $b18) (i64.add (get_local $b51) (get_local $tmp))))
    (set_local $b99 (i64.rotr (i64.xor (get_local $b99) (get_local $b18)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b66) (i64.const 0xffffffff)) (i64.and (get_local $b99) (i64.const 0xffffffff)))))
    (set_local $b66 (i64.add (get_local $b66) (i64.add (get_local $b99) (get_local $tmp))))
    (set_local $b51 (i64.rotr (i64.xor (get_local $b51) (get_local $b66)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b18) (i64.const 0xffffffff)) (i64.and (get_local $b51) (i64.const 0xffffffff)))))
    (set_local $b18 (i64.add (get_local $b18) (i64.add (get_local $b51) (get_local $tmp))))
    (set_local $b99 (i64.rotr (i64.xor (get_local $b99) (get_local $b18)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b66) (i64.const 0xffffffff)) (i64.and (get_local $b99) (i64.const 0xffffffff)))))
    (set_local $b66 (i64.add (get_local $b66) (i64.add (get_local $b99) (get_local $tmp))))
    (set_local $b51 (i64.rotr (i64.xor (get_local $b51) (get_local $b66)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b19) (i64.const 0xffffffff)) (i64.and (get_local $b34) (i64.const 0xffffffff)))))
    (set_local $b19 (i64.add (get_local $b19) (i64.add (get_local $b34) (get_local $tmp))))
    (set_local $b114 (i64.rotr (i64.xor (get_local $b114) (get_local $b19)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b67) (i64.const 0xffffffff)) (i64.and (get_local $b114) (i64.const 0xffffffff)))))
    (set_local $b67 (i64.add (get_local $b67) (i64.add (get_local $b114) (get_local $tmp))))
    (set_local $b34 (i64.rotr (i64.xor (get_local $b34) (get_local $b67)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b19) (i64.const 0xffffffff)) (i64.and (get_local $b34) (i64.const 0xffffffff)))))
    (set_local $b19 (i64.add (get_local $b19) (i64.add (get_local $b34) (get_local $tmp))))
    (set_local $b114 (i64.rotr (i64.xor (get_local $b114) (get_local $b19)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b67) (i64.const 0xffffffff)) (i64.and (get_local $b114) (i64.const 0xffffffff)))))
    (set_local $b67 (i64.add (get_local $b67) (i64.add (get_local $b114) (get_local $tmp))))
    (set_local $b34 (i64.rotr (i64.xor (get_local $b34) (get_local $b67)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b4) (i64.const 0xffffffff)) (i64.and (get_local $b36) (i64.const 0xffffffff)))))
    (set_local $b4 (i64.add (get_local $b4) (i64.add (get_local $b36) (get_local $tmp))))
    (set_local $b100 (i64.rotr (i64.xor (get_local $b100) (get_local $b4)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b68) (i64.const 0xffffffff)) (i64.and (get_local $b100) (i64.const 0xffffffff)))))
    (set_local $b68 (i64.add (get_local $b68) (i64.add (get_local $b100) (get_local $tmp))))
    (set_local $b36 (i64.rotr (i64.xor (get_local $b36) (get_local $b68)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b4) (i64.const 0xffffffff)) (i64.and (get_local $b36) (i64.const 0xffffffff)))))
    (set_local $b4 (i64.add (get_local $b4) (i64.add (get_local $b36) (get_local $tmp))))
    (set_local $b100 (i64.rotr (i64.xor (get_local $b100) (get_local $b4)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b68) (i64.const 0xffffffff)) (i64.and (get_local $b100) (i64.const 0xffffffff)))))
    (set_local $b68 (i64.add (get_local $b68) (i64.add (get_local $b100) (get_local $tmp))))
    (set_local $b36 (i64.rotr (i64.xor (get_local $b36) (get_local $b68)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b5) (i64.const 0xffffffff)) (i64.and (get_local $b37) (i64.const 0xffffffff)))))
    (set_local $b5 (i64.add (get_local $b5) (i64.add (get_local $b37) (get_local $tmp))))
    (set_local $b101 (i64.rotr (i64.xor (get_local $b101) (get_local $b5)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b69) (i64.const 0xffffffff)) (i64.and (get_local $b101) (i64.const 0xffffffff)))))
    (set_local $b69 (i64.add (get_local $b69) (i64.add (get_local $b101) (get_local $tmp))))
    (set_local $b37 (i64.rotr (i64.xor (get_local $b37) (get_local $b69)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b5) (i64.const 0xffffffff)) (i64.and (get_local $b37) (i64.const 0xffffffff)))))
    (set_local $b5 (i64.add (get_local $b5) (i64.add (get_local $b37) (get_local $tmp))))
    (set_local $b101 (i64.rotr (i64.xor (get_local $b101) (get_local $b5)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b69) (i64.const 0xffffffff)) (i64.and (get_local $b101) (i64.const 0xffffffff)))))
    (set_local $b69 (i64.add (get_local $b69) (i64.add (get_local $b101) (get_local $tmp))))
    (set_local $b37 (i64.rotr (i64.xor (get_local $b37) (get_local $b69)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b20) (i64.const 0xffffffff)) (i64.and (get_local $b52) (i64.const 0xffffffff)))))
    (set_local $b20 (i64.add (get_local $b20) (i64.add (get_local $b52) (get_local $tmp))))
    (set_local $b116 (i64.rotr (i64.xor (get_local $b116) (get_local $b20)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b84) (i64.const 0xffffffff)) (i64.and (get_local $b116) (i64.const 0xffffffff)))))
    (set_local $b84 (i64.add (get_local $b84) (i64.add (get_local $b116) (get_local $tmp))))
    (set_local $b52 (i64.rotr (i64.xor (get_local $b52) (get_local $b84)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b20) (i64.const 0xffffffff)) (i64.and (get_local $b52) (i64.const 0xffffffff)))))
    (set_local $b20 (i64.add (get_local $b20) (i64.add (get_local $b52) (get_local $tmp))))
    (set_local $b116 (i64.rotr (i64.xor (get_local $b116) (get_local $b20)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b84) (i64.const 0xffffffff)) (i64.and (get_local $b116) (i64.const 0xffffffff)))))
    (set_local $b84 (i64.add (get_local $b84) (i64.add (get_local $b116) (get_local $tmp))))
    (set_local $b52 (i64.rotr (i64.xor (get_local $b52) (get_local $b84)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b21) (i64.const 0xffffffff)) (i64.and (get_local $b53) (i64.const 0xffffffff)))))
    (set_local $b21 (i64.add (get_local $b21) (i64.add (get_local $b53) (get_local $tmp))))
    (set_local $b117 (i64.rotr (i64.xor (get_local $b117) (get_local $b21)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b85) (i64.const 0xffffffff)) (i64.and (get_local $b117) (i64.const 0xffffffff)))))
    (set_local $b85 (i64.add (get_local $b85) (i64.add (get_local $b117) (get_local $tmp))))
    (set_local $b53 (i64.rotr (i64.xor (get_local $b53) (get_local $b85)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b21) (i64.const 0xffffffff)) (i64.and (get_local $b53) (i64.const 0xffffffff)))))
    (set_local $b21 (i64.add (get_local $b21) (i64.add (get_local $b53) (get_local $tmp))))
    (set_local $b117 (i64.rotr (i64.xor (get_local $b117) (get_local $b21)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b85) (i64.const 0xffffffff)) (i64.and (get_local $b117) (i64.const 0xffffffff)))))
    (set_local $b85 (i64.add (get_local $b85) (i64.add (get_local $b117) (get_local $tmp))))
    (set_local $b53 (i64.rotr (i64.xor (get_local $b53) (get_local $b85)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b4) (i64.const 0xffffffff)) (i64.and (get_local $b37) (i64.const 0xffffffff)))))
    (set_local $b4 (i64.add (get_local $b4) (i64.add (get_local $b37) (get_local $tmp))))
    (set_local $b117 (i64.rotr (i64.xor (get_local $b117) (get_local $b4)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b84) (i64.const 0xffffffff)) (i64.and (get_local $b117) (i64.const 0xffffffff)))))
    (set_local $b84 (i64.add (get_local $b84) (i64.add (get_local $b117) (get_local $tmp))))
    (set_local $b37 (i64.rotr (i64.xor (get_local $b37) (get_local $b84)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b4) (i64.const 0xffffffff)) (i64.and (get_local $b37) (i64.const 0xffffffff)))))
    (set_local $b4 (i64.add (get_local $b4) (i64.add (get_local $b37) (get_local $tmp))))
    (set_local $b117 (i64.rotr (i64.xor (get_local $b117) (get_local $b4)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b84) (i64.const 0xffffffff)) (i64.and (get_local $b117) (i64.const 0xffffffff)))))
    (set_local $b84 (i64.add (get_local $b84) (i64.add (get_local $b117) (get_local $tmp))))
    (set_local $b37 (i64.rotr (i64.xor (get_local $b37) (get_local $b84)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b5) (i64.const 0xffffffff)) (i64.and (get_local $b52) (i64.const 0xffffffff)))))
    (set_local $b5 (i64.add (get_local $b5) (i64.add (get_local $b52) (get_local $tmp))))
    (set_local $b100 (i64.rotr (i64.xor (get_local $b100) (get_local $b5)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b85) (i64.const 0xffffffff)) (i64.and (get_local $b100) (i64.const 0xffffffff)))))
    (set_local $b85 (i64.add (get_local $b85) (i64.add (get_local $b100) (get_local $tmp))))
    (set_local $b52 (i64.rotr (i64.xor (get_local $b52) (get_local $b85)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b5) (i64.const 0xffffffff)) (i64.and (get_local $b52) (i64.const 0xffffffff)))))
    (set_local $b5 (i64.add (get_local $b5) (i64.add (get_local $b52) (get_local $tmp))))
    (set_local $b100 (i64.rotr (i64.xor (get_local $b100) (get_local $b5)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b85) (i64.const 0xffffffff)) (i64.and (get_local $b100) (i64.const 0xffffffff)))))
    (set_local $b85 (i64.add (get_local $b85) (i64.add (get_local $b100) (get_local $tmp))))
    (set_local $b52 (i64.rotr (i64.xor (get_local $b52) (get_local $b85)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b20) (i64.const 0xffffffff)) (i64.and (get_local $b53) (i64.const 0xffffffff)))))
    (set_local $b20 (i64.add (get_local $b20) (i64.add (get_local $b53) (get_local $tmp))))
    (set_local $b101 (i64.rotr (i64.xor (get_local $b101) (get_local $b20)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b68) (i64.const 0xffffffff)) (i64.and (get_local $b101) (i64.const 0xffffffff)))))
    (set_local $b68 (i64.add (get_local $b68) (i64.add (get_local $b101) (get_local $tmp))))
    (set_local $b53 (i64.rotr (i64.xor (get_local $b53) (get_local $b68)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b20) (i64.const 0xffffffff)) (i64.and (get_local $b53) (i64.const 0xffffffff)))))
    (set_local $b20 (i64.add (get_local $b20) (i64.add (get_local $b53) (get_local $tmp))))
    (set_local $b101 (i64.rotr (i64.xor (get_local $b101) (get_local $b20)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b68) (i64.const 0xffffffff)) (i64.and (get_local $b101) (i64.const 0xffffffff)))))
    (set_local $b68 (i64.add (get_local $b68) (i64.add (get_local $b101) (get_local $tmp))))
    (set_local $b53 (i64.rotr (i64.xor (get_local $b53) (get_local $b68)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b21) (i64.const 0xffffffff)) (i64.and (get_local $b36) (i64.const 0xffffffff)))))
    (set_local $b21 (i64.add (get_local $b21) (i64.add (get_local $b36) (get_local $tmp))))
    (set_local $b116 (i64.rotr (i64.xor (get_local $b116) (get_local $b21)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b69) (i64.const 0xffffffff)) (i64.and (get_local $b116) (i64.const 0xffffffff)))))
    (set_local $b69 (i64.add (get_local $b69) (i64.add (get_local $b116) (get_local $tmp))))
    (set_local $b36 (i64.rotr (i64.xor (get_local $b36) (get_local $b69)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b21) (i64.const 0xffffffff)) (i64.and (get_local $b36) (i64.const 0xffffffff)))))
    (set_local $b21 (i64.add (get_local $b21) (i64.add (get_local $b36) (get_local $tmp))))
    (set_local $b116 (i64.rotr (i64.xor (get_local $b116) (get_local $b21)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b69) (i64.const 0xffffffff)) (i64.and (get_local $b116) (i64.const 0xffffffff)))))
    (set_local $b69 (i64.add (get_local $b69) (i64.add (get_local $b116) (get_local $tmp))))
    (set_local $b36 (i64.rotr (i64.xor (get_local $b36) (get_local $b69)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b6) (i64.const 0xffffffff)) (i64.and (get_local $b38) (i64.const 0xffffffff)))))
    (set_local $b6 (i64.add (get_local $b6) (i64.add (get_local $b38) (get_local $tmp))))
    (set_local $b102 (i64.rotr (i64.xor (get_local $b102) (get_local $b6)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b70) (i64.const 0xffffffff)) (i64.and (get_local $b102) (i64.const 0xffffffff)))))
    (set_local $b70 (i64.add (get_local $b70) (i64.add (get_local $b102) (get_local $tmp))))
    (set_local $b38 (i64.rotr (i64.xor (get_local $b38) (get_local $b70)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b6) (i64.const 0xffffffff)) (i64.and (get_local $b38) (i64.const 0xffffffff)))))
    (set_local $b6 (i64.add (get_local $b6) (i64.add (get_local $b38) (get_local $tmp))))
    (set_local $b102 (i64.rotr (i64.xor (get_local $b102) (get_local $b6)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b70) (i64.const 0xffffffff)) (i64.and (get_local $b102) (i64.const 0xffffffff)))))
    (set_local $b70 (i64.add (get_local $b70) (i64.add (get_local $b102) (get_local $tmp))))
    (set_local $b38 (i64.rotr (i64.xor (get_local $b38) (get_local $b70)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b7) (i64.const 0xffffffff)) (i64.and (get_local $b39) (i64.const 0xffffffff)))))
    (set_local $b7 (i64.add (get_local $b7) (i64.add (get_local $b39) (get_local $tmp))))
    (set_local $b103 (i64.rotr (i64.xor (get_local $b103) (get_local $b7)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b71) (i64.const 0xffffffff)) (i64.and (get_local $b103) (i64.const 0xffffffff)))))
    (set_local $b71 (i64.add (get_local $b71) (i64.add (get_local $b103) (get_local $tmp))))
    (set_local $b39 (i64.rotr (i64.xor (get_local $b39) (get_local $b71)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b7) (i64.const 0xffffffff)) (i64.and (get_local $b39) (i64.const 0xffffffff)))))
    (set_local $b7 (i64.add (get_local $b7) (i64.add (get_local $b39) (get_local $tmp))))
    (set_local $b103 (i64.rotr (i64.xor (get_local $b103) (get_local $b7)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b71) (i64.const 0xffffffff)) (i64.and (get_local $b103) (i64.const 0xffffffff)))))
    (set_local $b71 (i64.add (get_local $b71) (i64.add (get_local $b103) (get_local $tmp))))
    (set_local $b39 (i64.rotr (i64.xor (get_local $b39) (get_local $b71)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b22) (i64.const 0xffffffff)) (i64.and (get_local $b54) (i64.const 0xffffffff)))))
    (set_local $b22 (i64.add (get_local $b22) (i64.add (get_local $b54) (get_local $tmp))))
    (set_local $b118 (i64.rotr (i64.xor (get_local $b118) (get_local $b22)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b86) (i64.const 0xffffffff)) (i64.and (get_local $b118) (i64.const 0xffffffff)))))
    (set_local $b86 (i64.add (get_local $b86) (i64.add (get_local $b118) (get_local $tmp))))
    (set_local $b54 (i64.rotr (i64.xor (get_local $b54) (get_local $b86)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b22) (i64.const 0xffffffff)) (i64.and (get_local $b54) (i64.const 0xffffffff)))))
    (set_local $b22 (i64.add (get_local $b22) (i64.add (get_local $b54) (get_local $tmp))))
    (set_local $b118 (i64.rotr (i64.xor (get_local $b118) (get_local $b22)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b86) (i64.const 0xffffffff)) (i64.and (get_local $b118) (i64.const 0xffffffff)))))
    (set_local $b86 (i64.add (get_local $b86) (i64.add (get_local $b118) (get_local $tmp))))
    (set_local $b54 (i64.rotr (i64.xor (get_local $b54) (get_local $b86)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b23) (i64.const 0xffffffff)) (i64.and (get_local $b55) (i64.const 0xffffffff)))))
    (set_local $b23 (i64.add (get_local $b23) (i64.add (get_local $b55) (get_local $tmp))))
    (set_local $b119 (i64.rotr (i64.xor (get_local $b119) (get_local $b23)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b87) (i64.const 0xffffffff)) (i64.and (get_local $b119) (i64.const 0xffffffff)))))
    (set_local $b87 (i64.add (get_local $b87) (i64.add (get_local $b119) (get_local $tmp))))
    (set_local $b55 (i64.rotr (i64.xor (get_local $b55) (get_local $b87)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b23) (i64.const 0xffffffff)) (i64.and (get_local $b55) (i64.const 0xffffffff)))))
    (set_local $b23 (i64.add (get_local $b23) (i64.add (get_local $b55) (get_local $tmp))))
    (set_local $b119 (i64.rotr (i64.xor (get_local $b119) (get_local $b23)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b87) (i64.const 0xffffffff)) (i64.and (get_local $b119) (i64.const 0xffffffff)))))
    (set_local $b87 (i64.add (get_local $b87) (i64.add (get_local $b119) (get_local $tmp))))
    (set_local $b55 (i64.rotr (i64.xor (get_local $b55) (get_local $b87)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b6) (i64.const 0xffffffff)) (i64.and (get_local $b39) (i64.const 0xffffffff)))))
    (set_local $b6 (i64.add (get_local $b6) (i64.add (get_local $b39) (get_local $tmp))))
    (set_local $b119 (i64.rotr (i64.xor (get_local $b119) (get_local $b6)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b86) (i64.const 0xffffffff)) (i64.and (get_local $b119) (i64.const 0xffffffff)))))
    (set_local $b86 (i64.add (get_local $b86) (i64.add (get_local $b119) (get_local $tmp))))
    (set_local $b39 (i64.rotr (i64.xor (get_local $b39) (get_local $b86)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b6) (i64.const 0xffffffff)) (i64.and (get_local $b39) (i64.const 0xffffffff)))))
    (set_local $b6 (i64.add (get_local $b6) (i64.add (get_local $b39) (get_local $tmp))))
    (set_local $b119 (i64.rotr (i64.xor (get_local $b119) (get_local $b6)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b86) (i64.const 0xffffffff)) (i64.and (get_local $b119) (i64.const 0xffffffff)))))
    (set_local $b86 (i64.add (get_local $b86) (i64.add (get_local $b119) (get_local $tmp))))
    (set_local $b39 (i64.rotr (i64.xor (get_local $b39) (get_local $b86)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b7) (i64.const 0xffffffff)) (i64.and (get_local $b54) (i64.const 0xffffffff)))))
    (set_local $b7 (i64.add (get_local $b7) (i64.add (get_local $b54) (get_local $tmp))))
    (set_local $b102 (i64.rotr (i64.xor (get_local $b102) (get_local $b7)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b87) (i64.const 0xffffffff)) (i64.and (get_local $b102) (i64.const 0xffffffff)))))
    (set_local $b87 (i64.add (get_local $b87) (i64.add (get_local $b102) (get_local $tmp))))
    (set_local $b54 (i64.rotr (i64.xor (get_local $b54) (get_local $b87)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b7) (i64.const 0xffffffff)) (i64.and (get_local $b54) (i64.const 0xffffffff)))))
    (set_local $b7 (i64.add (get_local $b7) (i64.add (get_local $b54) (get_local $tmp))))
    (set_local $b102 (i64.rotr (i64.xor (get_local $b102) (get_local $b7)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b87) (i64.const 0xffffffff)) (i64.and (get_local $b102) (i64.const 0xffffffff)))))
    (set_local $b87 (i64.add (get_local $b87) (i64.add (get_local $b102) (get_local $tmp))))
    (set_local $b54 (i64.rotr (i64.xor (get_local $b54) (get_local $b87)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b22) (i64.const 0xffffffff)) (i64.and (get_local $b55) (i64.const 0xffffffff)))))
    (set_local $b22 (i64.add (get_local $b22) (i64.add (get_local $b55) (get_local $tmp))))
    (set_local $b103 (i64.rotr (i64.xor (get_local $b103) (get_local $b22)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b70) (i64.const 0xffffffff)) (i64.and (get_local $b103) (i64.const 0xffffffff)))))
    (set_local $b70 (i64.add (get_local $b70) (i64.add (get_local $b103) (get_local $tmp))))
    (set_local $b55 (i64.rotr (i64.xor (get_local $b55) (get_local $b70)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b22) (i64.const 0xffffffff)) (i64.and (get_local $b55) (i64.const 0xffffffff)))))
    (set_local $b22 (i64.add (get_local $b22) (i64.add (get_local $b55) (get_local $tmp))))
    (set_local $b103 (i64.rotr (i64.xor (get_local $b103) (get_local $b22)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b70) (i64.const 0xffffffff)) (i64.and (get_local $b103) (i64.const 0xffffffff)))))
    (set_local $b70 (i64.add (get_local $b70) (i64.add (get_local $b103) (get_local $tmp))))
    (set_local $b55 (i64.rotr (i64.xor (get_local $b55) (get_local $b70)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b23) (i64.const 0xffffffff)) (i64.and (get_local $b38) (i64.const 0xffffffff)))))
    (set_local $b23 (i64.add (get_local $b23) (i64.add (get_local $b38) (get_local $tmp))))
    (set_local $b118 (i64.rotr (i64.xor (get_local $b118) (get_local $b23)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b71) (i64.const 0xffffffff)) (i64.and (get_local $b118) (i64.const 0xffffffff)))))
    (set_local $b71 (i64.add (get_local $b71) (i64.add (get_local $b118) (get_local $tmp))))
    (set_local $b38 (i64.rotr (i64.xor (get_local $b38) (get_local $b71)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b23) (i64.const 0xffffffff)) (i64.and (get_local $b38) (i64.const 0xffffffff)))))
    (set_local $b23 (i64.add (get_local $b23) (i64.add (get_local $b38) (get_local $tmp))))
    (set_local $b118 (i64.rotr (i64.xor (get_local $b118) (get_local $b23)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b71) (i64.const 0xffffffff)) (i64.and (get_local $b118) (i64.const 0xffffffff)))))
    (set_local $b71 (i64.add (get_local $b71) (i64.add (get_local $b118) (get_local $tmp))))
    (set_local $b38 (i64.rotr (i64.xor (get_local $b38) (get_local $b71)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b8) (i64.const 0xffffffff)) (i64.and (get_local $b40) (i64.const 0xffffffff)))))
    (set_local $b8 (i64.add (get_local $b8) (i64.add (get_local $b40) (get_local $tmp))))
    (set_local $b104 (i64.rotr (i64.xor (get_local $b104) (get_local $b8)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b72) (i64.const 0xffffffff)) (i64.and (get_local $b104) (i64.const 0xffffffff)))))
    (set_local $b72 (i64.add (get_local $b72) (i64.add (get_local $b104) (get_local $tmp))))
    (set_local $b40 (i64.rotr (i64.xor (get_local $b40) (get_local $b72)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b8) (i64.const 0xffffffff)) (i64.and (get_local $b40) (i64.const 0xffffffff)))))
    (set_local $b8 (i64.add (get_local $b8) (i64.add (get_local $b40) (get_local $tmp))))
    (set_local $b104 (i64.rotr (i64.xor (get_local $b104) (get_local $b8)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b72) (i64.const 0xffffffff)) (i64.and (get_local $b104) (i64.const 0xffffffff)))))
    (set_local $b72 (i64.add (get_local $b72) (i64.add (get_local $b104) (get_local $tmp))))
    (set_local $b40 (i64.rotr (i64.xor (get_local $b40) (get_local $b72)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b9) (i64.const 0xffffffff)) (i64.and (get_local $b41) (i64.const 0xffffffff)))))
    (set_local $b9 (i64.add (get_local $b9) (i64.add (get_local $b41) (get_local $tmp))))
    (set_local $b105 (i64.rotr (i64.xor (get_local $b105) (get_local $b9)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b73) (i64.const 0xffffffff)) (i64.and (get_local $b105) (i64.const 0xffffffff)))))
    (set_local $b73 (i64.add (get_local $b73) (i64.add (get_local $b105) (get_local $tmp))))
    (set_local $b41 (i64.rotr (i64.xor (get_local $b41) (get_local $b73)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b9) (i64.const 0xffffffff)) (i64.and (get_local $b41) (i64.const 0xffffffff)))))
    (set_local $b9 (i64.add (get_local $b9) (i64.add (get_local $b41) (get_local $tmp))))
    (set_local $b105 (i64.rotr (i64.xor (get_local $b105) (get_local $b9)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b73) (i64.const 0xffffffff)) (i64.and (get_local $b105) (i64.const 0xffffffff)))))
    (set_local $b73 (i64.add (get_local $b73) (i64.add (get_local $b105) (get_local $tmp))))
    (set_local $b41 (i64.rotr (i64.xor (get_local $b41) (get_local $b73)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b24) (i64.const 0xffffffff)) (i64.and (get_local $b56) (i64.const 0xffffffff)))))
    (set_local $b24 (i64.add (get_local $b24) (i64.add (get_local $b56) (get_local $tmp))))
    (set_local $b120 (i64.rotr (i64.xor (get_local $b120) (get_local $b24)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b88) (i64.const 0xffffffff)) (i64.and (get_local $b120) (i64.const 0xffffffff)))))
    (set_local $b88 (i64.add (get_local $b88) (i64.add (get_local $b120) (get_local $tmp))))
    (set_local $b56 (i64.rotr (i64.xor (get_local $b56) (get_local $b88)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b24) (i64.const 0xffffffff)) (i64.and (get_local $b56) (i64.const 0xffffffff)))))
    (set_local $b24 (i64.add (get_local $b24) (i64.add (get_local $b56) (get_local $tmp))))
    (set_local $b120 (i64.rotr (i64.xor (get_local $b120) (get_local $b24)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b88) (i64.const 0xffffffff)) (i64.and (get_local $b120) (i64.const 0xffffffff)))))
    (set_local $b88 (i64.add (get_local $b88) (i64.add (get_local $b120) (get_local $tmp))))
    (set_local $b56 (i64.rotr (i64.xor (get_local $b56) (get_local $b88)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b25) (i64.const 0xffffffff)) (i64.and (get_local $b57) (i64.const 0xffffffff)))))
    (set_local $b25 (i64.add (get_local $b25) (i64.add (get_local $b57) (get_local $tmp))))
    (set_local $b121 (i64.rotr (i64.xor (get_local $b121) (get_local $b25)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b89) (i64.const 0xffffffff)) (i64.and (get_local $b121) (i64.const 0xffffffff)))))
    (set_local $b89 (i64.add (get_local $b89) (i64.add (get_local $b121) (get_local $tmp))))
    (set_local $b57 (i64.rotr (i64.xor (get_local $b57) (get_local $b89)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b25) (i64.const 0xffffffff)) (i64.and (get_local $b57) (i64.const 0xffffffff)))))
    (set_local $b25 (i64.add (get_local $b25) (i64.add (get_local $b57) (get_local $tmp))))
    (set_local $b121 (i64.rotr (i64.xor (get_local $b121) (get_local $b25)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b89) (i64.const 0xffffffff)) (i64.and (get_local $b121) (i64.const 0xffffffff)))))
    (set_local $b89 (i64.add (get_local $b89) (i64.add (get_local $b121) (get_local $tmp))))
    (set_local $b57 (i64.rotr (i64.xor (get_local $b57) (get_local $b89)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b8) (i64.const 0xffffffff)) (i64.and (get_local $b41) (i64.const 0xffffffff)))))
    (set_local $b8 (i64.add (get_local $b8) (i64.add (get_local $b41) (get_local $tmp))))
    (set_local $b121 (i64.rotr (i64.xor (get_local $b121) (get_local $b8)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b88) (i64.const 0xffffffff)) (i64.and (get_local $b121) (i64.const 0xffffffff)))))
    (set_local $b88 (i64.add (get_local $b88) (i64.add (get_local $b121) (get_local $tmp))))
    (set_local $b41 (i64.rotr (i64.xor (get_local $b41) (get_local $b88)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b8) (i64.const 0xffffffff)) (i64.and (get_local $b41) (i64.const 0xffffffff)))))
    (set_local $b8 (i64.add (get_local $b8) (i64.add (get_local $b41) (get_local $tmp))))
    (set_local $b121 (i64.rotr (i64.xor (get_local $b121) (get_local $b8)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b88) (i64.const 0xffffffff)) (i64.and (get_local $b121) (i64.const 0xffffffff)))))
    (set_local $b88 (i64.add (get_local $b88) (i64.add (get_local $b121) (get_local $tmp))))
    (set_local $b41 (i64.rotr (i64.xor (get_local $b41) (get_local $b88)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b9) (i64.const 0xffffffff)) (i64.and (get_local $b56) (i64.const 0xffffffff)))))
    (set_local $b9 (i64.add (get_local $b9) (i64.add (get_local $b56) (get_local $tmp))))
    (set_local $b104 (i64.rotr (i64.xor (get_local $b104) (get_local $b9)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b89) (i64.const 0xffffffff)) (i64.and (get_local $b104) (i64.const 0xffffffff)))))
    (set_local $b89 (i64.add (get_local $b89) (i64.add (get_local $b104) (get_local $tmp))))
    (set_local $b56 (i64.rotr (i64.xor (get_local $b56) (get_local $b89)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b9) (i64.const 0xffffffff)) (i64.and (get_local $b56) (i64.const 0xffffffff)))))
    (set_local $b9 (i64.add (get_local $b9) (i64.add (get_local $b56) (get_local $tmp))))
    (set_local $b104 (i64.rotr (i64.xor (get_local $b104) (get_local $b9)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b89) (i64.const 0xffffffff)) (i64.and (get_local $b104) (i64.const 0xffffffff)))))
    (set_local $b89 (i64.add (get_local $b89) (i64.add (get_local $b104) (get_local $tmp))))
    (set_local $b56 (i64.rotr (i64.xor (get_local $b56) (get_local $b89)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b24) (i64.const 0xffffffff)) (i64.and (get_local $b57) (i64.const 0xffffffff)))))
    (set_local $b24 (i64.add (get_local $b24) (i64.add (get_local $b57) (get_local $tmp))))
    (set_local $b105 (i64.rotr (i64.xor (get_local $b105) (get_local $b24)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b72) (i64.const 0xffffffff)) (i64.and (get_local $b105) (i64.const 0xffffffff)))))
    (set_local $b72 (i64.add (get_local $b72) (i64.add (get_local $b105) (get_local $tmp))))
    (set_local $b57 (i64.rotr (i64.xor (get_local $b57) (get_local $b72)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b24) (i64.const 0xffffffff)) (i64.and (get_local $b57) (i64.const 0xffffffff)))))
    (set_local $b24 (i64.add (get_local $b24) (i64.add (get_local $b57) (get_local $tmp))))
    (set_local $b105 (i64.rotr (i64.xor (get_local $b105) (get_local $b24)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b72) (i64.const 0xffffffff)) (i64.and (get_local $b105) (i64.const 0xffffffff)))))
    (set_local $b72 (i64.add (get_local $b72) (i64.add (get_local $b105) (get_local $tmp))))
    (set_local $b57 (i64.rotr (i64.xor (get_local $b57) (get_local $b72)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b25) (i64.const 0xffffffff)) (i64.and (get_local $b40) (i64.const 0xffffffff)))))
    (set_local $b25 (i64.add (get_local $b25) (i64.add (get_local $b40) (get_local $tmp))))
    (set_local $b120 (i64.rotr (i64.xor (get_local $b120) (get_local $b25)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b73) (i64.const 0xffffffff)) (i64.and (get_local $b120) (i64.const 0xffffffff)))))
    (set_local $b73 (i64.add (get_local $b73) (i64.add (get_local $b120) (get_local $tmp))))
    (set_local $b40 (i64.rotr (i64.xor (get_local $b40) (get_local $b73)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b25) (i64.const 0xffffffff)) (i64.and (get_local $b40) (i64.const 0xffffffff)))))
    (set_local $b25 (i64.add (get_local $b25) (i64.add (get_local $b40) (get_local $tmp))))
    (set_local $b120 (i64.rotr (i64.xor (get_local $b120) (get_local $b25)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b73) (i64.const 0xffffffff)) (i64.and (get_local $b120) (i64.const 0xffffffff)))))
    (set_local $b73 (i64.add (get_local $b73) (i64.add (get_local $b120) (get_local $tmp))))
    (set_local $b40 (i64.rotr (i64.xor (get_local $b40) (get_local $b73)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b10) (i64.const 0xffffffff)) (i64.and (get_local $b42) (i64.const 0xffffffff)))))
    (set_local $b10 (i64.add (get_local $b10) (i64.add (get_local $b42) (get_local $tmp))))
    (set_local $b106 (i64.rotr (i64.xor (get_local $b106) (get_local $b10)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b74) (i64.const 0xffffffff)) (i64.and (get_local $b106) (i64.const 0xffffffff)))))
    (set_local $b74 (i64.add (get_local $b74) (i64.add (get_local $b106) (get_local $tmp))))
    (set_local $b42 (i64.rotr (i64.xor (get_local $b42) (get_local $b74)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b10) (i64.const 0xffffffff)) (i64.and (get_local $b42) (i64.const 0xffffffff)))))
    (set_local $b10 (i64.add (get_local $b10) (i64.add (get_local $b42) (get_local $tmp))))
    (set_local $b106 (i64.rotr (i64.xor (get_local $b106) (get_local $b10)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b74) (i64.const 0xffffffff)) (i64.and (get_local $b106) (i64.const 0xffffffff)))))
    (set_local $b74 (i64.add (get_local $b74) (i64.add (get_local $b106) (get_local $tmp))))
    (set_local $b42 (i64.rotr (i64.xor (get_local $b42) (get_local $b74)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b11) (i64.const 0xffffffff)) (i64.and (get_local $b43) (i64.const 0xffffffff)))))
    (set_local $b11 (i64.add (get_local $b11) (i64.add (get_local $b43) (get_local $tmp))))
    (set_local $b107 (i64.rotr (i64.xor (get_local $b107) (get_local $b11)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b75) (i64.const 0xffffffff)) (i64.and (get_local $b107) (i64.const 0xffffffff)))))
    (set_local $b75 (i64.add (get_local $b75) (i64.add (get_local $b107) (get_local $tmp))))
    (set_local $b43 (i64.rotr (i64.xor (get_local $b43) (get_local $b75)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b11) (i64.const 0xffffffff)) (i64.and (get_local $b43) (i64.const 0xffffffff)))))
    (set_local $b11 (i64.add (get_local $b11) (i64.add (get_local $b43) (get_local $tmp))))
    (set_local $b107 (i64.rotr (i64.xor (get_local $b107) (get_local $b11)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b75) (i64.const 0xffffffff)) (i64.and (get_local $b107) (i64.const 0xffffffff)))))
    (set_local $b75 (i64.add (get_local $b75) (i64.add (get_local $b107) (get_local $tmp))))
    (set_local $b43 (i64.rotr (i64.xor (get_local $b43) (get_local $b75)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b26) (i64.const 0xffffffff)) (i64.and (get_local $b58) (i64.const 0xffffffff)))))
    (set_local $b26 (i64.add (get_local $b26) (i64.add (get_local $b58) (get_local $tmp))))
    (set_local $b122 (i64.rotr (i64.xor (get_local $b122) (get_local $b26)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b90) (i64.const 0xffffffff)) (i64.and (get_local $b122) (i64.const 0xffffffff)))))
    (set_local $b90 (i64.add (get_local $b90) (i64.add (get_local $b122) (get_local $tmp))))
    (set_local $b58 (i64.rotr (i64.xor (get_local $b58) (get_local $b90)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b26) (i64.const 0xffffffff)) (i64.and (get_local $b58) (i64.const 0xffffffff)))))
    (set_local $b26 (i64.add (get_local $b26) (i64.add (get_local $b58) (get_local $tmp))))
    (set_local $b122 (i64.rotr (i64.xor (get_local $b122) (get_local $b26)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b90) (i64.const 0xffffffff)) (i64.and (get_local $b122) (i64.const 0xffffffff)))))
    (set_local $b90 (i64.add (get_local $b90) (i64.add (get_local $b122) (get_local $tmp))))
    (set_local $b58 (i64.rotr (i64.xor (get_local $b58) (get_local $b90)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b27) (i64.const 0xffffffff)) (i64.and (get_local $b59) (i64.const 0xffffffff)))))
    (set_local $b27 (i64.add (get_local $b27) (i64.add (get_local $b59) (get_local $tmp))))
    (set_local $b123 (i64.rotr (i64.xor (get_local $b123) (get_local $b27)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b91) (i64.const 0xffffffff)) (i64.and (get_local $b123) (i64.const 0xffffffff)))))
    (set_local $b91 (i64.add (get_local $b91) (i64.add (get_local $b123) (get_local $tmp))))
    (set_local $b59 (i64.rotr (i64.xor (get_local $b59) (get_local $b91)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b27) (i64.const 0xffffffff)) (i64.and (get_local $b59) (i64.const 0xffffffff)))))
    (set_local $b27 (i64.add (get_local $b27) (i64.add (get_local $b59) (get_local $tmp))))
    (set_local $b123 (i64.rotr (i64.xor (get_local $b123) (get_local $b27)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b91) (i64.const 0xffffffff)) (i64.and (get_local $b123) (i64.const 0xffffffff)))))
    (set_local $b91 (i64.add (get_local $b91) (i64.add (get_local $b123) (get_local $tmp))))
    (set_local $b59 (i64.rotr (i64.xor (get_local $b59) (get_local $b91)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b10) (i64.const 0xffffffff)) (i64.and (get_local $b43) (i64.const 0xffffffff)))))
    (set_local $b10 (i64.add (get_local $b10) (i64.add (get_local $b43) (get_local $tmp))))
    (set_local $b123 (i64.rotr (i64.xor (get_local $b123) (get_local $b10)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b90) (i64.const 0xffffffff)) (i64.and (get_local $b123) (i64.const 0xffffffff)))))
    (set_local $b90 (i64.add (get_local $b90) (i64.add (get_local $b123) (get_local $tmp))))
    (set_local $b43 (i64.rotr (i64.xor (get_local $b43) (get_local $b90)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b10) (i64.const 0xffffffff)) (i64.and (get_local $b43) (i64.const 0xffffffff)))))
    (set_local $b10 (i64.add (get_local $b10) (i64.add (get_local $b43) (get_local $tmp))))
    (set_local $b123 (i64.rotr (i64.xor (get_local $b123) (get_local $b10)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b90) (i64.const 0xffffffff)) (i64.and (get_local $b123) (i64.const 0xffffffff)))))
    (set_local $b90 (i64.add (get_local $b90) (i64.add (get_local $b123) (get_local $tmp))))
    (set_local $b43 (i64.rotr (i64.xor (get_local $b43) (get_local $b90)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b11) (i64.const 0xffffffff)) (i64.and (get_local $b58) (i64.const 0xffffffff)))))
    (set_local $b11 (i64.add (get_local $b11) (i64.add (get_local $b58) (get_local $tmp))))
    (set_local $b106 (i64.rotr (i64.xor (get_local $b106) (get_local $b11)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b91) (i64.const 0xffffffff)) (i64.and (get_local $b106) (i64.const 0xffffffff)))))
    (set_local $b91 (i64.add (get_local $b91) (i64.add (get_local $b106) (get_local $tmp))))
    (set_local $b58 (i64.rotr (i64.xor (get_local $b58) (get_local $b91)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b11) (i64.const 0xffffffff)) (i64.and (get_local $b58) (i64.const 0xffffffff)))))
    (set_local $b11 (i64.add (get_local $b11) (i64.add (get_local $b58) (get_local $tmp))))
    (set_local $b106 (i64.rotr (i64.xor (get_local $b106) (get_local $b11)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b91) (i64.const 0xffffffff)) (i64.and (get_local $b106) (i64.const 0xffffffff)))))
    (set_local $b91 (i64.add (get_local $b91) (i64.add (get_local $b106) (get_local $tmp))))
    (set_local $b58 (i64.rotr (i64.xor (get_local $b58) (get_local $b91)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b26) (i64.const 0xffffffff)) (i64.and (get_local $b59) (i64.const 0xffffffff)))))
    (set_local $b26 (i64.add (get_local $b26) (i64.add (get_local $b59) (get_local $tmp))))
    (set_local $b107 (i64.rotr (i64.xor (get_local $b107) (get_local $b26)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b74) (i64.const 0xffffffff)) (i64.and (get_local $b107) (i64.const 0xffffffff)))))
    (set_local $b74 (i64.add (get_local $b74) (i64.add (get_local $b107) (get_local $tmp))))
    (set_local $b59 (i64.rotr (i64.xor (get_local $b59) (get_local $b74)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b26) (i64.const 0xffffffff)) (i64.and (get_local $b59) (i64.const 0xffffffff)))))
    (set_local $b26 (i64.add (get_local $b26) (i64.add (get_local $b59) (get_local $tmp))))
    (set_local $b107 (i64.rotr (i64.xor (get_local $b107) (get_local $b26)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b74) (i64.const 0xffffffff)) (i64.and (get_local $b107) (i64.const 0xffffffff)))))
    (set_local $b74 (i64.add (get_local $b74) (i64.add (get_local $b107) (get_local $tmp))))
    (set_local $b59 (i64.rotr (i64.xor (get_local $b59) (get_local $b74)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b27) (i64.const 0xffffffff)) (i64.and (get_local $b42) (i64.const 0xffffffff)))))
    (set_local $b27 (i64.add (get_local $b27) (i64.add (get_local $b42) (get_local $tmp))))
    (set_local $b122 (i64.rotr (i64.xor (get_local $b122) (get_local $b27)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b75) (i64.const 0xffffffff)) (i64.and (get_local $b122) (i64.const 0xffffffff)))))
    (set_local $b75 (i64.add (get_local $b75) (i64.add (get_local $b122) (get_local $tmp))))
    (set_local $b42 (i64.rotr (i64.xor (get_local $b42) (get_local $b75)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b27) (i64.const 0xffffffff)) (i64.and (get_local $b42) (i64.const 0xffffffff)))))
    (set_local $b27 (i64.add (get_local $b27) (i64.add (get_local $b42) (get_local $tmp))))
    (set_local $b122 (i64.rotr (i64.xor (get_local $b122) (get_local $b27)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b75) (i64.const 0xffffffff)) (i64.and (get_local $b122) (i64.const 0xffffffff)))))
    (set_local $b75 (i64.add (get_local $b75) (i64.add (get_local $b122) (get_local $tmp))))
    (set_local $b42 (i64.rotr (i64.xor (get_local $b42) (get_local $b75)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b12) (i64.const 0xffffffff)) (i64.and (get_local $b44) (i64.const 0xffffffff)))))
    (set_local $b12 (i64.add (get_local $b12) (i64.add (get_local $b44) (get_local $tmp))))
    (set_local $b108 (i64.rotr (i64.xor (get_local $b108) (get_local $b12)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b76) (i64.const 0xffffffff)) (i64.and (get_local $b108) (i64.const 0xffffffff)))))
    (set_local $b76 (i64.add (get_local $b76) (i64.add (get_local $b108) (get_local $tmp))))
    (set_local $b44 (i64.rotr (i64.xor (get_local $b44) (get_local $b76)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b12) (i64.const 0xffffffff)) (i64.and (get_local $b44) (i64.const 0xffffffff)))))
    (set_local $b12 (i64.add (get_local $b12) (i64.add (get_local $b44) (get_local $tmp))))
    (set_local $b108 (i64.rotr (i64.xor (get_local $b108) (get_local $b12)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b76) (i64.const 0xffffffff)) (i64.and (get_local $b108) (i64.const 0xffffffff)))))
    (set_local $b76 (i64.add (get_local $b76) (i64.add (get_local $b108) (get_local $tmp))))
    (set_local $b44 (i64.rotr (i64.xor (get_local $b44) (get_local $b76)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b13) (i64.const 0xffffffff)) (i64.and (get_local $b45) (i64.const 0xffffffff)))))
    (set_local $b13 (i64.add (get_local $b13) (i64.add (get_local $b45) (get_local $tmp))))
    (set_local $b109 (i64.rotr (i64.xor (get_local $b109) (get_local $b13)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b77) (i64.const 0xffffffff)) (i64.and (get_local $b109) (i64.const 0xffffffff)))))
    (set_local $b77 (i64.add (get_local $b77) (i64.add (get_local $b109) (get_local $tmp))))
    (set_local $b45 (i64.rotr (i64.xor (get_local $b45) (get_local $b77)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b13) (i64.const 0xffffffff)) (i64.and (get_local $b45) (i64.const 0xffffffff)))))
    (set_local $b13 (i64.add (get_local $b13) (i64.add (get_local $b45) (get_local $tmp))))
    (set_local $b109 (i64.rotr (i64.xor (get_local $b109) (get_local $b13)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b77) (i64.const 0xffffffff)) (i64.and (get_local $b109) (i64.const 0xffffffff)))))
    (set_local $b77 (i64.add (get_local $b77) (i64.add (get_local $b109) (get_local $tmp))))
    (set_local $b45 (i64.rotr (i64.xor (get_local $b45) (get_local $b77)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b28) (i64.const 0xffffffff)) (i64.and (get_local $b60) (i64.const 0xffffffff)))))
    (set_local $b28 (i64.add (get_local $b28) (i64.add (get_local $b60) (get_local $tmp))))
    (set_local $b124 (i64.rotr (i64.xor (get_local $b124) (get_local $b28)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b92) (i64.const 0xffffffff)) (i64.and (get_local $b124) (i64.const 0xffffffff)))))
    (set_local $b92 (i64.add (get_local $b92) (i64.add (get_local $b124) (get_local $tmp))))
    (set_local $b60 (i64.rotr (i64.xor (get_local $b60) (get_local $b92)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b28) (i64.const 0xffffffff)) (i64.and (get_local $b60) (i64.const 0xffffffff)))))
    (set_local $b28 (i64.add (get_local $b28) (i64.add (get_local $b60) (get_local $tmp))))
    (set_local $b124 (i64.rotr (i64.xor (get_local $b124) (get_local $b28)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b92) (i64.const 0xffffffff)) (i64.and (get_local $b124) (i64.const 0xffffffff)))))
    (set_local $b92 (i64.add (get_local $b92) (i64.add (get_local $b124) (get_local $tmp))))
    (set_local $b60 (i64.rotr (i64.xor (get_local $b60) (get_local $b92)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b29) (i64.const 0xffffffff)) (i64.and (get_local $b61) (i64.const 0xffffffff)))))
    (set_local $b29 (i64.add (get_local $b29) (i64.add (get_local $b61) (get_local $tmp))))
    (set_local $b125 (i64.rotr (i64.xor (get_local $b125) (get_local $b29)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b93) (i64.const 0xffffffff)) (i64.and (get_local $b125) (i64.const 0xffffffff)))))
    (set_local $b93 (i64.add (get_local $b93) (i64.add (get_local $b125) (get_local $tmp))))
    (set_local $b61 (i64.rotr (i64.xor (get_local $b61) (get_local $b93)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b29) (i64.const 0xffffffff)) (i64.and (get_local $b61) (i64.const 0xffffffff)))))
    (set_local $b29 (i64.add (get_local $b29) (i64.add (get_local $b61) (get_local $tmp))))
    (set_local $b125 (i64.rotr (i64.xor (get_local $b125) (get_local $b29)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b93) (i64.const 0xffffffff)) (i64.and (get_local $b125) (i64.const 0xffffffff)))))
    (set_local $b93 (i64.add (get_local $b93) (i64.add (get_local $b125) (get_local $tmp))))
    (set_local $b61 (i64.rotr (i64.xor (get_local $b61) (get_local $b93)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b12) (i64.const 0xffffffff)) (i64.and (get_local $b45) (i64.const 0xffffffff)))))
    (set_local $b12 (i64.add (get_local $b12) (i64.add (get_local $b45) (get_local $tmp))))
    (set_local $b125 (i64.rotr (i64.xor (get_local $b125) (get_local $b12)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b92) (i64.const 0xffffffff)) (i64.and (get_local $b125) (i64.const 0xffffffff)))))
    (set_local $b92 (i64.add (get_local $b92) (i64.add (get_local $b125) (get_local $tmp))))
    (set_local $b45 (i64.rotr (i64.xor (get_local $b45) (get_local $b92)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b12) (i64.const 0xffffffff)) (i64.and (get_local $b45) (i64.const 0xffffffff)))))
    (set_local $b12 (i64.add (get_local $b12) (i64.add (get_local $b45) (get_local $tmp))))
    (set_local $b125 (i64.rotr (i64.xor (get_local $b125) (get_local $b12)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b92) (i64.const 0xffffffff)) (i64.and (get_local $b125) (i64.const 0xffffffff)))))
    (set_local $b92 (i64.add (get_local $b92) (i64.add (get_local $b125) (get_local $tmp))))
    (set_local $b45 (i64.rotr (i64.xor (get_local $b45) (get_local $b92)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b13) (i64.const 0xffffffff)) (i64.and (get_local $b60) (i64.const 0xffffffff)))))
    (set_local $b13 (i64.add (get_local $b13) (i64.add (get_local $b60) (get_local $tmp))))
    (set_local $b108 (i64.rotr (i64.xor (get_local $b108) (get_local $b13)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b93) (i64.const 0xffffffff)) (i64.and (get_local $b108) (i64.const 0xffffffff)))))
    (set_local $b93 (i64.add (get_local $b93) (i64.add (get_local $b108) (get_local $tmp))))
    (set_local $b60 (i64.rotr (i64.xor (get_local $b60) (get_local $b93)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b13) (i64.const 0xffffffff)) (i64.and (get_local $b60) (i64.const 0xffffffff)))))
    (set_local $b13 (i64.add (get_local $b13) (i64.add (get_local $b60) (get_local $tmp))))
    (set_local $b108 (i64.rotr (i64.xor (get_local $b108) (get_local $b13)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b93) (i64.const 0xffffffff)) (i64.and (get_local $b108) (i64.const 0xffffffff)))))
    (set_local $b93 (i64.add (get_local $b93) (i64.add (get_local $b108) (get_local $tmp))))
    (set_local $b60 (i64.rotr (i64.xor (get_local $b60) (get_local $b93)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b28) (i64.const 0xffffffff)) (i64.and (get_local $b61) (i64.const 0xffffffff)))))
    (set_local $b28 (i64.add (get_local $b28) (i64.add (get_local $b61) (get_local $tmp))))
    (set_local $b109 (i64.rotr (i64.xor (get_local $b109) (get_local $b28)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b76) (i64.const 0xffffffff)) (i64.and (get_local $b109) (i64.const 0xffffffff)))))
    (set_local $b76 (i64.add (get_local $b76) (i64.add (get_local $b109) (get_local $tmp))))
    (set_local $b61 (i64.rotr (i64.xor (get_local $b61) (get_local $b76)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b28) (i64.const 0xffffffff)) (i64.and (get_local $b61) (i64.const 0xffffffff)))))
    (set_local $b28 (i64.add (get_local $b28) (i64.add (get_local $b61) (get_local $tmp))))
    (set_local $b109 (i64.rotr (i64.xor (get_local $b109) (get_local $b28)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b76) (i64.const 0xffffffff)) (i64.and (get_local $b109) (i64.const 0xffffffff)))))
    (set_local $b76 (i64.add (get_local $b76) (i64.add (get_local $b109) (get_local $tmp))))
    (set_local $b61 (i64.rotr (i64.xor (get_local $b61) (get_local $b76)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b29) (i64.const 0xffffffff)) (i64.and (get_local $b44) (i64.const 0xffffffff)))))
    (set_local $b29 (i64.add (get_local $b29) (i64.add (get_local $b44) (get_local $tmp))))
    (set_local $b124 (i64.rotr (i64.xor (get_local $b124) (get_local $b29)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b77) (i64.const 0xffffffff)) (i64.and (get_local $b124) (i64.const 0xffffffff)))))
    (set_local $b77 (i64.add (get_local $b77) (i64.add (get_local $b124) (get_local $tmp))))
    (set_local $b44 (i64.rotr (i64.xor (get_local $b44) (get_local $b77)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b29) (i64.const 0xffffffff)) (i64.and (get_local $b44) (i64.const 0xffffffff)))))
    (set_local $b29 (i64.add (get_local $b29) (i64.add (get_local $b44) (get_local $tmp))))
    (set_local $b124 (i64.rotr (i64.xor (get_local $b124) (get_local $b29)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b77) (i64.const 0xffffffff)) (i64.and (get_local $b124) (i64.const 0xffffffff)))))
    (set_local $b77 (i64.add (get_local $b77) (i64.add (get_local $b124) (get_local $tmp))))
    (set_local $b44 (i64.rotr (i64.xor (get_local $b44) (get_local $b77)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b14) (i64.const 0xffffffff)) (i64.and (get_local $b46) (i64.const 0xffffffff)))))
    (set_local $b14 (i64.add (get_local $b14) (i64.add (get_local $b46) (get_local $tmp))))
    (set_local $b110 (i64.rotr (i64.xor (get_local $b110) (get_local $b14)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b78) (i64.const 0xffffffff)) (i64.and (get_local $b110) (i64.const 0xffffffff)))))
    (set_local $b78 (i64.add (get_local $b78) (i64.add (get_local $b110) (get_local $tmp))))
    (set_local $b46 (i64.rotr (i64.xor (get_local $b46) (get_local $b78)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b14) (i64.const 0xffffffff)) (i64.and (get_local $b46) (i64.const 0xffffffff)))))
    (set_local $b14 (i64.add (get_local $b14) (i64.add (get_local $b46) (get_local $tmp))))
    (set_local $b110 (i64.rotr (i64.xor (get_local $b110) (get_local $b14)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b78) (i64.const 0xffffffff)) (i64.and (get_local $b110) (i64.const 0xffffffff)))))
    (set_local $b78 (i64.add (get_local $b78) (i64.add (get_local $b110) (get_local $tmp))))
    (set_local $b46 (i64.rotr (i64.xor (get_local $b46) (get_local $b78)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b15) (i64.const 0xffffffff)) (i64.and (get_local $b47) (i64.const 0xffffffff)))))
    (set_local $b15 (i64.add (get_local $b15) (i64.add (get_local $b47) (get_local $tmp))))
    (set_local $b111 (i64.rotr (i64.xor (get_local $b111) (get_local $b15)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b79) (i64.const 0xffffffff)) (i64.and (get_local $b111) (i64.const 0xffffffff)))))
    (set_local $b79 (i64.add (get_local $b79) (i64.add (get_local $b111) (get_local $tmp))))
    (set_local $b47 (i64.rotr (i64.xor (get_local $b47) (get_local $b79)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b15) (i64.const 0xffffffff)) (i64.and (get_local $b47) (i64.const 0xffffffff)))))
    (set_local $b15 (i64.add (get_local $b15) (i64.add (get_local $b47) (get_local $tmp))))
    (set_local $b111 (i64.rotr (i64.xor (get_local $b111) (get_local $b15)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b79) (i64.const 0xffffffff)) (i64.and (get_local $b111) (i64.const 0xffffffff)))))
    (set_local $b79 (i64.add (get_local $b79) (i64.add (get_local $b111) (get_local $tmp))))
    (set_local $b47 (i64.rotr (i64.xor (get_local $b47) (get_local $b79)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b30) (i64.const 0xffffffff)) (i64.and (get_local $b62) (i64.const 0xffffffff)))))
    (set_local $b30 (i64.add (get_local $b30) (i64.add (get_local $b62) (get_local $tmp))))
    (set_local $b126 (i64.rotr (i64.xor (get_local $b126) (get_local $b30)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b94) (i64.const 0xffffffff)) (i64.and (get_local $b126) (i64.const 0xffffffff)))))
    (set_local $b94 (i64.add (get_local $b94) (i64.add (get_local $b126) (get_local $tmp))))
    (set_local $b62 (i64.rotr (i64.xor (get_local $b62) (get_local $b94)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b30) (i64.const 0xffffffff)) (i64.and (get_local $b62) (i64.const 0xffffffff)))))
    (set_local $b30 (i64.add (get_local $b30) (i64.add (get_local $b62) (get_local $tmp))))
    (set_local $b126 (i64.rotr (i64.xor (get_local $b126) (get_local $b30)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b94) (i64.const 0xffffffff)) (i64.and (get_local $b126) (i64.const 0xffffffff)))))
    (set_local $b94 (i64.add (get_local $b94) (i64.add (get_local $b126) (get_local $tmp))))
    (set_local $b62 (i64.rotr (i64.xor (get_local $b62) (get_local $b94)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b31) (i64.const 0xffffffff)) (i64.and (get_local $b63) (i64.const 0xffffffff)))))
    (set_local $b31 (i64.add (get_local $b31) (i64.add (get_local $b63) (get_local $tmp))))
    (set_local $b127 (i64.rotr (i64.xor (get_local $b127) (get_local $b31)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b95) (i64.const 0xffffffff)) (i64.and (get_local $b127) (i64.const 0xffffffff)))))
    (set_local $b95 (i64.add (get_local $b95) (i64.add (get_local $b127) (get_local $tmp))))
    (set_local $b63 (i64.rotr (i64.xor (get_local $b63) (get_local $b95)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b31) (i64.const 0xffffffff)) (i64.and (get_local $b63) (i64.const 0xffffffff)))))
    (set_local $b31 (i64.add (get_local $b31) (i64.add (get_local $b63) (get_local $tmp))))
    (set_local $b127 (i64.rotr (i64.xor (get_local $b127) (get_local $b31)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b95) (i64.const 0xffffffff)) (i64.and (get_local $b127) (i64.const 0xffffffff)))))
    (set_local $b95 (i64.add (get_local $b95) (i64.add (get_local $b127) (get_local $tmp))))
    (set_local $b63 (i64.rotr (i64.xor (get_local $b63) (get_local $b95)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b14) (i64.const 0xffffffff)) (i64.and (get_local $b47) (i64.const 0xffffffff)))))
    (set_local $b14 (i64.add (get_local $b14) (i64.add (get_local $b47) (get_local $tmp))))
    (set_local $b127 (i64.rotr (i64.xor (get_local $b127) (get_local $b14)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b94) (i64.const 0xffffffff)) (i64.and (get_local $b127) (i64.const 0xffffffff)))))
    (set_local $b94 (i64.add (get_local $b94) (i64.add (get_local $b127) (get_local $tmp))))
    (set_local $b47 (i64.rotr (i64.xor (get_local $b47) (get_local $b94)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b14) (i64.const 0xffffffff)) (i64.and (get_local $b47) (i64.const 0xffffffff)))))
    (set_local $b14 (i64.add (get_local $b14) (i64.add (get_local $b47) (get_local $tmp))))
    (set_local $b127 (i64.rotr (i64.xor (get_local $b127) (get_local $b14)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b94) (i64.const 0xffffffff)) (i64.and (get_local $b127) (i64.const 0xffffffff)))))
    (set_local $b94 (i64.add (get_local $b94) (i64.add (get_local $b127) (get_local $tmp))))
    (set_local $b47 (i64.rotr (i64.xor (get_local $b47) (get_local $b94)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b15) (i64.const 0xffffffff)) (i64.and (get_local $b62) (i64.const 0xffffffff)))))
    (set_local $b15 (i64.add (get_local $b15) (i64.add (get_local $b62) (get_local $tmp))))
    (set_local $b110 (i64.rotr (i64.xor (get_local $b110) (get_local $b15)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b95) (i64.const 0xffffffff)) (i64.and (get_local $b110) (i64.const 0xffffffff)))))
    (set_local $b95 (i64.add (get_local $b95) (i64.add (get_local $b110) (get_local $tmp))))
    (set_local $b62 (i64.rotr (i64.xor (get_local $b62) (get_local $b95)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b15) (i64.const 0xffffffff)) (i64.and (get_local $b62) (i64.const 0xffffffff)))))
    (set_local $b15 (i64.add (get_local $b15) (i64.add (get_local $b62) (get_local $tmp))))
    (set_local $b110 (i64.rotr (i64.xor (get_local $b110) (get_local $b15)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b95) (i64.const 0xffffffff)) (i64.and (get_local $b110) (i64.const 0xffffffff)))))
    (set_local $b95 (i64.add (get_local $b95) (i64.add (get_local $b110) (get_local $tmp))))
    (set_local $b62 (i64.rotr (i64.xor (get_local $b62) (get_local $b95)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b30) (i64.const 0xffffffff)) (i64.and (get_local $b63) (i64.const 0xffffffff)))))
    (set_local $b30 (i64.add (get_local $b30) (i64.add (get_local $b63) (get_local $tmp))))
    (set_local $b111 (i64.rotr (i64.xor (get_local $b111) (get_local $b30)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b78) (i64.const 0xffffffff)) (i64.and (get_local $b111) (i64.const 0xffffffff)))))
    (set_local $b78 (i64.add (get_local $b78) (i64.add (get_local $b111) (get_local $tmp))))
    (set_local $b63 (i64.rotr (i64.xor (get_local $b63) (get_local $b78)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b30) (i64.const 0xffffffff)) (i64.and (get_local $b63) (i64.const 0xffffffff)))))
    (set_local $b30 (i64.add (get_local $b30) (i64.add (get_local $b63) (get_local $tmp))))
    (set_local $b111 (i64.rotr (i64.xor (get_local $b111) (get_local $b30)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b78) (i64.const 0xffffffff)) (i64.and (get_local $b111) (i64.const 0xffffffff)))))
    (set_local $b78 (i64.add (get_local $b78) (i64.add (get_local $b111) (get_local $tmp))))
    (set_local $b63 (i64.rotr (i64.xor (get_local $b63) (get_local $b78)) (i64.const 63)))


    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b31) (i64.const 0xffffffff)) (i64.and (get_local $b46) (i64.const 0xffffffff)))))
    (set_local $b31 (i64.add (get_local $b31) (i64.add (get_local $b46) (get_local $tmp))))
    (set_local $b126 (i64.rotr (i64.xor (get_local $b126) (get_local $b31)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b79) (i64.const 0xffffffff)) (i64.and (get_local $b126) (i64.const 0xffffffff)))))
    (set_local $b79 (i64.add (get_local $b79) (i64.add (get_local $b126) (get_local $tmp))))
    (set_local $b46 (i64.rotr (i64.xor (get_local $b46) (get_local $b79)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b31) (i64.const 0xffffffff)) (i64.and (get_local $b46) (i64.const 0xffffffff)))))
    (set_local $b31 (i64.add (get_local $b31) (i64.add (get_local $b46) (get_local $tmp))))
    (set_local $b126 (i64.rotr (i64.xor (get_local $b126) (get_local $b31)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.mul (i64.and (get_local $b79) (i64.const 0xffffffff)) (i64.and (get_local $b126) (i64.const 0xffffffff)))))
    (set_local $b79 (i64.add (get_local $b79) (i64.add (get_local $b126) (get_local $tmp))))
    (set_local $b46 (i64.rotr (i64.xor (get_local $b46) (get_local $b79)) (i64.const 63)))


    (i64.store offset=0    (get_local $next_block) (i64.xor (get_local $b0  ) (get_local $tmp0  )))
    (i64.store offset=8    (get_local $next_block) (i64.xor (get_local $b1  ) (get_local $tmp1  )))
    (i64.store offset=16   (get_local $next_block) (i64.xor (get_local $b2  ) (get_local $tmp2  )))
    (i64.store offset=24   (get_local $next_block) (i64.xor (get_local $b3  ) (get_local $tmp3  )))
    (i64.store offset=32   (get_local $next_block) (i64.xor (get_local $b4  ) (get_local $tmp4  )))
    (i64.store offset=40   (get_local $next_block) (i64.xor (get_local $b5  ) (get_local $tmp5  )))
    (i64.store offset=48   (get_local $next_block) (i64.xor (get_local $b6  ) (get_local $tmp6  )))
    (i64.store offset=56   (get_local $next_block) (i64.xor (get_local $b7  ) (get_local $tmp7  )))
    (i64.store offset=64   (get_local $next_block) (i64.xor (get_local $b8  ) (get_local $tmp8  )))
    (i64.store offset=72   (get_local $next_block) (i64.xor (get_local $b9  ) (get_local $tmp9  )))
    (i64.store offset=80   (get_local $next_block) (i64.xor (get_local $b10 ) (get_local $tmp10 )))
    (i64.store offset=88   (get_local $next_block) (i64.xor (get_local $b11 ) (get_local $tmp11 )))
    (i64.store offset=96   (get_local $next_block) (i64.xor (get_local $b12 ) (get_local $tmp12 )))
    (i64.store offset=104  (get_local $next_block) (i64.xor (get_local $b13 ) (get_local $tmp13 )))
    (i64.store offset=112  (get_local $next_block) (i64.xor (get_local $b14 ) (get_local $tmp14 )))
    (i64.store offset=120  (get_local $next_block) (i64.xor (get_local $b15 ) (get_local $tmp15 )))
    (i64.store offset=128  (get_local $next_block) (i64.xor (get_local $b16 ) (get_local $tmp16 )))
    (i64.store offset=136  (get_local $next_block) (i64.xor (get_local $b17 ) (get_local $tmp17 )))
    (i64.store offset=144  (get_local $next_block) (i64.xor (get_local $b18 ) (get_local $tmp18 )))
    (i64.store offset=152  (get_local $next_block) (i64.xor (get_local $b19 ) (get_local $tmp19 )))
    (i64.store offset=160  (get_local $next_block) (i64.xor (get_local $b20 ) (get_local $tmp20 )))
    (i64.store offset=168  (get_local $next_block) (i64.xor (get_local $b21 ) (get_local $tmp21 )))
    (i64.store offset=176  (get_local $next_block) (i64.xor (get_local $b22 ) (get_local $tmp22 )))
    (i64.store offset=184  (get_local $next_block) (i64.xor (get_local $b23 ) (get_local $tmp23 )))
    (i64.store offset=192  (get_local $next_block) (i64.xor (get_local $b24 ) (get_local $tmp24 )))
    (i64.store offset=200  (get_local $next_block) (i64.xor (get_local $b25 ) (get_local $tmp25 )))
    (i64.store offset=208  (get_local $next_block) (i64.xor (get_local $b26 ) (get_local $tmp26 )))
    (i64.store offset=216  (get_local $next_block) (i64.xor (get_local $b27 ) (get_local $tmp27 )))
    (i64.store offset=224  (get_local $next_block) (i64.xor (get_local $b28 ) (get_local $tmp28 )))
    (i64.store offset=232  (get_local $next_block) (i64.xor (get_local $b29 ) (get_local $tmp29 )))
    (i64.store offset=240  (get_local $next_block) (i64.xor (get_local $b30 ) (get_local $tmp30 )))
    (i64.store offset=248  (get_local $next_block) (i64.xor (get_local $b31 ) (get_local $tmp31 )))
    (i64.store offset=256  (get_local $next_block) (i64.xor (get_local $b32 ) (get_local $tmp32 )))
    (i64.store offset=264  (get_local $next_block) (i64.xor (get_local $b33 ) (get_local $tmp33 )))
    (i64.store offset=272  (get_local $next_block) (i64.xor (get_local $b34 ) (get_local $tmp34 )))
    (i64.store offset=280  (get_local $next_block) (i64.xor (get_local $b35 ) (get_local $tmp35 )))
    (i64.store offset=288  (get_local $next_block) (i64.xor (get_local $b36 ) (get_local $tmp36 )))
    (i64.store offset=296  (get_local $next_block) (i64.xor (get_local $b37 ) (get_local $tmp37 )))
    (i64.store offset=304  (get_local $next_block) (i64.xor (get_local $b38 ) (get_local $tmp38 )))
    (i64.store offset=312  (get_local $next_block) (i64.xor (get_local $b39 ) (get_local $tmp39 )))
    (i64.store offset=320  (get_local $next_block) (i64.xor (get_local $b40 ) (get_local $tmp40 )))
    (i64.store offset=328  (get_local $next_block) (i64.xor (get_local $b41 ) (get_local $tmp41 )))
    (i64.store offset=336  (get_local $next_block) (i64.xor (get_local $b42 ) (get_local $tmp42 )))
    (i64.store offset=344  (get_local $next_block) (i64.xor (get_local $b43 ) (get_local $tmp43 )))
    (i64.store offset=352  (get_local $next_block) (i64.xor (get_local $b44 ) (get_local $tmp44 )))
    (i64.store offset=360  (get_local $next_block) (i64.xor (get_local $b45 ) (get_local $tmp45 )))
    (i64.store offset=368  (get_local $next_block) (i64.xor (get_local $b46 ) (get_local $tmp46 )))
    (i64.store offset=376  (get_local $next_block) (i64.xor (get_local $b47 ) (get_local $tmp47 )))
    (i64.store offset=384  (get_local $next_block) (i64.xor (get_local $b48 ) (get_local $tmp48 )))
    (i64.store offset=392  (get_local $next_block) (i64.xor (get_local $b49 ) (get_local $tmp49 )))
    (i64.store offset=400  (get_local $next_block) (i64.xor (get_local $b50 ) (get_local $tmp50 )))
    (i64.store offset=408  (get_local $next_block) (i64.xor (get_local $b51 ) (get_local $tmp51 )))
    (i64.store offset=416  (get_local $next_block) (i64.xor (get_local $b52 ) (get_local $tmp52 )))
    (i64.store offset=424  (get_local $next_block) (i64.xor (get_local $b53 ) (get_local $tmp53 )))
    (i64.store offset=432  (get_local $next_block) (i64.xor (get_local $b54 ) (get_local $tmp54 )))
    (i64.store offset=440  (get_local $next_block) (i64.xor (get_local $b55 ) (get_local $tmp55 )))
    (i64.store offset=448  (get_local $next_block) (i64.xor (get_local $b56 ) (get_local $tmp56 )))
    (i64.store offset=456  (get_local $next_block) (i64.xor (get_local $b57 ) (get_local $tmp57 )))
    (i64.store offset=464  (get_local $next_block) (i64.xor (get_local $b58 ) (get_local $tmp58 )))
    (i64.store offset=472  (get_local $next_block) (i64.xor (get_local $b59 ) (get_local $tmp59 )))
    (i64.store offset=480  (get_local $next_block) (i64.xor (get_local $b60 ) (get_local $tmp60 )))
    (i64.store offset=488  (get_local $next_block) (i64.xor (get_local $b61 ) (get_local $tmp61 )))
    (i64.store offset=496  (get_local $next_block) (i64.xor (get_local $b62 ) (get_local $tmp62 )))
    (i64.store offset=504  (get_local $next_block) (i64.xor (get_local $b63 ) (get_local $tmp63 )))
    (i64.store offset=512  (get_local $next_block) (i64.xor (get_local $b64 ) (get_local $tmp64 )))
    (i64.store offset=520  (get_local $next_block) (i64.xor (get_local $b65 ) (get_local $tmp65 )))
    (i64.store offset=528  (get_local $next_block) (i64.xor (get_local $b66 ) (get_local $tmp66 )))
    (i64.store offset=536  (get_local $next_block) (i64.xor (get_local $b67 ) (get_local $tmp67 )))
    (i64.store offset=544  (get_local $next_block) (i64.xor (get_local $b68 ) (get_local $tmp68 )))
    (i64.store offset=552  (get_local $next_block) (i64.xor (get_local $b69 ) (get_local $tmp69 )))
    (i64.store offset=560  (get_local $next_block) (i64.xor (get_local $b70 ) (get_local $tmp70 )))
    (i64.store offset=568  (get_local $next_block) (i64.xor (get_local $b71 ) (get_local $tmp71 )))
    (i64.store offset=576  (get_local $next_block) (i64.xor (get_local $b72 ) (get_local $tmp72 )))
    (i64.store offset=584  (get_local $next_block) (i64.xor (get_local $b73 ) (get_local $tmp73 )))
    (i64.store offset=592  (get_local $next_block) (i64.xor (get_local $b74 ) (get_local $tmp74 )))
    (i64.store offset=600  (get_local $next_block) (i64.xor (get_local $b75 ) (get_local $tmp75 )))
    (i64.store offset=608  (get_local $next_block) (i64.xor (get_local $b76 ) (get_local $tmp76 )))
    (i64.store offset=616  (get_local $next_block) (i64.xor (get_local $b77 ) (get_local $tmp77 )))
    (i64.store offset=624  (get_local $next_block) (i64.xor (get_local $b78 ) (get_local $tmp78 )))
    (i64.store offset=632  (get_local $next_block) (i64.xor (get_local $b79 ) (get_local $tmp79 )))
    (i64.store offset=640  (get_local $next_block) (i64.xor (get_local $b80 ) (get_local $tmp80 )))
    (i64.store offset=648  (get_local $next_block) (i64.xor (get_local $b81 ) (get_local $tmp81 )))
    (i64.store offset=656  (get_local $next_block) (i64.xor (get_local $b82 ) (get_local $tmp82 )))
    (i64.store offset=664  (get_local $next_block) (i64.xor (get_local $b83 ) (get_local $tmp83 )))
    (i64.store offset=672  (get_local $next_block) (i64.xor (get_local $b84 ) (get_local $tmp84 )))
    (i64.store offset=680  (get_local $next_block) (i64.xor (get_local $b85 ) (get_local $tmp85 )))
    (i64.store offset=688  (get_local $next_block) (i64.xor (get_local $b86 ) (get_local $tmp86 )))
    (i64.store offset=696  (get_local $next_block) (i64.xor (get_local $b87 ) (get_local $tmp87 )))
    (i64.store offset=704  (get_local $next_block) (i64.xor (get_local $b88 ) (get_local $tmp88 )))
    (i64.store offset=712  (get_local $next_block) (i64.xor (get_local $b89 ) (get_local $tmp89 )))
    (i64.store offset=720  (get_local $next_block) (i64.xor (get_local $b90 ) (get_local $tmp90 )))
    (i64.store offset=728  (get_local $next_block) (i64.xor (get_local $b91 ) (get_local $tmp91 )))
    (i64.store offset=736  (get_local $next_block) (i64.xor (get_local $b92 ) (get_local $tmp92 )))
    (i64.store offset=744  (get_local $next_block) (i64.xor (get_local $b93 ) (get_local $tmp93 )))
    (i64.store offset=752  (get_local $next_block) (i64.xor (get_local $b94 ) (get_local $tmp94 )))
    (i64.store offset=760  (get_local $next_block) (i64.xor (get_local $b95 ) (get_local $tmp95 )))
    (i64.store offset=768  (get_local $next_block) (i64.xor (get_local $b96 ) (get_local $tmp96 )))
    (i64.store offset=776  (get_local $next_block) (i64.xor (get_local $b97 ) (get_local $tmp97 )))
    (i64.store offset=784  (get_local $next_block) (i64.xor (get_local $b98 ) (get_local $tmp98 )))
    (i64.store offset=792  (get_local $next_block) (i64.xor (get_local $b99 ) (get_local $tmp99 )))
    (i64.store offset=800  (get_local $next_block) (i64.xor (get_local $b100) (get_local $tmp100)))
    (i64.store offset=808  (get_local $next_block) (i64.xor (get_local $b101) (get_local $tmp101)))
    (i64.store offset=816  (get_local $next_block) (i64.xor (get_local $b102) (get_local $tmp102)))
    (i64.store offset=824  (get_local $next_block) (i64.xor (get_local $b103) (get_local $tmp103)))
    (i64.store offset=832  (get_local $next_block) (i64.xor (get_local $b104) (get_local $tmp104)))
    (i64.store offset=840  (get_local $next_block) (i64.xor (get_local $b105) (get_local $tmp105)))
    (i64.store offset=848  (get_local $next_block) (i64.xor (get_local $b106) (get_local $tmp106)))
    (i64.store offset=856  (get_local $next_block) (i64.xor (get_local $b107) (get_local $tmp107)))
    (i64.store offset=864  (get_local $next_block) (i64.xor (get_local $b108) (get_local $tmp108)))
    (i64.store offset=872  (get_local $next_block) (i64.xor (get_local $b109) (get_local $tmp109)))
    (i64.store offset=880  (get_local $next_block) (i64.xor (get_local $b110) (get_local $tmp110)))
    (i64.store offset=888  (get_local $next_block) (i64.xor (get_local $b111) (get_local $tmp111)))
    (i64.store offset=896  (get_local $next_block) (i64.xor (get_local $b112) (get_local $tmp112)))
    (i64.store offset=904  (get_local $next_block) (i64.xor (get_local $b113) (get_local $tmp113)))
    (i64.store offset=912  (get_local $next_block) (i64.xor (get_local $b114) (get_local $tmp114)))
    (i64.store offset=920  (get_local $next_block) (i64.xor (get_local $b115) (get_local $tmp115)))
    (i64.store offset=928  (get_local $next_block) (i64.xor (get_local $b116) (get_local $tmp116)))
    (i64.store offset=936  (get_local $next_block) (i64.xor (get_local $b117) (get_local $tmp117)))
    (i64.store offset=944  (get_local $next_block) (i64.xor (get_local $b118) (get_local $tmp118)))
    (i64.store offset=952  (get_local $next_block) (i64.xor (get_local $b119) (get_local $tmp119)))
    (i64.store offset=960  (get_local $next_block) (i64.xor (get_local $b120) (get_local $tmp120)))
    (i64.store offset=968  (get_local $next_block) (i64.xor (get_local $b121) (get_local $tmp121)))
    (i64.store offset=976  (get_local $next_block) (i64.xor (get_local $b122) (get_local $tmp122)))
    (i64.store offset=984  (get_local $next_block) (i64.xor (get_local $b123) (get_local $tmp123)))
    (i64.store offset=992  (get_local $next_block) (i64.xor (get_local $b124) (get_local $tmp124)))
    (i64.store offset=1000 (get_local $next_block) (i64.xor (get_local $b125) (get_local $tmp125)))
    (i64.store offset=1008 (get_local $next_block) (i64.xor (get_local $b126) (get_local $tmp126)))
    (i64.store offset=1016 (get_local $next_block) (i64.xor (get_local $b127) (get_local $tmp127))))
  
  (func $G (param $a i64) (param $b i64) (param $c i64) (param $d i64)
    (local $tmp i64)

    (set_local $tmp (i64.mul (i64.const 2) (i64.add (i64.xor (get_local $a) (i64.const 0xffffffff)) (i64.xor (get_local $b) (i64.const 0xffffffff)))))

    (set_local $a (i64.add (get_local $a) (i64.add (get_local $b) (get_local $tmp))))
    (set_local $d (i64.rotr (i64.xor (get_local $d) (get_local $a)) (i64.const 32)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.add (i64.xor (get_local $c) (i64.const 0xffffffff)) (i64.xor (get_local $d) (i64.const 0xffffffff)))))

    (set_local $c (i64.add (get_local $c) (i64.add (get_local $d) (get_local $tmp))))
    (set_local $b (i64.rotr (i64.xor (get_local $b) (get_local $c)) (i64.const 24)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.add (i64.xor (get_local $a) (i64.const 0xffffffff)) (i64.xor (get_local $b) (i64.const 0xffffffff)))))

    (set_local $a (i64.add (get_local $a) (i64.add (get_local $b) (get_local $tmp))))
    (set_local $d (i64.rotr (i64.xor (get_local $d) (get_local $a)) (i64.const 16)))

    (set_local $tmp (i64.mul (i64.const 2) (i64.add (i64.xor (get_local $c) (i64.const 0xffffffff)) (i64.xor (get_local $d) (i64.const 0xffffffff)))))

    (set_local $c (i64.add (get_local $c) (i64.add (get_local $d) (get_local $tmp))))
    (set_local $b (i64.rotr (i64.xor (get_local $b) (get_local $c)) (i64.const 63)))

    (set_global $register0 (get_local $a))
    (set_global $register1 (get_local $b))
    (set_global $register2 (get_local $c))
    (set_global $register3 (get_local $d)))

  (func $blake2b_compress (export "blake2b_compress") (param $ctx i32)
    (local $v0 i64)
    (local $v1 i64)
    (local $v2 i64)
    (local $v3 i64)
    (local $v4 i64)
    (local $v5 i64)
    (local $v6 i64)
    (local $v7 i64)
    (local $v8 i64)
    (local $v9 i64)
    (local $v10 i64)
    (local $v11 i64)
    (local $v12 i64)
    (local $v13 i64)
    (local $v14 i64)
    (local $v15 i64)

    (local $m0 i64)
    (local $m1 i64)
    (local $m2 i64)
    (local $m3 i64)
    (local $m4 i64)
    (local $m5 i64)
    (local $m6 i64)
    (local $m7 i64)
    (local $m8 i64)
    (local $m9 i64)
    (local $m10 i64)
    (local $m11 i64)
    (local $m12 i64)
    (local $m13 i64)
    (local $m14 i64)
    (local $m15 i64)

    (local $h0 i32)
    (local $h1 i32)
    (local $h2 i32)
    (local $h3 i32)
    (local $h4 i32)
    (local $h5 i32)
    (local $h6 i32)
    (local $h7 i32)
    (local $h8 i32)

    ;; set h ptrs
    (set_local $h0 (i32.add (get_local $ctx) (i32.const 128)))
    (set_local $h1 (i32.add (get_local $ctx) (i32.const 136)))
    (set_local $h2 (i32.add (get_local $ctx) (i32.const 144)))
    (set_local $h3 (i32.add (get_local $ctx) (i32.const 152)))
    (set_local $h4 (i32.add (get_local $ctx) (i32.const 160)))
    (set_local $h5 (i32.add (get_local $ctx) (i32.const 168)))
    (set_local $h6 (i32.add (get_local $ctx) (i32.const 176)))
    (set_local $h7 (i32.add (get_local $ctx) (i32.const 184)))

    ;; set v[0-8] to ctx.h[0-8]
    (set_local $v0 (i64.load (get_local $h0)))
    (set_local $v1 (i64.load (get_local $h1)))
    (set_local $v2 (i64.load (get_local $h2)))
    (set_local $v3 (i64.load (get_local $h3)))
    (set_local $v4 (i64.load (get_local $h4)))
    (set_local $v5 (i64.load (get_local $h5)))
    (set_local $v6 (i64.load (get_local $h6)))
    (set_local $v7 (i64.load (get_local $h7)))

    ;; set v[8-16] to init vectors
    (set_local $v8 (i64.const 0x6a09e667f3bcc908))
    (set_local $v9 (i64.const 0xbb67ae8584caa73b))
    (set_local $v10 (i64.const 0x3c6ef372fe94f82b))
    (set_local $v11 (i64.const 0xa54ff53a5f1d36f1))
    (set_local $v12 (i64.const 0x510e527fade682d1))
    (set_local $v13 (i64.const 0x9b05688c2b3e6c1f))
    (set_local $v14 (i64.const 0x1f83d9abfb41bd6b))
    (set_local $v15 (i64.const 0x5be0cd19137e2179))

    ;; set m[0-16] to ctx[0-128]
    (set_local $m0 (i64.load offset=0 (get_local $ctx)))
    (set_local $m1 (i64.load offset=8 (get_local $ctx)))
    (set_local $m2 (i64.load offset=16 (get_local $ctx)))
    (set_local $m3 (i64.load offset=24 (get_local $ctx)))
    (set_local $m4 (i64.load offset=32 (get_local $ctx)))
    (set_local $m5 (i64.load offset=40 (get_local $ctx)))
    (set_local $m6 (i64.load offset=48 (get_local $ctx)))
    (set_local $m7 (i64.load offset=56 (get_local $ctx)))
    (set_local $m8 (i64.load offset=64 (get_local $ctx)))
    (set_local $m9 (i64.load offset=72 (get_local $ctx)))
    (set_local $m10 (i64.load offset=80 (get_local $ctx)))
    (set_local $m11 (i64.load offset=88 (get_local $ctx)))
    (set_local $m12 (i64.load offset=96 (get_local $ctx)))
    (set_local $m13 (i64.load offset=104 (get_local $ctx)))
    (set_local $m14 (i64.load offset=112 (get_local $ctx)))
    (set_local $m15 (i64.load offset=120 (get_local $ctx)))

    ;; v12 = v12 ^ ctx.t
    (set_local $v12
      (i64.xor
        (get_local $v12)
        (i64.load offset=192 (get_local $ctx))
      )
    )

    ;; v14 = v14 ^ ctx.f
    (set_local $v14
      (i64.xor
        (get_local $v14)
        (i64.load  offset=208 (get_local $ctx))
      )
    )

    ;; ROUNDS GENERATED BY `node generate-rounds.js`

    ;; ROUND(0)

    ;; G(0, 0)

    ;; $v0 = $v0 + $v4 + $m0
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m0))))

    ;; $v12 = rotr64($v12 ^ $v0, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 32)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 24)))

    ;; $v0 = $v0 + $v4 + $m1
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m1))))

    ;; $v12 = rotr64($v12 ^ $v0, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 16)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 63)))

    ;; G(0, 1)

    ;; $v1 = $v1 + $v5 + $m2
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m2))))

    ;; $v13 = rotr64($v13 ^ $v1, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 32)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 24)))

    ;; $v1 = $v1 + $v5 + $m3
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m3))))

    ;; $v13 = rotr64($v13 ^ $v1, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 16)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 63)))

    ;; G(0, 2)

    ;; $v2 = $v2 + $v6 + $m4
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m4))))

    ;; $v14 = rotr64($v14 ^ $v2, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 32)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 24)))

    ;; $v2 = $v2 + $v6 + $m5
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m5))))

    ;; $v14 = rotr64($v14 ^ $v2, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 16)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 63)))

    ;; G(0, 3)

    ;; $v3 = $v3 + $v7 + $m6
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m6))))

    ;; $v15 = rotr64($v15 ^ $v3, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 32)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 24)))

    ;; $v3 = $v3 + $v7 + $m7
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m7))))

    ;; $v15 = rotr64($v15 ^ $v3, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 16)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 63)))

    ;; G(0, 4)

    ;; $v0 = $v0 + $v5 + $m8
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m8))))

    ;; $v15 = rotr64($v15 ^ $v0, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 32)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 24)))

    ;; $v0 = $v0 + $v5 + $m9
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m9))))

    ;; $v15 = rotr64($v15 ^ $v0, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 16)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 63)))

    ;; G(0, 5)

    ;; $v1 = $v1 + $v6 + $m10
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m10))))

    ;; $v12 = rotr64($v12 ^ $v1, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 32)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 24)))

    ;; $v1 = $v1 + $v6 + $m11
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m11))))

    ;; $v12 = rotr64($v12 ^ $v1, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 16)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 63)))

    ;; G(0, 6)

    ;; $v2 = $v2 + $v7 + $m12
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m12))))

    ;; $v13 = rotr64($v13 ^ $v2, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 32)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 24)))

    ;; $v2 = $v2 + $v7 + $m13
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m13))))

    ;; $v13 = rotr64($v13 ^ $v2, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 16)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 63)))

    ;; G(0, 7)

    ;; $v3 = $v3 + $v4 + $m14
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m14))))

    ;; $v14 = rotr64($v14 ^ $v3, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 32)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 24)))

    ;; $v3 = $v3 + $v4 + $m15
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m15))))

    ;; $v14 = rotr64($v14 ^ $v3, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 16)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 63)))

    ;; ROUND(1)

    ;; G(1, 0)

    ;; $v0 = $v0 + $v4 + $m14
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m14))))

    ;; $v12 = rotr64($v12 ^ $v0, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 32)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 24)))

    ;; $v0 = $v0 + $v4 + $m10
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m10))))

    ;; $v12 = rotr64($v12 ^ $v0, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 16)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 63)))

    ;; G(1, 1)

    ;; $v1 = $v1 + $v5 + $m4
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m4))))

    ;; $v13 = rotr64($v13 ^ $v1, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 32)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 24)))

    ;; $v1 = $v1 + $v5 + $m8
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m8))))

    ;; $v13 = rotr64($v13 ^ $v1, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 16)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 63)))

    ;; G(1, 2)

    ;; $v2 = $v2 + $v6 + $m9
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m9))))

    ;; $v14 = rotr64($v14 ^ $v2, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 32)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 24)))

    ;; $v2 = $v2 + $v6 + $m15
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m15))))

    ;; $v14 = rotr64($v14 ^ $v2, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 16)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 63)))

    ;; G(1, 3)

    ;; $v3 = $v3 + $v7 + $m13
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m13))))

    ;; $v15 = rotr64($v15 ^ $v3, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 32)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 24)))

    ;; $v3 = $v3 + $v7 + $m6
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m6))))

    ;; $v15 = rotr64($v15 ^ $v3, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 16)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 63)))

    ;; G(1, 4)

    ;; $v0 = $v0 + $v5 + $m1
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m1))))

    ;; $v15 = rotr64($v15 ^ $v0, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 32)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 24)))

    ;; $v0 = $v0 + $v5 + $m12
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m12))))

    ;; $v15 = rotr64($v15 ^ $v0, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 16)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 63)))

    ;; G(1, 5)

    ;; $v1 = $v1 + $v6 + $m0
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m0))))

    ;; $v12 = rotr64($v12 ^ $v1, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 32)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 24)))

    ;; $v1 = $v1 + $v6 + $m2
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m2))))

    ;; $v12 = rotr64($v12 ^ $v1, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 16)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 63)))

    ;; G(1, 6)

    ;; $v2 = $v2 + $v7 + $m11
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m11))))

    ;; $v13 = rotr64($v13 ^ $v2, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 32)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 24)))

    ;; $v2 = $v2 + $v7 + $m7
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m7))))

    ;; $v13 = rotr64($v13 ^ $v2, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 16)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 63)))

    ;; G(1, 7)

    ;; $v3 = $v3 + $v4 + $m5
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m5))))

    ;; $v14 = rotr64($v14 ^ $v3, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 32)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 24)))

    ;; $v3 = $v3 + $v4 + $m3
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m3))))

    ;; $v14 = rotr64($v14 ^ $v3, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 16)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 63)))

    ;; ROUND(2)

    ;; G(2, 0)

    ;; $v0 = $v0 + $v4 + $m11
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m11))))

    ;; $v12 = rotr64($v12 ^ $v0, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 32)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 24)))

    ;; $v0 = $v0 + $v4 + $m8
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m8))))

    ;; $v12 = rotr64($v12 ^ $v0, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 16)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 63)))

    ;; G(2, 1)

    ;; $v1 = $v1 + $v5 + $m12
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m12))))

    ;; $v13 = rotr64($v13 ^ $v1, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 32)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 24)))

    ;; $v1 = $v1 + $v5 + $m0
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m0))))

    ;; $v13 = rotr64($v13 ^ $v1, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 16)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 63)))

    ;; G(2, 2)

    ;; $v2 = $v2 + $v6 + $m5
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m5))))

    ;; $v14 = rotr64($v14 ^ $v2, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 32)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 24)))

    ;; $v2 = $v2 + $v6 + $m2
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m2))))

    ;; $v14 = rotr64($v14 ^ $v2, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 16)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 63)))

    ;; G(2, 3)

    ;; $v3 = $v3 + $v7 + $m15
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m15))))

    ;; $v15 = rotr64($v15 ^ $v3, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 32)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 24)))

    ;; $v3 = $v3 + $v7 + $m13
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m13))))

    ;; $v15 = rotr64($v15 ^ $v3, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 16)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 63)))

    ;; G(2, 4)

    ;; $v0 = $v0 + $v5 + $m10
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m10))))

    ;; $v15 = rotr64($v15 ^ $v0, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 32)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 24)))

    ;; $v0 = $v0 + $v5 + $m14
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m14))))

    ;; $v15 = rotr64($v15 ^ $v0, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 16)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 63)))

    ;; G(2, 5)

    ;; $v1 = $v1 + $v6 + $m3
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m3))))

    ;; $v12 = rotr64($v12 ^ $v1, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 32)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 24)))

    ;; $v1 = $v1 + $v6 + $m6
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m6))))

    ;; $v12 = rotr64($v12 ^ $v1, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 16)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 63)))

    ;; G(2, 6)

    ;; $v2 = $v2 + $v7 + $m7
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m7))))

    ;; $v13 = rotr64($v13 ^ $v2, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 32)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 24)))

    ;; $v2 = $v2 + $v7 + $m1
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m1))))

    ;; $v13 = rotr64($v13 ^ $v2, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 16)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 63)))

    ;; G(2, 7)

    ;; $v3 = $v3 + $v4 + $m9
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m9))))

    ;; $v14 = rotr64($v14 ^ $v3, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 32)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 24)))

    ;; $v3 = $v3 + $v4 + $m4
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m4))))

    ;; $v14 = rotr64($v14 ^ $v3, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 16)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 63)))

    ;; ROUND(3)

    ;; G(3, 0)

    ;; $v0 = $v0 + $v4 + $m7
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m7))))

    ;; $v12 = rotr64($v12 ^ $v0, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 32)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 24)))

    ;; $v0 = $v0 + $v4 + $m9
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m9))))

    ;; $v12 = rotr64($v12 ^ $v0, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 16)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 63)))

    ;; G(3, 1)

    ;; $v1 = $v1 + $v5 + $m3
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m3))))

    ;; $v13 = rotr64($v13 ^ $v1, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 32)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 24)))

    ;; $v1 = $v1 + $v5 + $m1
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m1))))

    ;; $v13 = rotr64($v13 ^ $v1, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 16)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 63)))

    ;; G(3, 2)

    ;; $v2 = $v2 + $v6 + $m13
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m13))))

    ;; $v14 = rotr64($v14 ^ $v2, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 32)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 24)))

    ;; $v2 = $v2 + $v6 + $m12
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m12))))

    ;; $v14 = rotr64($v14 ^ $v2, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 16)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 63)))

    ;; G(3, 3)

    ;; $v3 = $v3 + $v7 + $m11
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m11))))

    ;; $v15 = rotr64($v15 ^ $v3, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 32)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 24)))

    ;; $v3 = $v3 + $v7 + $m14
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m14))))

    ;; $v15 = rotr64($v15 ^ $v3, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 16)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 63)))

    ;; G(3, 4)

    ;; $v0 = $v0 + $v5 + $m2
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m2))))

    ;; $v15 = rotr64($v15 ^ $v0, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 32)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 24)))

    ;; $v0 = $v0 + $v5 + $m6
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m6))))

    ;; $v15 = rotr64($v15 ^ $v0, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 16)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 63)))

    ;; G(3, 5)

    ;; $v1 = $v1 + $v6 + $m5
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m5))))

    ;; $v12 = rotr64($v12 ^ $v1, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 32)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 24)))

    ;; $v1 = $v1 + $v6 + $m10
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m10))))

    ;; $v12 = rotr64($v12 ^ $v1, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 16)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 63)))

    ;; G(3, 6)

    ;; $v2 = $v2 + $v7 + $m4
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m4))))

    ;; $v13 = rotr64($v13 ^ $v2, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 32)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 24)))

    ;; $v2 = $v2 + $v7 + $m0
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m0))))

    ;; $v13 = rotr64($v13 ^ $v2, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 16)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 63)))

    ;; G(3, 7)

    ;; $v3 = $v3 + $v4 + $m15
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m15))))

    ;; $v14 = rotr64($v14 ^ $v3, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 32)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 24)))

    ;; $v3 = $v3 + $v4 + $m8
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m8))))

    ;; $v14 = rotr64($v14 ^ $v3, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 16)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 63)))

    ;; ROUND(4)

    ;; G(4, 0)

    ;; $v0 = $v0 + $v4 + $m9
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m9))))

    ;; $v12 = rotr64($v12 ^ $v0, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 32)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 24)))

    ;; $v0 = $v0 + $v4 + $m0
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m0))))

    ;; $v12 = rotr64($v12 ^ $v0, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 16)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 63)))

    ;; G(4, 1)

    ;; $v1 = $v1 + $v5 + $m5
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m5))))

    ;; $v13 = rotr64($v13 ^ $v1, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 32)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 24)))

    ;; $v1 = $v1 + $v5 + $m7
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m7))))

    ;; $v13 = rotr64($v13 ^ $v1, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 16)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 63)))

    ;; G(4, 2)

    ;; $v2 = $v2 + $v6 + $m2
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m2))))

    ;; $v14 = rotr64($v14 ^ $v2, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 32)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 24)))

    ;; $v2 = $v2 + $v6 + $m4
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m4))))

    ;; $v14 = rotr64($v14 ^ $v2, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 16)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 63)))

    ;; G(4, 3)

    ;; $v3 = $v3 + $v7 + $m10
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m10))))

    ;; $v15 = rotr64($v15 ^ $v3, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 32)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 24)))

    ;; $v3 = $v3 + $v7 + $m15
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m15))))

    ;; $v15 = rotr64($v15 ^ $v3, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 16)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 63)))

    ;; G(4, 4)

    ;; $v0 = $v0 + $v5 + $m14
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m14))))

    ;; $v15 = rotr64($v15 ^ $v0, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 32)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 24)))

    ;; $v0 = $v0 + $v5 + $m1
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m1))))

    ;; $v15 = rotr64($v15 ^ $v0, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 16)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 63)))

    ;; G(4, 5)

    ;; $v1 = $v1 + $v6 + $m11
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m11))))

    ;; $v12 = rotr64($v12 ^ $v1, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 32)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 24)))

    ;; $v1 = $v1 + $v6 + $m12
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m12))))

    ;; $v12 = rotr64($v12 ^ $v1, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 16)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 63)))

    ;; G(4, 6)

    ;; $v2 = $v2 + $v7 + $m6
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m6))))

    ;; $v13 = rotr64($v13 ^ $v2, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 32)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 24)))

    ;; $v2 = $v2 + $v7 + $m8
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m8))))

    ;; $v13 = rotr64($v13 ^ $v2, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 16)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 63)))

    ;; G(4, 7)

    ;; $v3 = $v3 + $v4 + $m3
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m3))))

    ;; $v14 = rotr64($v14 ^ $v3, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 32)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 24)))

    ;; $v3 = $v3 + $v4 + $m13
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m13))))

    ;; $v14 = rotr64($v14 ^ $v3, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 16)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 63)))

    ;; ROUND(5)

    ;; G(5, 0)

    ;; $v0 = $v0 + $v4 + $m2
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m2))))

    ;; $v12 = rotr64($v12 ^ $v0, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 32)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 24)))

    ;; $v0 = $v0 + $v4 + $m12
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m12))))

    ;; $v12 = rotr64($v12 ^ $v0, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 16)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 63)))

    ;; G(5, 1)

    ;; $v1 = $v1 + $v5 + $m6
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m6))))

    ;; $v13 = rotr64($v13 ^ $v1, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 32)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 24)))

    ;; $v1 = $v1 + $v5 + $m10
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m10))))

    ;; $v13 = rotr64($v13 ^ $v1, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 16)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 63)))

    ;; G(5, 2)

    ;; $v2 = $v2 + $v6 + $m0
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m0))))

    ;; $v14 = rotr64($v14 ^ $v2, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 32)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 24)))

    ;; $v2 = $v2 + $v6 + $m11
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m11))))

    ;; $v14 = rotr64($v14 ^ $v2, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 16)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 63)))

    ;; G(5, 3)

    ;; $v3 = $v3 + $v7 + $m8
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m8))))

    ;; $v15 = rotr64($v15 ^ $v3, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 32)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 24)))

    ;; $v3 = $v3 + $v7 + $m3
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m3))))

    ;; $v15 = rotr64($v15 ^ $v3, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 16)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 63)))

    ;; G(5, 4)

    ;; $v0 = $v0 + $v5 + $m4
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m4))))

    ;; $v15 = rotr64($v15 ^ $v0, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 32)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 24)))

    ;; $v0 = $v0 + $v5 + $m13
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m13))))

    ;; $v15 = rotr64($v15 ^ $v0, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 16)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 63)))

    ;; G(5, 5)

    ;; $v1 = $v1 + $v6 + $m7
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m7))))

    ;; $v12 = rotr64($v12 ^ $v1, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 32)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 24)))

    ;; $v1 = $v1 + $v6 + $m5
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m5))))

    ;; $v12 = rotr64($v12 ^ $v1, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 16)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 63)))

    ;; G(5, 6)

    ;; $v2 = $v2 + $v7 + $m15
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m15))))

    ;; $v13 = rotr64($v13 ^ $v2, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 32)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 24)))

    ;; $v2 = $v2 + $v7 + $m14
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m14))))

    ;; $v13 = rotr64($v13 ^ $v2, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 16)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 63)))

    ;; G(5, 7)

    ;; $v3 = $v3 + $v4 + $m1
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m1))))

    ;; $v14 = rotr64($v14 ^ $v3, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 32)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 24)))

    ;; $v3 = $v3 + $v4 + $m9
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m9))))

    ;; $v14 = rotr64($v14 ^ $v3, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 16)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 63)))

    ;; ROUND(6)

    ;; G(6, 0)

    ;; $v0 = $v0 + $v4 + $m12
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m12))))

    ;; $v12 = rotr64($v12 ^ $v0, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 32)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 24)))

    ;; $v0 = $v0 + $v4 + $m5
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m5))))

    ;; $v12 = rotr64($v12 ^ $v0, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 16)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 63)))

    ;; G(6, 1)

    ;; $v1 = $v1 + $v5 + $m1
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m1))))

    ;; $v13 = rotr64($v13 ^ $v1, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 32)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 24)))

    ;; $v1 = $v1 + $v5 + $m15
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m15))))

    ;; $v13 = rotr64($v13 ^ $v1, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 16)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 63)))

    ;; G(6, 2)

    ;; $v2 = $v2 + $v6 + $m14
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m14))))

    ;; $v14 = rotr64($v14 ^ $v2, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 32)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 24)))

    ;; $v2 = $v2 + $v6 + $m13
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m13))))

    ;; $v14 = rotr64($v14 ^ $v2, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 16)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 63)))

    ;; G(6, 3)

    ;; $v3 = $v3 + $v7 + $m4
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m4))))

    ;; $v15 = rotr64($v15 ^ $v3, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 32)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 24)))

    ;; $v3 = $v3 + $v7 + $m10
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m10))))

    ;; $v15 = rotr64($v15 ^ $v3, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 16)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 63)))

    ;; G(6, 4)

    ;; $v0 = $v0 + $v5 + $m0
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m0))))

    ;; $v15 = rotr64($v15 ^ $v0, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 32)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 24)))

    ;; $v0 = $v0 + $v5 + $m7
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m7))))

    ;; $v15 = rotr64($v15 ^ $v0, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 16)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 63)))

    ;; G(6, 5)

    ;; $v1 = $v1 + $v6 + $m6
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m6))))

    ;; $v12 = rotr64($v12 ^ $v1, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 32)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 24)))

    ;; $v1 = $v1 + $v6 + $m3
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m3))))

    ;; $v12 = rotr64($v12 ^ $v1, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 16)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 63)))

    ;; G(6, 6)

    ;; $v2 = $v2 + $v7 + $m9
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m9))))

    ;; $v13 = rotr64($v13 ^ $v2, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 32)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 24)))

    ;; $v2 = $v2 + $v7 + $m2
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m2))))

    ;; $v13 = rotr64($v13 ^ $v2, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 16)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 63)))

    ;; G(6, 7)

    ;; $v3 = $v3 + $v4 + $m8
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m8))))

    ;; $v14 = rotr64($v14 ^ $v3, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 32)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 24)))

    ;; $v3 = $v3 + $v4 + $m11
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m11))))

    ;; $v14 = rotr64($v14 ^ $v3, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 16)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 63)))

    ;; ROUND(7)

    ;; G(7, 0)

    ;; $v0 = $v0 + $v4 + $m13
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m13))))

    ;; $v12 = rotr64($v12 ^ $v0, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 32)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 24)))

    ;; $v0 = $v0 + $v4 + $m11
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m11))))

    ;; $v12 = rotr64($v12 ^ $v0, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 16)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 63)))

    ;; G(7, 1)

    ;; $v1 = $v1 + $v5 + $m7
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m7))))

    ;; $v13 = rotr64($v13 ^ $v1, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 32)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 24)))

    ;; $v1 = $v1 + $v5 + $m14
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m14))))

    ;; $v13 = rotr64($v13 ^ $v1, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 16)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 63)))

    ;; G(7, 2)

    ;; $v2 = $v2 + $v6 + $m12
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m12))))

    ;; $v14 = rotr64($v14 ^ $v2, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 32)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 24)))

    ;; $v2 = $v2 + $v6 + $m1
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m1))))

    ;; $v14 = rotr64($v14 ^ $v2, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 16)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 63)))

    ;; G(7, 3)

    ;; $v3 = $v3 + $v7 + $m3
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m3))))

    ;; $v15 = rotr64($v15 ^ $v3, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 32)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 24)))

    ;; $v3 = $v3 + $v7 + $m9
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m9))))

    ;; $v15 = rotr64($v15 ^ $v3, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 16)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 63)))

    ;; G(7, 4)

    ;; $v0 = $v0 + $v5 + $m5
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m5))))

    ;; $v15 = rotr64($v15 ^ $v0, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 32)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 24)))

    ;; $v0 = $v0 + $v5 + $m0
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m0))))

    ;; $v15 = rotr64($v15 ^ $v0, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 16)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 63)))

    ;; G(7, 5)

    ;; $v1 = $v1 + $v6 + $m15
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m15))))

    ;; $v12 = rotr64($v12 ^ $v1, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 32)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 24)))

    ;; $v1 = $v1 + $v6 + $m4
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m4))))

    ;; $v12 = rotr64($v12 ^ $v1, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 16)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 63)))

    ;; G(7, 6)

    ;; $v2 = $v2 + $v7 + $m8
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m8))))

    ;; $v13 = rotr64($v13 ^ $v2, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 32)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 24)))

    ;; $v2 = $v2 + $v7 + $m6
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m6))))

    ;; $v13 = rotr64($v13 ^ $v2, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 16)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 63)))

    ;; G(7, 7)

    ;; $v3 = $v3 + $v4 + $m2
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m2))))

    ;; $v14 = rotr64($v14 ^ $v3, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 32)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 24)))

    ;; $v3 = $v3 + $v4 + $m10
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m10))))

    ;; $v14 = rotr64($v14 ^ $v3, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 16)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 63)))

    ;; ROUND(8)

    ;; G(8, 0)

    ;; $v0 = $v0 + $v4 + $m6
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m6))))

    ;; $v12 = rotr64($v12 ^ $v0, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 32)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 24)))

    ;; $v0 = $v0 + $v4 + $m15
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m15))))

    ;; $v12 = rotr64($v12 ^ $v0, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 16)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 63)))

    ;; G(8, 1)

    ;; $v1 = $v1 + $v5 + $m14
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m14))))

    ;; $v13 = rotr64($v13 ^ $v1, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 32)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 24)))

    ;; $v1 = $v1 + $v5 + $m9
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m9))))

    ;; $v13 = rotr64($v13 ^ $v1, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 16)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 63)))

    ;; G(8, 2)

    ;; $v2 = $v2 + $v6 + $m11
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m11))))

    ;; $v14 = rotr64($v14 ^ $v2, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 32)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 24)))

    ;; $v2 = $v2 + $v6 + $m3
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m3))))

    ;; $v14 = rotr64($v14 ^ $v2, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 16)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 63)))

    ;; G(8, 3)

    ;; $v3 = $v3 + $v7 + $m0
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m0))))

    ;; $v15 = rotr64($v15 ^ $v3, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 32)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 24)))

    ;; $v3 = $v3 + $v7 + $m8
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m8))))

    ;; $v15 = rotr64($v15 ^ $v3, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 16)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 63)))

    ;; G(8, 4)

    ;; $v0 = $v0 + $v5 + $m12
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m12))))

    ;; $v15 = rotr64($v15 ^ $v0, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 32)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 24)))

    ;; $v0 = $v0 + $v5 + $m2
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m2))))

    ;; $v15 = rotr64($v15 ^ $v0, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 16)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 63)))

    ;; G(8, 5)

    ;; $v1 = $v1 + $v6 + $m13
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m13))))

    ;; $v12 = rotr64($v12 ^ $v1, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 32)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 24)))

    ;; $v1 = $v1 + $v6 + $m7
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m7))))

    ;; $v12 = rotr64($v12 ^ $v1, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 16)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 63)))

    ;; G(8, 6)

    ;; $v2 = $v2 + $v7 + $m1
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m1))))

    ;; $v13 = rotr64($v13 ^ $v2, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 32)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 24)))

    ;; $v2 = $v2 + $v7 + $m4
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m4))))

    ;; $v13 = rotr64($v13 ^ $v2, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 16)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 63)))

    ;; G(8, 7)

    ;; $v3 = $v3 + $v4 + $m10
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m10))))

    ;; $v14 = rotr64($v14 ^ $v3, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 32)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 24)))

    ;; $v3 = $v3 + $v4 + $m5
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m5))))

    ;; $v14 = rotr64($v14 ^ $v3, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 16)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 63)))

    ;; ROUND(9)

    ;; G(9, 0)

    ;; $v0 = $v0 + $v4 + $m10
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m10))))

    ;; $v12 = rotr64($v12 ^ $v0, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 32)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 24)))

    ;; $v0 = $v0 + $v4 + $m2
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m2))))

    ;; $v12 = rotr64($v12 ^ $v0, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 16)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 63)))

    ;; G(9, 1)

    ;; $v1 = $v1 + $v5 + $m8
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m8))))

    ;; $v13 = rotr64($v13 ^ $v1, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 32)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 24)))

    ;; $v1 = $v1 + $v5 + $m4
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m4))))

    ;; $v13 = rotr64($v13 ^ $v1, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 16)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 63)))

    ;; G(9, 2)

    ;; $v2 = $v2 + $v6 + $m7
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m7))))

    ;; $v14 = rotr64($v14 ^ $v2, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 32)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 24)))

    ;; $v2 = $v2 + $v6 + $m6
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m6))))

    ;; $v14 = rotr64($v14 ^ $v2, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 16)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 63)))

    ;; G(9, 3)

    ;; $v3 = $v3 + $v7 + $m1
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m1))))

    ;; $v15 = rotr64($v15 ^ $v3, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 32)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 24)))

    ;; $v3 = $v3 + $v7 + $m5
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m5))))

    ;; $v15 = rotr64($v15 ^ $v3, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 16)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 63)))

    ;; G(9, 4)

    ;; $v0 = $v0 + $v5 + $m15
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m15))))

    ;; $v15 = rotr64($v15 ^ $v0, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 32)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 24)))

    ;; $v0 = $v0 + $v5 + $m11
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m11))))

    ;; $v15 = rotr64($v15 ^ $v0, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 16)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 63)))

    ;; G(9, 5)

    ;; $v1 = $v1 + $v6 + $m9
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m9))))

    ;; $v12 = rotr64($v12 ^ $v1, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 32)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 24)))

    ;; $v1 = $v1 + $v6 + $m14
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m14))))

    ;; $v12 = rotr64($v12 ^ $v1, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 16)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 63)))

    ;; G(9, 6)

    ;; $v2 = $v2 + $v7 + $m3
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m3))))

    ;; $v13 = rotr64($v13 ^ $v2, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 32)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 24)))

    ;; $v2 = $v2 + $v7 + $m12
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m12))))

    ;; $v13 = rotr64($v13 ^ $v2, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 16)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 63)))

    ;; G(9, 7)

    ;; $v3 = $v3 + $v4 + $m13
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m13))))

    ;; $v14 = rotr64($v14 ^ $v3, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 32)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 24)))

    ;; $v3 = $v3 + $v4 + $m0
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m0))))

    ;; $v14 = rotr64($v14 ^ $v3, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 16)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 63)))

    ;; ROUND(10)

    ;; G(10, 0)

    ;; $v0 = $v0 + $v4 + $m0
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m0))))

    ;; $v12 = rotr64($v12 ^ $v0, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 32)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 24)))

    ;; $v0 = $v0 + $v4 + $m1
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m1))))

    ;; $v12 = rotr64($v12 ^ $v0, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 16)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 63)))

    ;; G(10, 1)

    ;; $v1 = $v1 + $v5 + $m2
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m2))))

    ;; $v13 = rotr64($v13 ^ $v1, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 32)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 24)))

    ;; $v1 = $v1 + $v5 + $m3
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m3))))

    ;; $v13 = rotr64($v13 ^ $v1, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 16)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 63)))

    ;; G(10, 2)

    ;; $v2 = $v2 + $v6 + $m4
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m4))))

    ;; $v14 = rotr64($v14 ^ $v2, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 32)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 24)))

    ;; $v2 = $v2 + $v6 + $m5
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m5))))

    ;; $v14 = rotr64($v14 ^ $v2, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 16)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 63)))

    ;; G(10, 3)

    ;; $v3 = $v3 + $v7 + $m6
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m6))))

    ;; $v15 = rotr64($v15 ^ $v3, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 32)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 24)))

    ;; $v3 = $v3 + $v7 + $m7
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m7))))

    ;; $v15 = rotr64($v15 ^ $v3, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 16)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 63)))

    ;; G(10, 4)

    ;; $v0 = $v0 + $v5 + $m8
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m8))))

    ;; $v15 = rotr64($v15 ^ $v0, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 32)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 24)))

    ;; $v0 = $v0 + $v5 + $m9
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m9))))

    ;; $v15 = rotr64($v15 ^ $v0, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 16)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 63)))

    ;; G(10, 5)

    ;; $v1 = $v1 + $v6 + $m10
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m10))))

    ;; $v12 = rotr64($v12 ^ $v1, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 32)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 24)))

    ;; $v1 = $v1 + $v6 + $m11
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m11))))

    ;; $v12 = rotr64($v12 ^ $v1, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 16)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 63)))

    ;; G(10, 6)

    ;; $v2 = $v2 + $v7 + $m12
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m12))))

    ;; $v13 = rotr64($v13 ^ $v2, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 32)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 24)))

    ;; $v2 = $v2 + $v7 + $m13
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m13))))

    ;; $v13 = rotr64($v13 ^ $v2, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 16)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 63)))

    ;; G(10, 7)

    ;; $v3 = $v3 + $v4 + $m14
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m14))))

    ;; $v14 = rotr64($v14 ^ $v3, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 32)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 24)))

    ;; $v3 = $v3 + $v4 + $m15
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m15))))

    ;; $v14 = rotr64($v14 ^ $v3, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 16)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 63)))

    ;; ROUND(11)

    ;; G(11, 0)

    ;; $v0 = $v0 + $v4 + $m14
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m14))))

    ;; $v12 = rotr64($v12 ^ $v0, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 32)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 24)))

    ;; $v0 = $v0 + $v4 + $m10
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v4) (get_local $m10))))

    ;; $v12 = rotr64($v12 ^ $v0, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v0)) (i64.const 16)))

    ;; $v8 = $v8 + $v12
    (set_local $v8 (i64.add (get_local $v8) (get_local $v12)))

    ;; $v4 = rotr64($v4 ^ $v8, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v8)) (i64.const 63)))

    ;; G(11, 1)

    ;; $v1 = $v1 + $v5 + $m4
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m4))))

    ;; $v13 = rotr64($v13 ^ $v1, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 32)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 24)))

    ;; $v1 = $v1 + $v5 + $m8
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v5) (get_local $m8))))

    ;; $v13 = rotr64($v13 ^ $v1, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v1)) (i64.const 16)))

    ;; $v9 = $v9 + $v13
    (set_local $v9 (i64.add (get_local $v9) (get_local $v13)))

    ;; $v5 = rotr64($v5 ^ $v9, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v9)) (i64.const 63)))

    ;; G(11, 2)

    ;; $v2 = $v2 + $v6 + $m9
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m9))))

    ;; $v14 = rotr64($v14 ^ $v2, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 32)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 24)))

    ;; $v2 = $v2 + $v6 + $m15
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v6) (get_local $m15))))

    ;; $v14 = rotr64($v14 ^ $v2, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v2)) (i64.const 16)))

    ;; $v10 = $v10 + $v14
    (set_local $v10 (i64.add (get_local $v10) (get_local $v14)))

    ;; $v6 = rotr64($v6 ^ $v10, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v10)) (i64.const 63)))

    ;; G(11, 3)

    ;; $v3 = $v3 + $v7 + $m13
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m13))))

    ;; $v15 = rotr64($v15 ^ $v3, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 32)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 24)))

    ;; $v3 = $v3 + $v7 + $m6
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v7) (get_local $m6))))

    ;; $v15 = rotr64($v15 ^ $v3, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v3)) (i64.const 16)))

    ;; $v11 = $v11 + $v15
    (set_local $v11 (i64.add (get_local $v11) (get_local $v15)))

    ;; $v7 = rotr64($v7 ^ $v11, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v11)) (i64.const 63)))

    ;; G(11, 4)

    ;; $v0 = $v0 + $v5 + $m1
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m1))))

    ;; $v15 = rotr64($v15 ^ $v0, 32)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 32)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 24)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 24)))

    ;; $v0 = $v0 + $v5 + $m12
    (set_local $v0 (i64.add (get_local $v0) (i64.add (get_local $v5) (get_local $m12))))

    ;; $v15 = rotr64($v15 ^ $v0, 16)
    (set_local $v15 (i64.rotr (i64.xor (get_local $v15) (get_local $v0)) (i64.const 16)))

    ;; $v10 = $v10 + $v15
    (set_local $v10 (i64.add (get_local $v10) (get_local $v15)))

    ;; $v5 = rotr64($v5 ^ $v10, 63)
    (set_local $v5 (i64.rotr (i64.xor (get_local $v5) (get_local $v10)) (i64.const 63)))

    ;; G(11, 5)

    ;; $v1 = $v1 + $v6 + $m0
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m0))))

    ;; $v12 = rotr64($v12 ^ $v1, 32)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 32)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 24)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 24)))

    ;; $v1 = $v1 + $v6 + $m2
    (set_local $v1 (i64.add (get_local $v1) (i64.add (get_local $v6) (get_local $m2))))

    ;; $v12 = rotr64($v12 ^ $v1, 16)
    (set_local $v12 (i64.rotr (i64.xor (get_local $v12) (get_local $v1)) (i64.const 16)))

    ;; $v11 = $v11 + $v12
    (set_local $v11 (i64.add (get_local $v11) (get_local $v12)))

    ;; $v6 = rotr64($v6 ^ $v11, 63)
    (set_local $v6 (i64.rotr (i64.xor (get_local $v6) (get_local $v11)) (i64.const 63)))

    ;; G(11, 6)

    ;; $v2 = $v2 + $v7 + $m11
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m11))))

    ;; $v13 = rotr64($v13 ^ $v2, 32)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 32)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 24)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 24)))

    ;; $v2 = $v2 + $v7 + $m7
    (set_local $v2 (i64.add (get_local $v2) (i64.add (get_local $v7) (get_local $m7))))

    ;; $v13 = rotr64($v13 ^ $v2, 16)
    (set_local $v13 (i64.rotr (i64.xor (get_local $v13) (get_local $v2)) (i64.const 16)))

    ;; $v8 = $v8 + $v13
    (set_local $v8 (i64.add (get_local $v8) (get_local $v13)))

    ;; $v7 = rotr64($v7 ^ $v8, 63)
    (set_local $v7 (i64.rotr (i64.xor (get_local $v7) (get_local $v8)) (i64.const 63)))

    ;; G(11, 7)

    ;; $v3 = $v3 + $v4 + $m5
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m5))))

    ;; $v14 = rotr64($v14 ^ $v3, 32)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 32)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 24)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 24)))

    ;; $v3 = $v3 + $v4 + $m3
    (set_local $v3 (i64.add (get_local $v3) (i64.add (get_local $v4) (get_local $m3))))

    ;; $v14 = rotr64($v14 ^ $v3, 16)
    (set_local $v14 (i64.rotr (i64.xor (get_local $v14) (get_local $v3)) (i64.const 16)))

    ;; $v9 = $v9 + $v14
    (set_local $v9 (i64.add (get_local $v9) (get_local $v14)))

    ;; $v4 = rotr64($v4 ^ $v9, 63)
    (set_local $v4 (i64.rotr (i64.xor (get_local $v4) (get_local $v9)) (i64.const 63)))

    ;; END OF GENERATED CODE

    (i64.store (get_local $h0)
      (i64.xor
        (i64.load (get_local $h0))
        (i64.xor
          (get_local $v0)
          (get_local $v8)
        )
      )
    )

    (i64.store (get_local $h1)
      (i64.xor
        (i64.load (get_local $h1))
        (i64.xor
          (get_local $v1)
          (get_local $v9)
        )
      )
    )

    (i64.store (get_local $h2)
      (i64.xor
        (i64.load (get_local $h2))
        (i64.xor
          (get_local $v2)
          (get_local $v10)
        )
      )
    )

    (i64.store (get_local $h3)
      (i64.xor
        (i64.load (get_local $h3))
        (i64.xor
          (get_local $v3)
          (get_local $v11)
        )
      )
    )

    (i64.store (get_local $h4)
      (i64.xor
        (i64.load (get_local $h4))
        (i64.xor
          (get_local $v4)
          (get_local $v12)
        )
      )
    )

    (i64.store (get_local $h5)
      (i64.xor
        (i64.load (get_local $h5))
        (i64.xor
          (get_local $v5)
          (get_local $v13)
        )
      )
    )

    (i64.store (get_local $h6)
      (i64.xor
        (i64.load (get_local $h6))
        (i64.xor
          (get_local $v6)
          (get_local $v14)
        )
      )
    )

    (i64.store (get_local $h7)
      (i64.xor
        (i64.load (get_local $h7))
        (i64.xor
          (get_local $v7)
          (get_local $v15)
        )
      )
    )
  )
)
