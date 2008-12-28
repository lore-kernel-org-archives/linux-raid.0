From: Mark Lord <liml@rtr.ca>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Sun, 28 Dec 2008 17:26:07 -0500
Message-ID: <4957FCFF.20606@rtr.ca>
References: <87f94c370812261344s3f70de25r4d132101d2247e00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370812261344s3f70de25r4d132101d2247e00@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Redeeman <redeeman@metanurb.dk>, piergiorgio.sartor@nexgo.de, neilb@suse.de, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Greg Freemyer wrote:
> All,
> 
> On the mdraid list, there was a recent thread about using raid
> functionality to detect / repair silent corruption.
> 
> The issues brought up were that a lot of silent data corruption occurs
> when cables, controllers, power supplies, ram, cache, etc. goes bad.
> 
> It made me think about another option for detecting silent corruption
> I have not seen discussed, but maybe I missed it.
> 
> Aiui, the ATA spec allows for the reading of a long sector as well as
> the normal 512 byte sector.  When you get a long sector you also get
> the CRC (or whatever checksum data there is on the disk that allows
> the drive itself to detect media errors).
> 
> I don't have any idea how easy or hard it would be to do, but I would
> like to see the entire block subsystem enhanced to optionally allow
> long sector reads to be used in a "paranoid" fashion.
> 
> Effectively it would be:
> 
> 1) Read long sector from drive:  verify CRC in kernel.  This tests
> most everything on the i/o path.
> 
> 2) maintain CRC type information in block subsystem.  Verify no
> corruption just before handing off to userspace.  This would
> potentially identify CPU/cache/RAM failures.
> 
> Mark Lord has implemented long sector reads via hdparm.  Mark can you
> comment on the feasibility of this idea?
..

The ATA READ/WRITE LONG commands have been obsoleted in the past few ATA specs,
even though most drives continue to implement them.

But not a good avenue.

There's a separate effort, involving drive vendors and kernel hackers,
to provide end-to-end CRC protection of data.  I forget what it was called,
but that's the future of this stuff for high-reliability requirements.

Cheers
