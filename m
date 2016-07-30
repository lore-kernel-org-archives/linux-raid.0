From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: Prevent IO hold during accessing to failed raid5
 array
Date: Sat, 30 Jul 2016 14:01:20 -0700
Message-ID: <20160730210120.GA9149@kernel.org>
References: <1468589067-1966-1-git-send-email-aleksey.obitotskiy@intel.com>
 <20160719224603.GB79792@kernel.org>
 <1469783178.2660.21.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469783178.2660.21.camel@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Obitotskiy, Aleksey" <aleksey.obitotskiy@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jul 29, 2016 at 09:07:43AM +0000, Obitotskiy, Aleksey wrote:
> Hello,
> 
> I would like to know what the status of this patch.
> Maybe I should provide more info about?

I'm in vacation, so response is slow, sorry. Please reorganize the patch log
and mention this is for external managed array. What's the s.failed <=
conf->max_degraded check for?

Thanks,
Shaohua

> 
> Regards,
> Aleksey
> 
> On Tue, 2016-07-19 at 15:46 -0700, Shaohua Li wrote:
> > On Fri, Jul 15, 2016 at 03:24:27PM +0200, Alexey Obitotskiy wrote:
> > > 
> > > After array enters in failed state (e.g. number of failed drives
> > > becomes more then accepted for raid5 level) it sets error flags
> > > (one of this flags is MD_CHANGE_PENDING). This flag prevents to
> > > finish all new or non-finished IOs to array and hold them in
> > > pending state. In some cases this can leads to deadlock situation.
> > > 
> > > For example udev handle array state changes (drives becomes faulty)
> > > and blkid started but unable to finish reads due to IO hold.
> > > At the same time we unable to get exclusive access to array
> > > (to stop array in our case) because another external application
> > > still use this array (blkid in our case).
> > > 
> > > Fix makes possible to return IO with errors immediately.
> > > So external application can finish working with array and
> > > give exclusive access to other applications.
> > > 
> > > Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
> > > ---
> > >  drivers/md/raid5.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > index 6c1149d..99471b6 100644
> > > --- a/drivers/md/raid5.c
> > > +++ b/drivers/md/raid5.c
> > > @@ -4692,7 +4692,9 @@ finish:
> > >  	}
> > >  
> > >  	if (!bio_list_empty(&s.return_bi)) {
> > > -		if (test_bit(MD_CHANGE_PENDING, &conf->mddev-
> > > >flags)) {
> > > +		if (test_bit(MD_CHANGE_PENDING, &conf->mddev-
> > > >flags) &&
> > > +				(s.failed <= conf->max_degraded ||
> > > +					conf->mddev->external ==
> > > 0)) {
> > >  			spin_lock_irq(&conf->device_lock);
> > >  			bio_list_merge(&conf->return_bi,
> > > &s.return_bi);
> > >  			spin_unlock_irq(&conf->device_lock);
