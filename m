From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: Re: [SOLVED] RAID-10 array won't auto-assemble @ boot of a Xen Guest;
	Works just fine 'manually' ... Any ideas?
Date: Wed, 16 Dec 2009 09:30:43 -0800
Message-ID: <babafd2f0912160930r6a30d741p6ff3aad960a91b@mail.gmail.com>
References: <babafd2f0912151558y513b589ay5e43080ef8e697d@mail.gmail.com>
	<babafd2f0912151705sbda2f50i84ca88433713888d@mail.gmail.com>
	<20091216091615.GB15689@cthulhu.home.robinhill.me.uk> <babafd2f0912160810p34e43a6ao93dae8a576bfcb75@mail.gmail.com>
	<20091216162013.GC15689@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091216162013.GC15689@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> A check of the manual page shows that on openSUSE, the command would be:
>    chkconfig --list --allservices | grep -i boot
>
> Boot services are hidden by default, so you need the --allservices (or
> -A) switch to show them.

Learned something new, thanks.

"Something" auto-enabled those services -- particularly boot.md -- on
the box on which "/" & "/boot" were installed to RAID.  I'm gonna
guess the installation process itself took care of that.

I've yet to find/notice an opensuse doc that says I need to manually
enable that -- with 20-20 hindsight, makes sense.

All working now, and procedure noted.

Thanks.

BenDJ
