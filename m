From: Zeno Davatz <zdavatz@generika.cc>
Subject: raidhotadd error
Date: 07 May 2003 20:18:07 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1052331487.742.175.camel@zrr>
References: <1052325714.1551.137.camel@zrr> <3EB93BF5.4E3912EE@SteelEye.com>
	 <1052327381.649.140.camel@zrr>  <3EB93F4D.501B2106@SteelEye.com>
Reply-To: zdavatz@generika.cc
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EB93F4D.501B2106@SteelEye.com>
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi List

df gives me /dev/md0

raidhotadd /dev/md0 /dev/hdc2

gives me:

md: can not import ide/host0/bus1/target0/lun0/part2, has active inodes!
md: error, md_import_device() returned -16

Why would that be? Thanks for you time an help.

Zeno

