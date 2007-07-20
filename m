From: Al Boldi <a1426z@gawab.com>
Subject: Re: [RFH] Partition table recovery
Date: Fri, 20 Jul 2007 14:29:44 +0300
Message-ID: <200707201429.44915.a1426z@gawab.com>
References: <200707200813.03553.a1426z@gawab.com> <46A05A84.6050305@wolfmountaingroup.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46A05A84.6050305@wolfmountaingroup.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Jeffrey V. Merkey wrote:
> Al Boldi wrote:
> >As always, a good friend of mine managed to scratch my partion table by
> >cat'ing /dev/full into /dev/sda.  I was able to push him out of the way,
> > but at least the first 100MB are gone.  I can probably live without the
> > first partion, but there are many partitions after that, which I hope
> > should easily be recoverable.
> >
> >I tried parted, but it's not working out for me.  Does anybody know of a
> >simple partition recovery tool, that would just scan the disk for lost
> >partions?
>
> One thing NetWare always did was to stamp a copy of the partition table
> at the time a partition was created as the second logical sector (offset
> 1) from the start of a newly created partition. This allowed the disk to
> be scanned for the original (or last) partition table copy.

This is really a good idea, as this would save you the trouble of 
reconstructing the table due to older overlapping entries.

Can linux do something like that?


Thanks!

--
Al

