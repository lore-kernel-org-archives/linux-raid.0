From: keld@keldix.com
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to make it more robust
Date: Wed, 18 Jul 2012 23:02:25 +0200
Message-ID: <20120718210225.GA21295@www5.open-std.org>
References: <20120718114935.GA29915@www5.open-std.org> <aa819a8e-1502-4a46-9840-45068d607306@zmail15.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aa819a8e-1502-4a46-9840-45068d607306@zmail15.collab.prod.int.phx2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jaromir Capik <jcapik@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 18, 2012 at 09:08:51AM -0400, Jaromir Capik wrote:
> > > Hello.
> > > 
> > > I'd like to ask you to implement the following ...
> > > 
> > > The current RAID1 solution is not robust enough to protect the data
> > > against random data corruptions. Such corruptions usually happen
> > > when an unreadable sector is found by the drive's electronics
> > > and when the drive's trying to reallocate the sector to the spare
> > > area.
> > > There's no guarantee that the reallocated data will always match
> > > the original stored data since the drive sometimes can't read the
> > > data
> > > correctly even with several retries. That unfortunately completely
> > > masks
> > > the issue, because the sector can be read by the OS without
> > > problems
> > > even if it doesn't contain correct data. Would it be possible
> > > to implement chunk checksums to avoid such data corruptions?
> > > If a corrupted chunk is encountered, it would be taken from the
> > > second
> > > drive and immediately synced back. This would have a small
> > > performance
> > > and capacity impact (1 sector per chunk to minimize performance
> > > impact
> > > caused by unaligned granularity = 0.78% of the capacity with 64k
> > > chunks).
> > > 
> > > Please, let me know if you find my request reasonable or not.
> > 
> > I believe alternative to that is implemented via the Linux RAID MD
> > badblock feature.
> 
> Hello keld ...
> 
> I couldn't find any info about that feature.  Could you please give
> me more info about that?

I do believe it is already implemented. I do not have the documentation.
But have a look in newer mdadm documentation or in the kernel sources,
or in he archives for this email list.

If you do find useful info, then please tell it here, and we can put the info on our wiki.
The wiki is now open again for modifications.
If you find out how to use it we could also add info on that to the wiki.

best regards
keld
