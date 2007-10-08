From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: very degraded RAID5, or increasing capacity by adding discs
Date: Tue, 09 Oct 2007 02:52:06 +0400
Message-ID: <470AB496.5010406@msgid.tls.msk.ru>
References: <20071008211313.6cd8bbb5@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071008211313.6cd8bbb5@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki wrote:
> Hello,
> 
> Recently I started to use mdadm and I'm very impressed by its
> capabilities. 
> 
> I have raid0 (250+250 GB) on my workstation. And I want to have
> raid5 (4*500 = 1500 GB) on my backup machine.

Hmm.  Are you sure you need that much space on the backup, to
start with?  Maybe better backup strategy will help to avoid
hardware costs?  Such as using rsync for backups as discussed
on this mailinglist about a month back (rsync is able to keep
many ready to use copies of your filesystems but only store
files that actually changed since the last backup, thus
requiring much less space than many full backups).

> The backup machine currently doesn't have raid, just a single 500 GB
> drive. I plan to buy more HDDs to have a bigger space for my
> backups but since I cannot afford all HDDs at once I face a problem
> of "expanding" an array. I'm able to add one 500 GB drive every few
> months until I have all 4 drives.
> 
> But I cannot make a backup of a backup... so reformatting/copying all
> data each time when I add new disc to the array is not possible for me.
> 
> Is it possible anyhow to create a "very degraded" raid array - a one
> that consists of 4 drives, but has only TWO ?
> 
> This would involve some very tricky *hole* management on the block
> device... A one that places holes in stripes on the block device,
> until more discs are added to fill the holes. When the holes are
> filled, the block device grows bigger, and with lvm I just increase
> the filesystem size. This is perhaps coupled with some "unstripping"
> that moves/reorganizes blocks around to fill/defragment the holes.

It's definitely not possible with raid5.  Only option is to create a
raid5 array consisting of less drives than it should contain at the
end, and reshape it when you get more drives, as others noted in this
thread.  But do note the following points:

o degraded raid5 isn't really Raid - i.e, it's not any better than
  a raid0 array, that is, any disk fails => the whole array fails.
  So instead of creating a degraded raid5 array initially, create
  smaller one instead, but not degraded, and reshape it when
  necessary.

o reshaping takes time, and for this volume, reshape will take
  many hours, maybe days, to complete.

o During this reshape time, errors may be fatal to the whole array -
  while mdadm do have a sense of "critical section", but the
  whole procedure isn't as much tested as the rest of raid code,
  I for one will not rely on it, at least for now.  For example,
  a power failure at an "unexpected" moment, or some plain-stupid
  error in reshape code so that the whole array goes "boom" etc...

o A filesystem on the array has to be resized separately after
  re{siz,shap}ing the array.  And filesystems are different at
  this point, too - there are various limitations.  For example,
  it's problematic to grow ext[23]fs by large amounts, because
  when it gets initially created, mke2fs calculates sizes of
  certain internal data structures based on the device size,
  and those structures can't be grown significantly, only
  recreating the filesystem will do the trick.

> is it just a pipe dream?

I'd say it is... ;)

/mjt
