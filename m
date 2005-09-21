From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Wed, 21 Sep 2005 21:23:26 +0200
Message-ID: <20050921192326.GA30405@uio.no>
References: <20050920143346.GA5777@uio.no> <17200.9302.242957.23189@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17200.9302.242957.23189@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 21, 2005 at 01:01:42AM +1000, Neil Brown wrote:
> I doubt speed is a top priority.

I just found something interesting; if I raise speed_limit_min, I get much
better speed than I initially got. My 2->4 slow IDE disk setup:

md1 : active raid5 hdg1[4] hde1[5] hdc1[1] hda1[0]
      39078016 blocks level 5, 64k chunk, algorithm 2 [4/2] [UU__]
      [==========>..........]  resync = 52.4% (20499840/39078016) finish=50.0min speed=6187K/sec

This is more than good enough for me, at least. :-)

I noticed a problem during a big test resize now, BTW; for some reason,
pdflush goes into uninterruptable sleep, and kjournald and thus the
filesystem seems to follow. I'm not sure if this is a starvation issue or
not, but it sure is a bug -- I'll look into it and see if I find something
obvious.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
