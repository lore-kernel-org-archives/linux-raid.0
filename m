From: "Jeff Zheng" <Jeff.Zheng@endace.com>
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
Date: Thu, 17 May 2007 14:09:49 +1200
Message-ID: <659F626D666070439A4A5965CD6EBF406B33ED@gazelle.ad.endace.com>
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com><6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com><17994.19043.771733.453896@notabene.brown><659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com> <17995.42562.870806.396617@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <17995.42562.870806.396617@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids


> The only difference of any significance between the working 
> and non-working configurations is that in the non-working, 
> the component devices are larger than 2Gig, and hence have 
> sector offsets greater than 32 bits.

Do u mean 2T here?, but in both configuartion, the component devices are
larger than 2T (2.25T&5.5T).
 
> This does cause a slightly different code path in one place, 
> but I cannot see it making a difference.  But maybe it does.
> 
> What architecture is this running on?
> What C compiler are you using?

I386(i686)
Gcc 4.0.2 20051125, 
Distro is Fedora core, we've tried fc4 and fc6.

> Can you try with this patch?  It is the only thing that I can 
> find that could conceivably go wrong.
> 

OK, I will try the patach and post the result.

Best Regards
Jeff Zheng

