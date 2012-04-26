From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Removing a failing drive from multiple arrays
Date: Thu, 26 Apr 2012 07:19:14 +0100
Message-ID: <4F98E8E2.6070503@anonymous.org.uk>
References: <4F905F66.6070803@tmr.com> <20369.29756.761374.308057@quad.stoffel.home> <4F918F5C.2000607@anonymous.org.uk> <CAK2H+efwgznsS4==Rrtm6UE=uOb25-Q0Qm84i8yAJEJJ2JLdgg@mail.gmail.com> <4F9450D1.40305@anonymous.org.uk> <4F98B4FE.5010101@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F98B4FE.5010101@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/04/2012 03:37, Bill Davidsen wrote:
> John Robinson wrote:
[...]
>> Without either hardware or BIOS RAID, you can still end up being
>> unable to boot,
>> e.g. the BIOS will try to boot from the first hard drive present, but
>> if it has
>> bad sectors in the MBR or /boot partition, booting may fail even
>> though there's
>> a perfectly good mirror on the second drive, because the BIOS doesn't
>> understand
>> RAID. This has happened to me :-(
>>
> Doesn't need to understand RAID, just be willing to try the next item in
> the boot list on failure. My experience has been that almost every BIOS
> will try the 2nd item if the 1st fails totally (ie. drive isn't there).
> A _good_ BIOS will try the next item on sector error in the MBR.

Absolutely - but in the case I had, grub couldn't load its next stage 
because of a sector error.

It probably didn't help that the weekly array scrubs don't touch the 
space between the MBR and the first partition, where that code lives.

> After that the BIOS needs to understand a lot more to do anything
> smart after the MBR runs.

Agreed; only a RAID BIOS (software e.g. IMSM or hardware RAID card) 
could have saved me from the above failure.

Cheers,

John.
