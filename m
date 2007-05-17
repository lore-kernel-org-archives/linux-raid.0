From: Neil Brown <neilb@suse.de>
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
Date: Thu, 17 May 2007 12:45:22 +1000
Message-ID: <17995.49602.427417.500049@notabene.brown>
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
	<6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com>
	<17994.19043.771733.453896@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com>
	<17995.42562.870806.396617@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B33ED@gazelle.ad.endace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: message from Jeff Zheng on Thursday May 17
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Zheng <Jeff.Zheng@endace.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 17, Jeff.Zheng@endace.com wrote:
> 
> > The only difference of any significance between the working 
> > and non-working configurations is that in the non-working, 
> > the component devices are larger than 2Gig, and hence have 
> > sector offsets greater than 32 bits.
> 
> Do u mean 2T here?, but in both configuartion, the component devices are
> larger than 2T (2.25T&5.5T).

Yes, I meant 2T, and yes, the components are always over 2T.  So I'm
at a complete loss.  The raid0 code follows the same paths and does
the same things and uses 64bit arithmetic where needed.

So I have no idea how there could be a difference between these two
cases.  

I'm at a loss...

NeilBrown
