From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID-10 unbalanced reads
Date: Tue, 10 Feb 2009 20:07:55 +0100
Message-ID: <20090210190755.GA5415@lazy.lzy>
References: <20090209202728.GA11996@lazy.lzy> <20090209231138.GB13450@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090209231138.GB13450@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

thanks for the answer.

The kernel is the latest in Fedora 10, i.e.
the 2.6.27.12-170.2.5.fc10.x86_64, the array
has metadata 1.1 and bitmap.

There are two issues, which I noticed, which
have led to the iostat discovery.

One is that the reading speed of the array is
less than double the speed of the slowest drive.
Accordingly to hdparm, /dev/sda2 transfers about
100~110 MB/s, /dev/sdb2 about 75~85 MB/s, while
/dev/md1 goes about 140~150 MB/s.
I would have expected a bit more, let's say
around 150~160 MB/s for the RAID.

Second, I ran a smart long test on both drives.
/dev/sda finished more or less in one hour, as
declared by the smart info (the system was
barely in use).
/dev/sdb finished in maybe 3~4 hours, by far more
than the (about) 1h40m declared by the smart info.

The only reason it took so long could be the drive
was somehow in use, but it belongs completely to
the RAID, so it should be is use as much as /dev/sda.

Or I have some virus...

Any idea?

Thanks again,

pg

On Tue, Feb 10, 2009 at 12:11:39AM +0100, Keld J=F8rn Simonsen wrote:
> On Mon, Feb 09, 2009 at 09:27:28PM +0100, Piergiorgio Sartor wrote:
> > Hi all.
> >=20
> > I've setup a system with two RAID volumes.
> > One is a small RAID-1, /dev/md0, with the /boot
> > content, the other is a RAID-10 f2, with LVM,
> > for the rest of the system.
> >=20
> > I just noticed that /dev/sdb, which is not the
> > boot disk, I assume, has more reads than /dev/sda.
> > Writes are the same, here is the output of "iostat":
> >=20
> > Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_w=
rtn
> > sda              10.08       183.15       408.74     755018    1684=
972
> > sda1              0.04         1.24         0.02       5118        =
 66
> > sda2             10.03       181.71       408.72     749071    1684=
880
> > sdb              10.49       187.64       408.74     773532    1684=
972
> > sdb1              0.03         1.17         0.02       4837        =
 66
> > sdb2             10.44       186.26       408.72     767832    1684=
880
> > md1              62.95       367.26       391.79    1513976    1615=
112
> > md0               0.02         0.18         0.00        724        =
  8
> >=20
> > Note that sda1 has more reads than sdb1.
> > This is possibly due to the fact that it is
> > used during boot.
> >=20
> > What is strange, is sdb2, which has by far
> > more reads than sda2. Both belong to /dev/md1.
> >=20
> > Note also the /dev/sdb is the slowest of the
> > two drives.
> >=20
> > Is that somehow normal?
> > If not, is it possible to find out what or
> > why the reads are unbalanced?
>=20
> What kernel are you using?
> Before 2.6.25 you could have differences in usage.
>=20
> Anyway, I think the difference is too small to be of inportance
> for the performance. Or did you notice a difference?
>=20
> best regards
> keld
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
