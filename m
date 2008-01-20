From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: how to create a degraded raid1 with only 1 of 2 drives ??
Date: Sun, 20 Jan 2008 17:12:22 -0500
Message-ID: <4793C746.5040707@tmr.com>
References: <20080120192801.GA11149@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080120192801.GA11149@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mitchell Laks wrote:
> Hi mdadm raid gurus,
>
> I wanted to make a raid1 array, but at the moment I have only 1 drive available. The other disk is
> in the mail. I wanted to make a raid1 that i will use as a backup.
>
> But I need to do the backup now, before the second drive comes.
>
> So I did this.
>
> formated /dev/sda creating /dev/sda1 with type fd.
>
> then I tried to run
> mdadm -C /dev/md0 --level=1 --raid-devices=1 /dev/sda1
>
> but I got an error message
> mdadm: 1 is an unusual numner of drives for an array so it is probably a mistake. If you really
> mean it you will need to specify --force before setting the number of drives
>
> so then i tried
>
> mdadm -C /dev/md0 --level=1 --force --raid-devices=1 /dev/sda1
> mdadm: /dev/sda1 is too small:0K
> mdadm: create aborted
>
> now what does that mean?
>
> fdisk -l /dev/sda  shows
>
> device boot	start	end	blocks 	Id	System
> /dev/sda1 	1	60801	488384001 fd	linux raid autodetect
>
> so what do I do?
>
>
> I need to back up my data.
> If I simply format /dev/sda1 as an ext3 file system then I can't "add" the second drive later on.
>
> How can I  set it up as a `degraded` raid1 array so I can later on add in the second drive and sync?
>   

Specify two drives and one as missing.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


