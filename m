From: Alexander Kisselev <kisselev@mail.desy.de>
Subject: Re: MD device id change
Date: Mon, 7 Apr 2003 10:41:08 +0200 (MEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0304071040140.5745-100000@worf.desy.de>
References: <16012.45741.447317.341813@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16012.45741.447317.341813@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: raid-list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  Hi Neil,

> On Thursday April 3, kisselev@mail.desy.de wrote:
> >
> >   Here is the question: is there an easy way to change RAID device ID?
> > If not, is the following sequence correct in my case (1-disk RAID linear):
> >
> >   - stop device;
> >   - 'dd' 4k RAID superblock from /dev/sda2 at offset 292021440;
> >   - change 4-byte field at offset 11 (md_minor) to the desired number
> >     (say '5' for md5);
> >   - copy superblock back;
> >   - reboot;
>
> Sort of, but it is much easier to get mdadm to do this.
> Get mdadm 1.2.0 and check out
>    --assemble --update=super-minor
>
> in the documentation.

  thank you, worked fine.

  Cheers,
    Alexander.

