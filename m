From: Sven Luther <sven.luther@wanadoo.fr>
Subject: Re: Root Drive Mirroring and LVM.
Date: Tue, 27 Jan 2004 10:32:13 +0100
Sender: owner-linuxppc-dev@lists.linuxppc.org
Message-ID: <20040127093213.GA10049@iliana>
References: <868055F9-5045-11D8-8066-00039382032A@mindspring.com> <200401270801.i0R81HdT022197@kruuna.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <owner-linuxppc-dev@lists.linuxppc.org>
Content-Disposition: inline
In-Reply-To: <200401270801.i0R81HdT022197@kruuna.Helsinki.FI>
To: Atro.Tossavainen@helsinki.fi
Cc: linuxppc-dev@lists.linuxppc.org, linux-raid@vger.kernel.org, tas@mindspring.com
List-Id: linux-raid.ids


On Tue, Jan 27, 2004 at 10:01:17AM +0200, Atro Tossavainen wrote:
>
> Sorry about the crossposting.
>
> I wrote on the Yellow Dog Linux list when somebody asked about software
> RAID on YDL about my experiences with it:
>
> >> The one really big gotcha is that the Macintosh partitioning scheme
> >> can't tell the Linux kernel that certain partitions are to be
> >> considered "Linux RAID autodetect" (as in x86 using the DOS partition
> >> table type 0xfd). This means that you can't boot a Mac Linux system
> >> directly from RAID because the kernel won't be able to autostart the
> >> RAID devices. You have to work around this by creating an initial RAM
> >> disk that uses the raidstart command to start your metadevices, then
> >> swaps the initrd out of the way and proceeds to start the real system.
>
> to which Tim Seufert replied on the same list:
>
> > Hmmm.  That would seem to be a lack in the Linux RAID code, since the
> > Macintosh partition table has a vastly more flexible partition type
> > field than DOS: instead of a single byte it's a string.  It would mean
> > breaking from the convention of using the "Apple_SVR2_UNIX" type for
> > Linux partitions, but that really is just a convention as far as I know.
>
> Perhaps the PPC Linux developers and the Linux RAID developers should
> get together on this and make some decisions so as to make it happen.

Seems ok for me. Also, i guess that there are other partition types,
like the amiga partitition table the pegasos boxes mostly use, which has
a 32bit identifier for partition types. I guess it is the task of the
RAID code to have some per partition type checking for this RAID autodetect
magic.

Friendly,

Sven Luther

** Sent via the linuxppc-dev mail list. See http://lists.linuxppc.org/
