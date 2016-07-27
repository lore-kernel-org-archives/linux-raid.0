From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Wed, 27 Jul 2016 14:10:16 +0100
Message-ID: <fb64b6c0-40e7-e12d-f077-ca501ad7befb@youngman.org.uk>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au>
 <5797C415.8010206@suddenlinkmail.com>
 <CAJCQCtSkE+-C5U9OEm0-zazLW2KHCMUqduDTA=UHsMxmf4DVrQ@mail.gmail.com>
 <5797E869.8080403@suddenlinkmail.com>
 <CAJCQCtQpGVf2Tj13o57T4=raF=czYr-V99tEDSkJ-_buk7JtTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQpGVf2Tj13o57T4=raF=czYr-V99tEDSkJ-_buk7JtTg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 27/07/16 00:18, Chris Murphy wrote:
>>    The real question for me is what is the effect of having /dev/sdc1 and
>> >/dev/sdd1 as unused partitions on the drive while I'm using the whole drive. Is
>> >that something that can bite me later?
> It already bit you. All you have to do is forget again that you're not
> using this partition table for anything, and then try to repair it and
> you're back in this same situation. You or someone else who ends up
> managing the drive. So yeah, it's not an in-use valid structure so I'd
> invalidate it so that libblkid unambiguously tells you the only
> signatures that matter onthe drive -> drives are not partitioned, they
> are completely under the control of mdadm, and the logical array from
> those members is ext4 or whatever.
And once you've blown away the GPT, those partitions won't exist anyway. 
The only way anything should be able to find any trace of them will be 
if you run a forensic data recovery tool.

Cheers,
Wol
