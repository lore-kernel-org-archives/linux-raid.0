From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Quick RAID 1+0 advice
Date: Thu, 18 Jan 2018 22:08:25 +0800
Message-ID: <7c9c45b6-94b8-d97e-ee1b-e1a6bd4aff32@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

G'day all,

Background and reasoning up front, single question at the end.

I currently run a small RAID10 comprised of 3 Samsung 830 & 3 Intel 330 
250GB SSD. This is starting to show its age and so I'm planning on an 
upgrade.

Because of the 830s lack of DRAT I've never used discard on the array as 
the LSI SAS controllers I have won't enable it on the Samsung drives.

What I'm planning is a 1TB Samsung 960 Pro M2 in a RAID1 with a RAID0 of 
4 256G SATA SSD's. Unfortunately my system only has a single M2 slot. I 
plan on using compatible SATA SSDs such that I get discard support.

That should buy me 2 or 3 times the bandwidth I get now, and that's 
sufficient. The most important thing is all the drives and controllers 
are OPAL SED compliant and I can lose the dm-crypt I'm currently running.

My other option was 8 256G SATA SSDs in another RAID10, but my thoughts 
were if I have the M2 slot I might as well use it and free up some drive 
bays.

This array gets partitioned into 3 sections :
- Root filesystem
- Home partition (mail spools)
- VM Backing store

This is not a heavily loaded machine, but it's not unusual to have a 
couple of VMs going hard in parallel with significant IMAP mail loads on 
the Home partition. Average write load over 5 years has been ~55GB/day 
on the whole array.

The current setup is acceptable, but between dm-crypt and aging drives 
it's not a snappy as it was when it was installed. SED takes dm-crypt 
out of the equation, and drives have improved somewhat in the last 5 years.

So, my question is :

- If I stack RAID1 & RAID0 will I reliably pass discard down the stack 
from an Ext4 filesystem right now with a current kernel?

Regards,
Brad
