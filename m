From: rich turner <rich@storix.com>
Subject: mdadm output format
Date: Thu, 02 Sep 2004 11:21:04 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1094149263.8447.42.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

assume i want to rebuild the same raid device on a completely different
system, cloning for example. "mdadm --detail /dev/md0" appears to be the
only command that will display all of the information needed to
completely rebuild a raid device with the exact same characteristics
(persistent superblock, chunk size, layout, etc.). has the format of
this file changed from back level versions? can i expect to see the same
format in the future?

also, is there any way with mdadm to create a raid device that does not
have persistent superblock? with raidtools there is a flag to indicate
whether you want a persistent superblock.

