From: linux@horizon.com
Subject: RE: Please help with a special RAID 1 setup
Date: 13 Jan 2004 20:50:25 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040113205025.24981.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andy Cress wrote:
> Note that RAID-1 will only ever have a maximum of 2 active disks.
> When you add the 3rd disk, it is added to the array as a spare, that's
> why it doesn't rebuild.

That surprises the hell out of me...

> md1 : active raid1 hdk1[5] hdi1[4] hdg1[3] hde1[2] hdc1[1] hda1[0]
>      439360 blocks [6/6] [UUUUUU]

(/boot and backup recovery tools.)
