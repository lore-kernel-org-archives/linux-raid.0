From: "Bailey, Scott" <scott.bailey@eds.com>
Subject: Alpha kernel 2.4.20 md repeatable oops
Date: Thu, 16 Jan 2003 13:23:46 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <D232AEB4AA44D411B4B900508BDF07740DD23E5B@usahm011.exmi01.exch.eds.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
Cc: "'mingo@redhat.com'" <mingo@redhat.com>, "'neilb@cse.unsw.edu.au'" <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

I've seen some old traffic on the list, but no definite solutions and no
recent notes. So maybe I am just one more person to stumble across an
existing problem. :-) In brief, this is a problem with raid1_read_balance
apparently mangling base pointers.

I have a "new" (er, redeployed) Alphaserver 4100 with 2 processors and I am
busy trying to set up software mirrored disks on it. I started with a Debian
woody base install, and have been working on compiling my own kernel from
the Debian-patched 2.4.20 sources. (Using gcc 3.2.1, more on this below.)
Essentially, setting up the md devices works fine, but doing a mke2fs on a
raid device generates an oops every time. I also tried mke2fs on a physical
partition before creating the mirror set (with --[censored]force), and then
can generate an oops with e2fsck instead. Here are a couple of ksymoops
samples: (Ignore warnings -- the guessed default arguments actually are
correct.)

