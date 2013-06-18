From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Proper way to delete an old RAID1?
Date: Tue, 18 Jun 2013 13:02:30 -0700
Message-ID: <CAK2H+edx7b81fVzRFOTYKw-hXfrgZF6Xgt4_WB=9zBrgJ3ZsLA@mail.gmail.com>
References: <CAKFseUOGX=9MQLfs3JMdku7D8AOsnFHosKc0DHL3b2crWtqxRA@mail.gmail.com>
	<CAK2H+eebtek=fRrXxLLdc27OO5xLXaq3r6jCYiPxoFkJcZD=8w@mail.gmail.com>
	<CAKFseUNFi3zwrtJV37dp5EV0W5SA_QDwV+VtpYs6Z6+LXPLF3A@mail.gmail.com>
	<CAK2H+edFOHXaeK0F8QQQMWpCya2X85LdzOMLhwYxQGwsA1Q5vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+edFOHXaeK0F8QQQMWpCya2X85LdzOMLhwYxQGwsA1Q5vg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 18, 2013 at 12:08 PM, Mark Knecht <markknecht@gmail.com> wrote:
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

I suppose one other small point on this topic, should anyone read it
in the distant future, is that once I've stopped the RAID and zero'ed
the superblocks the RAID itself is gone and cannot be reassembled but
the partitions are still there, and they are still marked as 'Linux
raid autodetect' in fdisk.

To move forward with growing other RAIDs I need to remove the existing
but now unused partitions to make room for future changes.

Cheers,
Mark
