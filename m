From: Andrew Clayton <andrew@digital-domain.net>
Subject: Re: RAID 5 performance issue.
Date: Wed, 3 Oct 2007 21:19:10 +0100
Message-ID: <20071003211910.439ded54@alpha.digital-domain.net>
References: <20071003105321.06943824@zeus.pccl.info>
	<Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 3 Oct 2007 12:43:24 -0400 (EDT), Justin Piszcz wrote:

> Have you checked fragmentation?

You know, that never even occurred to me. I've gotten into the mind set
that it's generally not a problem under Linux.

> xfs_db -c frag -f /dev/md3
> 
> What does this report?

# xfs_db -c frag -f /dev/md0
actual 1828276, ideal 1708782, fragmentation factor 6.54%

Good or bad? 

Seeing as this filesystem will be three years old in December, that
doesn't seem overly bad.


I'm currently looking to things like

http://lwn.net/Articles/249450/ and 
http://lwn.net/Articles/242559/

for potential help, fortunately it seems I won't have too long to wait.

> Justin.

Cheers,

Andrew
