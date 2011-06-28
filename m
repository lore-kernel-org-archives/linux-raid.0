From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5: failing an active component during spare rebuild -
 arrays hangs
Date: Tue, 28 Jun 2011 12:29:21 +1000
Message-ID: <20110628122921.42480f72@notabene.brown>
References: <BANLkTikkeoCsr3-UBSPEDrYwh4jGSn=MaA@mail.gmail.com>
	<BANLkTinwr9UE_B+MSXfbE2nAv0wLrTvhXg@mail.gmail.com>
	<20110622125409.14428883@notabene.brown>
	<BANLkTinijekK8Y6TTk6TYtYhv4Dn2YGQbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinijekK8Y6TTk6TYtYhv4Dn2YGQbA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 26 Jun 2011 21:13:17 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil,
> thank you for your response. Meanwhile I have moved to stock ubuntu
> natty 11.04, but it still happens. I have a simple script that
> reproduces the issue for me in less than 1 minute.
> System details:
> Linux ubuntu 2.6.38-8-server #42-Ubuntu SMP Mon Apr 11 03:49:04 UTC
> 2011 x86_64 x86_64 x86_64 GNU/Linux
> 
> Here is the script:
> ##################################
> #!/bin/bash
> 
> while true
> do
> 	mdadm --create /dev/md1123 --raid-devices=3 --level=5
> --bitmap=internal --name=1123 --run --auto=md --metadata=1.2
> --homehost=alex --verbose /dev/sda /dev/sdb /dev/sdc
> 	sleep 6
> 	mdadm --manage /dev/md1123 --fail /dev/sda
> 	sleep 1
> 	if mdadm --stop /dev/md1123
> 	then
> 		true
> 	else
> 		break
> 	fi
> done
> #####################################

Thanks for the script.  Unfortunately I still cannot reproduce.
I suspect there is some subtle race issue that is heavily dependant on the
particular hardware you have.

It might help if I could get stack traces of the relevant processes. i.e.
md1123_raid5 and md1123_resync.

A previous post contained a trace of _resync, but it wouldn't hurt to get
another one.  You can get them by

  cat /proc/PROCESS-ID/stack

or possibly

  echo w > /proc/sysrq-trigger

then look in the output of 'dmesg'.

Thanks,
NeilBrown
