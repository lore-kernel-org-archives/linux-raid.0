From: "Michael Li" <michael.li@netgear.com>
Subject: RE: RAID10 status when you remove the first disk and last disk
Date: Tue, 20 Jul 2010 22:36:01 -0700
Message-ID: <F03AFE7E8C7E644392BE79B102C8B5A50489FDA9@MAIL3.netgear.com>
References: <F03AFE7E8C7E644392BE79B102C8B5A50489FCD5@MAIL3.netgear.com> <20100721130650.3b23b960@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20100721130650.3b23b960@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your attention.
I am using version 2.6.33.4
# mdadm -D /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Tue Jul 20 00:17:31 2010
     Raid Level : raid10
     Array Size : 7401216 (7.06 GiB 7.58 GB)
  Used Dev Size : 3700608 (3.53 GiB 3.79 GB)
   Raid Devices : 4
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Tue Jul 20 22:34:12 2010
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : far=3D2
     Chunk Size : 64K

           Name : 001F33EA1487:2
           UUID : 58fa65b1:36791e6c:708a49d6:e458fe4e
         Events : 698

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       19        1      active sync   /dev/sdb3
       2       8       35        2      active sync   /dev/sdc3
       3       0        0        3      removed

-----Original Message-----
=46rom: Neil Brown [mailto:neilb@suse.de]=20
Sent: 2010=C4=EA7=D4=C221=C8=D5 11:07
To: Michael Li
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID10 status when you remove the first disk and last disk

On Tue, 20 Jul 2010 19:34:06 -0700
"Michael Li" <michael.li@netgear.com> wrote:

> Hi ,
>=20
> =20
>=20
> I am using RAID10 far copy 2 by 4 disks, when I removed the first dis=
k
> and last disk, I think this raid should be failed, but mdadm -D
> /dev/md2, I saw it was degraded, but when I try to read/write, there
> will be I/O error. And when I added the two disks again, the raid wil=
l
> be recovery, so that's normal? why it is designed like this?
>=20
> =20
>=20
> Anyone know the detail about that? Thanks so much!
>=20

Sounds like a bug.  You have definitely lost data if the first and last
devices of such an array go missing, so it should not try to recover a =
spare
in to either slot.

What kernel version are you using?

NeilBrown

This e-mail, including attachments, may include confidential=20
and/or=20
proprietary information, and may be used only by the person or=20
entity to which it is addressed.  If the reader of this e-mail is=20
not the intended recipient or his or her authorized agent, the=20
reader is hereby notified that any dissemination, distribution or=20
copying of this e-mail is prohibited. If you have received this e-
mail in error, please notify the sender by replying to this message=20
and delete this e-mail immediately
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
