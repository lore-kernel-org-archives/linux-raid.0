From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH] md: Remove risk of overflow via sprintf) by using snprintf()
 in md_check_recovery()
Date: Sat, 12 Feb 2011 16:48:58 +0300
Message-ID: <4D568FCA.90902@msgid.tls.msk.ru>
References: <alpine.LNX.2.00.1102112227040.16994@swampdragon.chaosbits.net> <4D56541D.3030409@uw.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D56541D.3030409@uw.no>
Sender: linux-raid-owner@vger.kernel.org
To: "Daniel K." <dk@uw.no>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

12.02.2011 12:34, Daniel K. wrote:
> Jesper Juhl wrote:
>> sprintf() is dangerous - given the wrong source string it will
>> overflow the destination. snprintf() is safer in that at least we'll
>> never overflow the destination. Even if overflow will never happen
>> today, code changes over time and snprintf() is just safer in the long
>> run.
>
>> -                        sprintf(nm,"rd%d", rdev->raid_disk);
>> +                        snprintf(nm, sizeof(nm), "rd%d",
>> rdev->raid_disk);
>>                          sysfs_remove_link(&mddev->kobj, nm);
>
> What if "rd1234" get truncated to "rd123" and you remove the wrong link.
> (No, I didn't actually bother to check how much room was allocated.)

That allocation is in the line above first sprintf which you deleted.
Sure, didn't bother, it's very difficult.

C'mon guys, this is pointless.  20 bytes allocated for the device
name, and this is for raid disk number.  It is impossible to have
more than 10^17 (20 bytes total, 2 for "rd" and on for the zero
terminator) drives in a single array.

/mjt
