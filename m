From: Marc-Christian Petersen <m.c.p@wolk-project.de>
Subject: Re: RAID-0 read perf. decrease after 2.4.20
Date: Mon, 8 Dec 2003 14:11:04 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200312081411.04057.m.c.p@wolk-project.de>
References: <Pine.LNX.4.44.0312080949520.889-100000@logos.cnet>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0312080949520.889-100000@logos.cnet>
Content-Disposition: inline
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, Mikael Johansson <mpjohans@pcu.helsinki.fi>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, riel@redhat.com, knobi@knobisoft.de, Jens Axboe <axboe@suse.de>, mason@suse.com
List-Id: linux-raid.ids

On Monday 08 December 2003 13:47, Marcelo Tosatti wrote:

Hi Marcelo,

> 2.4.20-aa included rmap and some VM modifications most notably
> "drop_behind()" logic which I believe should be the reason for the huge
> read speedups. Can you please try it? Against 2.4.23.

-aa tree never had -rmap :)

ciao, Marc

