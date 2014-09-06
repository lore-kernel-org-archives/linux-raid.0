From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?Re=3A_RAID0_size_over_2_TB_=2D_RAID1?=
Date: Sat, 06 Sep 2014 23:17:48 +0200
Message-ID: <20140906231748.50094079@pobox.sk>
References: <20140906230928.BB645CEE@pobox.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140906230928.BB645CEE@pobox.sk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>Hi,
>
>i'm having problems with growing my RAID0 array over 2 TB. I installed two 4 TB drives, created 4 TB partitions but array cannot be resized over 2 TB. Superblock versoin is 0.90 and kernel version is 3.2.53 - according to linux RAID wiki, it should support 4 TB component/array size:
>https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#The_version-0.90_Superblock_Format




I'm sorry for a mistake, it's RAID1 of course.

azur
