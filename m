From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: mount(2) system call failed: Structure needs cleaning?
Date: Fri, 27 Oct 2017 05:02:44 -0500
Message-ID: <3f1359a2-f07a-f75e-605a-0d271df11913@suddenlinkmail.com>
References: <021c3df6-536c-73bc-84e2-281d4bd8099d@suddenlinkmail.com>
 <5a939404-9405-1721-99c9-0884dc978702@suddenlinkmail.com>
 <59F30025.5020803@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59F30025.5020803@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/27/2017 04:45 AM, Wols Lists wrote:
> You say you ran "mdadm --create" over the array? Oh dear oh dear oh
> dear! :-(

Yes, that's what I fear... If mdadm wasn't so darn reliable, I'd have to mess
with it more than I do :)
> 
> If the array was originally 1.0, and the re-create created it as 1.2, it
> just stomped all over your data.
> 

That explains it nicely.

> And now it's probably having problems re-assembling because it's finding
> two superblocks and doesn't know what to do with them.
> 
> Bottom line, yes I suspect your array is recoverable. But your
> filesystem is ALSO damaged, and trying to fix two problems has probably
> squared the workload ... :-(
> 
> The only good news I can see is it's a mirror. Your best bet is probably
> to destroy both superblocks, and try and mount the partition directly
> not as a mirror. That way, your only problem will be a damaged
> filesystem. Don't try this until you've had better advice than mine, though!
> 

Then the best bet is probably to just get rid of this array and wait until I
get it installed back in the box with the good disk, leave this unplugged,
boot in degraded mode on the good disk and re-add this one and let it re-sync.
(I suppose?)

How best to clear this array completely so that it doesn't cause mdadm any
problem on the rebuild from the good array?

> Cheers,
> Wol (the bringer of bad news :-(

Oh, the irony...

-- 
David C. Rankin, J.D.,P.E.
