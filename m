From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Some raid1 questions
Date: Tue, 3 Feb 2004 08:48:26 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16414.50602.162401.424505@notabene.cse.unsw.edu.au>
References: <200402011438.01880.yg@mind.lu>
	<16413.54658.442268.733528@notabene.cse.unsw.edu.au>
	<24725.213.135.224.9.1075707187.squirrel@www.mind.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Yves Glodt on Monday February 2
To: yg@mind.lu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 2, yg@mind.lu wrote:
> 
> Sorry for being unclear...
> After an unclean shutdown, my raid always rebuilds, and the filesystem never
> replays the journal. I just does not see that it was not properly
> unmounted.

That is certainly odd.  Are you sure that is what is happening?
There are two ways that the journal can be replayed:
   1/ fsck can replay it or
   2/ ext3 in the kernel can replay it.

The former will not appear in any logs and will only be seen if you
watch the boot-time messages go past.  The latter will cause a kernel
message to be logged.

Were you watching for fsck messages, or only looking in logs?

NeilBrown
