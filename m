From: Xavier Brochard <xavier@alternatif.org>
Subject: disk order problem in a raid 10 array
Date: Fri, 18 Mar 2011 15:49:20 +0100
Message-ID: <201103181549.20835.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

trying to solve my problem with a unusable raid10 array, I discovered that 
disk order is mixed between each boot - even with live-cd.
Here's an extract from dmesg:
[   12.5]  sda:
[   12.5]  sdc:
[   12.5]  sdd:
[   12.5]  sde: sdd1
[   12.5]  sdf: sdc1
[   12.5]  sda1 sda2
[   12.5]  sdg: sde1
[   12.5]  sdf1

is that normal?
could this be a sign of hardware controler problem?
could this happen because all disks are sata-3 except 1 SSD which is sata-2?


Xavier
xavier@alternatif.org
