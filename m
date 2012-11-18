From: Phil Turmel <philip@turmel.org>
Subject: Re: Issue with Raid 10 super block failing
Date: Sun, 18 Nov 2012 09:35:51 -0500
Message-ID: <50A8F247.8060002@turmel.org>
References: <CAPAnFc_USC=a8S_0wcsK36Sx=HXgfVTQ4LPC=m9Y9mDFrYrepg@mail.gmail.com> <50A82267.9030802@turmel.org> <CAPAnFc_ZtiE_-6usMHZA56Vx9JOw=gT3O3ABdpb2kcqLV6hcBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPAnFc_ZtiE_-6usMHZA56Vx9JOw=gT3O3ABdpb2kcqLV6hcBw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew Reusser <dreusser@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Drew,


On 11/17/2012 10:07 PM, Drew Reusser wrote:

[top-posting repaired.  Please don't do that on kernel.org lists.]

> On Sat, Nov 17, 2012 at 11:48 PM, Phil Turmel <philip@turmel.org> wrote:

[trim /]

>> This isn't a complete report for four devices.  Please show the output
>> of "blkid" and "cat /proc/partitions" so we can help you report the
>> details needed.

> C is the pen-drive I am booting from currently and F is the 2TB disk I
> was using to backup to.
> 
> mint dev # cat /proc/partitions
> major minor  #blocks  name
> 
>    7        0     939820 loop0
>    8        0  976762584 sda
>    8        1  976760832 sda1
>    8       16  976762584 sdb
>    8       17  976237568 sdb1
>    8       32    1985024 sdc
>    8       33    1984960 sdc1
>    8       48  976762584 sdd
>    8       49  976760832 sdd1
>    8       64  976762584 sde
>    8       65  976237568 sde1
>   11        0    1048575 sr0
>    8       80 1953514584 sdf
>    8       81 1953512448 sdf1

Ok.  This suggests that the array was originally built from partition #1
on each drive, not the drive itself.

> mint dev # blkid
> /dev/loop0: TYPE="squashfs"
> /dev/sda1: UUID="db9e3115-556a-49db-27c4-2d3002657472"
> UUID_SUB="933ec5c0-d681-9e33-adb0-e6c890e337bd" LABEL="mint:0"
> TYPE="linux_raid_member"
> /dev/sdb1: UUID="db9e3115-556a-49db-27c4-2d3002657472"
> UUID_SUB="9d6df7c7-ce40-1405-4ea1-8763a528ecc5" LABEL="mint:0"
> TYPE="linux_raid_member"
> /dev/sdc1: UUID="5860-2FA0" TYPE="vfat"
> /dev/sdd1: UUID="db9e3115-556a-49db-27c4-2d3002657472"
> UUID_SUB="fa1a1b82-989e-933a-95e4-d2495cee901d" LABEL="mint:0"
> TYPE="linux_raid_member"
> /dev/sde1: UUID="db9e3115-556a-49db-27c4-2d3002657472"
> UUID_SUB="594ed481-471e-f11a-027f-1c246f9d057d" LABEL="mint:0"
> TYPE="linux_raid_member"
> /dev/sdf1: UUID="1C3C2B104A8445ED" TYPE="ntfs"

As does this.  Somehow you ended up with a v1.2 superblock on /dev/sda.

Please repeat the examines with "mdadm -E /dev/sd[abde]1"

Phil


