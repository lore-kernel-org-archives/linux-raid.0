From: Thunder from the hill <thunder@lightweight.ods.org>
Subject: Re: PATCH - change to blkdev->queue calling triggers BUG in md.c
Date: Mon, 2 Sep 2002 15:43:56 -0600 (MDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209021542590.3270-100000@hawkeye.luckynet.adm>
References: <UTC200209022127.g82LR3g12738.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <UTC200209022127.g82LR3g12738.aeb@smtp.cwi.nl>
To: Andries.Brouwer@cwi.nl
Cc: aebr@win.tue.nl, torvalds@transmeta.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Hi,

On Mon, 2 Sep 2002 Andries.Brouwer@cwi.nl wrote:
> [Yes, a shock, but very easy for people to add
>       blockdev --rereadpt /dev/foo
> (or a partx call) in some bootscripts.]

fdisk -r DEV -> read device's partition table

> The faraway goal is: no partition table reading in the kernel.

Why not the faraway goal: no partition tables any more? They're annoying.

			Thunder
-- 
--./../...-/. -.--/---/..-/.-./..././.-../..-. .---/..-/.../- .-
--/../-./..-/-/./--..-- ../.----./.-../.-.. --./../...-/. -.--/---/..-
.- -/---/--/---/.-./.-./---/.--/.-.-.-
--./.-/-.../.-./.././.-../.-.-.-

