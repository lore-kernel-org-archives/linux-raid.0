From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: md software raid
Date: Tue, 27 Oct 2009 19:45:18 -0500
Message-ID: <20091028004524773.SGCK5890@cdptpa-omta01.mail.rr.com>
References: <4AE75D87.60708@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AE75D87.60708@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> That's certainly a valid point, if you are stuck using xfs by preference
> or requirement. I have seen claims that 2.6.32 will be better, but I
> have no intention of testing it, having parted company with xfs a while
> ago.

	May I ask, "Why?"  I am running XFS on both my video server and its
backup.  Generally I have been very pleased.  The only issue I have had was
trying to fsck the arrays.  I only have 10G of swap space, and XFS requires
much more than that to successfully check file systems in excess of 6T.  It
wasn't a really big deal, however.  I just plugged in a 750G drive, shut
down the default swap, and turned it up on the large drive.  Once done, I
switched the swap back to the boot drive.

