From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Problem with changing array_size
Date: Tue, 30 Mar 2010 15:13:57 -0700
Message-ID: <e9c3a7c21003301513l48cb89d7g48c5e0a0742ef043@mail.gmail.com>
References: <905EDD02F158D948B186911EB64DB3D11C584B56@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D11C584B56@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Tue, Mar 30, 2010 at 6:53 AM, Kwolek, Adam <adam.kwolek@intel.com> w=
rote:
> I found that setting new raid volume size using array_size entry in s=
ysfs causes that inode references in vfs can be lost.
>
> Conditions:
> =A0SLES 11 (32bit) machine with
> =A0 =A0 =A0 =A0kernel: 2.6.33
> =A0 =A0 =A0 =A0mdadm : 3.1.2
> =A05 SATA hdds in system:
> =A0 =A0 =A0 =A0SLES 11 on =A0 /dev/sda
> =A0 =A0 =A0 =A04 test disks /dev/hdb - /dev/hde
>
> Reproduction:
> 1. Configure:
> =A0 =A0 =A0 =A0# create native raid5 volume, with specified size (rel=
atively small)
> =A0 =A0 =A0 =A0mdadm -C /dev/md/raid5vol_0 -amd -l 5 --chunk 64 --siz=
e 104857 -n 3 /dev/sdb /dev/sdc /dev/sde -R
>
> =A0 =A0 =A0 =A0# Create file system
> =A0 =A0 =A0 =A0mkfs /dev/md/raid5vol_0
>
> =A0 =A0 =A0 =A0# mount it and copy some files there
> =A0 =A0 =A0 =A0mount /dev/md/raid5vol_0 /mnt/vol
> =A0 =A0 =A0 =A0cp * /mnt/vol
>
> 2. Try to change volume size. This should affect volume, but not vfs
> =A0 =A0 =A0 =A0echo "157285" >/sys/block/md127/md/array_size

Of course this affects the filesystem.  You have reduced the size of
the volume from 209,664KB to 157,285KB.  Perhaps you are confusing the
--size parameter to mdadm (which is per member) and the md/array_size
attribute which is the total volume size??


> In the few tries (maybe at first shot) you would probably find that w=
hen you are trying to execute ls command on mounted volume message in u=
ser space appears:
> =A0 =A0 =A0 =A0ls: cannot access 'copied file name': Input/output err=
or
> In kernel space messages can be found:
> =A0In response to size change:
> =A0 =A0 =A0 =A0Mar 30 16:27:03 linux kernel: md127: detected capacity=
 change from 214695936 to 161059840
> =A0 =A0 =A0 =A0Mar 30 16:27:03 linux kernel: VFS: busy inodes on chan=
ged media or resized disk md127

Yes, the filesystem is horribly confused at this point because 50MB of
space has disappeared.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
