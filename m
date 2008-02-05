From: Neil Brown <neilb@suse.de>
Subject: Re: Re[2]: mdadm 2.6.4 : How i can check out current status of reshaping ?
Date: Tue, 5 Feb 2008 21:10:00 +1100
Message-ID: <18344.13816.921912.885730@notabene.brown>
References: <79188012.20080204070802@j8.com.ru>
	<18343.38465.112723.66522@notabene.brown>
	<58351009.20080205121332@j8.com.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andreas-Sokov on Tuesday February 5
Sender: linux-raid-owner@vger.kernel.org
To: Andreas-Sokov <andre.s@j8.com.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday February 5, andre.s@j8.com.ru wrote:
> Feb  5 11:56:12 raid01 kernel: BUG: unable to handle kernel paging request at virtual address 001cd901

This looks like some sort of memory corruption.

> Feb  5 11:56:12 raid01 kernel: EIP is at md_do_sync+0x629/0xa32

This tells us what code is executing.

> Feb  5 11:56:12 raid01 kernel: Code: 54 24 48 0f 87 a4 01 00 00 72 0a 3b 44 24 44 0f 87 98 01 00 00 3b 7c 24 40 75 0a 3b 74 24 3c 0f 84 88 01 00 00 0b 85 30 01 00 00 <88> 08 0f 85 90 01 00 00 8b 85 30 01 00 00 a8 04 0f 85 82 01 00

This tells us what the actual byte of code were.
If I feed this line (from "Code:" onwards) into "ksymoops" I get 

   0:   54                        push   %esp
   1:   24 48                     and    $0x48,%al
   3:   0f 87 a4 01 00 00         ja     1ad <_EIP+0x1ad>
   9:   72 0a                     jb     15 <_EIP+0x15>
   b:   3b 44 24 44               cmp    0x44(%esp),%eax
   f:   0f 87 98 01 00 00         ja     1ad <_EIP+0x1ad>
  15:   3b 7c 24 40               cmp    0x40(%esp),%edi
  19:   75 0a                     jne    25 <_EIP+0x25>
  1b:   3b 74 24 3c               cmp    0x3c(%esp),%esi
  1f:   0f 84 88 01 00 00         je     1ad <_EIP+0x1ad>
  25:   0b 85 30 01 00 00         or     0x130(%ebp),%eax
Code;  00000000 Before first symbol
  2b:   88 08                     mov    %cl,(%eax)
  2d:   0f 85 90 01 00 00         jne    1c3 <_EIP+0x1c3>
  33:   8b 85 30 01 00 00         mov    0x130(%ebp),%eax
  39:   a8 04                     test   $0x4,%al
  3b:   0f                        .byte 0xf
  3c:   85                        .byte 0x85
  3d:   82                        (bad)  
  3e:   01 00                     add    %eax,(%eax)


I removed the "Code;..." lines as they are just noise, except for the
one that points to the current instruction in the middle.
Note that it is dereferencing %eax, after just 'or'ing some value into
it, which is rather unusual.

Now get the "md-mod.ko" for the kernel you are running.
run
   gdb md-mod.ko

and give the command

   disassemble md_do_sync

and look for code at offset 0x629, which is 1577 in decimal.

I found a similar kernel to what you are running, and the matching code
is 

0x000055c0 <md_do_sync+1485>:	cmp    0x30(%esp),%eax
0x000055c4 <md_do_sync+1489>:	ja     0x5749 <md_do_sync+1878>
0x000055ca <md_do_sync+1495>:	cmp    0x2c(%esp),%edi
0x000055ce <md_do_sync+1499>:	jne    0x55da <md_do_sync+1511>
0x000055d0 <md_do_sync+1501>:	cmp    0x28(%esp),%esi
0x000055d4 <md_do_sync+1505>:	je     0x5749 <md_do_sync+1878>
0x000055da <md_do_sync+1511>:	mov    0x130(%ebp),%eax
0x000055e0 <md_do_sync+1517>:	test   $0x8,%al
0x000055e2 <md_do_sync+1519>:	jne    0x575f <md_do_sync+1900>
0x000055e8 <md_do_sync+1525>:	mov    0x130(%ebp),%eax
0x000055ee <md_do_sync+1531>:	test   $0x4,%al
0x000055f0 <md_do_sync+1533>:	jne    0x575f <md_do_sync+1900>
0x000055f6 <md_do_sync+1539>:	mov    0x38(%esp),%ecx
0x000055fa <md_do_sync+1543>:	mov    0x0,%eax
-

Note the sequence "cmp, ja, cmp, jne, cmp, je"
where the "cmp" arguments are consecutive 4byte values on the stack
(%esp).
In the code from your oops, the offsets are 0x44 0x40 0x3c.
In the kernel I found they are 0x30 0x2c 0x28.  The difference is some
subtle difference in the kernel, possibly a different compiler or
something.

Anyway, your code crashed at 


  25:   0b 85 30 01 00 00         or     0x130(%ebp),%eax
Code;  00000000 Before first symbol
  2b:   88 08                     mov    %cl,(%eax)

The matching code in the kernel I found is 

0x000055da <md_do_sync+1511>:	mov    0x130(%ebp),%eax
0x000055e0 <md_do_sync+1517>:	test   $0x8,%al

Note that you have an 'or', the kernel I found has 'mov'.

If we look at the actual byte of code for those two instructions
the code that crashed shows the bytes above:

    0b 85 30 01 00 00
    88 08

if I get the same bytes with gdb:

(gdb) x/8b 0x000055da
0x55da <md_do_sync+1511>:	0x8b	0x85	0x30	0x01	0x00	0x00	0xa8	0x08
(gdb) 

So what should be "8b" has become "0b", and what should be "a8" has
become "08".

If you look for the same data in your md-mod.ko, you might find
slightly different details but it is clear to me that the code in
memory is bad.

Possible you have bad memory, or a bad CPU, or you are overclocking
the CPU, or it is getting hot, or something.


But you clearly have a hardware error.

NeilBrown
