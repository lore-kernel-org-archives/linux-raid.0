From: Sam Bingner <sam@bingner.com>
Subject: UDEV Rule for Timeouts
Date: Mon, 17 Jun 2013 22:59:41 +0000
Message-ID: <7D41A0C4-44C8-46D5-A1B3-F2187DEE32F4@bingner.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <14D66A58BBCAF84A82A187A175BFF756@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: "<linux-raid@vger.kernel.org> RAID" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have written a simple udev rule calling a bash script to set the timeouts on all connected devices.  I would like to a) provide this to anybody who feels they may need it and b) know if anybody sees any potential issues with this.  It seems to work fine for me over a couple reboots...

contents of udev rule:
ACTION=="add", SUBSYSTEM=="block", KERNEL=="[sh]d[a-z]", RUN+="/usr/local/bin/settimeout"

contents of /usr/local/bin/settimeout:
#!/bin/bash

[ "${ACTION}" == "add" ] && {
	/usr/sbin/smartctl -l scterc,70,70 ${DEVNAME} || echo 180 > /sys/${DEVPATH}/device/timeout
}

