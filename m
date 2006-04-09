From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: linear writes to raid5
Date: Sun, 9 Apr 2006 16:24:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0604091600230.22779-100000@coffee.psychology.mcmaster.ca>
References: <m37j60udi8.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m37j60udi8.fsf@bzzz.home.net>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Tomas <alex@clusterfs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> is there a way to batch explicitely write requests raid5 issues?

sort of like TCP_CORK?

> for example, there is a raid5 built from 3 disks with chunk=64K.
> one types dd if=/dev/zero of=/dev/md0 bs=128k count=1

OK, so this is an aligned, whole-stripe write.

>and 128K
> bio gets into the raid5. raid5 processes the request, does xor
> for parity stripe, then issues 2 64KB requests down to lower level.

don't you mean _3_ chunk-sized writes?  if so, are you actually
asking about the case when you issue an aligned two-stripe write?
(which might get broken into 6 64K writes, not sure, rather than 
three 2-chunk writes...)

_not_ that I know this code at all!

