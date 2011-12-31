From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: RAID5 alignment issues with 4K/AF drives (WD green ones)
Date: Sat, 31 Dec 2011 15:20:29 -0700
Message-ID: <CALFpzo7sHukyuZsqDVJc7m1-jXHPc1h_PZKS9hjae5Tg_=FYXw@mail.gmail.com>
References: <A0933627-0D84-496C-B7B7-4FE265C2A212@gmail.com>
	<4EFD5928.100@fnarfbargle.com>
	<4085BCC9-B901-4D96-B530-4D580A162D20@gmail.com>
	<4EFE468E.3010007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EFE468E.3010007@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zdenek Kaspar <zkaspar82@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> WTF is the jumper for then ? (on 512B drive)
> Does it change somehow:
> /sys/block/sdX/queue/physical_block_size
> /sys/block/sdX/queue/logical_block_size
> /sys/block/sdX/alignment_offset

No, it doesn't change what the OS sees at all. Off the top of my head
I think it just changes how the drive maps internally, so an OS that
normally starts the 1st partition on sector 63 will align correctly,
hence XP mode. That might not be exactly what's going on but something
along those lines.

> Could you explain how I could look into the stripe-cache settings?

In /sys/block/md0/md/stripe_cache_size, this allows the system to keep
the contents of recently read stripes in memory, so if they need to be
modified again it doesn't have to read from disk to calculate parity.
