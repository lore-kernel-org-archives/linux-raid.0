From: "Zhai, Edwin" <edwin.zhai@intel.com>
Subject: how to uninstall raid
Date: Wed, 30 Jul 2003 15:29:27 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A12F5F3545A0654B97BFD863950C1E185FAD48@pdsmsx403.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have installed raid0 on /dev/md0 which is composed of /dev/hdc1 &
dev/hdd1 but want to uninstall raid and get hdc1&hdd1 back now.
Anybody knows how to do it?

When using mdadm /dev/md0 --fail /dev/hdc1 --remove /dev/hdc1,I got a
error msg "invalid argument". I also want to know how to erase the raid
configuration data in the kernel (not in the conf file).

Thanks,
Edwin
