From: NeilBrown <neilb@suse.de>
Subject: Re: Likely forced assemby with wrong disk during raid5 grow.
 Recoverable?
Date: Wed, 23 Feb 2011 12:53:38 +1100
Message-ID: <20110223125338.2179dd78@notabene.brown>
References: <AANLkTikhOAXQ6JAG1fK3x9V3icki8cjn0_ggyQwkGmnt@mail.gmail.com>
	<AANLkTi=5UZcMRKHTiXC3w8joh-qyi50gtTYwRf_scksW@mail.gmail.com>
	<20110220162509.2eb85a03@notabene.brown>
	<AANLkTi=-guMf-8YJDMvq9ybyY9Fppi+W0pqhH2Of=mKd@mail.gmail.com>
	<20110221115303.4862e093@notabene.brown>
	<AANLkTimaemNqVwaLmqYCS+6fHCTVmAqzUe9RUh3rdhvc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimaemNqVwaLmqYCS+6fHCTVmAqzUe9RUh3rdhvc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Claude Nobs <claudenobs@blunet.cc>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 23 Feb 2011 01:56:13 +0100 Claude Nobs <claudenobs@blunet.cc> w=
rote:

> bernstein@server:~/mdadm$ sudo ./mdadm -Afvv /dev/md2 /dev/sda1
> /dev/md0 /dev/md1 /dev/sdc1
> mdadm: looking for devices for /dev/md2
> mdadm: /dev/sda1 is identified as a member of /dev/md2, slot 4.
> mdadm: /dev/md0 is identified as a member of /dev/md2, slot 3.
> mdadm: /dev/md1 is identified as a member of /dev/md2, slot 2.
> mdadm: /dev/sdc1 is identified as a member of /dev/md2, slot 0.
> mdadm: forcing event count in /dev/md1(2) from 133603 upto 133609

This is normal - mdadm is just letting you know that it is including in=
 the=20
array a device that looks a bit old - we expected this.

> mdadm: Cannot open /dev/sdc1: Device or resource busy

This is odd.  I cannot explain this at all.  When this message is print=
ed
mdadm should give up and  not continue.  Yet it seems that it did conti=
nue
because the array is started and is reshaping.

> bernstein@server:~/mdadm$ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md2 : active raid5 md1[3] md0[4] sda1[5] sdc1[0]
> =A0=A0=A0=A0=A0 2930281920 blocks super 1.2 level 5, 64k chunk, algor=
ithm 2 [5/4] [U_UUU]
> =A0=A0=A0=A0=A0 [=3D=3D>..................]=A0 reshape =3D 12.8% (125=
839952/976760640)
> finish=3D825.1min speed=3D17186K/sec

This looks OK.  125839952 corresponds to a "reshape Pos'n" of=20
503359808 which is slightly after where we would expect it to start, wh=
ich
is what we would expect.
There won't be any info in the logs to tell us exactly where it started=
,
which is a shame, but it probably started at the right place.

>=20
> this i not strictly a raid/mdadm question, but do you know a simple
> way to ckeck everything went ok? i think that an e2fsck (ext4 fs) and
> checksumming some random files located behind the interruption point
> should verify all went ok. plus just to be sure i'd like to check
> files located at the interruption point. is the offset to the
> interruption point into the md device simply the reshape pos'n (e.g.
> 502815488K) ?

No - just the things you suggest.
The Reshape pos'n is the address in the array where reshape was up to.
You could try using 'debugfs' to have a look at the context of those bl=
ocks.
Remember to divide this number by 4 to get an ext4fs block number (assu=
ming
4K blocks).

Use:   testb BLOCKNUMBER COUNT

to see if the blocks were even allocated.
Then
       icheck BLOCKNUM
on a few of the blocks to see what inode was using them.
Then
       ncheck INODE
to find a path to that inode number.


=46eel free to report your results - particularly if you find anything =
helpful.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
