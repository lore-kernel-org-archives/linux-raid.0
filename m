From: Shaohua Li <shli@kernel.org>
Subject: Re: RAID creation resync behaviors
Date: Wed, 3 May 2017 19:04:52 -0700
Message-ID: <20170504020452.kcmjgxnk7zsx7kdx@kernel.org>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
 <87inlhpgzu.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87inlhpgzu.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, jes.sorensen@gmail.com, neilb@suse.de
List-Id: linux-raid.ids

On Thu, May 04, 2017 at 11:07:01AM +1000, Neil Brown wrote:
> On Wed, May 03 2017, Shaohua Li wrote:
> 
> > Hi,
> >
> > Currently we have different resync behaviors in array creation.
> >
> > - raid1: copy data from disk 0 to disk 1 (overwrite)
> > - raid10: read both disks, compare and write if there is difference (compare-write)
> > - raid4/5: read first n-1 disks, calculate parity and then write parity to the last disk (overwrite)
> > - raid6: read all disks, calculate parity and compare, and write if there is difference (compare-write)
> 
> The approach taken for raid1 and raid4/5 provides the fastest sync for
> an array built on uninitialised spinning devices.
> RAID6 could use the same approach but would involve more CPU and so
> the original author of the RAID6 code (hpa) chose to go for the low-CPU
> cost option.  I don't know if tests were done, or if they would still be
> valid on new hardware.
> The raid10 approach comes from "it is too hard to optimize in general
> because different RAID10 layouts have different trade-offs, so just
> take the easy way out."

ok, thanks for the explanation! 
> >
> > Write whole disk is very unfriendly for SSD, because it reduces lifetime. And
> > if user already does a trim before creation, the unncessary write could make
> > SSD slower in the future. Could we prefer compare-write to overwrite if mdadm
> > detects the disks are SSD? Surely sometimes compare-write is slower than
> > overwrite, so maybe add new option in mdadm. An option to let mdadm trim SSD
> > before creation sounds reasonable too.
> 
> An option to ask mdadm to trim the data space and then --assume-clean
> certainly sounds reasonable.

This doesn't work well. read returns 0 for trimmed data space in some SSDs, but
not all. If not, we will have trouble.

> One possible approach would be to use compare-write until some
> threshold of writes were crossed, then switch to over-write.  That could
> work well for RAID1, but could be awkward to manage for RAID5.
> Possibly mdadm could read the first few megas of each device in RAID5
> and try to guess if many writes will be needed.  If they will, the
> current approach is best.  If not, assemble the array so that
> compare-write is used.

I think this makes sense if we do trim first, assume in most SSDs read return 0
for trimmed space. Maybe trim first, and check if read returns 0. If returns 0,
do compare-write (even assume-clean), otherwise overwrite.

> I'm in favour of providing options and making the defaults "not
> terrible".  I think they currently are "not terrible", but maybe they
> can be better in some cases.

Agree, more options are required.

Thanks,
Shaohua
