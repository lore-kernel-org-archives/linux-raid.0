From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: RAID-0 read perf. decrease after 2.4.20
Date: Mon, 8 Dec 2003 11:21:37 -0200 (BRST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0312081121310.1289-100000@logos.cnet>
References: <200312081411.04057.m.c.p@wolk-project.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200312081411.04057.m.c.p@wolk-project.de>
To: Marc-Christian Petersen <m.c.p@wolk-project.de>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, Mikael Johansson <mpjohans@pcu.helsinki.fi>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, riel@redhat.com, knobi@knobisoft.de, Jens Axboe <axboe@suse.de>, mason@suse.com
List-Id: linux-raid.ids



On Mon, 8 Dec 2003, Marc-Christian Petersen wrote:

> On Monday 08 December 2003 13:47, Marcelo Tosatti wrote:
> 
> Hi Marcelo,
> 
> > 2.4.20-aa included rmap and some VM modifications most notably
> > "drop_behind()" logic which I believe should be the reason for the huge
> > read speedups. Can you please try it? Against 2.4.23.
> 
> -aa tree never had -rmap :)

-ac I mean, sorry. 

