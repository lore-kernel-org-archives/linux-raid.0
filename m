From: Jonathan Tripathy <jonnyt@abpni.co.uk>
Subject: Disk Order
Date: Sun, 12 Aug 2012 22:10:09 +0100
Message-ID: <50281BB1.6030309@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Everyone,

Our server currently has 6 SATA ports on the motherboard filled with 6 
drives in RAID10. I have a need to install an additional PCIe SATA 
controller in a server in order to obtain 2 more SATA ports to install 
an additional 2 new drives (As I want a new RAID1 array). However I 
would like to move one of the current drives onto the new controller, 
and one of the new drives onto the motherboard. This should give me a 
little redundancy in case the new controller card were to fail (I don't 
want the new controller to bring down 2 drives).

When setting up MD RAID in this configuration, how would I go about tell 
MD RAID which disk is which in the array (referring to the near/far 
configurations)? I'm assuming by default that MD RAID just uses 
alphabetical order in order to determine the drive order?

Let's say the RAID10 drives will be sda sdb sdc sdd sde sdg*, where sdg 
is the second of the RAID0 strip of sde.
And the two new RAID1 drives are sdf sdh*.
The drives with the asterisks beside them will be on the new PCIe 
controller.

Do I have to do anything special for this configuration? Will there be a 
performance hit since one drive in the RAID10 array will be on a 
different controller?

Thanks
