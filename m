From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: mdadm --wait returns while array under construction?
Date: Wed, 21 Nov 2012 08:43:02 -0800
Message-ID: <1353516182.5795.39.camel@corn.betterworld.us>
References: <1353434141.27671.13.camel@corn.betterworld.us>
	 <20121121084357.41f2f9d9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121121084357.41f2f9d9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: ross@biostat.ucsf.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2012-11-21 at 08:43 +1100, NeilBrown wrote:
> On Tue, 20 Nov 2012 09:55:41 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrote:
> 
> > While switching the disks a RAID 1 is based on I used the --wait command
> > to wait for the rebuild to finish.  It returned immediately, but a
> > subsequent query showed it had not been rebuilt.  Have I misunderstood
> > something, or is this an error?
> > 
> > While doing these commands a much larger rebuild was going on with a
> > different array, involving some of the same physical disks but different
> > partitions.  The partitions being rebuilt are on different physical
> > disks for the different arrays.
> > 
> > Here are the logs, with version info at the end (Debian Lenny + more
> > recent kernel):
> ....
> 
> > markov:~# uname -a
> > Linux markov 2.6.32-5-amd64 #1 SMP Wed Jan 12 03:40:32 UTC 2011 x86_64 GNU/Linux
> > markov:~# mdadm --version
> > mdadm - v2.6.7.2 - 14th November 2008
> > 
> > 
> > I notice that in this case, unlike the other array, the message during
> > the rebuild (the last detail report) does not include a line like
> > Rebuild Status : 0% complete
> > 
> > I just tried --wait again to see if there was some kind of race, but
> > once again it returned immediately, though detail says the spare is
> > rebuilding.
> 
> Can you test this patch to see if it fixes the problem?
> 
> diff --git a/Monitor.c b/Monitor.c
> index c4d57c3..a5e7aaa 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -973,7 +973,7 @@ int Wait(char *dev)
>  			if (e->devnum == devnum)
>  				break;
>  
> -		if (!e || e->percent < 0) {
> +		if (!e || e->percent == RESYNC_NONE) {
>  			if (e && e->metadata_version &&
>  			    strncmp(e->metadata_version, "external:", 9) == 0) {
>  				if (is_subarray(&e->metadata_version[9]))
> 
> 
> NeilBrown
Thanks for the patch.  I take it the current behavior is expected, if
undesirable?

I'll try to apply it, but I'm in the middle of several system upgrades
and I may have trouble getting the source for the current system, since
it is out of date.

I spent most of yesterday dealing with various RAID problems, which I
will detail in a separate message.
Thanks.
Ross

