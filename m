From: Shaohua Li <shli@kernel.org>
Subject: Re: linux-next: WARNING: CPU: 0 PID: 1 at lib/refcount.c:114
 refcount_inc+0x37/0x40
Date: Tue, 14 Mar 2017 09:31:55 -0700
Message-ID: <20170314163155.v4ppkwcfcmfwwdu7@kernel.org>
References: <CANaxB-xDKh+_0eR2p4rODObQPVFwNM1-vK=fmCV-jaBYpGkPAw@mail.gmail.com>
 <20170310205413.wjs64c4zvrqvswg7@kernel.org>
 <2236FBA76BA1254E88B949DDB74E612B41C5816D@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C5816D@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Andrei Vagin <avagin@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 13, 2017 at 10:04:32AM +0000, Reshetova, Elena wrote:
> > On Fri, Mar 10, 2017 at 12:01:06PM -0800, Andrei Vagin wrote:
> > > Hello,
> > >
> > > We run CRIU tests for linux-next kernels and here is a new issue:
> > >
> > > All logs are here: https://api.travis-ci.org/jobs/209680974/log.txt?deansi=true
> > > The kernel version is 4.11.0-rc1-next-20170310
> > 
> > Thanks for the reporting. It caused by 731d126(drivers, md: convert
> > mddev.active from atomic_t to refcount_t). It turns out the count doesn't match
> > the refcount usage. I'll drop the patch temporarily.
> 
> The log below indicates that you are using your refcounter in a bit weird way in mddev_find(). 
> However, I can't find the place (just by reading the code) where you would increment refcounter from zero (vs. setting it to one).
> It looks like you either iterate over existing nodes (and increment their counters, which should be >= 1 at the time of increment) or create a new node, but then mddev_init() sets the counter to 1. 
> 
> Do you somehow reuse the objects or?

Yes, we reuse the objects, so they are not typical refcounter. The other patch
for stripe->count probably has the same issue, as we will reuse the stripe even
its count equals to 0, I guess that doesn't fit into refcount too.

Thanks,
Shaohua
