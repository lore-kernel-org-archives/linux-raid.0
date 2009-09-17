From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: recommended 4port SATA controller ?
Date: Thu, 17 Sep 2009 13:44:53 +0200
Message-ID: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,

I need to move my 4 disk raid5 array from a motherboard with 4 onboard 
SATA ports to a mainboard with just 2 ports. therefore I'm looking for a 
reliable and inexpensive 4port PCI controller.

the less raid features it has the better since I fear that a raid 
controller may initially write some management informationen (signatures 
etc.) to the disks and therefore damage the linux raid5 setup.

And, if possible, it should have low power consumption since it is about 
to be used in a small server powered by photovoltaic panels.

any recommendations aprreciated.

thanks and best regards.
