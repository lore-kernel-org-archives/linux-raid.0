From: Iustin Pop <iusty@k1024.org>
Subject: Re: mdadm and TLER (Time Limited Error Recovery)
Date: Tue, 8 Sep 2009 20:48:37 +0200
Message-ID: <20090908184837.GA28217@teal.hq.k1024.org>
References: <299cc2790909071735x6eefd8bsc05ad76fa782cae1@mail.gmail.com>
 <slrnhacpsm.2i5.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <slrnhacpsm.2i5.Mario.Holbe@darkside.dyn.samba-tng.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 08, 2009 at 04:17:58PM +0200, Mario 'BitKoenig' Holbe wrote:
> Tim Rutter <timrutter@gmail.com> wrote:
> > Is the TLER on drives like Western Digital's WD2002FYPS a problem or
> > benefit for mdadm(RAID5/RAID6)?
> 
> Neither nor with a very very small drift to "problem", IMHO.
> A (not so little) while ago when md did not automatically correct
> read-errors, the drift to "problem" was a bit less small ;) This could
> be the reason for some of the vague answers you mentioned.
> 
> Anyways, clarification...
> The only reason for TLER (Time Limited Error Recovery) is to behave
> "friendly" toward RAID controllers that timeout disks.
> In fact, md does not timeout disks as many Hardware RAID controllers do.
> So, from md's point of view, TLER is useless, i.e. it has no benefit.

I'm sorry but I disagree here. *Especially* because md is used over
normal SATA controllers most of the time, TLER is beneficial because the
drive doesn't go catatonic for minutes at a time trying to recover a bad
sector, which would (because md doesn't timeout disks) cause md to hung
up the whole device. TLER will allow md to see the error quickly and
attempt to rewrite (read) or retry/fail the disk (write) for a bad the
sector.

Just my understanding of the md stack.

regards,
iustin
