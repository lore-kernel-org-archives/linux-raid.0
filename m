From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: RAID 5 recovery to not degrade device on bad block
Date: Sun, 23 Aug 2009 13:46:10 +0530
Message-ID: <5c45fce80908230116o2f129ab4y8d255cbe83bfac5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here is a simple feature request which I assume would not be much
logic change for kernel devs familiar with the code.

Essentially, if I understand correctly, the kernel raid code will try
to let the drive fix a bad sector and otherwise fail the device and
degrade the array.
However, if an array is already degraded then this behvaviour can be
very limiting because typically you are in recovery mode and want to
get as much data out to your new disk as you can.

I would say that for an already degraded array, bad blocks should
*NOT* by default cause a single bad block to fail the whole
array...instead just log the bad blocks to the syslog and let the
admin take care of it.

Right now, the big benefit of RAID5 is being affected

Ideally, I'd like to see Neil's road map bad block device handler
implemented (have often thought of tinkering with the block device
code in the kernel to do just that)...but till then a simple check
that an array is  degraded before failing a device which would render
the whole array inoperable should suffice? This could throw big errors
in the syslog but at least the a 2 TB MD array won't be down because
of 1 512 byte sector?

Thanks,
Anshuman
