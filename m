From: Thomas Horsten <thomas@horsten.com>
Subject: Re: New mailing list for 2.6 Medley RAID (Silicon Image 3112 etc.)
 BIOS RAID development
Date: Mon, 9 Feb 2004 12:01:55 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.40.0402091155040.8715-100000@jehova.dsm.dk>
References: <1076320246.4444.0.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1076320246.4444.0.camel@laptop.fenrus.com>
To: Arjan van de Ven <arjanv@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 9 Feb 2004, Arjan van de Ven wrote:

> > The reason I insist on autodetection is that I think it's important that if
> > the BIOS will reckognise the drive without additional intervention, so will
> > Linux. This will make the entry route for newbies much simpler.
>
> do you call running devicemapper tools from the initrd autodetection ?

Probably not. I am working with several ways of doing it, and that's why I
wanted to have a discussion about this.

Ideally I'd want something like the MD autodetect code, so that the whole
thing can be set up by the kernel at boot-time if the necessary drivers
are compiled in (by reading the Medley superblock the same way it's done
for 0xfe partitions). And if the drivers are modules, then use the drive
mapper tools from userspace to set it up.

This would be the most flexible solution, since it'd allow you to boot
without an initrd if you wanted that, or to use the initrd and map the
drives manually if you preferred that solution.

Having autodetection at kernel level would make it possible to boot from a
kernel on a floppy disk without initrd support, and in general make a
system easier to set up.

But the reason I wanted this discussion is to figure out the best way to
go about it, and if there are some good arguments against autodetecting in
the kernel I'll listen to them.

// Thomas

