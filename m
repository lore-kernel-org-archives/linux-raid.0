From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 to RAID6 reshape?
Date: Mon, 18 Feb 2008 14:48:01 +1100
Message-ID: <18360.65521.598385.182668@notabene.brown>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
	<20080217143122.36413814@szpak>
	<20080217091815.0464044d@hardcode42.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Conway S. Smith on Sunday February 17
Sender: linux-raid-owner@vger.kernel.org
To: "Conway S. Smith" <beolach@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 17, beolach@gmail.com wrote:
> On Sun, 17 Feb 2008 14:31:22 +0100
> Janek Kozicki <janek_listy@wp.pl> wrote:
> 
> > oh, right - Sevrin Robstad has a good idea to solve your problem -
> > create raid6 with one missing member. And add this member, when you
> > have it, next year or such.
> > 
> 
> I thought I read that would involve a huge performance hit, since
> then everything would require parity calculations.  Or would that
> just be w/ 2 missing drives?

A raid6 with one missing drive would have a little bit of a
performance hit over raid5.

Partly there is a CPU hit to calculate the Q block which is slower
than calculating normal parity.

Partly there is the fact that raid6 never does "read-modify-write"
cycles, so to update one block in a stripe, it has to read all the
other data blocks.

But the worst aspect of doing this that if you have a system crash,
you could get hidden data corruption.
After a system crash you cannot trust parity data (as it may have been
in the process of being updated) so you have to regenerate it from
known good data.  But if your array is degraded, you don't have all
the known good data, so you loose.

It is really best to avoid degraded raid4/5/6 arrays when at all
possible.

NeilBrown
