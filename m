From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm RAID1 -> 5 conversion safety
Date: Wed, 5 Feb 2020 18:29:57 +0000
Message-ID: <5E3B09A5.8010209@youngman.org.uk>
References: <CALZj-VqNACF+Dn5rBrLaVmvVE2weOAjqtvWpwKU7sE=72nyvXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALZj-VqNACF+Dn5rBrLaVmvVE2weOAjqtvWpwKU7sE=72nyvXg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Dann <pdgiddie@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/02/20 11:51, Paul Dann wrote:
> Hi there,
> 
> I've got a load of data on an md RAID 1 array assembled from 2x4TB
> disks. I'm looking to expand this by adding a third 4TB disk and
> converting the array to RAID 5. Now the required procedure is
> documented on the wiki, but my question is:
> 
> When I convert the RAID 1 array to RAID 5, the array will be in a
> degraded state as it rebuilds onto the new disk. However, if one of
> the original two disks were to fail during this procedure, is mdadm
> smart enough to convert the array back to degraded RAID 1, or will my
> array now be a broken RAID 5 with no path to recovery?

There is a "revert reshape" option which will take you back to a raid 1.
This assumes, however, that it's the new disk that has failed.

I'm pretty certain, however, that should one of the old disks fail
during the conversion you will end up with a degraded raid 5.

If you're worried, I would make sure you've done a SMART health check on
your two original drives, although that's no guarantee everything's okay.

If you really are that worried, get two new disks with the intention of
ending up at raid 6. Add a 3rd drive to the mirror, fail and remove one
of the originals, add the 4th to go raid 5, then add back the first to
go raid 6.

One thing I will say - MAKE SURE you have the latest mdadm, and if
possible make sure you're running a recent kernel. There have been
issues converting from 1 to 5. None of them serious, and all fixed by
upgrading mdadm/kernel, hence the advice to be running the latest/greatest.
> 
> Many thanks,
> Paul
> 
Cheers,
Wol
