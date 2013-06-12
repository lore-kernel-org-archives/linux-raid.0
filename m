From: Phil Turmel <philip@turmel.org>
Subject: Re: Fwd: Help with failed RAID-5 -> 6 migration
Date: Wed, 12 Jun 2013 10:51:19 -0400
Message-ID: <51B88AE7.70900@turmel.org>
References: <CAASLJ=5ewoeNPV1-fwRm3o6rCxQjCYxuJTZ5M9g7p-vFpgDW-w@mail.gmail.com> <51B3B7FF.9080800@turmel.org> <CAASLJ=5JkQ8L9fbrOSUKH8Y-a7PZgkTcCsi6PW=rhzsUPRF6ow@mail.gmail.com> <CAASLJ=7NyJHSMhfhmOFFVR8-7OT5sOp24_WJs-kd6zX54fOG7w@mail.gmail.com> <51B62A8A.9070108@turmel.org> <CAASLJ=52pzLpk179U=SY+5aGmEe+XcSfrEuBLC_o1ThPvAXfew@mail.gmail.com> <51B6FF7E.1000707@turmel.org> <CAASLJ=6eEVY6DeZ=+9Aw6yXmqNSc5mygqtD_8y+MaUid6B_TcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAASLJ=6eEVY6DeZ=+9Aw6yXmqNSc5mygqtD_8y+MaUid6B_TcQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Phillips <spootsy.ootsy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry for the dupe, forgot the list:

On 06/11/2013 08:01 AM, Keith Phillips wrote:

[trim /]

> Assembling it with "mdadm -vv --assemble /dev/md0 /dev/sd[bcde]":
> -----------------------
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sde is identified as a member of /dev/md0, slot 3.
> mdadm:/dev/md0 has an active reshape - checking if critical section
> needs to be restored
> mdadm: Failed to find backup of critical section
> mdadm: Failed to restore critical section for reshape, sorry.
>       Possibly you needed to specify the --backup-file
                                           ^^^^^^^^^^^^^

You won't be able to assemble and run your array without a backup file.
 You said you lost your original, so you will have to use a blank one
and tell mdadm to ignore the invalid file.

When reshaping, some scenarios need the backup file only on the first
stripe.  Some only on the last stripe.  And some need the backup file
for every stripe.  That appears to be your situation.  Note that when
needed for every stripe, the speed of the reshape will be limited by the
speed of the device holding the backup file.

Phil
