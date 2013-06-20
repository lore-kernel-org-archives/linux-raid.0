From: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Subject: Problem with Raid1 when all drives failed
Date: Thu, 20 Jun 2013 06:22:32 +0000
Message-ID: <84A53BEA6EAC69439B7E311E9B17A76F0174829C@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

We have observed a strange behavior of a RAID1 volume when all its drives failed.
Here is our test case:

Steps to reproduce:
1. Create 2-drives RAID1 (tested on both native and IMSM metadata)
2. Wait for the end of the initial resync 
3. Hot-unplug both drives of the RAID1 volume

Actual behavior:
The RAID1 volume is still present in OS as a degraded one-drive array

Expected behavior:
Should a RAID volume disappear from OS?

I see that when a drive is removed from OS udev runs "mdadm -If <>" for missing member which tries to write "faulty" to the state of array's member.
I see also that md driver prevents from doing this operation for the last drive in a RAID1 array, so when two drives fail nothing really happens to the one that fails as the second one.

It can be very dangerous, because if user has mounted file system at this array it can lead to unstable work of system or even a system crash. More over user does not have proper information about the state of an array.

How should it work according to the design? Should mdadm stop volume when all its members disappear?

Pawel Baldysiak
