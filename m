From: Jimmy Hedman <jimmy.hedman@southpole.se>
Subject: Problem with auto-assembly on Itanium
Date: Wed, 09 Mar 2005 11:28:48 +0100
Message-ID: <1110364128.14707.19.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I try to create a Raid 1 device from two partitions on a Itanium, but i
can't get it to auto-assembly the raid when rebooting. Since it uses the
GPT partition-scheme i have to use parted. I set the raid-flag on the
partitions with "set 1 raid on" with no luck. I've also tried the
"md=0,/dev/sdb2,/dev/sdc2" kernel option and still no automatically
assembly of the raid device.
I tried similar setup on a i386 box (but not using parted) and it worked
fine. My suspicion is that parted doesn't set the partition type to 0xFD
or the kernel-code for auto-assembly the raid don't look into
GPT-partitions.
Is there any way i can make this work? Could it be doable with mdadm in
a initrd?

Many thanks in advance,
Jimmy Hedman


