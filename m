From: Brad Campbell <brad@wasp.net.au>
Subject: libata
Date: Sun, 15 Feb 2004 12:13:22 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <402F2A22.8080204@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

G'day all.

I have a pair of HPT1540 SATA cards that I'm currently using with the Highpoint supplied driver
(Sans raid proprietary binary - Complete source compile) on a 2.4 kernel.
I have been looking at libata as I'd like to move to an in-kernel driver and I'm having issues with
the in-kernel hpt366 ide driver. Plus, given all my drives are in Supermicro Hotswap bays I'm hoping
that one day we may realise seamless hotswap and I can swap out faulty software raid disks on the
fly and I guess libata is the best way to work towards this :p)

I think I get the idea of how libata goes together and I'd like to have a crack at writing a
sata_hpt module. Has anyone done any ground work on this or is already working on it or do I start
from scratch?

Are there any known reasons as to why it will / will not work or anything else that would preclude
me from getting it going?

Is there a better place to discuss this?

Regards,
Brad

