From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: segfault when killing subarray of non-existent
 container
Date: Wed, 7 Sep 2011 14:10:15 +1000
Message-ID: <20110907141015.2e3148f2@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F013DDEDC1B@irsmsx504.ger.corp.intel.com>
	<CAA9_cme=M22x5nrb4OddR_RxhOC-sarF6GuECZx9E4SLp-+XjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cme=M22x5nrb4OddR_RxhOC-sarF6GuECZx9E4SLp-+XjQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Czarnowska, Anna" <anna.czarnowska@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>
List-Id: linux-raid.ids

On Fri, 5 Aug 2011 14:44:45 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> On Mon, Aug 1, 2011 at 8:33 AM, Czarnowska, Anna
> <anna.czarnowska@intel.com> wrote:
> > From 9c3c974e1e047caf3434f98e183e58ed3b222396 Mon Sep 17 00:00:00 2001
> > From: Anna Czarnowska <anna.czarnowska@intel.com>
> > Date: Mon, 1 Aug 2011 17:23:33 +0200
> > Subject: [PATCH] fix: segfault when killing subarray of non-existent container
> >
> > Negative value must be returned to indicate error in open_subarray
> >
> > Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>


Thanks,
I have - somewhat belatedly - applied this now.

Thanks,
NeilBrown
