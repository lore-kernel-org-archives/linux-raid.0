From: Wim Vinckier <wim-raid@tisnix.be>
Subject: Re: fsck out of memory
Date: Fri, 7 Feb 2003 17:09:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0302071703100.12705-100000@nooks.wimpunk.com>
References: <Pine.LNX.4.53.0302071648250.1703@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0302071648250.1703@ddx.a2000.nu>
To: kernel@ddx.a2000.nu
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 7 Feb 2003 kernel@ddx.a2000.nu wrote:

> On Fri, 7 Feb 2003, Wim Vinckier wrote:
>
> > I've got an equivalent problem with my server.  After a long search, it
> > seemed to be a heating problem.  The ventilation wasn't good enough to
>
> disks are not warm at all
> there are 3 6000rpms fans blowing air over them
>

I'm just wondering why you are using ext2 in stead of ext3 or reiserfs...
I would still give it a try to boot my system without mounting the raid so
you just can wait untill the raid is synchronized.  Once this is ready,
you can check your raid.  BTW, I had two fans blowing air over my
harddisks but I got the crash because I used the normal flat IDE-cable...
I suppose you really checked the heat of the disks?

Wim.
------------------------------------------------------------------------
Wim VINCKIER
Wim-Raid@tisnix.be                                         ICQ 100545109
------------------------------------------------------------------------
'Windows 98 or better required' said the box... so I installed linux
