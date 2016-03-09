From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Import/recover RAID6 created with SAS2108?
Date: Wed, 9 Mar 2016 20:27:28 +0100
Message-ID: <20160309192728.GA3581@EIS>
References: <2832CD22-EADC-4BC6-A250-FE8919A92E0A@aol.com>
 <20160307215026.GA8042@EIS>
 <ECED3C91-8D12-469E-A9AB-1337292DA216@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ECED3C91-8D12-469E-A9AB-1337292DA216@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Russell <dpr@aol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 08, 2016 at 10:20:17PM -0500, Dan Russell wrote:
> The partially-rebuilt drive is sdk, the original =E2=80=9Cfailed=E2=80=
=9D drive is sdag

Best to leave both out if one has outdated and the other only half=20
the content...

> However fdisk and mdadm are reporting the array is 17.6TB in size, wh=
ereas it should be 66TB (24 3TB HDDs RAID6).

I reproduced your commands using tmpfs based loop devices and it gives =
me=20
the same problem. The RAID size is only 16 TiB. It seems to be hitting =
a=20
limit somewhere.

Your /dev/mapper/sdx are snapshot/overlays, I hope?

DDF metadata seems to be located at the end of the device, so you could=
 try=20
your luck with mdadm 1.0 metadata instead; that gives me a RAID of a si=
ze=20
closer to home.

# mdadm --create /dev/md42 --assume-clean --metadata=3D1.0 --level=3D6 =
--raid-devices=3D24 --chunk=3D64 /dev/loop{0..23}
# fdisk -l /dev/md42
Disk /dev/md42: 60 TiB, 65999996846080 bytes, 128906243840 sectors
Units: sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 65536 bytes / 1441792 bytes

It wastes some sectors at the end though, not sure if more or less=20
than what DDF uses for metadata. You might have to add some empty=20
space to your device mappings to get a full view.

Regards
Andreas Klauer
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
