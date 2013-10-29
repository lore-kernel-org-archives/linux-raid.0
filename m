From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: aac_write: aac_fib_send failed with status: -12
Date: Tue, 29 Oct 2013 18:14:26 +0100
Message-ID: <wrfjbo28c83x.fsf@redhat.com>
References: <526B675A.2020102@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <526B675A.2020102@crc.id.au> (Steven Haigh's message of "Sat, 26
	Oct 2013 17:55:22 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Steven Haigh <netwiz@crc.id.au> writes:
> Hi all,
>
> Not 100% sure if this is the correct list - or if there is a seperate
> hwraid list.
>
> I seem to be getting some random filesystem corruption on an IBM server
> that I use as a Xen Dom0.
>
> *** Specs ***
> Vendor: IBM
> Version: -[GGE149AUS-1.19]-
> Product Name: IBM System x3650 -[7979CBM]-
> AAC0: kernel 5.2-0[17003] Jul 25 2011
> AAC0: monitor 5.2-0[17003]
> AAC0: bios 5.2-0[17003]
> AAC0: serial 5AB49E0
> scsi0 : ServeRAID
> scsi 0:0:0:0: Direct-Access     ServeRA  Dom0_RAID6       V1.0 PQ: 0 ANSI: 2
> scsi 0:1:0:0: Direct-Access     IBM-ESXS MAY2073RC        T107 PQ: 0 ANSI: 5
> scsi 0:1:1:0: Direct-Access     IBM-ESXS MAY2073RC        T107 PQ: 0 ANSI: 5
> scsi 0:1:2:0: Direct-Access     IBM-ESXS MBC2073RC        SC06 PQ: 0 ANSI: 5
> scsi 0:1:3:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI: 5
> scsi 0:1:4:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI: 5
> scsi 0:1:5:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI: 5
> scsi 0:1:6:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI: 5
> scsi 0:1:7:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI: 5
> scsi 0:3:0:0: Enclosure         IBM-ESXS VSC7160          1.07 PQ: 0 ANSI: 3
>
> I'm currently running kernel 3.11.4 and before the filesystem corruption
> seems to happen, I get a load of these:
> aac_write: aac_fib_send failed with status: -12
>
> While this is going on, random things seem to fail. Eventually, I'll
> reboot the system and lots of tools will segfault - tracing it back
> leads to libraries that seem to have been corrupted.
>
> I can boot the system from rescue media, reinstall all the corrupted
> libraries / binaries and the system runs fine again for another few
> months before it happens again.

Nothing obvious to linux-raid I'd say. It sounds like you have a
hardware problem that either causes memory corruption which is then
written out to disk, or the RAID controller you are using is defective
and corrupts the data during parity calculations or something like that.
It could also be a driver problem.

You can try searching the linux-kernel or linux-scsi mailing list
archives to see if you find any similar reports.

Good luck!

Jes
