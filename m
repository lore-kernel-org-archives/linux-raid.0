From: Wim Vinckier <wim-raid@tisnix.be>
Subject: Re: fsck out of memory
Date: Fri, 7 Feb 2003 17:20:44 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0302071719520.13536-100000@nooks.wimpunk.com>
References: <Pine.LNX.4.53.0302071711260.1306@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0302071711260.1306@ddx.a2000.nu>
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 7 Feb 2003, Stephan van Hienen wrote:

> On Fri, 7 Feb 2003, Wim Vinckier wrote:
>
> > I'm just wondering why you are using ext2 in stead of ext3 or reiserfs...
> i'm running ext3
> but crash was heavy enough for removing the journal info :(
>

I would really use fsck.ext3...  I guess it will give a lot less errors...

> > I would still give it a try to boot my system without mounting the raid so
> > you just can wait untill the raid is synchronized.  Once this is ready,
> i can mount the filesystem, but get errors on accessing some files
> so i prefer to run fsck on it (and restore the journal info)
>
> > you can check your raid.  BTW, I had two fans blowing air over my
> > harddisks but I got the crash because I used the normal flat IDE-cable...
> > I suppose you really checked the heat of the disks?
> yes i did
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

------------------------------------------------------------------------
Wim VINCKIER
Wim-Raid@tisnix.be                                         ICQ 100545109
------------------------------------------------------------------------
'Windows 98 or better required' said the box... so I installed linux

