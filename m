From: Steve Bergman <sbergman27@gmail.com>
Subject: Confirm these stride and stripe-width values?
Date: Wed, 5 Jun 2013 12:11:37 -0500
Message-ID: <CAO9HMNEW1=PWJs0-YdsvPne-X=iW6-GzSpgo6pGr1_CwrQW8AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've configured a dm logical volume with thin provisioning using a
single md device which is configured as a 3-drive RAID-10 (aka RAID1e,
I think) array in the default "near" configuration. My chunk size is
the default 64k. And the fs is to use the default 4k blocks. There are
3 devices + 1 spare.


I've used this command to format it as ext4:

mkfs.ext4 -E stride=16 -E stripe-width=48 /dev/VolumeGroup/VolumeName

I'm seeing poor performance on writes. Only about 43MB/sec in
bonnie++. By comparison, formatting XFS without specifying a stride or
stripe-width gets me 83MB/s. (My understanding is that XFS
autoconfigures the values when running on md/lvm2. It that correct?)

Am I doing something wrong when I format the ext4 fs?

Thanks for any guidance.

-Steve Bergman
