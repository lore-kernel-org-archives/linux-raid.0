From: jlcenter@comcast.net
Subject: Fwd: grub-probe seems to be having problems
Date: Thu, 22 Mar 2012 17:52:57 +0000 (UTC)
Message-ID: <1838035626.349729.1332438777326.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
References: <4F5A48CF.50607@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_349728_712143523.1332438777324"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F5A48CF.50607@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

------=_Part_349728_712143523.1332438777324
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Neil,

I think this might be the message that was referred to.  I was hoping I mig=
ht peak someone's interest in checking out this discussion on grub-devel.  =
I would be very happy to see GRUB work better with mdadm, not get in the mi=
ddle of a discussion I barely understand.  Unfortunately, I only know enoug=
h to be dangerous... :-)

    -John

----- Forwarded Message -----
From: "Vladimir '=CF=86-coder/phcoder' Serbinenko" <phcoder@gmail.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>, "The development of =
GRUB 2" <grub-devel@gnu.org>, "Marco d'Itri" <md@Linux.IT>
Sent: Friday, March 9, 2012 1:15:43 PM
Subject: Re: grub-probe seems to be having problems

On 09.03.2012 17:05, Lennart Sorensen wrote:
> Attached is the first 512bytes of each disk (so partition table), and
> the first 64k of each partition and I believe the last 64k of each
> partition. The raid meta data appears to be in the first 64k of each
> partition. I have spared the grub-devel list from getting those.=20

The thing is: raid_disks =3D 2 in your metadata. I don't know how this
could be correct or how you could land with such a config.

@md: The problem is following: Lennart has a raid 1 on 3 disks, however
raid_disks in sdd2 is 2 and dev_roles contains only [0, 1, -1, -1, ...],
dev_number is 0

sda2 and sdb2 contain proper raid_disks=3D3, dev_roles=3D[0,1,2,-1,-1,..]
and dev_number=3D 0 respectively 1. It looks to me as a seriously damaged
metadata but apparently mdadm has no problem
@Lennart: did you dd one disk to another or done something like this?

root@rceng03new:~# mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Wed Feb  8 14:39:24 2012
     Raid Level : raid1
     Array Size : 976884 (954.15 MiB 1000.33 MB)
  Used Dev Size : 976884 (954.15 MiB 1000.33 MB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Thu Mar  1 15:02:06 2012
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

           Name : rceng03new:0  (local to host rceng03new)
           UUID : 88d43dc8:2888fece:34c1486f:49caa398
         Events : 74

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       50        2      active sync   /dev/sdd2



--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko



_______________________________________________
Grub-devel mailing list
Grub-devel@gnu.org
https://lists.gnu.org/mailman/listinfo/grub-devel

------=_Part_349728_712143523.1332438777324
Content-Type: application/pgp-signature; name=signature.asc
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=signature.asc
Content-Description: OpenPGP digital signature

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0NClZlcnNpb246IEdudVBHIHYxLjQuMTIgKEdO
VS9MaW51eCkNCkNvbW1lbnQ6IFVzaW5nIEdudVBHIHdpdGggTW96aWxsYSAtIGh0dHA6Ly9lbmln
bWFpbC5tb3pkZXYub3JnLw0KDQppRjRFQVJFS0FBWUZBazlhU004QUNna1FOYWs3ZE9ndVFna2E0
UUVBdUJJQ3p4cGlCZVhpSktUNGd5QlRlWnl5DQpSMUJkTkI1Zlo3eGFBbTg2SVJJQS9pck5XSmpZ
STZDN3RKajlEYzdta0ZsSEh2TTJKb05aZDlKODcvQWR1U3djDQo9TWJpcQ0KLS0tLS1FTkQgUEdQ
IFNJR05BVFVSRS0tLS0tDQo=
------=_Part_349728_712143523.1332438777324--