ksymoops 2.4.6 on alpha 2.4.20-lizard.1.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.4.20-lizard.1/ (default)
     -m /boot/System.map-2.4.20-lizard.1 (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

CPU 0 mke2fs(266): Oops 0
pc = [<fffffc0000446d70>]  ra = [<fffffc0000446eec>]  ps = 0000    Not
tainted
Using defaults from ksymoops -t elf64-alpha -a alpha
v0 = 0000000000000007  t0 = 0000000000000006  t1 = 0000000000000006
t2 = 000044008288912c  t3 = 0000120000eaa050  t4 = 0000000000000000
t5 = 0000000000000001  t6 = 0000000000000000  t7 = fffffc007da94000
s0 = fffffc0001c484c0  s1 = 0000000000000000  s2 = fffffc007db274a0
s3 = fffffc007ede1000  s4 = fffffc007e8b57c0  s5 = 0000000000000000
s6 = fffffc007da97d80
a0 = fffffc007ede1000  a1 = fffffc007db274a0  a2 = fffffc007db274a0
a3 = 0000000000000000  a4 = 000000012002b760  a5 = 000000011ffffc50
t8 = 0000000000000008  t9 = 0000000000000000  t10= 0000000000000002
t11= 0000000000000006  pv = fffffc0000446e00  at = 0000440082889140
gp = fffffc000058d8e8  sp = fffffc007da97c38
Trace:fffffc000044a0a8 fffffc000037385c fffffc00003cc128 fffffc00003ef948
fffffc00003efacc fffffc000035f3b0 fffffc0000361560 fffffc0000366ef0
fffffc00003ca86c fffffc0000366df0 fffffc0000344f1c fffffc0000345718
fffffc0000345580 fffffc000035be74 fffffc0000313760 
Code: 47ff041f  2ffe0000  ecc0001b  2063ffdc  40c03126  2ffe0000 <a0230010>
42e605a7 


>>RA;  fffffc0000446eec <raid1_make_request+ec/430>

>>PC;  fffffc0000446d70 <raid1_read_balance+180/210>   <=====

Trace; fffffc000044a0a8 <md_make_request+128/140>
Trace; fffffc000037385c <kill_fasync+3c/60>
Trace; fffffc00003cc128 <n_tty_receive_buf+188/5b0>
Trace; fffffc00003ef948 <generic_make_request+188/270>
Trace; fffffc00003efacc <submit_bh+9c/100>
Trace; fffffc000035f3b0 <end_buffer_io_async+0/190>
Trace; fffffc0000361560 <block_read_full_page+220/3a0>
Trace; fffffc0000366ef0 <blkdev_readpage+20/40>
Trace; fffffc00003ca86c <tty_default_put_char+2c/40>
Trace; fffffc0000366df0 <blkdev_get_block+0/80>
Trace; fffffc0000344f1c <do_generic_file_read+26c/5e0>
Trace; fffffc0000345718 <generic_file_read+b8/140>
Trace; fffffc0000345580 <file_read_actor+0/e0>
Trace; fffffc000035be74 <sys_read+c4/1e0>
Trace; fffffc0000313760 <entSys+a8/c0>

Code;  fffffc0000446d58 <raid1_read_balance+168/210>
0000000000000000 <_PC>:
Code;  fffffc0000446d58 <raid1_read_balance+168/210>
   0:   1f 04 ff 47       nop  
Code;  fffffc0000446d5c <raid1_read_balance+16c/210>
   4:   00 00 fe 2f       unop 
Code;  fffffc0000446d60 <raid1_read_balance+170/210>
   8:   1b 00 c0 ec       ble  t5,78 <_PC+0x78> fffffc0000446dd0
<raid1_read_balance+1e0/210>
Code;  fffffc0000446d64 <raid1_read_balance+174/210>
   c:   dc ff 63 20       lda  t2,-36(t2)
Code;  fffffc0000446d68 <raid1_read_balance+178/210>
  10:   26 31 c0 40       subl t5,0x1,t5
Code;  fffffc0000446d6c <raid1_read_balance+17c/210>
  14:   00 00 fe 2f       unop 
Code;  fffffc0000446d70 <raid1_read_balance+180/210>   <=====
  18:   10 00 23 a0       ldl  t0,16(t2)   <=====
Code;  fffffc0000446d74 <raid1_read_balance+184/210>
  1c:   a7 05 e6 42       cmpeq        t9,t5,t6


1 warning issued.  Results may not be reliable.

ksymoops 2.4.6 on alpha 2.4.20-lizard.1.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.4.20-lizard.1/ (default)
     -m /boot/System.map-2.4.20-lizard.1 (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

CPU 0 mke2fs(1147): Oops 0
pc = [<fffffc0000446cd0>]  ra = [<fffffc0000446eec>]  ps = 0000    Not
tainted
Using defaults from ksymoops -t elf64-alpha -a alpha
v0 = 0000000000000007  t0 = 0000000000000000  t1 = 000044000573c92c
t2 = 000044000573c940  t3 = 0000000000000008  t4 = 0000000000000001
t5 = 0000000000000000  t6 = 0000000000000000  t7 = fffffc0062470000
s0 = fffffc007ffb36a0  s1 = 0000000000000000  s2 = fffffc0061064580
s3 = fffffc0001c94800  s4 = fffffc007eb6c7c0  s5 = 0000000000000000
s6 = fffffc0062473d80
a0 = fffffc0001c94800  a1 = fffffc0061064580  a2 = fffffc0061064580
a3 = 0000000000000000  a4 = 000000012002b760  a5 = 000000011ffffc40
t8 = 0000000000000000  t9 = 00000200001a11d0  t10= 0000000000000002
t11= 0000000000000400  pv = fffffc0000446e00  at = 0000000000000001
gp = fffffc000058d8e8  sp = fffffc0062473c38
Trace:fffffc000044a0a8 fffffc000037385c fffffc00003cc128 fffffc00003ef948
fffffc00003efacc fffffc000035f3b0 fffffc0000361560 fffffc0000366ef0
fffffc00003ca86c fffffc0000366df0 fffffc0000344f1c fffffc0000345718
fffffc0000345580 fffffc000035be74 fffffc0000313760 
Code: 2042ffdc  2ffe0000  40a01644  40a605a1  2ffe0000  f4200004 <a0220010>
f43ffff6 


>>RA;  fffffc0000446eec <raid1_make_request+ec/430>

>>PC;  fffffc0000446cd0 <raid1_read_balance+e0/210>   <=====

Trace; fffffc000044a0a8 <md_make_request+128/140>
Trace; fffffc000037385c <kill_fasync+3c/60>
Trace; fffffc00003cc128 <n_tty_receive_buf+188/5b0>
Trace; fffffc00003ef948 <generic_make_request+188/270>
Trace; fffffc00003efacc <submit_bh+9c/100>
Trace; fffffc000035f3b0 <end_buffer_io_async+0/190>
Trace; fffffc0000361560 <block_read_full_page+220/3a0>
Trace; fffffc0000366ef0 <blkdev_readpage+20/40>
Trace; fffffc00003ca86c <tty_default_put_char+2c/40>
Trace; fffffc0000366df0 <blkdev_get_block+0/80>
Trace; fffffc0000344f1c <do_generic_file_read+26c/5e0>
Trace; fffffc0000345718 <generic_file_read+b8/140>
Trace; fffffc0000345580 <file_read_actor+0/e0>
Trace; fffffc000035be74 <sys_read+c4/1e0>
Trace; fffffc0000313760 <entSys+a8/c0>

Code;  fffffc0000446cb8 <raid1_read_balance+c8/210>
0000000000000000 <_PC>:
Code;  fffffc0000446cb8 <raid1_read_balance+c8/210>
   0:   dc ff 42 20       lda  t1,-36(t1)
Code;  fffffc0000446cbc <raid1_read_balance+cc/210>
   4:   00 00 fe 2f       unop 
Code;  fffffc0000446cc0 <raid1_read_balance+d0/210>
   8:   44 16 a0 40       s8addq       t4,0,t3
Code;  fffffc0000446cc4 <raid1_read_balance+d4/210>
   c:   a1 05 a6 40       cmpeq        t4,t5,t0
Code;  fffffc0000446cc8 <raid1_read_balance+d8/210>
  10:   00 00 fe 2f       unop 
Code;  fffffc0000446ccc <raid1_read_balance+dc/210>
  14:   04 00 20 f4       bne  t0,28 <_PC+0x28> fffffc0000446ce0
<raid1_read_balance+f0/210>
Code;  fffffc0000446cd0 <raid1_read_balance+e0/210>   <=====
  18:   10 00 22 a0       ldl  t0,16(t1)   <=====
Code;  fffffc0000446cd4 <raid1_read_balance+e4/210>
  1c:   f6 ff 3f f4       bne  t0,fffffffffffffff8 <_PC+0xfffffffffffffff8>
fffffc0000446cb0 <raid1_read_balance+c0/210>


1 warning issued.  Results may not be reliable.

For the truly interested, here is my attempt to annotate the generated
assembly code and trace the oops locations backwards from the instructions
to the corresponding source code. Some comments relative to use of array
base registers should be taken with a grain of salt.

"**1**" and "**2**" mark the point of the failures.

$16 points to conf (possibly offset by 8??)
$17 points to bh

$4  new_disk * 8
$5  new_disk
$6  disk

$22 this_sector
$24 sectors
$25 current_distance
    new_distance

sizeof(struct mirror_info) appears to be 36 bytes. Array stepping
consequently
seems to frequently involve doing:

	s8addq index,0,temp	! temp = index * 8
	addq   temp,index,temp	! temp = temp + index = index * 9
        s4addq temp,base,temp	! temp = temp * 4 + base = index * 36 + base

or:

	s8addq index,index,temp	! temp = index * 9
	s4addq temp,base,temp	! temp = temp * 4 + base = index * 36 + base

Further notice that for efficiency, "base" is taken as conf, even though the
mirrors array conf->mirrors comes after mddev (a pointer). You will
therefore
see ld/st offsets in this array be 8 greater than expected to take this into
account without requiring an additional prior calculation to "fix" the base.



	.set noat
	.set noreorder
	.set nomacro
	.arch ev56
[...]
	.align 4
	.ent raid1_read_balance
$raid1_read_balance..ng:
raid1_read_balance:
	.frame $30,0,$26,0
	.prologue 0
	ldl $7,992($16)			! $7 (new_disk) <- conf->last_used
	ldwu $1,16($17)			! $1 <- bh->b_size
	ldl $2,1032($16)		! $2 <- conf->resync_mirrors
	ldq $22,120($17)		! $22 (this_sector) <- bh->b_rsector
	addl $7,$31,$5			! $5 (new_disk) <- new_disk + 0
	srl $1,9,$24			! $24 (sectors) <- $1 >> 9
	mov $5,$6			! $6 (disk) <- new_disk
	s8addq $5,0,$4			! $4 <- new_disk * 8
	bne $2,$L452			! if conf->resync_mirrors goto
rb_out
	addq $4,$5,$1			! $1 <- new_disk * 9
	s4addq $1,$16,$3		! $3 <- conf->mirrors[new_disk] (-8)
	bis $31,$31,$31
	ldl $2,28($3)			! $2 <- $3.operational
	bne $2,$L476			! if operational branch ahead
	s8addq $23,$23,$1		! $1 <- $23 * 9
	lda $2,28($3)			! $2 <- address($3.operational)
	s4addq $1,$16,$3		! $3 <- conf->mirrors[$23] (-8)
	.align 4
$L458:
	ble $5,$L480			! if new_disk <= 0 then branch
$L456:
	subl $5,1,$5			! new_disk--
	lda $2,-36($2)			! $2 <- addr(mirrors[new_disk].oper)
	ldq_u $31,0($30)
	s8addq $5,0,$4			! $4 <- new_disk * 8
	cmpeq $5,$6,$1			! $1 <- bool(new_disk == disk)
	ldq_u $31,0($30)
	bne $1,$L479			! if new_disk == disk then branch
	ldl $1,0($2)			! $1 <-
mirrors[new_disk].operational
	beq $1,$L458			! if not operational loop back
$L476:			! when operational is true
	addq $4,$5,$1			! $1 <- new_disk * 9 (is $4 in
sync?)
	mov $5,$6			! $6 (disk) <- new_disk
	s4addq $1,$16,$2		! $2 <- conf->mirrors[new_disk] (-8)
	lda $3,16($2)			! $3 <- addr(mirrors[].dev)
	ldl $1,8($3)			! $1 <- mirrors[].head_position
	bis $31,$31,$31
	cmpeq $22,$1,$1			! $1 <- bool(this_sector ==
head_position)
	bne $1,$L452			! if equal goto rb_out
	ldl $2,20($2)			! $2 <- mirrors[new_disk].sect_limit
	ldl $1,1008($16)		! $1 <- conf->sect_count
	cmplt $1,$2,$1			! $1 <- bool(sect_count <
sect_limit)
	bne $1,$L460			! if true then branch
	s8addq $23,$23,$1		! $1 <- $23 * 9
	mov $3,$2			! $2 <- $3 addr(mirrors[].dev)
	stl $31,1008($16)		! conf->sect_count <- 0
	s4addq $1,$16,$3		! $3 <- conf->mirrors[$23] (-8)
	.align 4
$L461:			! loop from below
	ble $5,$L481			! if new_disk <= 0 then branch
$L464:			! return from out-of-line fixup
	subl $5,1,$5			! new_disk--
	lda $2,-36($2)			! $2 <- addr(mirrors[new_disk].dev)
	ldq_u $31,0($30)
	s8addq $5,0,$4			! $4 <- new_disk * 8
	cmpeq $5,$6,$1			! $1 <- bool(new_disk == disk)
	ldq_u $31,0($30)
	bne $1,$L452			! if equal then goto rb_out
**2**	ldl $1,16($2)			! $1 <- mirrors[new_disk].write_only
	bne $1,$L461			! if write_only then loop
	ldl $1,12($2)			! $1 <-
mirrors[new_disk].operational
	beq $1,$L461			! if not operational then loop
	.align 4
$L452:			! rb_out:
	addq $4,$5,$1			! $1 <- new_disk * 9 ($4 in sync?)
	addq $22,$24,$3			! $3 <- this_sector + sectors
	s4addq $1,$16,$1		! $1 <- conf->mirrors[new_disk] (-8)
	mov $5,$0			! $0 <- new_disk
	stl $3,24($1)			! .head_position <- sum
	ldl $2,1008($16)		! $2 <- conf->sect_count
	stl $5,992($16)			! conf->last_used <- new_disk
	addq $24,$2,$2			! $2 += sectors
	stl $2,1008($16)		! conf->sect_count <- sum
	ret $31,($26),1
	.align 4
$L481:			! new_disk <= 0
	lda $2,16($3)			! $2 <- addr(conf->mirrors[$23].dev)
	ldl $5,984($16)			! $5 (new_disk) <- conf->raid_disks
	br $31,$L464			! return to loop
	bis $31,$31,$31
$L460:			! sect_count < sect_limit
	addq $4,$5,$1			! $1 <- new_disk * 9 ($4 in sync?)
	s8addq $5,$5,$3			! $3 <- new_disk * 9
	s4addq $1,$16,$1		! $1 <- conf->mirrors[new_disk])
(-8)
	s8addq $23,$23,$4		! $4 <- $23 * 9
	ldl $2,24($1)			! $2 <-
mirrors[new_disk].head_position
	s4addq $3,$16,$3		! $3 <- conf->mirrors[new_disk])
