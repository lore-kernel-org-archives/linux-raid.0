From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: raid10 vs raid5 - strange performance
Date: Wed, 26 Mar 2008 18:16:30 +0100
Message-ID: <bb145bd20803261016t351e4b98rb8989cc6c849108f@mail.gmail.com>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com>
	 <20080325233649.GA632@rap.rap.dk>
	 <bb145bd20803251837x7ef1fa9dk6191fcaea7b02144@mail.gmail.com>
	 <20080326072416.GA8674@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080326072416.GA8674@rap.rap.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Keld_J=C3=B8rn_Simonsen?= <keld@dkuug.dk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>  OK, I think the normal hype on raid10 is to use the far layout for its
>  better striping performance.

Wasn't f2 supposed to improve *reads*? Maybe I've got it backwards.

>  Are the disks SATA disks or SCSI disks?

PATA. It's a how-to-best-utilize-some-older-stuff project.

>  you could probably get some more performance by moving 2 disks
>  to the PATA controller of the motherboard,

The board is newish and has just one PATA channel and that's
explicitly for CDROM use.

>  I think it is interesting that your 3ware controller is not maxing out
>  the PCI bus! With 6 disks of nominally 60 MB/s the  theoretical max is
>  360 MB/s. So the 3ware controller really has IO bandwidth available
>  which it is not getting close on putting to use.

Yes, that's the juicy part :)

>  What is the specifics for the 3ware controller?

http://www.3ware.com/products/parallel_ata.asp

It's the 8port version. Maybe their newer controllers are better but
this one frankly sucks at anything but raid1 and maybe raid0 ...

Cheers,

C.
