From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Creating failed-mode RAID1 with mdadm
Date: Tue, 30 Apr 2002 14:48:32 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020430184832.GA381@willow.seitz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey everyone,

	Creating a new array today, I decided I should probably start
using mdadm instead of the old tools.  I've been using it a bit at home
to do minor things, and it seemed nice.
	I've got a box with two 20G ide drives installed.  One is
currently the root drive at /dev/hda1 and the other is one of the disks
for the mirrored pair at /dev/hde1.  I'm trying to create the array with
/dev/hdg1 as a failed disk, and then move /dev/hda to /dev/hde after I
start booting the machine off of /dev/md0.
	When I do:

# mdadm --create /dev/md0 --level 1 --raid-disks=2 /dev/hde1 /dev/hdg1

I get:

mdadm: Cannot open /dev/hdg1: No such device or address
mdadm: create aborted

This makes sense, as /dev/hdg doesn't really exist yet.  I've tried
doing:

# mdadm --set-faulty /dev/md0 /dev/hdg1

but it doesn't seem to help.  How can I build an array like this via
mdadm?

Ross Vandegrift
ross@willow.seitz.com

