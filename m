From: Kyler Laird <kyler-keyword-linuxraid00.a7e7f0@lairds.com>
Subject: Re: recovering from a controller failure
Date: Tue, 1 Jun 2010 10:49:04 -0500
Message-ID: <20100601154904.GG2980@flews.lairds.us>
References: <20100531182734.GB2980@flews.lairds.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100531182734.GB2980@flews.lairds.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I decided to try simply using "--force" to assemble the array.  It seems
to have worked.
 	http://lairds.us/temp/ucmeng_md/suggested_recovery
As you can see, it didn't use /dev/sdah1, starting the RAID6 array with
one drive missing.

I can safely --add this drive or was there a reason it wasn't used?  I
also plan to add the spare (/dev/sdp1).

Thanks for all the help!

--kyler
