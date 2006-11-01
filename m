From: Shaya Potter <spotter@yucs.org>
Subject: accessing windows raid with mdadm?
Date: Wed, 01 Nov 2006 17:16:12 -0500
Message-ID: <1162419372.4743.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[please cc: me on responses]

if one read Documentation/fs/ntfs.txt in the linux kernel, it talks
about accessing windows raid volumes in Linux

If one is using non raid-5, one can use the device mapper, but if one is
using raid-5, one has to use the md driver. 

However, it seems to be about using raidtools (raidtab and the like).
Can anyone who understand raidtools and mdadm translate the instructions
to mdadm, as that would seem to be what most of us use today?

