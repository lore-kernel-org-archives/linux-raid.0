From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Stress testing system?
Date: Fri, 8 Oct 2004 23:02:55 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0410082257450.26162@lion.drogon.net>
References: <4167078A.3030609@robinbowes.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4167078A.3030609@robinbowes.com>
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 8 Oct 2004, Robin Bowes wrote:

> What's the best way to do get all six drives working as hard as possible?

I always run 'bonnie' on each partition (sometimes 2 to a partition) when
soak-testing a new server. Try to leave it running for as long as
possible. (ie. days)

That seems to get the disk heads moving (start the bonnies off at 1-2
minute interfals, but they desynchronise over time anyway, so some end up
reading, some writing, and some seeking) and I suspect head movement is
whats going to cause a disk drive to comsume the most current after
startup.

If I have a handy PC next to it, then I'll also run some scripted network
FTPs (via wget) of 1GB binary files copying to /dev/null on the recipient
side.

I certinaly see the motherboard temperature rise when I do this
(lm-sensors is your friend, but can be a PITA to get going)

Gordon
