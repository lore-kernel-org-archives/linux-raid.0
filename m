From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: question about mdmon --takeover
Date: Mon, 2 Sep 2013 10:27:29 +0200
Message-ID: <CAC9WiBjijg3FWbfY2gTz347=jUnYtiNdoELRECwqYUjNb6kcLg@mail.gmail.com>
References: <CAC9WiBgFPSeKGBYxYCkw8DHk4dS6=aBhCeiMGgkj2eNgtY0asw@mail.gmail.com>
	<20130805165908.2d1e291b@notabene.brown>
	<CAC9WiBhab-Acx+U0NWAxki+M9sXccdEPBj=LyLPYQv3XQ_Nnxg@mail.gmail.com>
	<CAC9WiBgunq0nHC2s1sOk=2zdTwDCJZN_5VOUgqA27r1s+0PNKQ@mail.gmail.com>
	<20130902120403.374b0895@notabene.brown>
	<CAC9WiBgmYX4JuxRAHvB7pa3udi7NAN8Ys42iWRYu49OF_wcPbA@mail.gmail.com>
	<20130902181035.79408f97@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130902181035.79408f97@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 2, 2013 at 10:10 AM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 2 Sep 2013 09:56:26 +0200 Francis Moreau <francis.moro@gmail.com>
> wrote:
>
>> Hi Neil,
>>
>> On Mon, Sep 2, 2013 at 4:04 AM, NeilBrown <neilb@suse.de> wrote:
>> > On Sat, 31 Aug 2013 22:21:36 +0200 Francis Moreau <francis.moro@gmail.com>
>> > wrote:
>> >
>> >> Hello Martin,
>> >>
>> >> I'm adding you in the discussion because you might have an idea on
>> >> what's going on with my array which is using DDF metadata.
>> >
>> > Hi Francis,
>> >  I think this problem will be fixed by Martin's latest patch set.
>> > The root cause seems to be that safe_mode_delay isn't being set properly
>> > which is the same root cause as the other problem you had.
>> >
>>
>> That's correct, this patch fixes this issue as well.
>
> Thanks.
>
>>
>> May I ask you when the 3.3 release is planned ?
>
> I was waiting for a confirmation from you and one other from Martin.
> So you have just brought it closer.
>
> Tuesday or Wednesday I expect.

Great news.

-- 
Francis
