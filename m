From: Phil Turmel <philip@turmel.org>
Subject: Re: All drive in Raid 5 are in 'spare' mode
Date: Wed, 11 Feb 2015 20:41:21 -0500
Message-ID: <54DC04C1.4010107@turmel.org>
References: <CAL7hTOctZ4tAoPSbO3iFEohRyXuvcY4=6yQj8U-FpoAhV6sT0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAL7hTOctZ4tAoPSbO3iFEohRyXuvcY4=6yQj8U-FpoAhV6sT0w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dush <tomdush@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Dush,

On 02/11/2015 02:56 PM, Dush wrote:
> Hi,
> 
> I have a RAID 5 composed by 4x 500Go hdd but for some days, it's 'inactive'.
> 
> I'm not raid expert and I prefer asking before doing an unrecoverable mistake...
> 
> Is it possible to fix this raid (md126)?
> Is it possible to recover data on it?

Probably.  Very good report, btw.

> Do I have a disk to change or it's "just" a desynchronization between disks?

One disk is now truly a spare (/dev/sdd3), which suggests you already
tried to '--add' it and didn't get anywhere.

Step one:  collect some forensics for later.  syslog or dmesg containing
your failure events.  Can be trimmed to just device and md stuff.
"smartctl -x /dev/sdX" for each drive involved in the arrays.

Then, we'll try the simple stuff.

Make sure the array is stopped with:

mdadm --stop /dev/md126

Then, force assemble it without sdd:

mdadm --assemble --force --verbose --run /dev/md126 /dev/sd[bce]3

If that works, mount it and catch a backup of critical files.

Then add your /dev/sdd3 back to the array and let it rebuild:

mdadm --add /dev/md126 /dev/sdd3

It may not make it through the rebuild if you have the common timeout
mismatch problem.[1]  Show the dmesg and smartctl data (pasted inline is
preferred) and we'll see.

Phil

Recent typical case:
[1] http://marc.info/?l=linux-raid&m=142353387024935&w=1

