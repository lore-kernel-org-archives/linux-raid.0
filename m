From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: RAID1 degradation failure.. (2.4.17)
Date: Tue, 23 Apr 2002 15:11:13 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020423151113.D1284@mea-ext.zmailer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have had a machine to go into degraded mode from whence
it does recover automatically at next power restart, but
the thing recovers wrong disk, e.g. leaps back in time!
(The disk is failing by 'Failure prediction threshold exceeded',
 and gets back online at next powerup..)

Apparently when a disk fails from under RAID1, the disks
that are left into running the set are not marked with
a NEW serial number in superblock so that auto-recovery
won't pick obsolete data in case such becomes available.

/Matti Aarnio
