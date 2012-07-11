From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: tests/03r5assemV1 issues
Date: Wed, 11 Jul 2012 09:18:19 +0200
Message-ID: <wrfjr4sisr44.fsf@redhat.com>
References: <wrfjtxxqcn38.fsf@redhat.com>
	<20120703114459.29c21b8f@notabene.brown> <wrfjpq8c96c9.fsf@redhat.com>
	<20120704152327.30dcf73e@notabene.brown> <wrfjehop1a8e.fsf@redhat.com>
	<20120711142053.36d33f61@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120711142053.36d33f61@notabene.brown> (NeilBrown's message of
	"Wed, 11 Jul 2012 14:20:53 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Fri, 06 Jul 2012 11:59:13 +0200 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
>> Hi Neil,
>> 
>> Odd - I see it with
>> mdadm:  721b662b5b33830090c220bbb04bf1904d4b7eed
>> kernel: ca24a145573124732152daff105ba68cc9a2b545
>> 
>> I've seen this happen for a while fwiw.
>> 
>> Note the box has a number of external drives with a number of my scratch
>> raid arrays on it. It shouldn't affect this, but just in case.
>> 
>> The system installed mdadm is a 3.2.3 derivative, but I checked running
>> with PATH=. as well.
>
> Thanks.
> I think I figured out what is happening.
>
> It seems that setting the max_speed down to 1000 is often enough, but not
> always.  So we need to set it lower.
> But setting max_speed lowers is not effective unless you also set min_speed
> lower.  This is the tricky bit that took me way too long to realised.
>
> So with this patch, it is quite reliable.

Hi Neil,

Just tried it out here, and it does indeed solve the problem for
me. Makes sense in the end :)

Looks like we need the same fix in tests/07reshape5intr

Thanks for figuring this out.

Cheers,
Jes
