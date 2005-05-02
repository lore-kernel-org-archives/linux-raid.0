From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Any way to Increase MD_SB_DISKS=27 ? I need 31 devices
Date: Mon, 2 May 2005 10:56:54 +0200
Message-ID: <mj6hk2-4lb.ln1@news.it.uc3m.es>
References: <427583FA.7030704@dtbb.net> <4b0hk2-1gn.ln1@news.it.uc3m.es> <4275E782.6090509@dtbb.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tyler <pml@dtbb.net> wrote:
> figured out what you put below, i'm wondering though, will changing the 
> structures here affect anything else? other than the mdadm tool.. what 

I can't think of anything, offhand.  I would first check through the
kernel cde looking for associated gotchas before worrying about trivia
like applications, however!

> about mkfs.ext3/xfs and possibly mount?

Not affected at all. They have no knowledge of such things.

You want to look for anything that uses md_p.h. I assume that is
"nothing", since applications will use md_u.h.


Peter

