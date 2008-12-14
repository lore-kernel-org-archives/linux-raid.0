From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Sun, 14 Dec 2008 19:33:36 +0100
Message-ID: <200812141933.37398.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am Sonntag 14 Dezember 2008 schrieben Sie:
> Am Sonntag 14 Dezember 2008 schrieb Peter Grandi:

> > But talking about barriers in the context of metadata, and for a
> > "benchmark" which has a metadata barrier every 11KB, and without
> > knowing whether the storage subsystem can queue multiple barrier
> > operations seems to be pretty crass and meangingless, if not
> > misleading. A waste of time at best.
>
> Hmmm, as far as I understood it would be that the IO scheduler would
> handle barrier requests itself if the device was not capable for
> queuing and ordering requests.
>
> Only thing that occurs to me know, that with barriers off it has more
> freedom to order requests and that might matter for that metadata
> intensive workload. With barriers it can only order 11 KB of requests.
> Without it could order as much as it wants... but even then the
> filesystem would have to make sure that metadata changes land in the
> journal first and then in-place. And this would involve a sync, if no
> barrier request was possible.

No it hasn't. As I do not think XFS or any other filesystem would be keen 
to see the IO scheduler reorder a journal write after a corresponding 
meta data in-place write. So either the filesystem uses sync...

> So I still don't get why even that metadata intense workload of tar -xf
> linux-2.6.27.tar.bz2 - or may better bzip2 -d the tar before - should
> be slower with barriers + write cache on than with no barriers and
> write cache off.

... or it tells the scheduler that this journal write should come prior to 
the later writes. This is what a barrier would do - except for that it 
cannot utilize any additional in-hardware /  in-firmware support.

So why on earth can write cache off +  barrier off be faster than write 
cache on + barrier on in *any workload*? There must be some technical 
detail that I miss.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
