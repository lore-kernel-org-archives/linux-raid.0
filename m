From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/1] RFC: Unreliable discard performance can cripple RAID1
Date: Wed, 24 Jun 2015 07:04:43 -0400
Message-ID: <wrfj1th1tlis.fsf@redhat.com>
References: <1435105573-1373-1-git-send-email-Jes.Sorensen@redhat.com>
	<20150624100014.7d1e9842@natsu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150624100014.7d1e9842@natsu> (Roman Mamedov's message of "Wed,
	24 Jun 2015 10:00:14 +0500")
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov <rm@romanrm.net> writes:
> On Tue, 23 Jun 2015 20:26:12 -0400
> Jes.Sorensen@redhat.com wrote:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> 
>> Neil,
>> 
>> I have been hitting issues with discard being ridiculously slow on
>> arrays with certain typs of SSDs that seem to serialize discard
>> processing.
>> 
>> This is particularly bad as I have seen systems where the IMSM BIOS
>> defaults to 4KB chunk size, combined with these badly performing
>> drives, it could bump the mkfs on an array from seconds to over 40
>> minutes. Most users will stick to the defaults and then hit the
>> problem during install without understanding why it goes wrong :(
>> 
>> The problem is that there is no way to benchmark our way to this or
>> somehow test if a drive performs discard at reasonable speed. I
>> suggest we take an approach similar to that of RAID456 and default to
>> disabling discard, except for the case where the user knows the drives
>> are safe.
>> 
>> Thoughts?
>
> It's very unfortunate if you would cripple all the good SSD models because of
> a few bad ones. No one will remember to explicitly put the override to enable
> TRIM, or perhaps even know that it gets disabled in md in the first place. The
> only thing they will later notice is lowered performance and lifespan of their
> SSDs.

We already disable discard per default on raid456 in a similar manner
because some of them unreliably reports discard_zeroes_data when they
in reality don't.

If there was a way to reliably detect these things it would be fine,
unfortunately there isn't.

Jes
