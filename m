From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.27.10: ata1.00: HPA detected: current 293044655, native  
 293046768
Date: Sat, 3 Jan 2009 08:15:52 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901030813410.31871@p34.internal.lan>
References: <alpine.DEB.1.10.0812300657050.11356@p34.internal.lan> <495A5A9F.9020406@shaw.ca> <495B9ED3.8050008@rtr.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <495B9ED3.8050008@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 31 Dec 2008, Mark Lord wrote:

> Robert Hancock wrote:
>> Justin Piszcz wrote:
>>> On one system, two Raptor 150s:
>>> 
>>> [    0.739402] ata1.00: HPA detected: current 293044655, native 293046768
> ..
>> Presumably somebody or something set up a host protected area on one drive 
>> and not the other.. I believe there are some utilities out there that can 
>> be used to disable the HPA and allow the full capacity to be used.
> ..
>
> "hdparm -N" can do this, temporarily or permanently.
> Get the latest version from Sourceforge, and see the manpage for details.
>
> -ml
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Just incase someone Google's this later on, this is what it looks like,
for my case:

The /dev/sda (first disk) is the one with the problem.

root@Knoppix:~/hpa# hdparm -N /dev/sda

/dev/sda:
  max sectors   = 293044655/293046768, HPA is enabled
root@Knoppix:~/hpa# hdparm -N /dev/sdb

/dev/sdb:
  max sectors   = 293046768/293046768, HPA is disabled
root@Knoppix:~/hpa# hdparm -N p293046768 /dev/sda

/dev/sda:
  setting max visible sectors to 293046768 (permanent)
  max sectors   = 293046768/293046768, HPA is disabled
root@Knoppix:~/hpa#

root@Knoppix:~# hdparm -N /dev/sda

/dev/sda:
  max sectors   = 293046768/293046768, HPA is disabled
root@Knoppix:~#

1. I backed up the volume of the RAID-1 array.
2. Failed out the disk with the problem.
3. Then ran the commands above.
4. Reboot back to the OS.
5. Re-add the disk back into the RAID-1.


Justin.

