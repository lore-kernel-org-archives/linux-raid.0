From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: re: RAID5 causing lockups
Date: Fri, 27 Jun 2003 01:32:36 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0306270129540.10913-100000@router.windsormachine.com>
References: <200306262202290330.05EDD355@ilneval.coreyfro.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200306262202290330.05EDD355@ilneval.coreyfro.com>
To: Corey McGuire <coreyfro@coreyfro.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 26 Jun 2003, Corey McGuire wrote:

> Whoa!!!
>
> The strangest thing happened when I hit 12.7% on my RAID5 rebuild
>
> md2 : active raid5 hdk3[5] hdi3[4] hdg3[3] hde3[2] hdc3[1] hda3[0](F)
>       962654400 blocks level 5, 32k chunk, algorithm 0 [6/5] [_UUUUU]

Ins't that a missing disk?  Or do i just not remember raid5 properly.

> >md2 : active raid5 hdk3[5] hdi3[4] hdg3[3] hde3[2] hdc3[1] hda3[0]
> >      962654400 blocks level 5, 32k chunk, algorithm 0 [6/6] [UUUUUU]
> >      [==>..................]  resync = 12.5% (24153596/192530880)


Yeah, I thought something had changed here.  What's up with that?

the (F) by hda, and I think you were talkinga bout HDA being bad?

Have you pulled hda out of the raid, and used the manufacturers utilities
to test this drive?

Mike

