From: David Chow <davidchow@shaolinmicro.com>
Subject: readonly start of Linux RAID
Date: Wed, 29 Jan 2003 01:49:55 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E36C2C3.3070101@shaolinmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I've been reading some archives in the Linux RAID mailing list. Someone ask for implementing a readonly mode instead of degraded mode in RAID-1/5 setups. I'm falling into a similar problem . I think it is important to have a readonly mode on starting a RAID device or operating on a RAID device. Think of systems that didn't want to rebuild their RAID immediately after an unclean shutdown... Calling autorun() ioctls will make all devices starting rebuild themselves in case of any available disk exists. In case we are on a shared storage system, the active cluster might have using the RAID disks which seems to be unclean on the other standby cluster. The standby cluster might want to have a read-only inspection of the shared storage. In case of a high availability cluster system failover, the standby cluster might want to determine to start full read/write access by some tools instead of forced automatic at system boot (initrd calling raidautorun). In such circumstances, the cur
 rent md driver cannot be used. This also prohibits many implementation of a high availability system from implement linux RAID on a shared storage on an HA system which is extremely important. I guess, this problem also comes with LVM and other similar volume management system. I'm currently studying the md.c code in a 2.4.19 kernel which I see implementing a read-only mode for md is possible. Please give advice or anything happening, so that I don't spend duplicated efforts. Thanks.


regards,
David Chow


