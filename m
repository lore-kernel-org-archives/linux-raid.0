From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: argh!
Date: Mon, 01 Nov 2010 01:51:37 +0000
Message-ID: <4CCE1D29.3070905@anonymous.org.uk>
References: <AANLkTi=RS0-F-M29uaYi9wJ7wVzM63PVyJxDPt2WDhn_@mail.gmail.com>	<C4.61.07087.9F0BCCC4@cdptpa-omtalb.mail.rr.com>	<AANLkTimL=Z5gh+cbadd5+k66AoNZ8xc9upMbfE_Yqxac@mail.gmail.com> <20101031174440.586709a7@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101031174440.586709a7@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jon@eHardcastle.com, jonathan.hardcastle@gmail.com, Leslie Rhorer <lrhorer@satx.rr.com>, Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/10/2010 21:44, Neil Brown wrote:
> On Sun, 31 Oct 2010 21:18:52 +0000
> Jon Hardcastle<jonathan.hardcastle@gmail.com>  wrote:
>
>> Hi,
>>
>> Thanks for your help. I use 0.90 as that is what there was when the
>> machine was build ~3yrs ago.. the array has been grown and resized
>> since then.
>>
>> Does anyone have a feature list for the superblocks? Why upgrade.....?
>
> The "md" man page mentions a couple of differences:
>    - v1.x can handle more than 28 devices in an array
>    - v1.x can easily be moved between hosts with different endian-ness
>    - v1.x can put the metadata at the front of the array
>
> I should probably add the other differences.
>
>    - with 0.90 there can be confusion about whether a superblock applies
>      to the whole device or to just the last partition (if it start on a
>      64K boundary).  1.x doesn't have that problem
>    - With 1.x a device recovery can be checkpointed and restarted.
>    - with 0.90, the maximum component for RAID1 or higher is 2TB (or maybe
>      4TB, not sure).  With 1.x you can go much higher.

Aha. Some other good info for me to perhaps incorporate if I ever get 
round to trying to patch the man page. In fact I probably ought to 
review the last few months' list postings, and especially Neil B's.

Cheers,

John.

