From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Strange intermittant errors + RAID doesn't fail the disk.
Date: Sat, 1 Jul 2006 08:13:23 +0200
Message-ID: <bb145bd20606302313x557f94d8xd69cce83731e2a4b@mail.gmail.com>
References: <bb145bd20606300932x2268822k78561e549996aef3@mail.gmail.com>
	 <17573.52096.655463.808666@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17573.52096.655463.808666@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Looks very much like a problem with the SATA controller.
> If the repeat look you have shown there is an "infinite" loop, then
> presumably some failure is not being handled properly.

I agree, even though the AHCI driver was supposed to be stable. The
loop is not quite infinite btw., it does time out after a few minutes.

> I suggest you find a SATA related mailing list to post this to (Look
> in the MAINTAINERS file maybe) or post it to linux-kernel.

Will do. linux-ide should do the trick.

> I doubt this is directly related to the raid code at all.

The only problem I see with the RAID code is that it does not fail the
disk when it hangs in this way. How is this possible? The libata
driver shows lots of errors and even if md does not react to these
there should be a (short) timeout for the request somewhere.

The disks do have limited integrated error correction, because RAID
controllers like to handle that themselves - could that have something
to do with it? Marketing blurb:

[...] Inside a RAID system, where the RAID controller handles error
recovery, the drive needn't pause for extended periods to recover
data. In fact, heroic error recovery attempts can cause a RAID system
to drop a drive out of the array. WD RE2 is engineered to prevent hard
drive error recovery fallout by limiting the drive's error recovery
time. With error recovery factory set to seven seconds, the drive has
time to attempt a recovery, allow the RAID controller to log the
error, and still stay online. [...]

> Good luck :-)

Thanks :)

C.
