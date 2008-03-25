From: Nagy Zoltan <kirk@bteam.hu>
Subject: Re: xfs+md(raid5) xfssyncd & kswapd & pdflush hung in d-state
Date: Tue, 25 Mar 2008 05:00:34 +0100
Message-ID: <20080325050034.8df80de0.kirk@bteam.hu>
References: <20080319150508.GA3087@localhost.localdomain>
	<20080325032906.GC108924158@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080325032906.GC108924158@sgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: David Flynn <davidf@rd.bbc.co.uk>, daivdf@rd.bbc.co.uk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,

i've not run thru the whole report - but i think i've experienced the
same problem, the thread is: '2.6.24-rc6 reproducible raid5 hang'
and the solution was for my setup was to upgrade to 2.6.25-rc6
it doesn't occur using other fs - as a quick test you could try out
ext3/jfs

cheers,
kirk

> Added linux-raid to cc - this is not an XFS problem
> 
> Cheers,
> 
> Dave.
> 
> On Wed, Mar 19, 2008 at 03:05:10PM +0000, David Flynn wrote:
> > We are currently experiencing a problem with writing to xfs on a 20disk
> > raid5 array.  It seems very similar to a post in 2007nov09:
> > 
> >   Re: 2.6.23.1: mdadm/raid5 hung/d-state
> > 
> > Using kernel 2.6.24.  Unlike the previous post the array was in a clean
> > state so no resync was occuring.  We are able to read from the array,
> > but any process that writes joins the list of blocked tasks
> > 
> > The machine is:
> >   2 of dual core opteron 280
> >   16GiB RAM
> >   4 lots of 5 sata disks connected to sil3124 sata hba.
> >   Running 2.6.24
> > 
> > There was a single rsync process accessing the array at the time
> > (~40MB/sec).
> > 
> > Random other bits[1]:
> > # cat /sys/block/md1/md/stripe_cache_active
> > 256
> > # cat /sys/block/md1/md/stripe_cache_size  
> > 256
> > 
> > Example of sysrq-w:
> > 
