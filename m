From: Leon Woestenberg <leonw@mailcan.com>
Subject: mapping of md device blocks to component blocks? (and vice versa)
Date: Fri, 10 Dec 2004 15:45:03 +0100
Message-ID: <1102689902.3987.60.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

given the LBA (bad) block of a disk drive, or the block number of
a partition, how can I tell which block on the /dev/md? device
corresponds with it?

Also, vice versa, given a block number on the /dev/md device, how
can I tell to which blocks it maps on the components?

Regards,

Leon.

