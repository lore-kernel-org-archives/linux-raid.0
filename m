From: Francois Barre <francois.barre@gmail.com>
Subject: What is the status of the raid5 online resize patch ?
Date: Thu, 1 Dec 2005 10:15:49 +0100
Message-ID: <fd8d0180512010115v305905b2s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

Surfing on the web I found a patch from Steinar H. Gunderson which
implements raid5 resize stuff.
(http://marc.theaimsgroup.com/?l=linux-raid&m=112998877619952&w=2).
It seems like it has been included in the 2.6.14 kernel
(http://www.linuxhq.com/kernel/v2.6/14/drivers/md/raid5.c), but I
would be sure :
- Is it really reliable ? Did you test it strongly enough to put the
'I trust it' label on it ?
- Does it implement crash recovery now ?
- Did anyone test a multiple growth (add 1 disk, then another, then...).

That could be really interresting to know.

Thanks for advance,

F.-E. Barre.
