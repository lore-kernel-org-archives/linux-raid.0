From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Kernel panic, FS corruption  Was: Re: Call for RAID-6 users
Date: Thu, 05 Aug 2004 17:36:49 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4112D2A1.9000001@zytor.com>
References: <cds76e$ee7$1@terminus.zytor.com> <200407310228.27969.maarten@ultratux.net> <200408011503.20452.maarten@ultratux.net> <20040801180536.GA3897@jim.sh> <ceuhbm$rgs$1@terminus.zytor.com> <20040806001909.GA19760@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040806001909.GA19760@jim.sh>
To: Jim Paris <jim@jtan.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim Paris wrote:
> 
> No, I did see the same corruption with XFS; it just took more work
> before it would show up (ie. I couldn't get it to show up by simply
> copying one huge file; I had to untar a full filesystem onto it).
> So I would suspect the odd access patterns.  I could also run a test
> with EXT2/3 if you'd like.  I didn't manage to trigger the corruption
> directly on the md device, but my access pattern was quite simple in
> that case (dd big blocks to different areas).
> 

If you can reproduce it with ext2/3 it would make debugging simpler, because I 
understand the ext code and data structures a lot better.

Thanks for that data element; it pretty much confirms my suspicions.

 >
> Are you able to reproduce the problem with the scripts I sent earlier?
> If not, I can give you access to a machine that can.
> 

I hate to admit it, but I haven't had a chance to try yet.

	-hpa
