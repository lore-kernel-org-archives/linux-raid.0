From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Driver for BIOS-based software RAIDs
Date: Tue, 14 Oct 2003 09:18:50 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031014071850.GD1951@marowsky-bree.de>
References: <200310131921.45824.thomas@horsten.com> <200310132025.30939.thomas@horsten.com> <20031013211722.GG23916@marowsky-bree.de> <200310132238.40012.thomas@horsten.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200310132238.40012.thomas@horsten.com>
To: Thomas Horsten <thomas@horsten.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-10-13T22:38:40,
   Thomas Horsten <thomas@horsten.com> said:

> Having said that, BIOS RAID does solve a few problems inherent to sof=
tware=20
> RAID's, particularly the boot process

The boot process is a real problem. It can be partly solved in the
bootloader - iff the BIOS is smart enough to try all disks until it can
read one copy -, but yes, BIOS RAID does have some advantage here. This
is pre-kernel stage though and so beyond this driver anyway.

After the kernel is up and running, we can handle that just fine.

> and consistency of RAID's between operating systems.

That's fortunately a problem I don't have to care about ;-)

> > Windows doesn't use the BIOS to access the device at all; the
> > corresponding hardware drivers emulate that.
> I know, but the BIOS supports its boot up to 32-bit mode. Which means=
 you=20
> could see the drive from DOS, etc.

Well, for the boot loader stage it does have some advantage as I said.

But beyond that it doesn't matter and is bypassed.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering		ever tried. ever failed. no matter.
SuSE Labs				try again. fail again. fail better.
Research & Development, SUSE LINUX AG		-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
