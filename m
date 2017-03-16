From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: linux-next: WARNING: CPU: 0 PID: 1 at lib/refcount.c:114
 refcount_inc+0x37/0x40
Date: Thu, 16 Mar 2017 18:00:02 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C59FF0@IRSMSX102.ger.corp.intel.com>
References: <CANaxB-xDKh+_0eR2p4rODObQPVFwNM1-vK=fmCV-jaBYpGkPAw@mail.gmail.com>
 <20170310205413.wjs64c4zvrqvswg7@kernel.org>
 <2236FBA76BA1254E88B949DDB74E612B41C5816D@IRSMSX102.ger.corp.intel.com>
 <20170314163155.v4ppkwcfcmfwwdu7@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170314163155.v4ppkwcfcmfwwdu7@kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Andrei Vagin <avagin@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> On Mon, Mar 13, 2017 at 10:04:32AM +0000, Reshetova, Elena wrote:
> > > On Fri, Mar 10, 2017 at 12:01:06PM -0800, Andrei Vagin wrote:
> > > > Hello,
> > > >
> > > > We run CRIU tests for linux-next kernels and here is a new issue:
> > > >
> > > > All logs are here: https://api.travis-
> ci.org/jobs/209680974/log.txt?deansi=true
> > > > The kernel version is 4.11.0-rc1-next-20170310
> > >
> > > Thanks for the reporting. It caused by 731d126(drivers, md: convert
> > > mddev.active from atomic_t to refcount_t). It turns out the count doesn't
> match
> > > the refcount usage. I'll drop the patch temporarily.
> >
> > The log below indicates that you are using your refcounter in a bit weird way in
> mddev_find().
> > However, I can't find the place (just by reading the code) where you would
> increment refcounter from zero (vs. setting it to one).
> > It looks like you either iterate over existing nodes (and increment their counters,
> which should be >= 1 at the time of increment) or create a new node, but then
> mddev_init() sets the counter to 1.
> >
> > Do you somehow reuse the objects or?
> 
> Yes, we reuse the objects, so they are not typical refcounter. The other patch
> for stripe->count probably has the same issue, as we will reuse the stripe even
> its count equals to 0, I guess that doesn't fit into refcount too.

I guess the only option for conversion in this case is to do global +1 on the whole refcounting scheme. 
We have done such changes in past to similar places. Do you think it would make sense for these patches? 
I can give it a try.

Best Regards,
Elena.
