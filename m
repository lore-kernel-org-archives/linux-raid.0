From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm GIT PULL] rebuild checkpoints, incremental assembly,
 volume delete/rename, and fixes
Date: Tue, 6 Jul 2010 14:50:43 +1000
Message-ID: <20100706145043.107f7f76@notabene.brown>
References: <1274921452.17973.253.camel@dwillia2-linux>
	<20100531113710.29e12d97@notabene.brown>
	<AANLkTimgVuEIkB2s9rra5QS11YMUSpvSkBOcbzza44LX@mail.gmail.com>
	<20100616163343.2c57de59@notabene.brown>
	<1278032211.2179.24.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1278032211.2179.24.camel@dwillia2-linux>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, Doug Ledford <dledford@redhat.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, linux-raid <linux-raid@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>
List-Id: linux-raid.ids

On Thu, 01 Jul 2010 17:56:51 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Tue, 2010-06-15 at 23:33 -0700, Neil Brown wrote:
> > On Thu, 10 Jun 2010 23:42:16 -0700
> > Dan Williams <dan.j.williams@intel.com> wrote:
> > 
> > > > I've merged and pushed out the other bits which all seem OK.  
> > > 
> > > Ok, there was one more you didn't comment on and didn't cherry-pick [2]
> > > 
> > > Dave Jiang (1):
> > >       create: Check with OROM limit before setting default chunk size
> > > 
> > > Thanks,
> > > Dan
> > 
> > I don't remember seeing that before - sorry.
> > It looks OK.  It might be nice to combine it with the ->default_layout
> > setting somehow, but that isn't necessary in the first instance.
> > 
> > Include it in the next pull request and I'll take it.
> > 
> 
> Here is the updated pull request:
> 
> The following changes since commit b3b4e8a7a229cccca915421329a5319f996b0842:
>   NeilBrown (1):
>         Avoid skipping devices where removing all faulty/detached devices.
> 
> are available in the git repository at:
> 
>   git://github.com/djbw/mdadm.git master
> 
> Dan Williams (10):
>       mdmon: periodically checkpoint recovery
>       Kill subarray v2
>       imsm: dump each disk's view of the slot state
>       mdmon: record sync_completed directly to the metadata
>       Remove 'checkpointing' side effect of --wait-clean
>       Always assume SKIP_GONE_DEVS behaviour and kill the flag
>       Rename subarray v2
>       mdmon: prevent allocations due to late binding
>       Merge branch 'subarray' into for-neil
>       Merge branch 'fixes' into for-neil
> 
> Dave Jiang (1):
>       create: Check with OROM limit before setting default chunk size

Thanks.  They all look credible.
I have pulled and pushed so you can find them in 
   git://neil.brown.name/mdadm master


I'm fairly seriously considering cutting a 3.1.3 shortly (Thursday?) so that
I have a clean slate to build the policy frame work and aim it for 3.2.0.

If you have anything that you would like to see included in (or addressed
for) 3.1.3, please let me know.

Thanks,
NeilBrown
