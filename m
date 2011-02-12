From: "Daniel K." <dk@uw.no>
Subject: Re: [PATCH] md: Remove risk of overflow via sprintf) by using snprintf()
 in md_check_recovery()
Date: Sat, 12 Feb 2011 09:34:21 +0000
Message-ID: <4D56541D.3030409@uw.no>
References: <alpine.LNX.2.00.1102112227040.16994@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1102112227040.16994@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

Jesper Juhl wrote:
> sprintf() is dangerous - given the wrong source string it will overflow 
> the destination. snprintf() is safer in that at least we'll never overflow 
> the destination. Even if overflow will never happen today, code changes 
> over time and snprintf() is just safer in the long run.

> -						sprintf(nm,"rd%d", rdev->raid_disk);
> +						snprintf(nm, sizeof(nm), "rd%d", rdev->raid_disk);
>  						sysfs_remove_link(&mddev->kobj, nm);

What if "rd1234" get truncated to "rd123" and you remove the wrong link.
(No, I didn't actually bother to check how much room was allocated.)

Isn't it better to overflow than silently to unlink the wrong file?

What will happen when you try to unlink the "rd123" file again, when the 
actual 123 is meant?

Whatever the real fix is, should this be checked for at create_link time 
as well?


Daniel K.
