From: "David Rees" <drees76@gmail.com>
Subject: Re: Sharing disks amoung multiple software RAIDs
Date: Fri, 2 May 2008 00:06:46 -0700
Message-ID: <72dbd3150805020006p7f976a04o487389840f03b4a2@mail.gmail.com>
References: <1209692359.16523.2.camel@localhost>
	 <73000.21239.qm@web50212.mail.re2.yahoo.com>
	 <A20315AE59B5C34585629E258D76A97C335477@34093-C3-EVS3.exchange.rackspace.com>
	 <1209696179.16523.13.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1209696179.16523.13.camel@localhost>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: David Lethe <david@santools.com>, alex14641@yahoo.com, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 1, 2008 at 7:42 PM, Kasper Sandberg <lkml@metanurb.dk> wrote:
>  in other words, would i be
>  safer to run rsync every day to my other disk, and run in non-raid
>  mode?!

What would be safer is to run rsync every day from one redundant array
to another array - preferably on another machine that is located as
far away as possible from the one that you are backing up.

RAID is not the same as a backup, though unfortunately, too many
people treat it as such.

-Dave
