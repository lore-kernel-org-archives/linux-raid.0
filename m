From: Nathan Lewis <nathapl@cs.okstate.edu>
Subject: Re: striping and mirroring with only two disks
Date: Sat, 31 Jan 2004 15:36:21 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6.0.1.1.2.20040131152717.03fe1f28@a.cs.okstate.edu>
References: <20040131195302.GA18341@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040131195302.GA18341@rap.rap.dk>
References: <20040131195302.GA18341@rap.rap.dk>
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Even if it were possible, your write performance would be TERRIBLE (ima=
ging=20
writing the chunks in order - 0, 1, 2, 3....  Your disk heads would be=20
thrashing constantly).  The RAID1 code already does read-balancing.  No=
t=20
the same thing as striping, but certainly increases performance on read=
s,=20
especially when more than one read is being done at a time.

If you wanted to try it, I think you might be able to accomplish it wit=
h=20
partitions.  Partition your two disks in half, so you have:
disk1 a & b
disk2 a & b

Then mirror disk1a with disk2b (say as /dev/md0), and likewise mirror=20
disk1b with disk2a (say as /dev/md1).  Then create a RAID0 array (/dev/=
md2)=20
from those two mirrors (md0 and md1).

You could also do it the other way:
create two raid0 arrays (disk1a+disk2a=3D/dev/md0) (disk1b+disk2b=3D/de=
v/md1)=20
then mirror them as /dev/md2.


At 01:53 PM 1/31/2004, Keld J=F8rn Simonsen wrote:
>Hi!
>
>Is it possible to both do striping and mirroring if you only have 2 di=
sks?
>
>I was thinking of having the chunks organized on each disk so
>that striping reads and writes could be done. Eg. by having
>
>disk1: chunk0 chunk2 chunk4 ......   chunk1 chunk3 chunk5
>disk2: chunk1 chunk3 chunk5 ......   chunk0 chunk2 chunk4
>
>Would such a layout of chunks allow for striped reading and writing?
>
>Best regards
>keld
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
