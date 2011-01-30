From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 12:09:02 +0000
Message-ID: <AANLkTi=jXwcEgRquKgsf5HQUA+AQdt8nHeHCUJYqdSbX@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<AANLkTi=SbAM3BXxjH6Mvcn-Tw4b0FYyLjLFqSGuxY1fk@mail.gmail.com>
	<AANLkTik4MGS7V7ePBgbk+KW-FcBBV7MuYgB7n29RRXF=@mail.gmail.com>
	<20110130094444.68288b0e@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110130094444.68288b0e@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: CoolCold <coolthecold@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30 January 2011 04:44, Roman Mamedov <rm@romanrm.ru> wrote:
> On Sun, 30 Jan 2011 00:18:34 +0000
> Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>
>> I ran the benchmark found on the page (except for writes); results:
>
> That's kinda unfortunate, as stripe_cache_size only (or mostly) affec=
ts writes.
>
> --
> With respect,
> Roman
>

Right, it's just that I don't want to destroy my data. I've ran a few
bonnie++ benchmarks with different mount options though. You can find
them here: http://stuff.dyndns.org/logs/bonnie_results.html
It actually looks like stripe=3D384 helped performance a bit. Currently
retrying the same mount options but with 32MB stripe cache instead of
8MB.

Then you have all the readahead settings as well, like:

blockdev --setra 8192 /dev/sd[abcdefgh]
blockdev --setra 65536 /dev/md0

And disabling NCQ;

for i in sdb sdc sdd sde sdf sdg; do echo 1 >
/sys/block/"$i"/device/queue_depth; done

I'll try those settings later.

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
