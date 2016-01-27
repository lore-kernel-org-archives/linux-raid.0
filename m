From: Sarah Newman <srn@prgmr.com>
Subject: mdadm bad blocks list
Date: Wed, 27 Jan 2016 10:45:01 -0800
Message-ID: <56A9102D.4030304@prgmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I experienced the following problems with the mdadm bad blocks list:

1. Additions to the bad block list do not cause an email to be sent by the mdadm monitor. Expected behavior is for an email to be sent as soon as the
bad blocks list becomes non-empty.
2. /proc/mdstat does not show any indication that there are bad blocks present on an md member. Specifically, the status for the raid personality
should show something other than "U" if the badblocks list is not empty for that member (maybe "B"?)
3. Adding a device when there is an md member with bad blocks does not appear to trigger a rebuild, meaning there could be at least one good copy of
all the data but no way to get all good data on a single device without expanding the entire array.

Kernel: CentOS 6 Xen4CentOS 3.18.21-17
mdadm: CentOS 6 v3.3.2

With the above behavior, I consider the bad blocks list to be actively harmful. If it's expected behavior in the current version, please consider
disabling the bad blocks list by default. We might be able to provide some patches to correct 1. and 2. but we don't have anything ready right now.

--Sarah
