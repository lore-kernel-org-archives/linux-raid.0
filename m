From: rich turner <rich@storix.com>
Subject: more mdadm questions
Date: Tue, 31 Aug 2004 17:13:26 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1093997605.3399.34.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

when mdadm queries information about the raid devices, does it simply
get the imformation from /proc/mdstat and format it accordingly?

when mdadm displays information about the block devices raid devices are
built on how does it display the name the devices? does it show the
devfs name? does it show the mapper name if built on a logical volume?
are these names consistent?

what about raid devices that were built with raidtools? does it look in
/proc/mdstat for information?

how does mdadm know what devices to query if they are not defined in
/etc/mdadm/mdamd.conf with DEVICES?

if devices are missing from the raid device, is there a way of knowing
the name of the missing device without the configuration file?

