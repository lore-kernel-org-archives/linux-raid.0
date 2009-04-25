From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Fri, 24 Apr 2009 23:32:58 -0500
Message-ID: <20090425043301801.UXMF6537@cdptpa-omta02.mail.rr.com>
References: <49F21B75.7060705@sauce.co.nz>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F21B75.7060705@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> >> Quad core Xeon 2.8GHz md RAID6 of 16 x 750GB. Delete 20GB file:
> >>
> >> time rm -f dump
> >>
> >> real    0m1.849s
> >> user    0m0.000s
> >> sys     0m1.633s
> >
> > 3.2 GHz AMD Athlon 64 x 2 RAID6 of 10 x 1T:
> >
> > RAID-Server:/RAID/Recordings# ll sizetest.fil
> > -rw-rw-rw- 1 lrhorer users 27847620608 2009-04-24 03:21 sizetest.fil
> > RAID-Server:/RAID/Recordings# time rm sizetest.fil
> >
> > real    0m21.503s
> > user    0m0.000s
> > sys     0m6.852s
> >
> > See what I mean?  'Zero additional activity on the array other than the
> rm
> > task.  We'll see what happens with XFS.
> 
> Hi Leslie,
> 
> Regarding my previous post, I missed your comment about later growing
> the array, so what I said about mkfs.xfs automatically calculating the
> correct swidth/sunit sizes is correct initially, but once you grow the
> array, you will need to manaully calculate new values and these are
> applied as mount options.
> 
> I grew a 3 disk RAID5 to 4 disks and the write performance was
> definitely inferior until this was done.

Well, write performance is not generally a big issue with this array, as it
does vastly more reading than writing.  In any case, as long as the
parameters can be updated with a mount option, it's not a really big deal.
What about the read performance?  Is it badly impacted for pre-existing
files?  The files on this system are very static.  Once they are edited and
saved, they're pretty much permanent.

