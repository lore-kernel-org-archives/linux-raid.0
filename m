From: NeilBrown <neilb@suse.de>
Subject: Re: high throughput storage server?
Date: Thu, 24 Mar 2011 17:33:43 +1100
Message-ID: <20110324173343.7d0491d8@notabene.brown>
References: <4D837DAF.6060107@hardwarefreak.com>
	<20110319090101.1786cc2a@notabene.brown>
	<4D8559A2.6080209@hardwarefreak.com>
	<20110320144147.29141f04@notabene.brown>
	<AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com>
	<4D868C36.5050304@hardwarefreak.com>
	<20110321024452.GA23100@www2.open-std.org>
	<4D875E51.50807@hardwarefreak.com>
	<20110321221304.GA900@www2.open-std.org>
	<20110322094658.GA21078@cthulhu.home.robinhill.me.uk>
	<20110322101403.GA9329@www2.open-std.org>
	<4D89B519.3020907@hardwarefreak.com>
	<AANLkTinONtwNh9KZKe98FL+u2GV_Fqaf1zR8eMyEDGBp@mail.gmail.com>
	<4D8ADC00.5010709@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D8ADC00.5010709@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, Keld =?ISO-8859-1?B?Svhybg==?= Simonsen <keld@keldix.com>, Mdadm <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

On Thu, 24 Mar 2011 00:52:00 -0500 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> If you write a file much smaller than the stripe size, say a 1MB file,
> to the filesystem atop this wide RAID10, the file will only be striped
> across 16 of the 192 spindles, with 64KB going to each stripe member, 16
> filesystem blocks, 128 sectors.  I don't know about mdraid, but with
> many hardware RAID striping implementations the remaining 176 disks in
> the stripe will have zeros or nulls written for their portion of the
> stripe for this file that is a tiny fraction of the stripe size. 

This doesn't make any sense at all.  No RAID - hardware or otherwise - is
going to write zeros to most of the stripe like this.  The RAID doesn't even
know about the concept of a file, so it couldn't.
The filesystem places files in the virtual device that is the array, and the
RAID just spreads those blocks out across the various devices.

There will be no space wastage.

If you have a 1MB file, then there is no way you can ever get useful 192-way
parallelism across that file.  Bit if you have 192 1MB files, then they will
be spread even across your spindles some how (depending on FS and RAID level)
and if you have multiple concurrent accessors, they could well get close to
192-way parallelism.

NeilBrown

