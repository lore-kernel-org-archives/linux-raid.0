From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: Re[2]: raid5 - which disk failed ?
Date: Tue, 25 Sep 2007 01:05:01 +0200
Message-ID: <743669701.20070925010501@kaneda.iguw.tuwien.ac.at>
References: <1314153413.20070924011710@kaneda.iguw.tuwien.ac.at>
 <18167.9351.878707.227090@notabene.brown>
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18167.9351.878707.227090@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



NB> Or maybe the drive is failing, but that is badly confusing the
NB> controller, with the same result.
NB> Is it always hde that is reporting errors?

for now - yes; but a few months ago for a short period of time hdg and
hdh also have been reported with errors, but this went away quickly
and never occured again.

NB> With PATA, it is fairly easy to make sure you have removed the correct
NB> drive, and names don't change.  hde is the 'master' on the 3rd
NB> channel.  Presumably the first channel of your controller card.

I know; what I meant was: I'd like to make sure that I remove the one
drive that md thinks is faulty - I want to avoid removing a healthy
drive, leaving md with one broken drive and two healthy ones which
isn't good for a raid5. but in this case, hde rather certainly is the
troublemaker.

NB> No, a faulty drive in a raid5 should not crash the whole server.  But
NB> a bad controller card or buggy driver for the controller could.

this seems to be the case here. guess its time to shop for a new
server.

tnx.

------------------------------------------------------------------------------
 Rainer Fuegenstein                              rfu@kaneda.iguw.tuwien.ac.at
------------------------------------------------------------------------------
"Why are you looking into the darkness and not into the fire as we do ?", Nell
asked. "Because the darkness is where danger comes from," Peter said, "and
from the fire comes only illusion".                   (from "The Diamond Age")
------------------------------------------------------------------------------

