From: David Greaves <david@dgreaves.com>
Subject: Re: mdadm create corrupted md data?
Date: Wed, 07 May 2008 10:29:36 +0100
Message-ID: <48217680.10903@dgreaves.com>
References: <20080506054819.GA6413@merlins.org> <20080506230800.GL31536@merlins.org> <e9c3a7c20805062238l36674d8akffda7ea9aec78371@mail.gmail.com> <20080507065657.GA21697@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080507065657.GA21697@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc_news@merlins.org>
Cc: Dan Williams <dan.j.williams@gmail.com>, linux-raid@vger.kernel.org, richard@sauce.co.nz
List-Id: linux-raid.ids

Marc MERLIN wrote:
> After that, I get my pv back, and my VG.
> 
> I did try an e2fsck -f -n -C 0 /dev/dshelf2/space when in the configuration
> with sdd1 (i.e. the drive I first tried to rebuild parity on, until I found
> out it was sde1 that had bad sectors), and it is showing some pretty scary
> errors that probably show that my fs is mostly toast if I elect to use sdd1
> instead of sde1.
> Considering that sde1 is the soon to be dead drive, I guess backups is where
> I go next.

I would obtain a replacement drive for sde and use gnu ddrescue (dd with error
retries) to create an image on a reliable drive. Then re-create the array using
the replaced sde instead of sdd. You should have more luck that way.

If you still have fsck issues then I'd suggest that the futzing around may have
caused corruption.

David



