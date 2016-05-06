From: Mike Lovell <mike.lovell@endurance.com>
Subject: Re: problems with lots of arrays
Date: Fri, 6 May 2016 11:59:20 -0600
Message-ID: <CAK9wOaCN5gYtyTTf8n=5j=3oR6mZLAXN+PrREfzjKH9S1MgJiw@mail.gmail.com>
References: <CAK9wOaB+Cic3nR5kzB3n=nVpbRtfo8+Qr9j_VNM3hh5tJRw6YA@mail.gmail.com>
	<87k2j7vg8m.fsf@notabene.neil.brown.name>
	<CAK9wOaDLu+edK5R=U61mTb3+OP2=QNotExsZzu2Sce-qLCVHcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK9wOaDLu+edK5R=U61mTb3+OP2=QNotExsZzu2Sce-qLCVHcA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 6, 2016 at 11:02 AM, Mike Lovell <mike.lovell@endurance.com> wrote:
> On Fri, May 6, 2016 at 12:43 AM, NeilBrown <nfbrown@novell.com> wrote:
>> I know why newer kernels don't seem to support more than 512 array.
>>
>> Commit: af5628f05db6 ("md: disable probing for md devices 512 and over.")
>>
>>
>> You can easily use many more md devices by using a newish mdadm and
>> setting
>>
>>    CREATE names=yes
>>
>> in /etc/mdadm.conf
>>
>> You cannot use names like "md512" because that gets confusing, but any
>> name that isn't a string of digits is fine.  e.g. create /dev/md/foo
>> and the array will be named "md_foo" in the kernel rather than "md127".
>>
>> I guess this qualifies as a regression and regressions are bad.....
>> But I really wanted to be able to have arrays that didn't get magically
>> created simply because you open a file in /dev.  That just leads to
>> races with udev.
>>
>> The magic number "512" appears three times in the kernel.
>>
>>                 /* find an unused unit number */
>>                 static int next_minor = 512;
>>
>> and
>>
>>         blk_register_region(MKDEV(MD_MAJOR, 0), 512, THIS_MODULE,
>>                             md_probe, NULL, NULL);
>> and
>>         blk_unregister_region(MKDEV(MD_MAJOR,0), 512);
>>
>> A boot parameter which set that to something larger would probably be OK
>> and would solve your immediate problem.
>>
>> But if you could transition to using named arrays instead of numbered
>> arrays - even if that are "/dev/md/X%d", that would be be good I think.
>>
>> NeilBrown
>
> we actually do specify the name to mdadm --create and mdadm --assemble
> and have a naming scheme from our own internal tools. the problem we
> were running into was that mdadm would auto-generate a minor number
> that was invalid but we also don't have "CREATE names=yes" in
> mdadm.conf. i'll have to experiment with that one.

i just tested with "CREATE names=yes" in /etc/mdadm.conf and using
some test names seems to work properly. the array was created using
the name and the kernel chose minor numbers starting at 512. i then
tried some of our management tools and things failed. it looks like
its having a problem with our naming scheme. its using names that are
a little over 30 characters with - and _ in them. are there supposed
to be any restrictions on the array name?

specifically, this is what happened from mdadm when trying. (names
changes to protect the innocent :) )

$ sudo mdadm -A /dev/md/test-volume_a-123456_123456 /dev/dm-1 /dev/dm-2
*** buffer overflow detected ***: mdadm terminated
======= Backtrace: =========
/lib64/libc.so.6(__fortify_fail+0x37)[0x7f7e50f40567]
/lib64/libc.so.6(+0x100450)[0x7f7e50f3e450]
/lib64/libc.so.6(+0xff8a9)[0x7f7e50f3d8a9]
/lib64/libc.so.6(_IO_default_xsputn+0xc9)[0x7f7e50eb2639]
/lib64/libc.so.6(_IO_vfprintf+0x41c0)[0x7f7e50e86190]
/lib64/libc.so.6(__vsprintf_chk+0x9d)[0x7f7e50f3d94d]
/lib64/libc.so.6(__sprintf_chk+0x7f)[0x7f7e50f3d88f]
mdadm[0x43068e]
mdadm[0x417089]
mdadm[0x4058a4]
/lib64/libc.so.6(__libc_start_main+0xfd)[0x7f7e50e5cd5d]
mdadm[0x402ca9]
======= Memory map: ========
00400000-0046d000 r-xp 00000000 09:00 16908296
  /sbin/mdadm
0066d000-00674000 rw-p 0006d000 09:00 16908296
  /sbin/mdadm
00674000-00687000 rw-p 00000000 00:00 0
00fbb000-00fdc000 rw-p 00000000 00:00 0                                  [heap]
7f7e50c28000-7f7e50c3e000 r-xp 00000000 09:00 18874642
  /lib64/libgcc_s-4.4.7-20120601.so.1
7f7e50c3e000-7f7e50e3d000 ---p 00016000 09:00 18874642
  /lib64/libgcc_s-4.4.7-20120601.so.1
7f7e50e3d000-7f7e50e3e000 rw-p 00015000 09:00 18874642
  /lib64/libgcc_s-4.4.7-20120601.so.1
7f7e50e3e000-7f7e50fc8000 r-xp 00000000 09:00 18874440
  /lib64/libc-2.12.so
7f7e50fc8000-7f7e511c8000 ---p 0018a000 09:00 18874440
  /lib64/libc-2.12.so
7f7e511c8000-7f7e511cc000 r--p 0018a000 09:00 18874440
  /lib64/libc-2.12.so
7f7e511cc000-7f7e511cd000 rw-p 0018e000 09:00 18874440
  /lib64/libc-2.12.so
7f7e511cd000-7f7e511d2000 rw-p 00000000 00:00 0
7f7e511d2000-7f7e511f2000 r-xp 00000000 09:00 18874758
  /lib64/ld-2.12.so
7f7e513e5000-7f7e513e8000 rw-p 00000000 00:00 0
7f7e513ee000-7f7e513f1000 rw-p 00000000 00:00 0
7f7e513f1000-7f7e513f2000 r--p 0001f000 09:00 18874758
  /lib64/ld-2.12.so
7f7e513f2000-7f7e513f3000 rw-p 00020000 09:00 18874758
  /lib64/ld-2.12.so
7f7e513f3000-7f7e513f4000 rw-p 00000000 00:00 0
7ffe90a1f000-7ffe90a40000 rw-p 00000000 00:00 0                          [stack]
7ffe90ab1000-7ffe90ab3000 r--p 00000000 00:00 0                          [vvar]
7ffe90ab3000-7ffe90ab5000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
  [vsyscall]

this was with kernel 4.4.8 and mdadm 3.3.2-5.el6

thanks
mike
