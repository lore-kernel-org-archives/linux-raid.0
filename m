From: Jens Axboe <axboe@suse.de>
Subject: Re: Where is the performance bottleneck?
Date: Wed, 31 Aug 2005 19:32:21 +0200
Message-ID: <20050831173219.GI4018@suse.de>
References: <Pine.LNX.4.61.0508301919250.25574@diagnostix.dwd.de> <20050831071126.GA7502@midnight.ucw.cz> <20050831072644.GF4018@suse.de> <Pine.LNX.4.61.0508311029170.16574@diagnostix.dwd.de> <20050831120714.GT4018@suse.de> <Pine.LNX.4.61.0508311339140.16574@diagnostix.dwd.de> <20050831162053.GG4018@suse.de> <4315C9EB.2030506@utah-nac.org> <20050831171124.GH4018@suse.de> <4315D3EB.4000601@utah-nac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964903AbVHaRcQ@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4315D3EB.4000601@utah-nac.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jmerkey <jmerkey@utah-nac.org>
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>, Vojtech Pavlik <vojtech@suse.cz>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Aug 31 2005, jmerkey wrote:
> 
> 512 is not enough. It has to be larger. I just tried 512 and it still 
> limits the data rates.

Please don't top post.

512 wasn't the point, setting it properly is the point. If you need more
than 512, go ahead. This isn't Holger's problem, though, the reading
would be much faster if it was. If the fusion is using a large queue
depth, increasing nr_requests would likely help the writes (but not to
the extent of where it would suddenly be as fast as it should).

-- 
Jens Axboe
