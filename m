From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raidsetfaulty (on raid5) gives kernel oops
Date: Fri, 18 Oct 2002 10:13:46 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15791.21050.696955.788062@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.44.0210170937290.17673-100000@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from raid@ddx.a2000.nu on Thursday October 17
To: raid@ddx.a2000.nu
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 17, raid@ddx.a2000.nu wrote:
> Hi,
> 
> tried to fail a disk on my raid5 array
> so i did : 'raidsetfaulty  /dev/md0  /dev/sdf1'
> 
> and then i have this in my kernel log :

Can you decode the oops - with ksymoops?   It would make it  easier to
interpret.

It isn't really something that is safe to ignore.

NeilBrown

> 
> --
> raid5: Disk failure on sdf1, disabling device. Operation continuing on 4
> devices
> md: updating md0 RAID superblock on device
> md: sdf1 [events: 00000002]<6>(write) sdf1's sb offset: 117218176
> md: recovery thread got woken up ...
> md0: no spare disk to reconstruct array! -- continuing in degraded mode
> Unable to handle kernel NULL pointer dereference at virtual address
> 00000000
>  printing eip:
> c025a526
> *pde = 00000000
> md: recovery thread finished ...
> Oops: 0000
> CPU:    3
> EIP:    0010:[<c025a526>]    Not tainted
> EFLAGS: 00010206
> eax: 00000000   ebx: 00000000   ecx: 00000400   edx: de718000
> esi: 00000000   edi: de718000   ebp: 00001000   esp: de6e1f34
> ds: 0018   es: 0018   ss: 0018
> Process raid5d (pid: 575, stackpage=de6e1000)
> Stack: dfb05780 dfb05780 de719000 c02557e2 de718000 00000000 00001000
> 0000005d
>        00000851 ce919200 dfb05780 df748500 dea14c94 dea14c80 c0255b57
> dfb05780
>        00000002 c166b72c 00000064 00000000 de6e0000 c166b400 dfb05700
> dfb05708
> Call Trace:    [<c02557e2>] [<c0255b57>] [<c0250816>] [<c0258e3f>]
> [<c01058ce>]
>   [<c0258d00>]
> 
> Code: f3 a5 e9 53 ff ff ff 8d 76 00 c1 e9 02 89 d7 f3 a5 a4 e9 43
> --
> 
> 
> i can still access my raid5 device (so i don't know if this is just
> something i can ignore ?)
> 
> /proc/mdstat gives me :
> 
> --
> Personalities : [raid0] [raid5]
> read_ahead 1024 sectors
> md0 : active raid5 sdf1[4](F) sde1[3] sdd1[2] sdc1[1] sdb1[0]
>       468872704 blocks level 5, 64k chunk, algorithm 0 [5/4] [UUUU_]
> 
> unused devices: <none>
> --
> 
> System is an Intel Dual Xeon 2 Ghz (with htt enabled)
> 512mb memory
> 3ware 7850 with 6*120gb 7200 2mb wdc ide
> 
> kernel 2.4.20-pre10
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
