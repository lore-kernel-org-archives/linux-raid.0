From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Software RAID Stopped Working With Aurora Kernel
Date: Wed, 22 May 2002 09:51:55 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15594.56731.169389.603464@notabene.cse.unsw.edu.au>
References: <15594.14625.624567.495812@notabene.cse.unsw.edu.au>
	<NDBBIAKEEKGGEIKCBKNAEENACPAA.kc130iseo@coastalnet.com>
	<15594.45618.113616.670740@notabene.cse.unsw.edu.au>
	<3CEAC664.8D738EC2@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Calvin D. Webster on Tuesday May 21
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday May 21, cwebster@ec.rr.com wrote:
> 
> There is only one thing that doesn't look right to me. That is the
> contents of "/proc/mdstat".
> The device numbers seem mismatched to their device names.
> 
> Also, different from what I'm used to seeing, is that the spare drive
> (sdc1) is not shown in the "active" list as it was before.

It is not there because you didn't tell "mdadm --assemble" about it.
mdadm will only assemble the drives that you give it.  It doesn't
matter what order you give them, but you should list all the drives
that part of the array (live or spare).
You can hot add /dev/sdc1 back in with
   mdadm /dev/md0 --add /dev/sdc1
or
   raidhotadd /dev/md0 /dev/sdc1

> 
> ## /proc/mdstat before (with 2.2 kernel):
> 
> ----------------------------------------------------------------------------------
> Personalities : [raid5]
> read_ahead 1024 sectors
> md0 : active raid5 sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
> 70726656 bloc
> ks level 5, 128k chunk, algorithm 0 [5/5] [UUUUU]
> unused devices: <none>
> ----------------------------------------------------------------------------------
> 
> ## /proc/mdstat after (with 2.4 kernel, fixed with mdadm):
> 
> ----------------------------------------------------------------------------------
> Personalities : [raid5] 
> read_ahead 1024 sectors
> md0 : active raid5 sda1[4] sde1[3] sdd1[2] sdf1[1] sdb1[0]
>       70726656 blocks level 5, 128k chunk, algorithm 0 [5/5] [UUUUU]
>       
> unused devices: <none>
> ----------------------------------------------------------------------------------

I don't know what caused the different numbering.  However as the raid
drive is clearly putting the right disks in the right places I
wouldn't worry about it.

I'm glad all went well.

NeilBrown
