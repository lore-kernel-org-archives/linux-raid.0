From: Atro Tossavainen <atossava@cc.helsinki.fi>
Subject: Re: Root Drive Mirroring and LVM.
Date: Tue, 27 Jan 2004 10:01:17 +0200 (EET)
Sender: owner-linuxppc-dev@lists.linuxppc.org
Message-ID: <200401270801.i0R81HdT022197@kruuna.Helsinki.FI>
References: <868055F9-5045-11D8-8066-00039382032A@mindspring.com>
Reply-To: Atro.Tossavainen@helsinki.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <owner-linuxppc-dev@lists.linuxppc.org>
In-Reply-To: <868055F9-5045-11D8-8066-00039382032A@mindspring.com> from Tim Seufert
 at "Jan 26, 2004 01:20:54 pm"
To: linuxppc-dev@lists.linuxppc.org, linux-raid@vger.kernel.org
Cc: tas@mindspring.com
List-Id: linux-raid.ids


Sorry about the crossposting.

I wrote on the Yellow Dog Linux list when somebody asked about software
RAID on YDL about my experiences with it:

>> The one really big gotcha is that the Macintosh partitioning scheme
>> can't tell the Linux kernel that certain partitions are to be
>> considered "Linux RAID autodetect" (as in x86 using the DOS partition
>> table type 0xfd). This means that you can't boot a Mac Linux system
>> directly from RAID because the kernel won't be able to autostart the
>> RAID devices. You have to work around this by creating an initial RAM
>> disk that uses the raidstart command to start your metadevices, then
>> swaps the initrd out of the way and proceeds to start the real system.

to which Tim Seufert replied on the same list:

> Hmmm.  That would seem to be a lack in the Linux RAID code, since the
> Macintosh partition table has a vastly more flexible partition type
> field than DOS: instead of a single byte it's a string.  It would mean
> breaking from the convention of using the "Apple_SVR2_UNIX" type for
> Linux partitions, but that really is just a convention as far as I know.

Perhaps the PPC Linux developers and the Linux RAID developers should
get together on this and make some decisions so as to make it happen.

--
Atro Tossavainen (Mr.)               / The Institute of Biotechnology at
Systems Analyst, Techno-Amish &     / the University of Helsinki, Finland,
+358-9-19158939  UNIX Dinosaur     / employs me, but my opinions are my own.
< URL : http : / / www . helsinki . fi / %7E atossava / > NO FILE ATTACHMENTS

** Sent via the linuxppc-dev mail list. See http://lists.linuxppc.org/
