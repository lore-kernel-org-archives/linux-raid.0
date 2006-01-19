From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Thu, 19 Jan 2006 11:35:33 +1100
Message-ID: <17358.57045.876284.256190@cse.unsw.edu.au>
References: <20060117174531.27739.patches@notabene>
	<43CCA80B.4020603@tls.msk.ru>
	<fd8d0180601170121s1e6a55b7o@mail.gmail.com>
	<fd8d0180601170138m6847fb14k@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Francois Barre on Tuesday January 17
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 17, francois.barre@gmail.com wrote:
> Regarding box crash and process interruption, what is the remaining
> work to be done to save the process status efficiently, in order to
> resume resize process ?

design and implement ...
It's not particularly hard, but it is a separate task and I wanted to
keep it separate to ease code review.

> In my case, I would really wish to trust resizing enough to use it on
> working env.
> May I help you ?

Testing and code review is probably the most helpful thing you can do,
thanks.


> 
> Anyway, the patchset you submitted appeared to me so clearly, neat and
> simple, that it looks a piece of cake to make it secure. I know it's
> wrong, but you know, you can take it as a congratulation for your code
> quality :-p

Thanks :-)

NeilBrown 