(-8)
	addl $7,$31,$23			! $23 <- $7 ( + 0 )
	lda $3,16($3)			! $3 <- a(mirrors[new_disk].dev)
	subl $22,$2,$2			! $2 <- this_sector - head_position
	s4addq $4,$16,$28		! $28 <- conf->mirrors[old-$23] (-8)
	subq $31,$2,$1			! $1 <- 0 - $2 (difference)
	bis $31,$31,$31
	cmovge $2,$2,$1			! if $2 >= 0 then $1 <- $2
	addl $1,$31,$25			! $25 (current_distance) <- $1
	.align 4
$L467:
	ble $6,$L482			! if disk <= 0 then branch
$L470:			! return from out-of-line fixup
	lda $3,-36($3)			! $3 <- addr(mirrors[disk].dev) (?)
	subl $6,1,$6			! disk--
	ldq_u $31,0($30)
**1**	ldl $1,16($3)			! $1 <- mirrors[].write_only
	cmpeq $23,$6,$7			! $23 <- bool(disk == $7)
	ldq_u $31,0($30)
	bne $1,$L469
	ldl $1,12($3)
	beq $1,$L469
	ldl $1,8($3)
	subl $22,$1,$1
	subq $31,$1,$2
	cmovge $1,$1,$2
	addl $2,$31,$2
	bis $31,$31,$31
	cmpult $2,$25,$1
	beq $1,$L469
	stl $31,1008($16)
	mov $2,$25
	mov $6,$5
	.align 4
