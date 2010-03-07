From: Neil Brown <neilb@suse.de>
Subject: Re: What RAID type and why?
Date: Sun, 7 Mar 2010 13:21:13 +1100
Message-ID: <20100307132113.7e2c95b6@notabene.brown>
References: <5bdc1c8b1003061402n1281b64es9fa597b8bc714bd5@mail.gmail.com>
	<87f94c371003061433x404a8c2fgcb61f817af6ecb1@mail.gmail.com>
	<9089562724D84B3C858E337F202FF550@m5>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9089562724D84B3C858E337F202FF550@m5>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: 'Greg Freemyer' <greg.freemyer@gmail.com>, 'Mark Knecht' <markknecht@gmail.com>, 'Linux-RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 06 Mar 2010 18:17:44 -0500
"Guy Watkins" <linux-raid@watkins-home.com> wrote:

> } 
> } At a minimum I would build a 3-disk raid 6.  raid 6 does a lot of i/o
> } which may be a problem.
> 
> If he only needs 3 drives I would recommend RAID1.  Can still loose 2 drives
> and you don't have the RAID6 I/O overhead.
> 

and as md/raid6 requires at least 4 drives, RAID1 is not just the best
solution to survive two failures on a 3-device array, it is the only solution.

NeilBrown
