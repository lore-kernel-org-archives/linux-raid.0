From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Thu, 8 Nov 2007 11:02:36 -0700
Message-ID: <e9c3a7c20711081002k5c3be41doa700afce7c1a7a6e@mail.gmail.com>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
	 <18222.16003.92062.970530@notabene.brown>
	 <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>
	 <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>
	 <Pine.LNX.4.64.0711051335450.11422@p34.internal.lan>
	 <e9c3a7c20711051619u7054aab9l208b604b9e58fb61@mail.gmail.com>
	 <47303FB8.7000801@systella.fr>
	 <1194398700.2970.18.camel@dwillia2-linux.ch.intel.com>
	 <47314653.80905@Lessem.org> <47334B46.7000809@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47334B46.7000809@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jeff Lessem <Jeff@lessem.org>, =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>, Justin Piszcz <jpiszcz@lucidpixels.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/8/07, Bill Davidsen <davidsen@tmr.com> wrote:
> Jeff Lessem wrote:
> > Dan Williams wrote:
> > > The following patch, also attached, cleans up cases where the code
> > looks
> > > at sh->ops.pending when it should be looking at the consistent
> > > stack-based snapshot of the operations flags.
> >
> > I tried this patch (against a stock 2.6.23), and it did not work for
> > me.  Not only did I/O to the effected RAID5 & XFS partition stop, but
> > also I/O to all other disks.  I was not able to capture any debugging
> > information, but I should be able to do that tomorrow when I can hook
> > a serial console to the machine.
>
> That can't be good! This is worrisome because Joel is giddy with joy
> because it fixes his iSCSI problems. I was going to try it with nbd, but
> perhaps I'll wait a week or so and see if others have more information.
> Applying patches before a holiday weekend is a good way to avoid time
> off. :-(

We need to see more information on the failure that Jeff is seeing,
and whether it goes away with the two known patches applied.  He
applied this most recent patch against stock 2.6.23 which means that
the platform was still open to the first biofill flags issue.

--
Dan
