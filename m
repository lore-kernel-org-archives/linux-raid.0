From: "Marcus" <mrhaarmann@gmx-topmail.de>
Subject: Shared RAID Setup
Date: Sat, 29 Aug 2009 14:40:46 +0200
Message-ID: <000501ca28a5$f0f344b0$6902a8c0@haarmann>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I am planning a cold standby database server pair with shared disks (over
Fibre Channel).
The database will use the devices without a filesystem, addressing block
devices directly.

I want to setup two external arrays, the devices should build a RAID 1 in
pairs over both arrays.
This is to handle failure of one complete array, which should not occur
(because each array is itself redundant
with double power, double controller).
We need to do this to be able to replace one complete array without
disturbing the database operation.

The general plan is to make a md with raid 1 for each of the partitions.
The cold standby machine should be able to take over  the whole disk
situation and the IP address which is used to access
the database engine.
This will be done via scripts, executed by heartbeat. I need to have a quick
failover.

OS is Debian Lenny, Machines are 2 Proc Opteron Quad core, Fibre Channel
Adapters QLogic.
Now my questions:
Is it possible to setup the md devices on the cold standby machine already
with one device missing (the fibre channel
devices are visible by both machines at the same time) or will this action
disturb the operation of the md raid on the active machine ?
Or is it more safe to setup the devices when a failover takes place, because
the md process checks the drive permanently ?

If this setup is too dangerous, is it better to create the md initially with
one device missing on failover or should I setup the device with two members
(failover takes place on machine failure, so assuming the external arrays
are not affected at this time, both should be accessible) ?
I assume this would be faster than setting up the raid initially with two
devices, because the raid 1 with one device missing does not have to check
which device is more recent.
The database could come up when the mds are created and then we would re-add
the other devices, which triggers background processing,
but the database is already working.
Because the device was not missing very long, I assume the re-assign process
would not take that long, correct ?

Any thoughts on this ?

Thanks, Marcus

