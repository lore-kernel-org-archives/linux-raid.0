From: Gordon Henderson <gordon@drogon.net>
Subject: RE: Mirroring swap
Date: Fri, 27 Jun 2003 09:49:50 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0306270947001.32150-100000@unicorn.drogon.net>
References: <1056662597.10690.6.camel@gregdell.example.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1056662597.10690.6.camel@gregdell.example.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26 Jun 2003, Gregory Leblanc wrote:

> On Thu, 2003-06-26 at 01:30, Gordon Henderson wrote:
> [snip]
> > So now with important machines which had mirrored or RAIDed disk systems,
> > I always put swap on a mirrored or RAID5d device.
>
> Swap on RAID 5 is going to have pretty poor performance, in general.
> Swap needs to be both high bandwidth and low latency, both for reading
> and writing.  RAID 5 just isn't that.

I don't actually care right now - these machines are servers and I really
don't want them to swap - I'd rather run them without swap at all, but
I've yet to see something that'll convince me that this is a good idea,
and anyway.. Bonnie might not be the best thing in disk benchmarks, but..

Version 1.02b       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
red              1G 15418  99 68565  37 31359  24 14286  97 150174  84 390.6   1

is fairly reasonable.

G

