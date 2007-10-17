From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [BUG] Raid5 trouble
Date: Wed, 17 Oct 2007 07:58:28 -0700
Message-ID: <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>
References: <4714BB92.7040701@systella.fr> <47161CE3.80909@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47161CE3.80909@systella.fr>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Cc: linux-raid@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-raid.ids

On 10/17/07, BERTRAND Jo=EBl <joel.bertrand@systella.fr> wrote:
> BERTRAND Jo=EBl wrote:
> >     Hello,
> >
> >     I run 2.6.23 linux kernel on two T1000 (sparc64) servers. Each
> > server has a partitionable raid5 array (/dev/md/d0) and I have to
> > synchronize both raid5 volumes by raid1. Thus, I have tried to buil=
d a
> > raid1 volume between /dev/md/d0p1 and /dev/sdi1 (exported by iscsi =
from
> > the second server) and I obtain a BUG :
> >
> > Root gershwin:[/usr/scripts] > mdadm -C /dev/md7 -l1 -n2 /dev/md/d0=
p1
> > /dev/sdi1
> > ...
>
>         Hello,
>
>         I have fixed iscsi-target, and I have tested it. It works now=
 without
> any trouble. Patches were posted on iscsi-target mailing list. When I
> use iSCSI to access to foreign raid5 volume, it works fine. I can for=
mat
> foreign volume, copy large files on it... But when I tried to create =
a
> new raid1 volume with a local raid5 volume and a foreign raid5 volume=
, I
> receive my well known Oops. You can find my dmesg after Oops :
>

Can you send your .config and your bootup dmesg?

Thanks,
Dan
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
