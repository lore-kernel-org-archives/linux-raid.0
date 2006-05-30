From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Can't get drives containing spare devices to spindown
Date: Tue, 30 May 2006 12:39:01 -0400
Message-ID: <447C7525.4010100@tmr.com>
References: <446395C0.5060502@debruin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <446395C0.5060502@debruin.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Marc L. de Bruin" <marc@debruin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Did I miss an answer to this? As the weather gets hotter I'm doing all I 
can to reduce heat.

Marc L. de Bruin wrote:

> Lo,
>
> Situation: /dev/md0, type raid1, containing 2 active devices 
> (/dev/hda1 and /dev/hdc1) and 2 spare devices (/dev/hde1 and /dev/hdg1).
>
> Those two spare 'partitions' are the only partitions on those disks 
> and therefore I'd like to spin down those disks using hdparm for 
> obvious reasons (noise, heat). Specifically, 'hdparm -S <value> 
> <device>' sets the standby (spindown) timeout for a drive; the value 
> is used by the drive to determine how long to wait (with no disk 
> activity) before turning off the spindle motor to save power.
>
> However, it turns out that md actually sort-of prevents those spare 
> disks to spindown. I can get them off for about 3 to 4 seconds, after 
> which they immediately spin up again. Removing the spare devices from 
> /dev/md0 (mdadm /dev/md0 --remove /dev/hd[eg]1) actually solves this, 
> but I have no intention actually removing those devices.
>
> How can I make sure that I'm actually able to spin down those two 
> spare drives? 



-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

