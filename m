From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] RAID-6 check standalone code cleanup
Date: Tue, 5 Apr 2011 09:12:42 +1000
Message-ID: <20110405091242.3427e0b1@notabene.brown>
References: <20110221204551.GA15675@lazy.lzy>
	<20110321140244.2314b4b4@notabene.brown>
	<20110321104007.GA15379@lazy.lzy>
	<20110321220457.29d52f5c@notabene.brown>
	<20110321115440.GA15635@lazy.lzy>
	<20110322095905.737fb1d5@notabene.brown>
	<20110404175242.GA3411@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110404175242.GA3411@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 4 Apr 2011 19:52:42 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi Neil,
> 
> please find below a second patch to "raid6check.c".
> This applies on top of the previous one.
> 
> Major change is code cleanup and simplification.
> Furthermore, a better error handling and a couple
> of bug fixes.
> Last but not least, the command line parameters are
> changed from "bytes" to "stripes", which is more
> convenient, I guess.

Thanks - I've applied this.

I'm not sure about using 'stripes', though it would be hard to argue in
favour of 'bytes'.
Possibly the best number to use would be 'sectors' as that is how the kernel
would report an inconsistency.

Once the code settles and you work out what the expected usage pattern would
be, it might then be obvious what the best number is.  i.e. try to document
how it would be use and if you find yourself describing complex calculations,
then change the program so it does the the calculations and you document can
avoid the complexity.

> 
> If you prefer, I can send a single patch, including
> in one shot the last one and this one.

no, multiple patches are much better - thanks.

As for the granularity for suspend/check/fix/unsuspend, I suspect that 
per-stripe would be best.
A smaller size wouldn't work, and a bigger size would only be helpful if
there were lots and lots of fixes needed ... which hopefully won't be the
case.

NeilBrown

