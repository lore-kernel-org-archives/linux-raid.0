From: Neil Brown <neilb@suse.de>
Subject: Re: Spare drive won't spin down
Date: Fri, 7 May 2010 16:20:34 +1000
Message-ID: <20100507162034.1370d645@notabene.brown>
References: <922812.29139.qm@web31703.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <922812.29139.qm@web31703.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Bryant <tenminjoe@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 6 May 2010 10:49:06 -0700 (PDT)
Joe Bryant <tenminjoe@yahoo.com> wrote:

> Hello -
> 
> I hope some kind soul is able to help. I have configured a RAID1 array - two mirrored drives, one spare. My understanding is that the spare disk should  be allowed to spin down, but it won't. 

Yes, it should.  But as you say, it doesn't.
More precisely, it seems to work if you create an array with 1.x metadata
(e.g. --metadata=1.0) but not if you use 0.90 (which the default for mdadm
before 3.1).

It seems I broke it with commit 51d5668cb2e3f in 2.6.31.

I'll see about fixing that.

> 
> This box is a fresh build and can be rebuilt if that's necessary to fix 
> or diagnose the problem.

Recreate the array with "--metadata 1.0" or "--metadata 1.2" and it should
work better.

> 
> Thanks in advance for any help. Linux software RAID is just terrific - I report this minor issue largely because, as I said, it seems like this is something that is *supposed* to work.
> 

Yes, thanks for reporting it.

NeilBrown

