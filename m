From: "bart@ardistech.com" <bart@ardistech.com>
Subject: Re: RAID5 attempt rebuilding despite being incomplete
Date: Fri, 24 Jun 2005 10:20:49 +0200
Message-ID: <42BBC261.1408AA23@ardistech.com>
References: <42BA9D87.B6808FFC@ardistech.com>
		<17082.46466.985928.971926@cse.unsw.edu.au>
		<42BABCDD.F4D0191E@ardistech.com> <17083.25767.665831.24231@cse.unsw.edu.au>
Reply-To: bart@ardistech.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

> I cannot find the patch I was thinking of to check when it went in,
> but I have just tested various failure scenarios on 2.6.12-rc3-mm3 and
> it handles them all properly.
> 
> If you could try 2.6.12 and confirm, I would appreciate it.
> 
Ok, will try with 2.6.12

> I noticed that the raid5 was resyncing rather than recovering.
> Normally when you create a raid5 with mdadm it will recover as this is
> faster than resync.  Did you create the array with '-f' ??
> 
No, but the '--run' flag was set. I noticed that when ommiting the
'--run' flag (like 'mdadm --create /dev/md3 --level=5 --raid-devices=4
/dev/hd[abef]4') the array goes into recovery straight away, so 
probably the '--run' flag forces a '-f'.

It also looks like the '--detail --test' flag of mdadm (to obtain the array
status as return value) does not work (always returns 0). I'll start a
different thread on that when I tested it further.

Cheers,
	Bart
