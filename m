From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: raid6 - data integrity issue - data mis-compare on rebuilding
 RAID 6 - with 100 Mb resync speed.
Date: Wed, 23 Apr 2014 13:03:42 +0300
Message-ID: <20140423100342.GK18930@reaktio.net>
References: <13688C12F44C7C428726663F950CA2530972DC8C@venus.in.megatrends.com>
 <20140423091924.GG18930@reaktio.net>
 <13688C12F44C7C428726663F950CA2530985D414@venus.in.megatrends.com>
 <20140423093053.GH18930@reaktio.net>
 <13688C12F44C7C428726663F950CA2530985D41F@venus.in.megatrends.com>
 <20140423094516.GJ18930@reaktio.net>
 <13688C12F44C7C428726663F950CA2530985D434@venus.in.megatrends.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <13688C12F44C7C428726663F950CA2530985D434@venus.in.megatrends.com>
Sender: linux-raid-owner@vger.kernel.org
To: Manibalan P <pmanibalan@amiindia.co.in>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Wed, Apr 23, 2014 at 03:29:34PM +0530, Manibalan P wrote:
> >On Wed, Apr 23, 2014 at 03:03:21PM +0530, Manibalan P wrote:
> >> >On Wed, Apr 23, 2014 at 02:55:15PM +0530, Manibalan P wrote:
> >> >> >On Fri, Apr 11, 2014 at 05:41:12PM +0530, Manibalan P wrote:
> >> >> >> Hi Neil,
> >> >> >> 
> >> >> >> Also, I found the data corruption issue on RHEL 6.5.
> >> >> >> 
> >> >> 
> >> >> >Did you file a bug about the corruption to redhat bugzilla?
> >> >> 
> >>>> Yes, today I raised a support ticket with Redhat regarding this issue.
> >>>> 
> >> 
> >> >Ok, good. Can you paste the bz# ?
> >> 
> >> https://access.redhat.com/support/cases/01080080/
> >> 
> 
> >Hmm, I can't access that, do you have an url for bugzilla.redhat.com (which is the public bug tracker) ? 
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1090423
> 
> please look at the above link, I created one now.
> 

Great, thanks!

> Manibalan.


-- Pasi

> >-- Pasi
> 
> > manibalan
> >  
> > >
> > >-- Pasi
> > 
> > > Manibalan
> > > 
> > > >-- Pasi
> > > 
> > > > For your kind attention, I up-ported the md code [raid5.c + 
> > > > raid5.h] from FC11 kernel to CentOS 6.4, and there is no 
> > > > mis-compare with the up-ported code.
> > > > 
> > > > Thanks,
> > > > Manibalan.
> > > > 
> > > > -----Original Message-----
> > > > From: Manibalan P
> > > > Sent: Monday, March 24, 2014 6:46 PM
> > > > To: 'linux-raid@vger.kernel.org'
> > > > Cc: neilb@suse.de
> > > > Subject: RE: raid6 - data integrity issue - data mis-compare on 
> > > > rebuilding RAID 6 - with 100 Mb resync speed.
> > > > 
> > > > Hi,
> > > > 
> > > > I have performed the following tests to narrow down the integrity issue.
> > > > 
> > > > 1. RAID 6, single drive failure - NO ISSUE
> > > > 	a. Running IO
> > > > 	b. mdadm set faulty and remove a drive
> > > > 	c. mdadm add the drive back
> > > >  There is no mis-compare happen in this path.
> > > > 
> > > > 2. RAID 6, two drive failure - write during Degrade and verify 
> > > > after rebuild
> > > > 	a. remove two drives, to make the RAID array degraded.
> > > > 	b. now run write IO write cycle, wait till the write cycle completes
> > > > 	c. insert the drives back one by one, and wait till the re-build 
> > > > completes and a RAID array become optimal.
> > > > 	d. now perform the verification cycle.
> > > > There is no mis-compare happened in this path also.
> > > > 
> > > > During All my test, the sync_Speed_max and min is set to 100Mb
> > > > 
> > > > So, as you referred in your previous mail, the corruption might be 
> > > > happening only during resync and IO happens in parallel.
> > > > 
> > > > Also, I tested with upstream 2.6.32 kernel from git:
> > > > "http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/ - 
> > > > tags/v2.6.32"
> > > > 	And I am facing mis-compare issue in this kernel as well.  on 
> > > > RAID 6, two drive failure with high sync_speed.
> > > > 
> > > > Thanks,
> > > > Manibalan.
> > > > 
> > > > -----Original Message-----
> > > > From: NeilBrown [mailto:neilb@suse.de]
> > > > Sent: Thursday, March 13, 2014 11:49 AM
> > > > To: Manibalan P
> > > > Cc: linux-raid@vger.kernel.org
> > > > Subject: Re: raid6 - data integrity issue - data mis-compare on 
> > > > rebuilding RAID 6 - with 100 Mb resync speed.
> > > > 
> > > > On Wed, 12 Mar 2014 13:09:28 +0530 "Manibalan P"
> > > > <pmanibalan@amiindia.co.in>
> > > > wrote:
> > > > 
> > > > > >
> > > > > >Was the array fully synced before you started the test?
> > > > > 
> > > > > Yes , IO is started, only after the re-sync is completed.
> > > > >  And to add more info,
> > > > >              I am facing this mis-compare only with high resync 
> > > > > speed (30M to 100M), I ran the same test with resync speed min 
> > > > > -10M and max
> > > > > - 30M, without any issue. So the  issue has relationship with 
> > > > > sync_speed_max / min.
> > > > 
> > > > So presumably it is an interaction between recovery and IO.  Maybe 
> > > > if we write to a stripe that is being recoverred, or recover a 
> > > > stripe that is being written to, then something gets confused.
> > > > 
> > > > I'll have a look to see what I can find.
> > > > 
> > > > Thanks,
> > > > NeilBrown
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-raid" 
> > > > in the body of a message to majordomo@vger.kernel.org More 
> > > > majordomo info at  http://vger.kernel.org/majordomo-info.html
