From: Jonas Fisher <fisherthepooh@protonmail.com>
Subject: Choosing the value to update the size of each member device in mdadm Grow_reshape
Date: Wed, 17 Jun 2020 03:14:12 +0000
Message-ID: <D6m2t3zOKX2WVfwblOhsMTF2cxL2bcl55Amvta4TPl8c9f5wv79ydTCPMsuX0WCtexsFSK-Bjlpryhccn3cpC_F48XdEgYOnSujcnrMydrs=@protonmail.com>
Reply-To: Jonas Fisher <fisherthepooh@protonmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I got a raid1 composed with 2 disks, 4T each

At first, I was only using 1T of the each disk, then I grew the array recen=
tly

with the command

mdadm --grow /dev/md1 --size=3D1951944704K

After grow finished, I found that Avail Dev Size become 3903889408

not like 4T as before

/dev/sdb3:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 8d7b8858:e0e93d83:7c87e6e0:bd1628b8
           Name : 1
  Creation Time : Sun Apr 8 09:54:47 2018
     Raid Level : raid1
   Raid Devices : 2

Avail Dev Size : 3903889408 (1861.52 GiB 1998.79 GB)
     Array Size : 1951944704 (1861.52 GiB 1998.79 GB)
........

/dev/sda3:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 8d7b8858:e0e93d83:7c87e6e0:bd1628b8
           Name : 1
  Creation Time : Sun Apr 8 09:54:47 2018
     Raid Level : raid1
   Raid Devices : 2

Avail Dev Size : 3903889408 (1861.52 GiB 1998.79 GB)
     Array Size : 1951944704 (1861.52 GiB 1998.79 GB)

after tracing the code, this value was modified in mdadm Grow.c

Grow_reshape() function

/* Update the size of each member device in case
  * they have been resized.  This will never reduce
  * below the current used-size.  The "size" attribute
  * understands '0' to mean 'max'.
  */
min_csize =3D 0;
rv =3D 0;
for (mdi =3D sra->devs; mdi; mdi =3D mdi->next) {
         if (sysfs_set_num(sra, mdi, "size",
                           s->size =3D=3D MAX_SIZE ? 0 : s->size) < 0) {
                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                 /* Probably kernel refusing to let us
                  * reduce the size - not an error.
                  */
                 break;
         }

I thought the "size" here in kernel means "Device size", but under this sit=
uation,

my component device size become smaller than its actual size

I was curious that why don't we always set the size to MAX_SIZE?

Thanks,
