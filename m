From: Andries.Brouwer@cwi.nl
Subject: Re: PATCH - change to blkdev->queue calling triggers BUG in md.c
Date: Mon, 2 Sep 2002 23:41:22 +0200 (MEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <UTC200209022141.g82LfMV21308.aeb@smtp.cwi.nl>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andries.Brouwer@cwi.nl, torvalds@transmeta.com
Cc: aebr@win.tue.nl, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

> The point about backwards compatibility is that things WORK.

Must I conclude that you did not read my entire letter?

Since we started this small detour talking about media change,
let me quote that fragment once more.

"[Don't think that I actually propose doing this today as the default,
but it would be a very small patch to add this as an optional
behaviour. But there is today, and there is the faraway goal.
The faraway goal is: no partition table reading in the kernel.
And that influences designing today what to do on media change.
Already today I would consider it entirely reasonable if there
was no automatic partition table reading after a media change.]"

No, my suggested changes would not break a single Linux installation
in the world.

Andries
