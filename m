From: Boris T <tlknv@yandex.ru>
Subject: Re: mismatch_cnt constantly goes up on ssd+hdd raid1
Date: Thu, 25 Jun 2015 10:24:34 -0700
Message-ID: <CADkUup9YhMwH6UMrEamT3rfUkOhdMiWLyeu46CTNsjPm-173UQ@mail.gmail.com>
References: <3700381434301996@web21o.yandex.ru>
	<20150625113335.7bf72b0b@noble>
	<20150625101959.23981c72@natsu>
	<20150625172530.5c5338b6@noble>
	<2762371435246396@web9o.yandex.ru>
	<20150625205026.42f41a81@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150625205026.42f41a81@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: tlknv <tlknv@yandex.ru>, NeilBrown <neilb@suse.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Roman,

Thanks for the suggestion. I would probably consider keeping TRIM if I
had less free/unpartitioned space on my SSD. Currently all partitioned
space is just a fraction (about 1/3) of total SSD size. In this
situation I prefer to make sure that my raid is consistent than to
prolong the life of SSD a bit.

Thanks,
Boris

On Thu, Jun 25, 2015 at 8:50 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Thu, 25 Jun 2015 18:33:16 +0300
> tlknv <tlknv@yandex.ru> wrote:
>
>> I have just discovered that I had 'discard' mount option even though I though it wasn't there :-(
>> After removing 'discard' and forcing 'repair' mismatch_cnt stays 0 even after a bunch of writes and deletes (the most importantly) to the partition.
>
> I wouldn't recommend disabling discard 'for good' though, from your experiment
> we can probably conclude the mismatch_cnt numbers you had previously are indeed
> harmless. If you had no other issues due to discard being active, then what you
> did now is disable a working and useful feature to fix what's only a cosmetic
> problem.
>
> --
> With respect,
> Roman
