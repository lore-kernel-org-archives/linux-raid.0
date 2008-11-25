From: "Wallior, Julien" <Julien.Wallior@sig.com>
Subject: DM multipath limits IO size to 512kB
Date: Tue, 25 Nov 2008 13:08:45 -0500
Message-ID: <DDA5DF6A64A9A6418661A501B3B8465201F9B6304F@msgbal514.ds.susq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

In Linux you can change the maximum IO size of a block device from /sys/block/sd*/queue/max_sectors_kb. It can be any size up to max_hw_sectors_kb.

When DM multipath is used to manage failover between multiple links to a SAN, the virtual device's max_sectors_kb variable cannot be changed from sysfs. Moreover, by default, multipath sets max_sectors_kb of the virtual device to the minimum between max_sectors_kb of each devices and 512kB.

The attached patch changed that behavior to the minimum between max_sectors_kb of each devices.

This patch is for the SLES10sp1 kernel (2.6.16.46-0.12); but should work on 2.6.27.7. We've been using it for a few months without any issue.

Note: when you attach to the LUN, the default value for max_sectors_kb is 512. If multipathd is running at that time, it will create the virtual device with max_sectors_kb set to 512. In order to make it work, you have to shutdown multipathd, attach to the LUN, change max_sectors_kb for each path and then start multipathd.

If you need anymore information, let me know.

I submitted this as an enhancement to the lustre filesystem: https://bugzilla.lustre.org/show_bug.cgi?id=17798

Thanks,

Julien

IMPORTANT: The information contained in this email and/or its attachments is confidential. If you are not the intended recipient, please notify the sender immediately by reply and immediately delete this message and all its attachments. Any review, use, reproduction, disclosure or dissemination of this message or any attachment by an unintended recipient is strictly prohibited. Neither this message nor any attachment is intended as or should be construed as an offer, solicitation or recommendation to buy or sell any security or other financial instrument. Neither the sender, his or her employer nor any of their respective affiliates makes any warranties as to the completeness or accuracy of any of the information contained herein or that this message or any of its attachments is free of vi
 ruses.
