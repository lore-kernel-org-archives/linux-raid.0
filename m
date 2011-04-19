From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: raid6 + caviar black + mpt2sas horrific performance
Date: Tue, 19 Apr 2011 13:04:48 +0200
Message-ID: <20110419110443.GA12278@apartia.fr>
References: <20110330080823.GA9167@apartia.fr>
 <4D933435.3010709@gmail.com>
 <20110330152011.GA6863@apartia.fr>
 <4D93565E.3070403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D93565E.3070403@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 30, 2011 at 12:12:14PM -0400, Joe Landman wrote:
> >- T610:
> >
> >32000+0 enregistrements lus
> >32000+0 enregistrements =E9crits
> >1048576000 octets (1,0 GB) copi=E9s, 0,870001 s, 1,2 GB/s
> >
> >- PE2900:
> >
> >32000+0 records in
> >32000+0 records out
> >1048576000 bytes (1.0 GB) copied, 9.11934 s, 115 MB/s
>=20
> Ahhh ...  look at that.  Cached write is very different between the
> two.  An order of magnitude.  You could also try a direct
> (noncached) write, using oflag=3Ddirect at the end of the line.  This
> could be useful, though direct IO isn't terribly fast on MD raids.
>=20
> If we can get the other dd's indicated, we might have a better sense
> of which layer is causing the issue.  It might not be MD.

Hi,

=46WIW I removed a disk from the raid6 array, formatted a partition as =
xfs
and mounted it to test write speed on a single device:

- T610 (LSI Logic SAS2008 + 8 X WDC Caviar Black WD1002FAEX):

	ZENON:/mnt/test# time tar -xjf /usr/src/linux-2.6.37.tar.bz2=20
	tar -xjf /usr/src/linux-2.6.37.tar.bz2  21.89s user 3.93s system 44% c=
pu 58.115 total
	ZENON:/mnt/test# time rm linux-2.6.37 -rf
	rm -i linux-2.6.37 -rf  0.07s user 2.29s system 1% cpu 2:28.32 total

- PE2900 (MegaRAID SAS 1078 + 8 X Hitachi Ultrastar 7K1000):

	PYRRHUS:/mnt/test# time tar -xjf /usr/src/linux-2.6.37.tar.bz2
	tar -xjf /usr/src/linux-2.6.37.tar.bz2  18.00s user 3.20s system 114% =
cpu 18.537 total
	PYRRHUS:/mnt/test# time rm linux-2.6.37 -rf
	rm -i linux-2.6.37 -rf  0.03s user 1.68s system 63% cpu 2.665 total

This would mean that the problem really lies with the controller or the
disks, not the raid6 array.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
