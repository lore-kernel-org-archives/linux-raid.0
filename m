From: Neil Brown <neilb@suse.de>
Subject: Re: fixes for 3.1.3 (was: Re: [mdadm GIT PULL] rebuild
 checkpoints...)
Date: Thu, 22 Jul 2010 17:47:18 +1000
Message-ID: <20100722174718.25ff4383@notabene>
References: <1274921452.17973.253.camel@dwillia2-linux>
	<20100531113710.29e12d97@notabene.brown>
	<AANLkTimgVuEIkB2s9rra5QS11YMUSpvSkBOcbzza44LX@mail.gmail.com>
	<20100616163343.2c57de59@notabene.brown>
	<1278032211.2179.24.camel@dwillia2-linux>
	<20100706145043.107f7f76@notabene.brown>
	<1278445909.3949.11.camel@dwillia2-linux>
	<1279735444.25713.9.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1279735444.25713.9.camel@dwillia2-linux>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, Doug Ledford <dledford@redhat.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, linux-raid <linux-raid@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>
List-Id: linux-raid.ids

On Wed, 21 Jul 2010 11:04:04 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Tue, 2010-07-06 at 12:51 -0700, Williams, Dan J wrote:
> > On Mon, 2010-07-05 at 21:50 -0700, Neil Brown wrote:
> > > I'm fairly seriously considering cutting a 3.1.3 shortly (Thursday?) so that
> > > I have a clean slate to build the policy frame work and aim it for 3.2.0.
> > > 
> > > If you have anything that you would like to see included in (or addressed
> > > for) 3.1.3, please let me know.
> > > 
> > 
> > The pthread_create() vs clone(2) issue is still being discussed, but in
> > the meantime using pthreads seems the safe thing to do.  So, here is
> > that implementation and another trivial build-warning fixup.
> > 
> 
> I've appended a patch to repair external metadata incremental assembly
> that was broken by commit 3a6ec29a "Don't let incremental add devices to
> active arrays."  So the pull request is now:
> 
> The following changes since commit 50526e9090d0c118b065840719bc9601be8af8b8:
>   NeilBrown (1):
>         super-0.90: don't write bitmap larger than 60K
> 
> are available in the git repository at:
> 
>   git://github.com/djbw/mdadm.git master
> 
> Dan Williams (3):
>       mdmon: satisfy glibc tls abi requirements with pthreads
>       imsm: fix a -O2 build warning
>       Incremental: restore assembly for inactive containers, block active

Thanks - pulled and pushed out.

I'm not going to get to 3.1.3 today after all - too many other things
happened this week.

But I'm really hoping for next week....

NeilBrown

