From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: RAID 5 performance problems
Date: Thu, 3 Apr 2003 15:25:43 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0304031525060.27745-100000@router.windsormachine.com>
References: <200304031949.LAA28555@astra.scripps.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200304031949.LAA28555@astra.scripps.edu>
To: Andy Arvai <arvai@scripps.edu>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 3 Apr 2003, Andy Arvai wrote:

> Shouldn't /proc/mdstat have [UUUUU] instead of [_UUUU]? Perhaps
> this is running in degraded mode. Also, you have 'algorithm 0',
> whereas my raid5 has 'algorithm 2', which is the left-symmetric
> parity algorithm.

he's running it in degraded mode intentionally, the setup is so broken
that the performance loss is masked by the rest of the system.


