From: Wim Vinckier <wimpunk@tisnix.be>
Subject: Re: fsck out of memory
Date: Fri, 7 Feb 2003 17:16:36 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0302071715420.12705-100000@nooks.wimpunk.com>
References: <Pine.LNX.4.33.0302071637050.11484-100000@nooks.wimpunk.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.33.0302071637050.11484-100000@nooks.wimpunk.com>
To: kernel@ddx.a2000.nu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 7 Feb 2003, Wim Vinckier wrote:

> On Fri, 7 Feb 2003 kernel@ddx.a2000.nu wrote:
>
> > i'm trying to run e2fsk after a system hang
> > after 1 hour running (70%) which had a memory usage for about 128M
> > i get these errors in the dmesg :
> >
> > Out of Memory: Killed process 732 (fsck.ext2).
> > Out of Memory: Killed process 732 (fsck.ext2).
> > Out of Memory: Killed process 732 (fsck.ext2).
> > Out of Memory: Killed process 732 (fsck.ext2).
> >
> > and this some pages
> >
> > top gives me this info for fsck.ext2 :
> >
> >   732 root       9   0  592M 465M  2068 S    64.7 92.6   6:31 fsck.ext2
> >
> > Mem:   514360K av,  512176K used,    2184K free,       0K shrd,     564K
> > buff
> > Swap:  136544K av,  136544K used,       0K free                    3120K
> > cache
> >
> > system has 512Megabyte memory (and 128mb swap (only fileserver, never
> > needed more swap)
> >
> > I really wonder if there is something wrong with e2fsk ?
> > does it really need that much memory ?
> > (fsck on 2.2TB /dev/md0)
> >
> > it was putting a lot of info on the screen (for some minutes) :
> > Duplicate/bad block in inode ... / ... ...  ... ... ...
> > (and scrolling in real fast speed)
> >
> > e2fsprogs version 1.27 with kernel 2.4.20 (+lbd patch)
> > i tried upgrading e2fsutils to 1.32 (latest version), but this doesn't
> > help
> >
> > any hints ? (maybe a way to disable the enormous output from
> > 'Duplicate/bad block in inode ..' ?)
> >
> > (also why does it tell, killed when it stays running (otherwise it can't
> > kill multiple times...))
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
> I've got an equivalent problem with my server.  After a long search, it
> seemed to be a heating problem.  The ventilation wasn't good enough to
> cool down my harddisks and since there's a lot of access on the disks
> during the combination of sync'ing (raid) and filesystem check there was a
> lot of heat production.
> I solved the problem by changing the ventilation and using kernel 2.4.10.
>
> Greets,
>
> Wim.
> ------------------------------------------------------------------------
> Wim VINCKIER
> Wim-Raid@tisnix.be                                         ICQ 100545109
> ------------------------------------------------------------------------
> 'Windows 98 or better required' said the box... so I installed linux
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
little correction: I use kernel 2.4.20 of course.
------------------------------------------------------------------------
Wim VINCKIER                                            +32 473 96 06 24
Wasstraat 38                                           WimPunk@tisnix.be
B-9000  Gent                                               ICQ 100545109
------------------------------------------------------------------------
'Windows 98 or better required' said the box... so I installed linux

