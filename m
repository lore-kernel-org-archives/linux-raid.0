From: Chris <email.bug@arcor.de>
Subject: Re: What are mdadm maintainers to do? (error recovery redundancy/data loss)
Date: Tue, 17 Feb 2015 23:33:26 +0000 (UTC)
Message-ID: <loom.20150217T232739-21@post.gmane.org>
References: <loom.20150214T222329-324@post.gmane.org> <20150216142845.0d50207c@notabene.brown> <loom.20150216T124230-883@post.gmane.org> <54E1EDEA.1030503@turmel.org> <loom.20150216T165111-551@post.gmane.org> <54E226B5.1080500@turmel.org> <loom.20150216T183419-387@post.gmane.org> <20150217104906.62d36c62@notabene.brown> <loom.20150217T080345-764@post.gmane.org> <CAJCQCtQvoB0yPPc=RXPPyJhpaFwH0pQTRCRaR_ycTbzHrD6rLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Murphy writes:

> 
> It's not just mdadm. It likewise affects Btrfs, ZFS, and LVM.

Do they have own timouts, or rely on the kernel?
Maybe the kernel could read the SCTERT value from the drives (in lieu of
some better retry timout information, and set the controller timout a little
greater than that, or very large if SCTERT is disabled/not available.


> sda1 and sdb1 are raid0, and sda2 and sdb2 are
> raid1. What's the proper configuration for SCT ERC and the SCSI
> command timer?

guessing...

For SCTERT disabled drives:
A compromise may be to stay with the linux default controller timout, it's
30s, and set the drives SCTERT below 30s (maybe 27s), to avoid losing
redundancy and risking data loss *AND* allow more of the available time for ERC.

For longer error correcting attempts (and just as long i/o controller
blocking!) the contoller timout could be set to 180s, and SCTERT to 175s?

BUT: If I chose to use a raid0 alongside a redundant raid I already
explicitly decided to take all data loss the hardware throws at me. So I
don't think it makes much of a difference if ERC times out after <30 secs or
180s, its just more or less errors belonging to me.


For SCTERC enabled drives:
30s and 7s seems ok?



 
> *shrug* I don't think the automatic udev configuration idea is fail
> safe. It sounds too easy for it to automatically cause a
> misconfiguration.


A matching timeout configuration prevents that unavoidable unrecoverable
read error take down the redundancy for sure, and cause high risk of data
loss during rebuild.

It does fix a misconfiguration, however could possibly set SCTERT just below
the (30s) controler timout, to reduce the impact of SCTERT (e.g make use of
the small chance of error correction succceding a couple of seconds later).
Given the longer SCTERT timout does not lead to subseqent read error timouts
piling up.


> And it also doesn't at all solve the problem that
> there's next to no error reporting to user space.

That is correct, but rather not related to the importance to fix the timout
mismatch and reduce the risk, is it? The settings do solve unecessary loss
of redundancy on read errors that are sure to occur, unnecessary resyncing,
and high risk of data loss during all that.



