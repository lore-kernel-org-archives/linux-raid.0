From: Tanmay <tanmayinamdar@gmail.com>
Subject: Question regarding command completion from RAID driver
Date: Fri, 24 Jul 2009 11:08:10 +0530
Message-ID: <cdc1d1310907232238q1cb64d30t79f7a244d1614932@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a setup with a RAID-0 device configured. I export this RAID
device as a iSCSI LUN to remote machine over iSCSI protocol. Whenever
the iSCSI initiator does IO on this RAID device, the iSCSI target
driver queues a block request further to be handled by RAID driver.
My question is - when exactly RAID-0 driver acknowledges the upper
layer (block) with the (read / write) command completion? Does it send
completion after the data is successfully written to the disks OR Does
RAID-0 driver maintains its own cache and even before data is
successfully written to disks, it sends completion? If its the later
case, then iSCSI initiator might get false responses and in case of
power failure of my target machine, it might corrupt the data.

Thanking in advance,
Tanmay
