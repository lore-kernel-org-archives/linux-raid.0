From: Wayde Milas <wmilas@rarcoa.com>
Subject: Promise 378 tx2(plus) serial ata w/ 2.6.1
Date: Wed, 28 Jan 2004 08:56:03 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1075301763.18600.105.camel@wayde.rarcoa.com>
Reply-To: wmilas@rarcoa.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thought I'd try here before I went to the kernel mailing list.

I'm tying to get my promise 378 tx(plus2) chip thats built into my msi
865pe neo2 working. I'm aiming for a 4 drive sata raid 5 array, and I've
got the 2 sata ports on the intel chip working flawlessly.

The promise is another mater. The driver loads no problem. I can fsck
the drives and even install (non raid) reiserfs or ext2 no problem on
them. Mounting a reiserfs partition causes the box to hard lock.
Mounting an ext2 partition is ok, but as soon as I try to read or write
to it it hardlocks the box within 15 seconds.

I can't be the only one experiencing this :)

I've tried emailing Jeff Grazik (author of the 2.6 sata_promise driver I
think... hes the only name I could find in the source) to no avail.

Anyone have any experience related to this? :)

