From: Caspar Smit <c.smit@truebit.nl>
Subject: Re: Proper way to delete an old RAID1?
Date: Thu, 20 Jun 2013 11:58:59 +0200
Message-ID: <CAKFseUOAg31Lui6XQpNXgDSZ7d=pMWQQR9beoeDtreR+JV3JAQ@mail.gmail.com>
References: <CAKFseUOGX=9MQLfs3JMdku7D8AOsnFHosKc0DHL3b2crWtqxRA@mail.gmail.com>
	<CAK2H+eebtek=fRrXxLLdc27OO5xLXaq3r6jCYiPxoFkJcZD=8w@mail.gmail.com>
	<CAKFseUNFi3zwrtJV37dp5EV0W5SA_QDwV+VtpYs6Z6+LXPLF3A@mail.gmail.com>
	<CAK2H+edFOHXaeK0F8QQQMWpCya2X85LdzOMLhwYxQGwsA1Q5vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+edFOHXaeK0F8QQQMWpCya2X85LdzOMLhwYxQGwsA1Q5vg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

To all interested,

I tested the --remove option on an entire MD device it immediatly
returned to the command prompt with no output/action whatsoever.
The MD was still active and runnning. So I can confirm it does nothing
and the instruction on the mentioned page are incorrect.

Tested with mdadm v3.1.4

Kind regards,
Caspar

2013/6/18 Mark Knecht <markknecht@gmail.com>:
> On Tue, Jun 18, 2013 at 12:01 PM, Caspar Smit <c.smit@truebit.nl> wrote:
>> Mark,
>>
>> His instructions at #3 are correct, #6 are incorrect (or someone has
>> to correct me and knows the --remove will work on an entire MD
>> device?).
>>
>>
>> Kind regards,
>> Caspar
>> Met vriendelijke groet,
>
> You're right, I'm wrong. It was #6 I was referring to when I first posted.
>
> Thanks for the correction. We'll see if anyone else suggests #6 actually works.
>
> Cheers,
> Mark
