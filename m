From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 resize "testing opportunity"
Date: Thu, 18 May 2006 09:49:21 +1000
Message-ID: <17515.46721.340413.205804@cse.unsw.edu.au>
References: <20060501152229.18367.patches@notabene>
	<200605021938.45254.a1426z@gawab.com>
	<17495.62433.136481.543828@cse.unsw.edu.au>
	<200605030700.23515.a1426z@gawab.com>
	<17502.61577.874881.753541@cse.unsw.edu.au>
	<446B968B.6050606@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Patrik Jonsson on Wednesday May 17
Sender: linux-raid-owner@vger.kernel.org
To: Patrik Jonsson <patrik@ucolick.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 17, patrik@ucolick.org wrote:
> Hi all,
> 
> For Neil's benefit (:-) I'm about to test the raid5 resize code by
> trying to grow our 2TB raid5 from 8 to 10 devices. Currently, I'm
> running a 2.6.16-rc4-mm2 kernel.  Is this current enough to support the
> resize? (I suspect not.) If I upgrade to 2.6.17-rc4-mm1, would that do
> it, or is it even in stable 2.6.16.16?

Thanks!

You need at least 2.6.17-rc1.  I would suggest the latest -rc:
 2.6.17-rc4

Don't use -mm.  It could have new bugs, and you don't want them to
trouble you when you are growing your array.

I look forward to the results!

NeilBrown
