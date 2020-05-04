From: Chris Murphy <lists@colorremedies.com>
Subject: Re: WD Red drives are now SMR drives?
Date: Mon, 4 May 2020 17:28:24 -0600
Message-ID: <CAJCQCtRinqCeCV1OS0BrObcm4Vc4ymZ6NcXwVhuGWFHBbgYhCA@mail.gmail.com>
References: <b012e351-54cb-47c5-5fd7-fd2ee22322ed@youngman.org.uk>
 <20200504162138.GA4791@lazy.lzy> <CAJCQCtQaCq+D0YUa-smGqCDAeOQQcq1rM5RJ+xCGsWrCrrnM4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQaCq+D0YUa-smGqCDAeOQQcq1rM5RJ+xCGsWrCrrnM4A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, antlists <antlists@youngman.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 4, 2020 at 2:11 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> On Mon, May 4, 2020 at 10:21 AM Piergiorgio Sartor
> <piergiorgio.sartor@nexgo.de> wrote:
> >
> > On Mon, May 04, 2020 at 12:38:04AM +0100, antlists wrote:
> > > Has anyone else picked up on this? Apparently 1TB and 8TB drives are still
> > > CMR, but new drives between 2 and 6 TB are now SMR drives.
> > >
> > > https://www.extremetech.com/computing/309730-western-digital-comes-clean-shares-which-hard-drives-use-smr
> > >
> > > What impact will this have on using them in raid arrays?
> >
> > https://www.smartmontools.org/ticket/1313
> >
>
> I think it is defective abstraction that's the problem, not SMR per se.
>
> For a drive in normal use to fail with write errors like this? It's defective.
> [20809.396284] blk_update_request: I/O error, dev sdd, sector
> 3484334688 op 0x1:(WRITE) flags 0x700 phys_seg 2 prio class 0
>
> As to what kind of performance guarantees they've made or implied, I
> think they have an obligation to perform no worse than the slowest
> speed of CMR "inside track" performance. However, they want to achieve
> that is their technical problem. They market DM-SMR as handling
> ordinary file systems without local mitigations.
>

This same issue came up on the Btrfs list today. And one suggestion is
stratospheric SCSI block layer timeout settings beyond 10 minutes, to
avoid link resets. That's not what's reported in this thread so far,
so I think we need more information about the exact failure modes.
Link resets, however untenable for some workflows, can be changed. But
discrete write errors, that strikes me as a bug/defect.

-- 
Chris Murphy
