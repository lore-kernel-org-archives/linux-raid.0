From: Bernd Schubert <bs@q-leap.de>
Subject: Re: experiences with raid5: stripe_queue patches
Date: Wed, 17 Oct 2007 18:59:29 +0200
Message-ID: <200710171859.30152.bs@q-leap.de>
References: <200710151703.10404.bs@q-leap.de> <1192555868.16656.30.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1192555868.16656.30.camel@dwillia2-linux.ch.intel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hello Dan, hello Neil,

thanks for your help!

On Tuesday 16 October 2007 19:31:08 Dan Williams wrote:
> On Mon, 2007-10-15 at 08:03 -0700, Bernd Schubert wrote:
> > Hi,
> >
> > in order to tune raid performance I did some benchmarks with and
> > without the
> > stripe queue patches. 2.6.22 is only for comparison to rule out other
> > effects, e.g. the new scheduler, etc.
>
> Thanks for testing!
>
> > It seems there is a regression with these patch regarding the re-write
> > performance, as you can see its almost 50% of what it should be.
> >
> > write      re-write   read       re-read
> > 480844.26  448723.48  707927.55  706075.02 (2.6.22 w/o SQ patches)
> > 487069.47  232574.30  709038.28  707595.09 (2.6.23 with SQ patches)
> > 469865.75  438649.88  711211.92  703229.00 (2.6.23 without SQ patches)
>
> A quick way to verify that it is a fairness issue is to simply not
> promote full stripe writes to their own list, debug patch follows:

I tested with that and the rewrite performance is better, but still not 
perfect:

  write      re-write    read      re-read
461794.14   377896.27  701793.81  693018.02


[...]

> I made a rough attempt at multi-threading raid5[1] a while back.
> However, this configuration only helps affinity, it does not address the
> cases where the load needs to be further rebalanced between cpus.
>
> > Thanks,
> > Bernd
>
> [1] http://marc.info/?l=linux-raid&m=117262977831208&w=2
> Note this implementation incorrectly handles the raid6 spare_page, we
> would need a spare_page per cpu.

Ah great, I will test this on Friday.

Thanks,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
