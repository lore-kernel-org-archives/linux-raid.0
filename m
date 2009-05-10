From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Requesting replace mode for changing a disk
Date: Sun, 10 May 2009 09:02:24 +0200
Message-ID: <877i0pe8zj.fsf@frosties.localdomain>
References: <8763gb44xk.fsf@frosties.localdomain> <4A060CBE.9090308@tmr.com>
	<4019EAB86E8342028374C6968D6D67E2@m5>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4019EAB86E8342028374C6968D6D67E2@m5> (Guy Watkins's message of
	"Sat, 9 May 2009 22:20:07 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: 'Bill Davidsen' <davidsen@tmr.com>, 'Goswin von Brederlow' <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Guy Watkins" <linux-raid@watkins-home.com> writes:

> If the disk is suspect, I would expect read errors!
> If you have 1 bad block on the suspect disk, this process will fail.
> If the logic was built-in to md, then any read errors while replacing could
> be recovered from another disk or disks.

That is actualy a good point. I didn't even think of that.

It would require a true replace mode in all raid levels though and not
just internally starting a raid1.

MfG
        Goswin
