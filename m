From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Fw: Why does one get mismatches?
Date: Fri, 22 Jan 2010 19:13:16 +0100
Message-ID: <877hra57pf.fsf@frosties.localdomain>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <869541.92104.qm@web51304.mail.re2.yahoo.com> (Jon Hardcastle's
	message of "Wed, 20 Jan 2010 03:52:54 -0800 (PST)")
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Hardcastle <jd_hardcastle@yahoo.com> writes:

> --- On Tue, 19/1/10, Jon Hardcastle <jd_hardcastle@yahoo.com> wrote:
>
>> From: Jon Hardcastle <jd_hardcastle@yahoo.com>
>> Subject: Why does one get mismatches?
>> To: linux-raid@vger.kernel.org
>> Date: Tuesday, 19 January, 2010, 10:04
>> Hi,
>> 
>> I kicked off a check/repair cycle on my machine after i
>> moved the phyiscal ordering of my drives around and I am now
>> on my second check/repair cycle and it has kept finding
>> mismatches.
>> 
>> Is it correct that the mismatch value after a repair was
>> needed should equal the value present after a check? What if
>> it doesn't? What does it mean if another check STILL reveals
>> mismatches?
>> 
>> I had something similar after i reshaped from raid 5 to 6 i
>> had to run check/repair/check/repair several times before i
>> got my 0.
>> 
>> 
>
> Guys,
>
> Anyone got any suggestions here? I am now on my ~5 check/repair and after a reboot the first check is still returning 8.
>
> All i have done is move the drives around. It is the same controllers/cables/etc 
>
> I really dont like the seeming random nature of what can/does/has caused the mismatches?

There is some unknown corruption going on with raid1 that causes
mismatches but it is believed that it will never occur on any used
block. Swapping is a likely cause.

Any swap device on the raid? Try turning that off.
If that doesn't help try umounting filesystems or remounting RO.

MfG
        Goswin
