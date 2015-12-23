From: Marc Smith <marc.smith@mcc.edu>
Subject: Re: RAID10 Write Performance
Date: Wed, 23 Dec 2015 08:59:21 -0500
Message-ID: <CAHkw+LcTafoUeXbw8rdUwFi5a1oW=q-6uosa1uzaFjiYDYneaA@mail.gmail.com>
References: <CAHkw+LdtZY=d6kCtaTe5Uu8nNXOgF+yCAjJeHWJ2TrVAuNoDeA@mail.gmail.com>
	<CAHkw+LeVkGo8cOGMzQbq7sGtw5K9bc3CMOvurL0kjDf0ZWTfsA@mail.gmail.com>
	<87wps529dq.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wps529dq.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Okay, thanks, I'll turn it back on and try some different chunk sizes.

For my own knowledge, why/what is taking place under the covers that
causes this behavior? When testing with fio, it sometimes takes 1-2
minutes of "ramp up time" before the performance numbers are
good/expected (when the write-intent bitmap is enabled).


Thanks,

Marc


On Tue, Dec 22, 2015 at 9:20 PM, NeilBrown <neilb@suse.com> wrote:
> On Wed, Dec 23 2015, Marc Smith wrote:
>
>> Solved... appears it was the write-intent bitmap that caused the
>> performance issues. I discovered if I left the test running longer
>> than 60 seconds, the performance would eventually climb to where I'd
>> expect it. I ran 'mdadm --grow --bitmap=none /dev/md0' and now random
>> write performance is high/good/stable right off the bat.
>
> Keeping a write-intent bitmap really is a good idea.
> Using a larger bitmap chunk size can reduce the performance penalty and
> preserve much of the value.  It is easy enough to experiment with
> different sizes.
>
> NeilBrown
