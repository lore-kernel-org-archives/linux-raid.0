From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: recovering from a controller failure
Date: Wed, 02 Jun 2010 07:15:59 +1200
Message-ID: <4C055C6F.7080302@sauce.co.nz>
References: <20100531182734.GB2980@flews.lairds.us> <20100601154904.GG2980@flews.lairds.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601154904.GG2980@flews.lairds.us>
Sender: linux-raid-owner@vger.kernel.org
To: Kyler Laird <kyler-keyword-linuxraid00.a7e7f0@lairds.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kyler Laird wrote:
> I decided to try simply using "--force" to assemble the array.  It seems
> to have worked.
>   	http://lairds.us/temp/ucmeng_md/suggested_recovery
> As you can see, it didn't use /dev/sdah1, starting the RAID6 array with
> one drive missing.
>
> I can safely --add this drive or was there a reason it wasn't used?  I
> also plan to add the spare (/dev/sdp1).

It would be prudent to remove /dev/sdah1 and use smartctl on a non LSI 
SAS controller or another machine, to check that it has not failed.

If not, prior to re adding it back, I would perform on fsck on the 
filesystem to make sure there are no errors.

Regards,

Richard
