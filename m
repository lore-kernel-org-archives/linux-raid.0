From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: SW Raid doesn't play nice with devfs?
Date: Mon, 9 Sep 2002 16:20:14 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15740.15774.911597.853392@notabene.cse.unsw.edu.au>
References: <20020909054800.GV3806@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Marc MERLIN on Sunday September 8
To: Marc MERLIN <marc_news@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday September 8, marc_news@merlins.org wrote:
...
> All is well unless one of my disk arrays isn't powered when the system boots
...
> Yet, if my other arrays are down  at boot time, /dev/md3 doesn't get created
> at boot time, and a manual raidstart /dev/md3 yields:

Yep, raidstart is broken by design.  It depends on device number being
stable, and SCSI device number aren't, especially if they are added
after boot time.

That is part of the reason that I wrote mdadm.  It can do the right
thing for you.

  http://www.cse.unsw.edu.au/~neilb/source/mdadm/

NeilBrown
