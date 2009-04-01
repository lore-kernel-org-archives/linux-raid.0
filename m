From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm ignoring homehost?
Date: Thu, 2 Apr 2009 09:46:55 +1100
Message-ID: <18899.61151.445765.360191@notabene.brown>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com>
	<cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Wednesday April 1
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday April 1, jnelson-linux-raid@jamponi.net wrote:
> ping?

Oh yeah, that's right, I was going to reply to that - thanks for the
reminder.=20

>=20
> On Tue, Mar 24, 2009 at 11:57 AM, Jon Nelson
> <jnelson-linux-raid@jamponi.net> wrote:
> >
> > I have a raid1 comprised of a local physical device (/dev/sda) and =
a
> > network block device (/dev/nbd0).
> > When the machine hosting the network block device comes up, however=
,
> > it creates /dev/md127.
> > Why?

Because you cannot please all the people, all the time.

People seem to want their arrays to auto-assemble - you know, just
appear and do the right thing, read their mind probably, because
creating config files is too hard.
So I've endeavoured to make that happen.

The biggest problem with auto-assembly is what to do if two arrays
claim to have the same name. (e.g. /dev/md0) - which one wins.
The 'homehost' is (currently) used to resolve that.  An array only
gets to use the name it claims to have if it can show that it belongs
to "this" host.  If it doesn't it still get assembled, but with some
other more generic name.

But you want to actually stop some arrays from being assembled on a
particular host, in this case because the device is shared with
another host which "owns" the array.  mdadm cannot currently cope with
that.   But we have the source Luke!

Maybe I could make a three-way distinction with the 'homehost':
  - this host
  - no host specified
  - some other host

and only auto-assemble the first two. I suspect that would
inconvenience someone else though....

=46or now, my only suggestion is to provide a "DEVICES" line in you
mdadm.conf which lists all the device that you do want assembled into
arrays, but excluded /dev/sdb.

NeilBrown



> >
> > On the machine hosting the network block device, /dev/sdb is what
> > backs /dev/nbd0.
> > This is physical storage for /dev/nbd0:
> >
> > frank:~ # mdadm --examine /dev/sdb
> > /dev/sdb:
> > =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> > =A0 =A0 =A0 =A0Version : 1.0
> > =A0 =A0Feature Map : 0x1
> > =A0 =A0 Array UUID : cf24d099:9e174a79:2a2f6797:dcff1420
> > =A0 =A0 =A0 =A0 =A0 Name : turnip:11
> > =A0Creation Time : Mon Dec 15 07:06:13 2008
> > =A0 =A0 Raid Level : raid1
> > =A0 Raid Devices : 2
> >
> > =A0Avail Dev Size : 160086384 (76.34 GiB 81.96 GB)
> > =A0 =A0 Array Size : 156247976 (74.50 GiB 80.00 GB)
> > =A0Used Dev Size : 156247976 (74.50 GiB 80.00 GB)
> > =A0 Super Offset : 160086512 sectors
> > =A0 =A0 =A0 =A0 =A0State : clean
> > =A0 =A0Device UUID : 01524a75:c309869c:6da972c9:084115c6
> >
> > Internal Bitmap : 2 sectors from superblock
> > =A0 =A0 =A0Flags : write-mostly
> > =A0 =A0Update Time : Tue Mar 24 11:41:41 2009
> > =A0 =A0 =A0 Checksum : 643e99c0 - correct
> > =A0 =A0 =A0 =A0 Events : 111338
> >
> >
> > =A0 =A0Array Slot : 2 (failed, failed, empty, 1)
> > =A0 Array State : _u 2 failed
> > frank:~ #
> >
> >
> > As you can see, the "Name" attribute is "turnip:11". The hostname i=
s
> > "frank". Why did frank bring up the device?
> > The only thing in frank's /etc/mdadm.conf is "HOMEHOST frank" which=
 I
> > didn't think was necessary anyway.
> >
> >
> >
> > --
> > Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
