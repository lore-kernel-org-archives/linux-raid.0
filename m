From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Raid 5 - not clean and then a failure.
Date: Wed, 26 Aug 2009 22:35:59 +0200
Message-ID: <87y6p6wbww.fsf@frosties.localdomain>
References: <15771.7292.qm@web51312.mail.re2.yahoo.com>
	<87hbvu9626.fsf@frosties.localdomain>
	<7d86ddb90908260714j4ddc6b56w580b511bdcf12491@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90908260714j4ddc6b56w580b511bdcf12491@mail.gmail.com>
	(Ryan Wagoner's message of "Wed, 26 Aug 2009 10:14:31 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Jon@ehardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ryan Wagoner <rswagoner@gmail.com> writes:

> Wouldn't weekly RAID consistency checks reveal a bad block before you
> had a failure that required the need to do a full resync? It only
> takes 3 hours to resync my 3 x 1TB drives and having a bitmap would
> reduce the performance. I've never had to have a resync in the year
> I've had the array up. I just wonder if the performance drawback is
> worth having the bitmap to save a possible resync once every couple
> years. Or are the RAID consistency checks not reliable enough to
> prevent more errors during a resync?
>
> Ryan

Bitmaps don't protect against disk failures. They help with
intermittent failures, usualy caused by the controler. If you don't
have intermittent failures then bitmaps will only cost you for no
benefit.

MfG
        Goswin
