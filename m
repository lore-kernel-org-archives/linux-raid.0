From: "lilofile" <lilofile@aliyun.com>
Subject: =?UTF-8?B?cmFpZDUgVW5wbHVnIHRoZSBkaXNr?=
Date: Wed, 28 Jan 2015 14:44:44 +0800
Message-ID: <2c82c493-1fd8-4e59-9f9c-ecd2ab4296e3@aliyun.com>
Reply-To: "lilofile" <lilofile@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: lilofile <lilofile@aliyun.com>, stan <stan@hardwarefreak.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

kernel  linux 3.10, centos
when I use 5 disk to create raid5,after sync complete, I unplug a disk,and wait a moment, then replug the same disk.

the original 4 disk are still a raid5 which is degraded.
I find the single disk  become a new raid5,but inactive,what the reason?
