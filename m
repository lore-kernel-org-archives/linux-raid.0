From: Neil Brown <neilb@suse.de>
Subject: Re: Software raid0 will crash the file-system, when each disk is 5TB
Date: Wed, 16 May 2007 10:03:47 +1000
Message-ID: <17994.19043.771733.453896@notabene.brown>
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
	<6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: message from Michal Piotrowski on Wednesday May 16
Sender: linux-fsdevel-owner@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Jeff Zheng <Jeff.Zheng@endace.com>, Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 16, michal.k.k.piotrowski@gmail.com wrote:
> >
> > Anybody have a clue?
> >

No...
When a raid0 array is assemble, quite a lot of message get printed
about number of zones and hash_spacing etc.  Can you collect and post
those.  Both for the failing case (2*5.5T) and the working case
(4*2.55T) is possible.

NeilBrown
