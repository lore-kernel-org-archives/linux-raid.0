From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: PATCH - change to blkdev->queue calling triggers BUG in md.c
Date: Mon, 2 Sep 2002 15:00:27 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209021459030.1401-100000@home.transmeta.com>
References: <UTC200209022141.g82LfMV21308.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <UTC200209022141.g82LfMV21308.aeb@smtp.cwi.nl>
To: Andries.Brouwer@cwi.nl
Cc: aebr@win.tue.nl, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids


On Mon, 2 Sep 2002 Andries.Brouwer@cwi.nl wrote:
> 
> No, my suggested changes would not break a single Linux installation
> in the world.

.. by making your suggested behaviour not be used. Yes.

But if that is the case, then we _still_ need to fix the media change and 
partition read issue. Right? Which brings back _all_ my points for why it 
should be done at open time, and by the generic routine. Agreed?

		Linus

