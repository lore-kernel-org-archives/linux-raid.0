From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: kernel race with mdadm monitor
Date: Thu, 10 Feb 2005 13:57:43 -0500
Message-ID: <420BAEA7.4010302@steeleye.com>
References: <cufnea$ivd$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <cufnea$ivd$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario Holbe wrote:
> I'm running Linux 2.4.27 i686 single-processor from debian's
> kernel-source-2.4.27 and mdadm 1.9.0 in monitor mode:

> While stopping a raid1 (raidstop /dev/md8) it seems there

> Unable to handle kernel NULL pointer dereference at virtual address 000003d8
> c024be53
> *pde = 00000000
> Oops: 0000
> CPU:    0
> EIP:    0010:[<c024be53>]    Not tainted
> Using defaults from ksymoops -t elf32-i386 -a i386
> EFLAGS: 00010286
> eax: c1c149ac   ebx: f7da5634   ecx: c0308d1e   edx: f738e974
> esi: 00000000   edi: 00000000   ebp: f738e974   esp: f5539f18
> ds: 0018   es: 0018   ss: 0018
> Process mdadm (pid: 1731, stackpage=f5539000)
> Stack: c1c149c0 0ba4ee80 c0157b37 f63e1206 f7da5634 c1c149c0 c0308d1f 0ba4ee80 
>        c0252f0b f738e974 c1c149ac 0ba4ee80 00000000 00000000 f738e974 c1c149ac 
>        000001ec c015766d f738e974 c1c149ac f5539f74 f738e98c 00000000 00000007 
> Call Trace:    [<c0157b37>] [<c0252f0b>] [<c015766d>] [<c013e2f3>] [<c0108bcb>]
> Code: 8b 87 d8 03 00 00 89 44 24 0c 8b 87 d4 03 00 00 89 2c 24 89 
> 
> 
> 
>>>EIP; c024be53 <raid1_status+13/a0>   <=====
> 
> 
>>>eax; c1c149ac <_end+1832a48/3a58b0fc>
>>>ebx; f7da5634 <_end+379c36d0/3a58b0fc>
>>>ecx; c0308d1e <cpdext+32e3e/3a8e0>
>>>edx; f738e974 <_end+36faca10/3a58b0fc>
>>>ebp; f738e974 <_end+36faca10/3a58b0fc>
>>>esp; f5539f18 <_end+35157fb4/3a58b0fc>
> 
> 
> Trace; c0157b37 <seq_printf+37/60>
> Trace; c0252f0b <md_seq_show+15b/2d0>
> Trace; c015766d <seq_read+1cd/2c0>
> Trace; c013e2f3 <sys_read+a3/140>
> Trace; c0108bcb <system_call+33/38>
> 
> Code;  c024be53 <raid1_status+13/a0>
> 00000000 <_EIP>:
> Code;  c024be53 <raid1_status+13/a0>   <=====
>    0:   8b 87 d8 03 00 00         mov    0x3d8(%edi),%eax   <=====

Wow...I think this is the same bug I reported about 3.5 years ago:

http://marc.theaimsgroup.com/?l=linux-raid&m=100499418432072&w=2

This bug was fixed, but for some reason, the "active" test in 
do_md_stop(), which prevents this particular race, is commented out in 
the mainline/debian kernel:

(md.c, ~ line 1803)

static int do_md_stop(mddev_t * mddev, int ro)
{
         int err = 0, resync_interrupted = 0;
         kdev_t dev = mddev_to_kdev(mddev);

#if 0 /* ->active is not currently reliable */
         if (atomic_read(&mddev->active)>1) {
                 printk(STILL_IN_USE, mdidx(mddev));
                 OUT(-EBUSY);
         }
#endif


I guess there was some problem with this check, but the replacement for 
it (bd_openers check) is not foolproof either, it would appear. It looks 
like Neil has a more robust patch:

http://cgi.cse.unsw.edu.au/~neilb/patches/current/linux-stable-leadingedge/applied/007MdP1

that more completely solves the locking/refcounting problems in 2.4 md, 
but I don't know the status of that patch.

--
Paul
