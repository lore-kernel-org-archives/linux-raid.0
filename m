From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: confused raid1
Date: Mon, 15 Aug 2005 17:55:43 +0200
Message-ID: <ddqdtv$3m1$1@sea.gmane.org>
References: <Pine.LNX.4.61.0508151131020.10349@soloth.lewis.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Lewis <jlewis@lewis.org> wrote:
> I've inheritted responsibility for a server with a root raid1 that 
> degrades every time the system is rebooted.  It's a 2.4.x kernel.  I've 
...
> The raid1 device is supposed to be /dev/hde1 & /dev/hdg1 with /dev/hdc1 as 
...
> When the system reboots, md1 becomes just /dev/hdc1.  I've used mdadm to 

Well, reading the kernel boot messages could help.
Perhaps, the hdc1 partition is type fd (raid autodetect) and the driver
for hd[eg] is not in place when the RAID Autodetection is running.


regards
   Mario
-- 
We are the Bore. Resistance is futile. You will be bored.

