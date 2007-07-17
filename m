From: Andrew Burgess <aab@cichlid.com>
Subject: Re: raid5:md3: read error corrected , followed by , Machine Check
Date: Tue, 17 Jul 2007 08:18:30 -0700
Message-ID: <200707171518.l6HFIUBU022021@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 	The 'MCE's have been ongoing for sometime .  I have replaced every item 
>in the system except the chassis & scsi backplane & power supply(750Watts) .
> 	Everything .  MB,cpu,memory,scsi controllers, ...
> 	These MCE's only happen when I am trying to build or bonnie++ test the 
>md3 .  It consists of (now 7+1spare) 146GB drives in the SuperMicro 
>SYS-6035B-8B's backplane attached to a LSI22320 .

Probably every old timer has a story about chasing a hardware problem
where changing the power supply finally fixed it. I keep spares now.

If an MCE (which means bad cpu) doesn't go away after changing the cpu
it would either have to be temperature, power or a bug in the MCE code.
What else could it be?

