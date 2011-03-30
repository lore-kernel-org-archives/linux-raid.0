From: Joe Landman <joe.landman@gmail.com>
Subject: Re: raid6 + caviar black + mpt2sas horrific performance
Date: Wed, 30 Mar 2011 12:12:14 -0400
Message-ID: <4D93565E.3070403@gmail.com>
References: <20110330080823.GA9167@apartia.fr> <4D933435.3010709@gmail.com> <20110330152011.GA6863@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110330152011.GA6863@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/30/2011 11:20 AM, Louis-David Mitterrand wrote:
> On Wed, Mar 30, 2011 at 09:46:29AM -0400, Joe Landman wrote:

[...]

>> Try a similar test on your two units, without the "v" option.  Then
>
> - T610:
>
> 	tar -xjf linux-2.6.37.tar.bz2  24.09s user 4.36s system 2% cpu 20:30=
=2E95 total
>
> - PE2900:
>
> 	tar -xjf linux-2.6.37.tar.bz2  17.81s user 3.37s system 64% cpu 33.0=
62 total
>
> Still a huge difference.

The wallclock gives you a huge difference.  The user and system times=20
are quite similar.

[...]

> - T610:
>
> /dev/mapper/cmd1 on / type xfs (rw,inode64,delaylog,logbsize=3D262144=
)
>
> - PE2900:
>
> /dev/mapper/cmd1 on / type xfs (rw,inode64,delaylog,logbsize=3D262144=
)

Hmmm.  You are layering an LVM atop the raid?  Your raids are /dev/md1.=
=20
  How is /dev/mapper/cmd1 related to /dev/md1?

[...]

>> [root@vault t]# dd if=3D/dev/md2 of=3D/dev/null bs=3D32k count=3D320=
00
>
> - T610:
>
> 32000+0 enregistrements lus
> 32000+0 enregistrements =E9crits
> 1048576000 octets (1,0 GB) copi=E9s, 1,70421 s, 615 MB/s
>
> - PE2900:
>
> 32000+0 records in
> 32000+0 records out
> 1048576000 bytes (1.0 GB) copied, 2.02322 s, 518 MB/s

Raw reads from the MD device.  For completeness, you should also do

	dd if=3D/dev/mapper/cmd1 of=3D/dev/null bs=3D32k count=3D32000

and

	dd if=3D/backup/t/big.file  of=3D/dev/null bs=3D32k count=3D32000

to see if there is a sudden loss of performance at some level.

>> [root@vault t]# dd if=3D/dev/zero of=3D/backup/t/big.file bs=3D32k c=
ount=3D32000
>
> - T610:
>
> 32000+0 enregistrements lus
> 32000+0 enregistrements =E9crits
> 1048576000 octets (1,0 GB) copi=E9s, 0,870001 s, 1,2 GB/s
>
> - PE2900:
>
> 32000+0 records in
> 32000+0 records out
> 1048576000 bytes (1.0 GB) copied, 9.11934 s, 115 MB/s

Ahhh ...  look at that.  Cached write is very different between the two=
=2E=20
  An order of magnitude.  You could also try a direct (noncached) write=
,=20
using oflag=3Ddirect at the end of the line.  This could be useful, tho=
ugh=20
direct IO isn't terribly fast on MD raids.

If we can get the other dd's indicated, we might have a better sense of=
=20
which layer is causing the issue.  It might not be MD.

--=20
Joseph Landman, Ph.D
=46ounder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
