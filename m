From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: PATCH - change to blkdev->queue calling triggers BUG in md.c
Date: Mon, 2 Sep 2002 14:39:30 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209021437310.1374-100000@home.transmeta.com>
References: <UTC200209022127.g82LR3g12738.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <UTC200209022127.g82LR3g12738.aeb@smtp.cwi.nl>
To: Andries.Brouwer@cwi.nl
Cc: aebr@win.tue.nl, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids


On Mon, 2 Sep 2002 Andries.Brouwer@cwi.nl wrote:
> 
> Compare it with mounting.

NO.

The point about backwards compatibility is that things WORK.

There's no point in comparing things to how you _want_ them to work. The
only thing that matters for bckwards compatibility is how they work
_today_.

And your suggestion would break every single installation out there. Not 
"maybe a few".  Every single one.

(yeah, you could find some NFS-only setup that doesn't break. Big deal).

And backwards compatibility is extremely important. 

		Linus

