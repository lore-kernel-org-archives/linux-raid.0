From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: PATCH - change to blkdev->queue calling triggers BUG in md.c
Date: Mon, 2 Sep 2002 20:55:47 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209022051540.1332-100000@home.transmeta.com>
References: <UTC200209030053.g830r9b16219.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <UTC200209030053.g830r9b16219.aeb@smtp.cwi.nl>
To: Andries.Brouwer@cwi.nl
Cc: aebr@win.tue.nl, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids


On Tue, 3 Sep 2002 Andries.Brouwer@cwi.nl wrote:
> 
> Why?
> Because in some cases it is undesirable.

Again, Why?

You can always use the flat device as-is. 

> Because in some cases it crashes the kernel.

But moving it to user space would cause the kernel to crash anyway. Bugs 
are bugs.

> Because it involves guessing and heuristics.

The same guesses and heuristics would have to be in user space. 

> Because policy belongs in user space.

It's not policy. It's a fact of life that disks need to be split up into 
parts, and the partitioning schemes are well-defined and shared across 
multiple operating systems.

> Yes - that is my main point: doing it on demand. On demand only.

But I actually _agree_ with this. 

However, that has nothing to do with whether it is in user space or kernel 
space. In many ways it is _easier_ to do on demand in kernel space: when 
somebody opens /dev/sda1 and it isn't partitioned yet, you know it needs 
to be. 

The fact that partitioning right now is to some degree handled by device
drivers is a problem, but that's not a user space vs kernel space issue.
It's slowly getting moved to higher levels.

		Linus

