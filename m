From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: Can we deprecate ioctl(RAID_VERSION)?
Date: Tue, 11 Apr 2017 10:46:06 -0400
Message-ID: <fad96876-017b-ae43-a11d-6c0ea42fdbcf@gmail.com>
References: <wrfjvaqid9ih.fsf@gmail.com> <wrfjr316d6f5.fsf@gmail.com>
 <87h922trit.fsf@notabene.neil.brown.name>
 <070d7f50-c8f0-d5df-89ed-adb8b7582d8a@gmail.com>
 <87vaqhyx4i.fsf@notabene.neil.brown.name> <wrfjinmgqkjc.fsf@gmail.com>
 <878tn9yymi.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878tn9yymi.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, kernel-team@fb.com
List-Id: linux-raid.ids

On 04/09/2017 07:01 PM, NeilBrown wrote:
> On Fri, Apr 07 2017, jes.sorensen@gmail.com wrote:
>
>>
>> Next question since I am wearing my 'what is this old stuff doing' hat.
>> mdassemble? Does anything still use this? The reason is a lot of the
>> newer features are explicitly included, and switching to sysfs is
>> effectively going to kill it, unless it gets a major upgrade.
>>
>
> I was never a big fan, of mdassemble, but it is smaller than mdadm and
> some people apparently have (or had) space-constrained boot
> environments.
> Maybe post to the linux-raid list with a subject "mdassemble is going
> way, do you care?". ??

Makes sense - looking at the code it wasn't clear if it is even usable 
in modern times since it ignores sysfs access.

I'll post another message and get out the big hammer!

Cheers,
Jes


