From: Tim Small <tim@buttersideup.com>
Subject: Re: read errors with md RAID5 array
Date: Mon, 15 Aug 2016 15:42:38 +0100
Message-ID: <b353161b-255e-e359-e3f4-800eac848847@buttersideup.com>
References: <78aab29c-9b7b-ff8b-f9c7-fab286f16243@buttersideup.com>
 <CAJCQCtSggAsQMSH9Ufa=Vjmu13cBm58+Q-RBZ4WRXm9UF=Yd+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtSggAsQMSH9Ufa=Vjmu13cBm58+Q-RBZ4WRXm9UF=Yd+Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/08/16 14:57, Chris Murphy wrote:
> $ sudo smartctl -l scterc <dev>   ## for each device used in the array
> $ sudo cat /sys/block/<dev>/device/timeout   ## for each device used
> in the array

These were all reporting:

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

However I'm not sure how this would cause a read error from the md
device itself?  There are no timeout/reset messages in the kernel logs
for the underlying SATA devices?

To check, I've set the ERC on all drives to 6.5 seconds for both reads
and writes, and restarted the "dd if=/dev/md2 of=/dev/null
conv=noerror", and it's just produced read failures at exactly the same
places, with no further kernel messages.

Some scenarios:

1. These are write-hole locations, and the md driver has recorded this
and is failing I/O here (didn't know it did this, and a quick read
through the raid5 code couldn't see this, BICBW as I was just skimming it).

2. Two underlying drives have I/O problems at these locations (but then
why no errors in kernel logs?).

3. Something's bad in the block or ATA layer.

... or something else.

Cheers,

Tim.
