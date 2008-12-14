From: Michal Soltys <soltys@ziu.info>
Subject: Re: Raid 5 Problem
Date: Sun, 14 Dec 2008 22:14:01 +0100
Message-ID: <49457719.4000009@ziu.info>
References: <49450D04.8060703@nigelterry.net> <4945276E.1010405@ziu.info> <49456F94.8020100@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49456F94.8020100@nigelterry.net>
Sender: linux-raid-owner@vger.kernel.org
To: nterry <nigel@nigelterry.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

nterry wrote:
> 
> Great - All working.  Then I rebooted and was back to square one with 
> only 3 drives in /dev/md0 and /dev/sdb in /dev/md_d0
>                                   So I am still not understanding where 
> /dev/md_d0 is coming from and although I know how to get things working 
> after a reboot, clearly this is not a long term solution...
> 

My blind shot is that udev rules of your distro are doing mdadm 
--incremental assembly and picking sdb as a part of nonexisting array 
from the long ago (leftover after old experimentations ?). Or something 
else is doing so.

What does mdadm -Esvv /dev/sdb show ?

Add

DEVICE /dev/sd[bcde]1

on top of your mdadm.conf - it should stop --incremental from picking up 
sdb. Assuming that's the cause of the problem.

Also note, that FC9 might be trying to assemble the array during 
initramfs stage (assuming it uses one) and having problems there. I've 
never used Fedora so hard to tell for me - but definitely peek there, 
particulary at udev and mdadm part of things.

