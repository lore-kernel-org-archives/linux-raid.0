From: Meik Nienaber <usenet@saeder-krupp.com>
Subject: raid5 two disk failure
Date: Tue, 1 Nov 2005 16:13:03 +0000 (UTC)
Message-ID: <loom.20051101T170851-919@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

The story:

- raid5 set with four disks
- after power outage two disks were marked faulty
- reassembled the set with 3 disks (1,2,3)
- added the forth disk
- reconstruction of the set failed because of an uncorrectable sector of disk 3
- tried to reassemble the set with disk 1,2,4. Not possible because disk 4 is in
spare mode.

Any opportunities to get the set back with disks 1,2,4? Thanks in advance for 
your help.

mdadm v1.9.0
linux 2.6.12.3

Cheers
Meik

