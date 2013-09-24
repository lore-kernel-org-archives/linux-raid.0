From: Karel Walters <karel.walters@gmail.com>
Subject: Re: [Recovery] RAID10 hdd failureS help requested
Date: Tue, 24 Sep 2013 20:18:39 +0200
Message-ID: <CAB4fJqeoK-o+xvAc0vnp=ika6=vTV0d6wrJhjwg43c0f7O+K_g@mail.gmail.com>
References: <CAB4fJqfd1zrw_AS89ufysfyCoKNf6VYj81xov0=7y0aXoYtjxw@mail.gmail.com>
	<5241A06F.10704@turmel.org>
	<CAB4fJqezb0sWcUUgRPd4BXoWr3hNBp725gv8xnMOPmcqU8RiRw@mail.gmail.com>
	<5241B4B7.1010305@turmel.org>
	<CAB4fJqerQy7PJzK4+WSNAh7YCcHmwoAqB5vMrXeSYqzWawAS+A@mail.gmail.com>
	<5241C763.6040306@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5241C763.6040306@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 Hi Phil,

Thank you for all the great help so far!

> Yes, that dmesg did the trick.  The drive that failed first was #3, and
> the drive the failed second was #4.  You should create a list of which
> drive serial number corresponds to which raid device role, with a third
> column showing the current device name.

Serial no:              old name  ID     current name
WD-WCC1T1255024                     /dev/sdc1  new drive
W1F09XLV            /dev/sdb1 [3]    /dev/sdd1  failed drive 1
W1F0AXTQ           /dev/sdc1 [4]    /dev/sde1  failed drive 2
W1F0B6X6            /dev/sdd1 [0]    /dev/sdf1
S1F04BZT             /dev/sde1 [5]    /dev/sdg1
W1F0B9ER           /dev/sdf1 [2]    /dev/sdh1
WD-WMC1T2341606    /dev/sdg1 [1]    /dev/sdi1
S1F04CWH           /dev/sdh1 [6]    /dev/sdj1  (partially rebuild spare)

> Then, to deal with the large number of pending events, you'll need to do
> a "check" scrub with a very low speed limit.  To keep you from exceeding
> the 10/hour read error limit in the MD kernel driver.

echo 1000 > /proc/sys/dev/raid/speed_limit_min
echo 10000 > /proc/sys/dev/raid/speed_limit_max
echo check > /sys/block/md0/md/sync_action

Would this be ok in such a case?

Karel
