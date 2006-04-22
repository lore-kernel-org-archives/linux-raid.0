From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: data recovery on raid5
Date: Sat, 22 Apr 2006 22:22:26 +0200
Message-ID: <62b0912f0604221322k25c96c37q2bee9361a6316c1b@mail.gmail.com>
References: <444A7C99.80006@abhost.net>
	 <62b0912f0604221248s653843bfx363f346c7ef31a94@mail.gmail.com>
	 <444A8D04.20809@abhost.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <444A8D04.20809@abhost.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan <jrs@abhost.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jonathan wrote:
> I was already terrified of screwing things up
> now I'm afraid of making things worse

Adrenalin... makes life worth living there for a sec, doesn't it ;o)

> based on what was posted before is this a sensible thing to try?
> mdadm -C /dev/md0 -c 32 -n 4 -l 5 missing /dev/etherd/e0.[023]

Yes, looks exactly right.

> Is what I've done to the superblock size recoverable?

I don't think you've done anything at all.
I just *don't know* if you have, that's all.

Was just trying to say that it wasn't super-cautious of you to begin
with, that's all :-).

> I don't understand how mdadm --assemble would know what to do,
> which is why I didn't try it initially.

By giving it --force, you tell it to forcefully mount the array even
though it might be damaged.
That means including some disks (the freshest ones) that are out of sync.

That help?
