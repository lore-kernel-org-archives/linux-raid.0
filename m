From: Vladimir Milovanovic <vlad@webmail.co.za>
Subject: Somewhat ot, but I think that this is a place to ask
Date: Tue, 08 Apr 2003 21:15:54 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E931FEA.30707@webmail.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: raid-list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi everyone,

This post is somewhat OT, but it does have to do with md, and also I 
know that people that hang out here are knowledgeable about this stuff...

Anyway, I am working on a project where we have some data streaming in 
from an AD converter onto a card attached to a PCI bus. The data rate is 
quite high, about 80 MB/s. The PCI card is a local bus master, and a PCI 
slave device. My intention is to have the data from the PCI card (which 
is essentially an LVDS to PCI converter) transferred onto a large RAID 5 
created using md. I am doing this since I need redundancy and 
reliability (which I am hoping RAID 5 will provide) and also the high 
tranfer rates that I will get by combining disks into a RAID.

I still haven't decided on what kind of SCSI controller and what kind of 
SCSI disks I will use in this project, and I am very much open to 
suggestions from people here. I am toying with an idea of using a 64 bit 
PCI bus mobo, and thus a 64 bit SCSI card, since I have read that data 
rates of up to 266 MB/s (i.e. double of standard PCI) are possible with 
this.

My main question is this: is it possible, and if yes under what 
circumstances, that two PCI devices (in this case the LVDS->PCI card and 
the SCSI card) can transfer directly to each other, without writing to 
RAM first, i.e. can the LVDS->PCI card transfer data over the PCI bus 
directly to the SCSI card? If this is possible, it would make planning a 
lot easier.

Well I have some more questions, but I want to see whether this is too 
OT to be discussed here or not. Anyway, if anyone here think that they 
can help, or have some useful links and this turns out to be too OT, I 
would be much oblidged if you would reply by email.

Thanks and cheers,

Vlad.


