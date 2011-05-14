From: CoolCold <coolthecold@gmail.com>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sat, 14 May 2011 12:41:36 +0400
Message-ID: <BANLkTimBcZizneKK3+32BmQXHRKgGpjckQ@mail.gmail.com>
References: <20110513202900.GA1926@apartia.fr>
	<20110514073347.15dae0b8@notabene.brown>
	<20110514082159.GA306@apartia.fr>
	<BANLkTinpJQDR=0Qnu1tS-82T=OTi37aBMQ@mail.gmail.com>
	<20110514143613.7ec29ac4@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110514143613.7ec29ac4@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 14, 2011 at 12:36 PM, Roman Mamedov <rm@romanrm.ru> wrote:
> On Sat, 14 May 2011 12:27:45 +0400
> CoolCold <coolthecold@gmail.com> wrote:
>
>> This is just one more live example for partitions vs disks setups.
>
> Well, they did use partitions, but what do you do when the new RAID controller
> bites off a whopping 100 million bytes from the end of your disk? I use
> partitions too, and do leave some space at the end for cases like this, but
> what I leave is just 8 MB (enough for the Gigabyte motherboards HPA), not
> 100+. Would you suggest setting aside 500MB, 1GB just in case?
I've always (well, after switching to partitions) used something near
80mb, for the last servers using ~ 160mb
root@kappa2:~# parted /dev/cciss/c0d1 print free
Model: Compaq Smart Array (cpqarray)
Disk /dev/cciss/c0d1: 1000GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End     Size    Type     File system  Flags
 1      16.4kB  1000GB  1000GB  primary
        1000GB  1000GB  168MB            Free Space


>
> --
> With respect,
> Roman
>



-- 
Best regards,
[COOLCOLD-RIPN]
