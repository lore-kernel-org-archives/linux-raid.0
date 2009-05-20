From: raz ben yehuda <raziebe@gmail.com>
Subject: Re: Subject [ md PATCH 4/6] : md to support page size chunks in
	the case of raid 0
Date: Wed, 20 May 2009 16:30:11 +0300
Message-ID: <1242826211.3322.60.camel@raz>
References: <1242687989.21201.16.camel@raz>
	 <18962.444.630305.895248@notabene.brown> <20090520075117.GQ6403@skl-net.de>
	 <18963.55483.993420.606497@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18963.55483.993420.606497@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Wed, 2009-05-20 at 20:17 +1000, Neil Brown wrote:
> On Wednesday May 20, maan@systemlinux.org wrote:
> > On Tue, May 19, 2009 at 10:47:56AM +1000, Neil Brown wrote:
> > 
> > > And 'temp' should be 'sector_t'.  'sector_div' requires a 'sector_t'
> > > for the first argument.
> > 
> > ...
> > 
> > > Again, temp must be sector_t.
> > 
> > How about rolling our own md_sector_div() which at least checks for
> > such bugs via the
> > 
> >         (void)(((typeof((temp)) *)0) == ((sector_t *)0))
> > 
> > trick?
nice. did not know typeof is available in c. 
> Interesting idea..
> You would still need to eyeball that code to make sure md_sector_div
> was used instead of sector_div, though I guess that is more obvious..
> Maybe sector_div should have that test in it globally...
> Though I've actually hit more problems with the second arg not being
> "unsigned long" like it should be.
> 
> > 
> > > > @@ -3996,14 +4001,23 @@ static int do_md_run(mddev_t * mddev)
> > > >  				chunk_size, MAX_CHUNK_SIZE);
> > > >  			return -EINVAL;
> > > >  		}
> > > > +
> > > >  		/*
> > > >  		 * chunk-size has to be a power of 2
> > > >  		 */
> > > > -		if ( (1 << ffz(~chunk_size)) != chunk_size) {
> > > > +		if ((1 << ffz(~chunk_size)) != chunk_size &&
> > > > +			 mddev->level != 0) {
> > > >  			printk(KERN_ERR "chunk_size of %d not valid\n", chunk_size);
> > > >  			return -EINVAL;
> > > >  		}
> > > 
> > > I wold really like to remove any knowledge about specific raid levels
> > > from the common (md.c) code and keep it all in the personality modules
> > > (is that a job for you Andre ??).
> > > So I definitely don't want to add a test for ->level here.
> > > 
> > > So I would like to see the tests for chunk_size removed do_md_run and
> > > included in each personalities ->run function.  This would be a series
> > > of patches that adds the checks in ->run where needed, then removes it
> > > from md.c.  Would you like to do that?
> > 
> > Sure, I can give it a try. Though I'm not sure I fully understand
> > what would be the difference between the checks in the individual
> > ->run functions. Currently, in do_md_run() we check that
> > 
> >         * chunk_size <= MAX_CHUNK_SIZE
> >         * chunk_size is a power of two
> >         * the rdev is at least one chunk large
> > 
> > None of these checks depend on the raid level, so the above change
> > that allows chunk sizes which are not a power of two for raid0 would
> > be the only difference. Are you anticipating that the requirements
> > of the various raid levels with respect to chunk size will further
> > diverge in the future?
> 
> The second paragraph is already done (in for-next).  md.c doesn't
> check chunksize any more, that is only checked in personality modules
> that care.
> 
> What I was suggesting for you is the previous paragraph.  Removing all
> knowledge about specific raid levels from md.c.
> So where ever md.c tests the value for mddev->level, ask the question:
> how can this information be extracted from the module rather than
> having this hard-coded test.
> 
> Probably the easiest would be moving
> 
> 
> 	if (mddev->recovery_cp != MaxSector &&
> 	    mddev->level >= 1)
> 		printk(KERN_ERR "md: %s: raid array is not clean"
> 		       " -- starting background reconstruction\n",
> 		       mdname(mddev));
> 
> into various ->run methods.
> Probably the hardest would be all the messing with LEVEL_MULTIPATH.
> Somewhere in between would be the tests for which levels support
> bitmaps.
> 
> In general, we just want to delay the test until we are in personality
> code and do it there.
why not add a new method ? pers->validate_parms ?  
> Does that make sense?
> 
> Thanks,
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

