From: "harry" <hfranklin97@excite.com>
Subject: Re: disk testing
Date: Tue, 14 Sep 2004 05:54:07 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040914095407.4EDF53969@xprdmailfe9.nwk.excite.com>
Reply-To: hfranklin97@excite.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Here's an interesting twist: smartctl claims that all three disks don't support smart. However, I think this is because the disks show up as scsi and not ata disks (the controller they're attached to is a promise sata150 tx4). I tried tricking it into looking at the drive as an ata device with the '-d ata' option, but no dice. 

(I'm fairly certain that these 3 disks support smart because I have two more attached through a sata controller built into the motherboard, which both show up as hd? drives, and smartctl gives loads of info for them). All of the drives in question (3 new ones, 2 bought about 8 months ago) are Western Digital 2500JD's. 



And finally, forgive my ignorance, but what does libata do/provide? (I'm guessing it would allow smartctl to see disks that show up as scsi on the system as ata disks, but just want to verify). The system involved is running debian sid with a custom 2.4.27 kernel, and I just did an apt-file and apt-cache search for libata and both came up empty.


Thanks, Harry

_______________________________________________
Join Excite! - http://www.excite.com
The most personalized portal on the Web!