$L469:
	s8addq $5,0,$4
	bne $7,$L452
	br $31,$L467
	.align 4
$L482:			! (when disk <= 0)
	lda $3,16($28)			! $3 <- weird
	ldl $6,984($16)			! $6 (disk) <- conf->raid_disks
	br $31,$L470			! return to inline code
	bis $31,$31,$31
$L479:
	addl $7,$31,$5			! $5 <- $7 + 0 (is this pointless?)
	s8addq $5,0,$4			! $4 <- quad[new_disk]
	br $31,$L452			! return to inline code
	.align 4
$L480:			! (when new_disk <= 0)
	lda $2,28($3)			! $2 <- weird relative to conf??
	ldl $5,984($16)			! $5 (new_disk) <- conf->raid_disks
	br $31,$L456			! return to inline code
	.end raid1_read_balance
[...]
	.ident	"GCC: (GNU) 3.2.1 20020924 (Debian prerelease)"


Both failures appear to be in the while loops where the loop variable
(new_disk or disk) is moving circularly in reverse fashion through the
available disks and I am wondering if the registers with stashed base
pointers are not getting reset properly when the loop "wraps" off the bottom
of the list. That would seem to suggest to me a compiler bug, as the C code
seems correct, but my mind is hurting from looking at this. :-)

I tried building with gcc 2.95.4 but the resulting kernel died early in
boot. I am more than willing to use this system as a guinea pig for testing
patches, alternate compile approaches, or whatever will be of use to those
with more of a clue than myself.

Thanks for your attention,

	Scott Bailey
	scott.bailey@eds.com
