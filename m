From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: PATCH - change to blkdev->queue calling triggers BUG in md.c
Date: Mon, 2 Sep 2002 15:06:27 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209021501080.1401-100000@home.transmeta.com>
References: <Pine.LNX.4.44.0209021542590.3270-100000@hawkeye.luckynet.adm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0209021542590.3270-100000@hawkeye.luckynet.adm>
To: Thunder from the hill <thunder@lightweight.ods.org>
Cc: Andries.Brouwer@cwi.nl, aebr@win.tue.nl, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids


On Mon, 2 Sep 2002, Thunder from the hill wrote:
> 
> Why not the faraway goal: no partition tables any more? They're annoying.

Yeah, users and real life is annoying.

Guys, Linux is not a research project. Never was, never will be. If you
want to have a research project that does things the way people think they
should be done (as opposed to real life and being practical), look at Hurd
and look at a lot of other projects. But don't look at Linux.

Partition tables are a fact of life. And they are a fundamental part to 
being able to parse what the disk contains. 

Sure, you can do it in user space too. And you can do TCP in user space.  
But some things are just fairly fundamental to the working of the system.  
The disk and filesystem layout is one such thing. It had better "just
work".

		Linus

