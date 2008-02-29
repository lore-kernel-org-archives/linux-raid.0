From: Franck Routier <franck.routier@axege.com>
Subject: Re: Understanding bonnie++ results
Date: Fri, 29 Feb 2008 10:26:09 +0100
Message-ID: <1204277169.11773.17.camel@franck-gusty>
References: <1204191989.16924.10.camel@franck-gusty>
	 <20080228190609.GA29262@rap.rap.dk> <1204273192.9381.63.camel@franck-gusty>
	 <20080229090238.GA3717@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080229090238.GA3717@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?ISO-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

> 
> OK. How fast are the Fujitsu disks, measured by a simple  hdparm -t?

Timing buffered disk reads:  270 MB in  3.02 seconds =  89.52 MB/sec

> 
> OK, so the problem you reported earlier, that HW raid was faster than
> raid10,f2 for writing, is gone?
> 
Well actually not for sequetial output. Here are the most comparable
figures:

4dk hw raid 10, 256k chunks versus 4dks md raid 10, 256k chunks
per char sequential output = 69475 vs 69928   <------ this is similar
block sequential output = 159649 vs 93985     <------ hw is much faster
rewrite sequential output = 85914 vs 56930    <------ hw is much faster

But on reading, md is faster:
per char sequential input = 61622 vs 68669    <------ still comparable
block sequential input = 221771 vs 356923     <------ md is way faster
ransom seek = 1327.1 vs 1149.7                <------ that's a 15.4%
difference

> And you do a HW RAID10? Are you able to specify chunk size here?

Yes, RAID10 is an option in Adaptec's bios, and chink size can be set up
to 512k

> > -sequential input varies greatly, the big winner being md-f2-256 setup
> > with 356923K/sec, and the big loser md-near-64 setup with 34888K/sec
> > (factor of 10 !)
> 
> Both the chunk size, and the observation that raid10,n2 only reads from one
> disk at a time, gives reasons to this. I already explained why raid10,f2
> would be faster than HW RAID10.
> 
True, and quite impressive.

> > - what seems the most relevant to me, random seeks are always better on
> > software raid, by 10 to 20%, but I have no idea why.
> 
> raid10.f2 woul only seek on half the disk, so that would diminish the
> seek times.
> 
Great. But in fact md raid 10 near layout (with 64k chunks, that might
matter), gave me slitghly better results than l2 (1347.3 for near versus
1327.1 for far)

> > - and running two bonnie++ in parallel on two 4 disks arrays gives
> > better iops than 6 disks arrays.
> 
> I would run a combined 12 disk array raid10,f2 with adequate chunk size,
> I think that would get the best performance for you.
> 
I will try that.

> > So I tend to think I'd better use md-f2-256 with 3 arrays of 4 disks and
> > use tablespaces to make sure my requests are spread out on the 3 arrays.
> > But this conclusion may suffer from many many flaws, the first one being
> > my understanding of raid, fs and io :)
> > 
> > So, any comment ?
> 
> I would try to test it out, but I don't know if you can get a good
> benchmark for database enquieries.

That's the real problem for sure. I can throw in some huge queries, but
kernel resources and postgresql.conf clearly will change things much
more than raw disk io. That why I thought of running several bonnie++
tests in parallel, and add random seek results to simulate database
reading...

Thanks
Franck



