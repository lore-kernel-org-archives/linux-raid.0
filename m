From: Burkhard Carstens <suse-ml@onlinehome.de>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Thu, 14 Feb 2008 11:13:52 +0100
Message-ID: <200802141113.52248.suse-ml@onlinehome.de>
References: <4797430E.2020603@dionic.net> <18335.13615.134324.887637@fisica.ufpr.br> <479FAF93.5030408@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479FAF93.5030408@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Dienstag, 29. Januar 2008 23:58 schrieb Bill Davidsen:
> Carlos Carvalho wrote:
> > Tim Southerwood (ts@dionic.net) wrote on 28 January 2008 17:29:
> >  >Subtitle: Patch to mainline yet?
> >  >
> >  >Hi
> >  >
> >  >I don't see evidence of Neil's patch in 2.6.24, so I applied it
> >  > by hand on my server.
> >
> > I applied all 4 pending patches to .24. It's been better than .22
> > and .23... Unfortunately the bitmap and rai1 patch don't go in
> > .22.16.
>
> Neil, have these been sent up against 24-stable and 23-stable?

.. and .22-stable ?

Also, is this a xfs-on-raid5 bug or would it also happen with 
ext3-on-raid5 ?

regards
 Burkhard

