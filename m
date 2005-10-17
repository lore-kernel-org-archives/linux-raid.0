From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH md 000 of 8] Introduction
Date: Mon, 17 Oct 2005 12:38:52 +1000
Message-ID: <17235.3772.465205.512774@cse.unsw.edu.au>
References: <20051014122335.11602.patches@notabene>
	<Pine.LNX.4.64.0510160953530.11227@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Sunday October 16
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday October 16, babydr@baby-dragons.com wrote:
>  	Hello Neil ,  Is it possible to inert in the 'Introduction's for your
>  	patches a Min & Max kernel level they will successfully patch
>  	against ?  ie: 2.6.12 to 2.6.14-rc4 or some such .
>  	That would sure take the angst out of guessing .  Tia ,  JimL
> 

I could certainly be more precise about which kernel they are created
against (it is usually the latest 2.6-mm) but it would be a lot of
work to figure out how far back you can safely go and still have the
patch usefully apply, and I'm not sure that it is really worth it, is
it?

If you want to help test raid patch (and I do appreciate the help), it
is really best if you use the most recent kernel, otherwise there
could be unexpected interactions which invalidate the test.

Hope that's ok,

Thanks,
NeilBrown
