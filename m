From: hansbkk@gmail.com
Subject: Re: RAID 5 - One drive dropped while replacing another
Date: Wed, 2 Feb 2011 23:29:32 +0700
Message-ID: <AANLkTim6g0damiQfqOWyP5S2VqD+KGfWRbTEHNGAjazo@mail.gmail.com>
References: <AANLkTinXTYds442gPrs9a9vKtWTo4OcDHDEzvO0njvyv@mail.gmail.com>
	<AANLkTikSjLhoUM5f2ibqCUmo8XF-tsrhxZ7oieg08dtD@mail.gmail.com>
	<20110202043605.593f0c5c@natsu>
	<AANLkTimJC_e8=BmGj7Th_LLc=wnoNj8tRovAgTR=mmQ7@mail.gmail.com>
	<20110202192835.5d35f2d1@natsu>
	<AANLkTi=XzwtUGYH_wz44LHTYpyQRqnSCk4MxWZiQqZ8Z@mail.gmail.com>
	<AANLkTikm5unULgkUBM__d8N9XPReu9BtjijAHt9zzvaP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikm5unULgkUBM__d8N9XPReu9BtjijAHt9zzvaP@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Scott E. Armitage" <launchpad@scott.armitage.name>
Cc: Roman Mamedov <rm@romanrm.ru>, Robin Hill <robin@robinhill.me.uk>, Bryan Wintermute <bryanwintermute@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 2, 2011 at 11:03 PM, Scott E. Armitage
<launchpad@scott.armitage.name> wrote:
> RAID1+0 can lose up to half the drives in the array, as long as no single
> mirror loses all it's drives. Instead of only being able to survive "the
> right pair", it's quite the opposite: RAID1+0 will only fail if "the wrong
> pair" of drives fail.

AFAICT it''s a glass half-full/half-empty thing. Maybe it's just my
personality, but I don't like leaving such things to chance. Maybe if
I had more than two drives per array, but that would be **very**
inefficient (ie expensive usable space ratio).

However, following up on the "spare-group" idea, I'd like confirmation
please that this scenario would work:

From the man page:

mdadm may move a spare drive from one array to another if they are in
the same spare-group and if the destination array has a failed drive
but no spares.

Given all component drives are the same size, mdadm.conf contains

ARRAY 	/dev/md0 level=raid1 num-devices=2 spare-group=bigraid10
ARRAY	/dev/md1 level=raid1 num-device=2 spare-group=bigraid10	
etc

I then add any number of spares to any of the RAID1 arrays (which
under RAID 1+0 would be in turn components of the RAID0 span one layer
up - personally I'd use LVM for this) the follow/monitor mode feature
would allocate these spares as whatever RAID1 array needed them.

Does this make sense?

If so I would recognize this as being more fault-tolerant than RAID6,
with the big advantage being fast rebuild times - performance
advantages too, especially on writes - but obviously at a relatively
higher cost.
