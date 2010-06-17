From: "Graham Mitchell" <gmitch@woodlea.com>
Subject: RE: [md PATCH 00/16] bad block list management for md and RAID1
Date: Thu, 17 Jun 2010 11:53:40 -0400
Message-ID: <003901cb0e35$422f9020$c68eb060$@woodlea.com>
References: <20100606235833.13302.60932.stgit@notabene.brown> <hvd5iq$u83$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hvd5iq$u83$1@dough.gmane.org>
Content-language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Brett Russ' <bruss@netezza.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> This is a worthwhile addition, I think.  However, one concern we have is there
> appears to be no distinction between media errors (i.e. bad
> blocks) and other SCSI errors.

One thing I'd like to see would be being able to import a list of bad blocks from badblocks, and also have the ability for mdadm to be able to run a 'destructive' badblocks on the drives in the array, either at create/grow time, or on demand.

I say 'destructive' since it would be a bad thing (tm) if it truly were destructive on a live array, but it would be nice for mdadm to do the full destructive aa/55/ff/00 write/read/compare cycle on each disk, without actually being destructive to the data that's there. I am slightly paranoid (having been bitten in the bum in the past), so I do a full destructive badblocks on every disk BEFORE I add It to an array (and yes, it can take days when I have 3 or 4 1TB drives to add). It would be nice to be able to add the disks to the server untested, and let mdadm do the testing when it was doing the grow.


Graham


