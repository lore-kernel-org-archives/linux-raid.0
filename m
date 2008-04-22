From: Keith Roberts <keith@karsites.net>
Subject: PCI ATA EIDE cards and kernel drivers
Date: Tue, 22 Apr 2008 07:20:56 +0100 (BST)
Message-ID: <alpine.LFD.1.10.0804220658410.31467@www.karsites.net>
Reply-To: Keith Roberts <keith@karsites.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all.

I'm running Fedora 8, and having suffered a recent hard disk 
failure, I want to set up a RAID1 array of two EIDE ATA 133 
physical drives for my server. These will use the maximum 
number of partitions allowed under Linux. I also want to use 
a seperate non-raid ATA drive for making backups of 
important data from the RAID arrays. So in total I would 
have my important data on three seperate physical drives. 
I'm also making backups of my data to CD-R and DVD+R as 
well.

I have the standard EIDE connectors on my Motherboard, which 
will be used for the backup ATA drive, and the DVD RW 
optical drive. All drives will use separate cables and work 
as master drives. This applies to the RAID1 array drives as 
well.

**My Questions are:**

Do the PCI EIDE cards need to be supported with kernel 
drivers, or can I put any PCI EIDE card in the machine and 
it will 'just work'?

Obviously I don't want to buy the wrong PCI EIDE/ATA 
controller card.

Can anyone recommend any PCI EIDE ATA controller cards that 
are known to work under the latest versions of Linux please, 
without me having to keep re-compiling the kernel to support 
the PCI EIDE card?

I'm running kernel-2.6.24.4-64.fc8

Kind Regards

Keith Roberts

-----------------------------------------------------------------
Websites:
http://www.php-debuggers.net
http://www.karsites.net
http://www.raised-from-the-dead.org.uk

All email addresses are challenge-response protected with
TMDA [http://tmda.net]
-----------------------------------------------------------------
