From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: messages after server crash
Date: Tue, 12 Nov 2002 06:58:43 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15824.3059.420677.958049@notabene.cse.unsw.edu.au>
References: <200211111526.37325.bernd-schubert@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bernd Schubert on Monday November 11
To: Bernd Schubert <bernd-schubert@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 11, bernd-schubert@web.de wrote:
> Hi,
> 
> after our server crashed on Friday and Sunday, we can see some strange raid 
> related messages in the logs (please see the messages below).
> 
> Well, the 'delaying resync ...' messages are easy to understand, but are they 
> related to the 'resync aborted' messages ? At least the /proc/mdstat looks 
> fine.

It looks fine ... but the arrays probably aren't in sync.
The 'resync aborted' is caused either by IO errors, which should show
up in dmesg, or the resync threads being signaled, or by the array
being switched into readonly mode.

I'm curious about this raidautorun which said:
md: raidautorun(pid 89) used obsolete MD ioctl, upgrade your software to use new ictls

That appears to be part of mkinitrd.  What distribution are you
running? What version?  What version of mkinitrd?

NeilBrown
