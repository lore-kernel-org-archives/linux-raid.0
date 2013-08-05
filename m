From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: Bugreport ddf rebuild problems
Date: Mon, 5 Aug 2013 09:17:06 +0200
Message-ID: <CAGkViCEekLv6gLJ9Y48GD=bO7LqMJC7DPSp-YGi1+wmKdCT8TA@mail.gmail.com>
References: <CAGkViCHPvbmcehFvACBKVFFCw+DdnjqvK2uNGmvKrFki+n9n-Q@mail.gmail.com>
	<20130805162125.73d4ab90@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130805162125.73d4ab90@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I will check the latest git version tonight and let you know.

Thanks to you and Martin Wilck,

Albert

On 5 August 2013 08:21, NeilBrown <neilb@suse.de> wrote:
> On Thu, 1 Aug 2013 21:22:44 +0200 Albert Pauw <albert.pauw@gmail.com> wrote:
>
>> Now I've got it working, I checked a simple rebuild test with a ddf
>> container, containing two raidsets (raid 1 and raid 5).
>>
>> Having 6 loopback devices of 512 MB each I opened in a separate screen this
>> to monitor what happens:
>>
>> while true; do clear; cat /proc/mdstat ; sleep 1; done
>>
>
> For future reference:
>    watch cat /proc/mdstat
>
> works very nicely for this sort of task.
>
> I believe the bug you described is fixed in the current git tree.  If you
> could confirm I would appreciate it.
>
> Thanks,
> NeilBrown
