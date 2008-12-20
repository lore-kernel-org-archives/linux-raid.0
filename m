From: Kevin Shanahan <kmshanah@disenchant.net>
Subject: Re: Read errors and SMART tests
Date: Sat, 20 Dec 2008 15:52:44 +1030
Message-ID: <20081220052244.GN1749@cubit>
References: <20081220013043.GM1749@cubit> <A20315AE59B5C34585629E258D76A97C031B1B62@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A20315AE59B5C34585629E258D76A97C031B1B62@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 19, 2008 at 10:13:14PM -0600, David Lethe wrote:
> This shows nothing more than you having a single bad block.  You have a
> 1TB drive, for crying out loud, they can't all stay perfect ;)

Heh, true.

> This is no reason to assume the disk is bad, or that it has anything to
> do with cabling.   When you wrote you have 
> read "errors" .. does that mean you have dozens, hundreds of individual
> unreadable blocks, or 
> could you just have just this one bad block.

Sorry, I didn't provide a lot of detail there. The "bad" drive,
/dev/sdd was doing more than just failing the self test:

Dec 20 06:55:20 hermes kernel: ata4.00: exception Emask 0x0 SAct 0x5 SErr 0x0 action 0x0
Dec 20 06:55:20 hermes kernel: ata4.00: irq_stat 0x40000008
Dec 20 06:55:20 hermes kernel: ata4.00: cmd 60/78:10:47:d5:fa/00:00:1e:00:00/40 tag 2 ncq 61440 in
Dec 20 06:55:20 hermes kernel:          res 51/40:00:b9:d5:fa/00:00:1e:00:00/40 Emask 0x409 (media error) <F>
Dec 20 06:55:20 hermes kernel: ata4.00: status: { DRDY ERR }
Dec 20 06:55:20 hermes kernel: ata4.00: error: { UNC }
Dec 20 06:55:20 hermes kernel: ata4.00: configured for UDMA/133
Dec 20 06:55:20 hermes kernel: ata4: EH complete
Dec 20 06:55:20 hermes kernel: sd 3:0:0:0: [sdd] 1953525168 512-byte hardware sectors (1000205 MB)
Dec 20 06:55:20 hermes kernel: sd 3:0:0:0: [sdd] Write Protect is off
Dec 20 06:55:20 hermes kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Dec 20 06:55:20 hermes kernel: sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

(repeats several times)

Dec 20 06:55:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 519755016 on sdd1)
Dec 20 06:55:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 519755024 on sdd1)
Dec 20 06:55:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 519755032 on sdd1)
Dec 20 06:55:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 519755040 on sdd1)
Dec 20 06:55:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 519755048 on sdd1)
Dec 20 06:55:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 519755056 on sdd1)
Dec 20 06:55:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 519755064 on sdd1)
Dec 20 06:55:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 519755072 on sdd1)
Dec 20 06:55:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 519755080 on sdd1)
Dec 20 06:55:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 519755088 on sdd1)

...

Dec 20 07:04:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 613165696 on sdd1)
Dec 20 07:04:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 613165704 on sdd1)
Dec 20 07:04:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 613165712 on sdd1)
Dec 20 07:04:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 613165720 on sdd1)
Dec 20 07:04:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 613165728 on sdd1)
Dec 20 07:04:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 613165736 on sdd1)
Dec 20 07:04:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 613165744 on sdd1)
Dec 20 07:04:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 613165752 on sdd1)
Dec 20 07:04:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 613165760 on sdd1)
Dec 20 07:04:30 hermes kernel: raid5:md5: read error corrected (8 sectors at 613165768 on sdd1)

...

Dec 20 07:04:47 hermes kernel: raid5:md5: read error corrected (8 sectors at 613181440 on sdd1)
Dec 20 07:04:47 hermes kernel: raid5:md5: read error corrected (8 sectors at 613181448 on sdd1)
Dec 20 07:04:47 hermes kernel: raid5:md5: read error corrected (8 sectors at 613181456 on sdd1)
Dec 20 07:04:47 hermes kernel: raid5:md5: read error corrected (8 sectors at 613181464 on sdd1)
Dec 20 07:04:47 hermes kernel: raid5:md5: read error corrected (8 sectors at 613181472 on sdd1)
Dec 20 07:04:47 hermes kernel: raid5:md5: read error corrected (8 sectors at 613181480 on sdd1)
Dec 20 07:04:47 hermes kernel: raid5:md5: read error corrected (8 sectors at 613181488 on sdd1)
Dec 20 07:04:47 hermes kernel: raid5:md5: read error corrected (8 sectors at 613181496 on sdd1)
Dec 20 07:04:47 hermes kernel: raid5:md5: read error corrected (8 sectors at 613181504 on sdd1)
Dec 20 07:04:47 hermes kernel: raid5:md5: read error corrected (8 sectors at 613181512 on sdd1)

...

Dec 20 08:10:09 hermes kernel: raid5:md5: read error corrected (8 sectors at 613552584 on sdd1)
Dec 20 08:10:09 hermes kernel: raid5:md5: read error corrected (8 sectors at 613552592 on sdd1)
Dec 20 08:10:09 hermes kernel: raid5:md5: read error corrected (8 sectors at 613552600 on sdd1)
Dec 20 08:10:09 hermes kernel: raid5:md5: read error corrected (8 sectors at 613552608 on sdd1)
Dec 20 08:10:09 hermes kernel: raid5:md5: read error corrected (8 sectors at 613552616 on sdd1)
Dec 20 08:10:09 hermes kernel: raid5:md5: read error corrected (8 sectors at 613552624 on sdd1)
Dec 20 08:10:09 hermes kernel: raid5:md5: read error corrected (8 sectors at 613552632 on sdd1)

...

Dec 20 08:16:19 hermes kernel: raid5:md5: read error corrected (8 sectors at 613020008 on sdd1)

That's just a sample from today - it's been doing similar things for
several days.  So the drive was hanging in there in the array, thanks
to the error correction, but it was of course impacting performance.

Anyway, when I put the replacement drive in I decided to do a self
test before adding it to the array and I guess I was a bit concerned
that it immediately failed the test. Since it was inserted into the
same slot in the drive cage, same cable, etc. I wondered if those
factors can affect a self test. My assumption was no, but I thought
I'd ask.

Cheers,
Kevin.
