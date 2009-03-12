From: Ryan Wagoner <rswagoner@gmail.com>
Subject: High IO Wait with RAID 1
Date: Thu, 12 Mar 2009 18:46:45 -0500
Message-ID: <7d86ddb90903121646q485ad12y90824a4c3fcc2dfd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From what I can tell the issue here lies with mdadm and/or its
interaction with CentOS 5.2. Let me first go over the configuration of
both systems.

System 1 - CentOS 5.2 x86_64
2x Seagate 7200.9 160GB in RAID 1
2x Seagate 7200.10 320GB in RAID 1
3x Hitachi Deskstar 7K1000 1TB in RAID 5
All attached to Supermicro LSI 1068 PCI Express controller

System 2 - CentOS 5.2 x86
1x Non Raid System Drive
2x Hitachi Deskstart 7K1000 1TB in RAID 1
Attached to onboard ICH controller

Both systems exhibit the same issues on the RAID 1 drives. That rules
out the drive brand and controller card. During any IO intensive
process the IO wait will raise and the system load will climb. I've
had the IO wait as high as 70% and the load at 13+ while migrating a
vmdk file with vmware-vdiskmanager. You can easily recreate the issue
with bonnie++.

I can perform the same disk intensive operation on the RAID 5 array
with almost no io wait or load. What is the deal with this? Is there
something I can tweak?
