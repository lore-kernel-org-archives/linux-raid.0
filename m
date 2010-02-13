From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux mdadm superblock question.
Date: Sat, 13 Feb 2010 11:58:03 -0800
Message-ID: <4B77044B.1020609@zytor.com>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 02/11/2010 05:52 PM, Michael Evans wrote:
> On Thu, Feb 11, 2010 at 3:00 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> Hi,
>>
>> I may be converting a host to ext4 and was curious, is 0.90 still the only
>> superblock version for mdadm/raid-1 that you can boot from without having to
>> create an initrd/etc?
>>
>> Are there any benefits to using a superblock > 0.90 for a raid-1 boot volume
>> < 2TB?
>>
>> Justin.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> You need the superblock at the end of the partition:  If you read the
> manual that is clearly either version 0.90 OR 1.0 (NOT 1.1 and also
> NOT 1.2; those use the same superblock layout but different
> locations).

0.9 has the *serious* problem that it is hard to distinguish a whole-volume

However, apparently mdadm recently switched to a 1.1 default.  I
strongly urge Neil to change that to either 1.0 and 1.2, as I have
started to get complaints from users that they have made RAID volumes
with newer mdadm which apparently default to 1.1, and then want to boot
from them (without playing MBR games like Grub does.)  I have to tell
them that they have to regenerate their disks -- the superblock occupies
the boot sector and there is nothing I can do about it.  It's the same
pathology XFS has.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
