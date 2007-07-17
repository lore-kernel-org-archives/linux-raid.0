From: Tobias Rehn <tr@crontex.de>
Subject: Software Raid 5, multiple raid controller disk mixup problem
Date: Tue, 17 Jul 2007 18:25:10 +0200
Message-ID: <469CED66.50109@crontex.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey Guys,

I am currently having a strange problem. I have a system with 4 onboard 
sata ports. The system also has four 4-port sata controllers plugged 
into it.

The raid works fine but if i reboot the system, sometimes my harddisks 
are mixed up so that my system disk(normally sda) is sometimes sdb or 
sdc... My system disk is plugged to one of onboard sata ports.

I already tried to bind the disks statically via udev to a certain 
device name, but no chance.

Are there any other methods to stop this mixing of the drives? Or does 
anyone have the same problem?

Kind regards,
Tobias Rehn
