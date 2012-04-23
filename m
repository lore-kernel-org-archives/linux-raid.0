From: Veedar Hokstadt <veedar@gmail.com>
Subject: Re: mdadm -E won't examine loop back device, works ok on source disk
Date: Mon, 23 Apr 2012 00:46:16 -0400
Message-ID: <CANb3qHdLoaqp_N1awphoexuxpVgtnLSBewsGdGnP5NvUp=7BhQ@mail.gmail.com>
References: <CANb3qHeDF10CoRiteo_wwUSvGtpjcNWPh95xdatkFoY+GyAZJQ@mail.gmail.com>
	<20120423075816.6d21afe8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120423075816.6d21afe8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your reply but setting IMSM_NO_PLATFORM seems to have no eff=
ect...

% export IMSM_NO_PLATFORM=3D1
% echo $IMSM_NO_PLATFORM
1

% mdadm -V
mdadm - v3.2.3 - 23rd December 2011

% mdadm -E -v /dev/loop2
mdadm: No md superblock detected on /dev/loop2.

% export IMSM_NO_PLATFORM=3D""
% echo $IMSM_NO_PLATFORM

% mdadm -E -v /dev/loop2
mdadm: No md superblock detected on /dev/loop2.

And trying to assemble fails...
export IMSM_NO_PLATFORM=3D1
% mdadm --assemble /dev/md0 /dev/loop1 /dev/loop2
mdadm: Cannot assemble mbr metadata on /dev/loop1
mdadm: /dev/loop1 has no superblock - assembly aborted

Regards,
V

On Sun, Apr 22, 2012 at 5:58 PM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 22 Apr 2012 17:00:04 -0400 Veedar Hokstadt <veedar@gmail.com>=
 wrote:
>
>> Consider a SATA drive /dev/sdb which is a member of an imsm RAID0 ar=
ray...
>>
>> % sum /dev/sdb
>> 25645 156290904
>>
>> The drive was imaged to a file without error and mounted as a loopba=
ck device...
>>
>> % sum /dev/loop2
>> 25645 156290904
>>
>> The checksums match as expected. But I can not examine the loopback =
I get....
>>
>> % mdadm =A0-E -v /dev/loop2
>> mdadm: No md superblock detected on /dev/loop2.
>>
>> But I can examine the physical source drive /dev/sdb...
>>
>> % mdadm =A0-E -v /dev/sdb
>> /dev/sdb:
>> =A0 =A0 =A0 =A0 =A0 Magic : Intel Raid ISM Cfg Sig.
>> =A0 =A0 =A0 =A0 Version : 1.0.00
>> =A0 =A0 Orig Family : e92a11d9
>> =A0 =A0 =A0 =A0 =A0Family : e92a11d9
>> =A0 =A0 =A0Generation : 00001608
>> =A0 =A0 =A0 =A0 =A0 =A0UUID : 25137636:2ff64e75:10ae5444:4e8f609b
>> =A0 =A0 =A0 =A0Checksum : e1237b20 correct
>> =A0 =A0 MPB Sectors : 1
>> =A0 =A0 =A0 =A0 =A0 Disks : 2
>> =A0 =A0RAID Devices : 1
>>
>> =A0 Disk01 Serial : 8068C3QVT
>> =A0 =A0 =A0 =A0 =A0 State : active
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0Id : 00010000
>> =A0 =A0 Usable Size : 312577294 (149.05 GiB 160.04 GB)
>>
>> [Volume0]:
>> =A0 =A0 =A0 =A0 =A0 =A0UUID : 72acd5fa:35c5a901:995af79b:83a29de1
>> =A0 =A0 =A0RAID Level : 0
>> =A0 =A0 =A0 =A0 Members : 2
>> =A0 =A0 =A0 This Slot : 1
>> =A0 =A0 =A0Array Size : 625154048 (298.10 GiB 320.08 GB)
>> =A0 =A0Per Dev Size : 312577283 (149.05 GiB 160.04 GB)
>> =A0 Sector Offset : 0
>> =A0 =A0 Num Stripes : 1221004
>> =A0 =A0 =A0Chunk Size : 128 KiB
>> =A0 =A0 =A0 =A0Reserved : 0
>> =A0 Migrate State : idle
>> =A0 =A0 =A0 Map State : normal
>> =A0 =A0 Dirty State : clean
>>
>> =A0 Disk00 Serial : 809BC541T
>> =A0 =A0 =A0 =A0 =A0 State : active failed
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0Id : 00000000
>> =A0 =A0 Usable Size : 312577294 (149.05 GiB 160.04 GB)
>>
>> I'm trying to recover data from a failed RAID0.
>> I can successfully reassemble the RAID0 from the image files using
>> other proprietary recovery software.
>> But I would like to get it working with mdadm if at all possible.
>> Any ideas?
>>
>
> Try setting =A0IMSM_NO_PLATFORM in the environment:
>
> =A0IMSM_NO_PLATFORM=3D1 mdadm -E -v /dev/loop2
>
> or
>
> =A0export IMSM_NO_PLATFORM=3D1
> =A0mdadm -E -v /dev/loop2
>
> I think this is fixed in more recent mdadm. =A0You still need IMSM_NO=
_PLATFORM
> to create or assemble an array, but not just to look at it.
>
> NeilBrown
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
