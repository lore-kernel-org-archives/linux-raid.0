From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: libata retry - disable?
Date: Tue, 18 Apr 2006 18:49:14 +0200
Message-ID: <62b0912f0604180949h3448fc48j539a9ea39b1166d0@mail.gmail.com>
References: <62b0912f0604172330g274c286fje159f9d920d5ec61@mail.gmail.com>
	 <4444FB56.9060806@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4444FB56.9060806@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> Molle Bestefich wrote:
> > Does anyone know of a way to disable libata's 5-time retry when a read fails?
> >
> > It has the effect of causing every failed sector read to take 6
> > seconds before it fails, causing raid5 rebuilds to go awfully slow.
> > It's generally undesirable too, when you've got RAID on top that can
> > write replacement data onto the failed sectors..
> >
> > Log showing a failed sector:
> > Apr 18 09:49:53 linux kernel: end_request: I/O error, dev sda, sector 131124407
> > Apr 18 09:49:55 linux kernel: ata1: no sense translation for status: 0x51
> > Apr 18 09:49:55 linux kernel: ata1: translated ATA stat/err 0x51/00 to
> > SCSI SK/ASC/ASCQ 0x3/11/04
> >
> What kernel Molle?
>
> There were some nasties in 2.6.15 to do with FUA. Have a look for my
> postings in linux-ide (my problems are still not entirely resolved).

2.6.16.5.  A bit surprised to see 2.6.16.7 out already.
I think the errors are (were, md-rewrite fixed it) real enough.

> (I got very used to mdadm --force and xfs_repair during that experience!)

:-)
