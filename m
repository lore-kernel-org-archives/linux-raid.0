From: Tim Small <tim@buttersideup.com>
Subject: Re: disk testing
Date: Tue, 14 Sep 2004 13:17:17 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4146E14D.2090404@buttersideup.com>
References: <20040914095208.E790A3969@xprdmailfe9.nwk.excite.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040914095208.E790A3969@xprdmailfe9.nwk.excite.com>
To: hfranklin97@excite.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

harry wrote:

>Here's an interesting twist: smartctl claims that all three disks don't support smart. However, I think this is because the disks show up as scsi and not ata disks (the controller they're attached to is a promise sata150 tx4). I tried tricking it into looking at the drive as an ata device with the '-d ata' option, but no dice. 
>
>(I'm fairly certain that these 3 disks support smart because I have two more attached through a sata controller built into the motherboard, which both show up as hd? drives, and smartctl gives loads of info for them). All of the drives in question (3 new ones, 2 bought about 8 months ago) are Western Digital 2500JD's. 
>
>
>
>And finally, forgive my ignorance, but what does libata do/provide? (I'm guessing it would allow smartctl to see disks that show up as scsi on the system as ata disks, but just want to verify). The system involved is running debian sid with a custom 2.4.27 kernel, and I just did an apt-file and apt-cache search for libata and both came up empty.
>
>  
>
libata is the new SATA controller support in 2.6.x (also available for 
2.4.x).  If you are seeing your SATA disks as /dev/sdx then you are 
probably using libata.  libata lives here:

http://www.kernel.org/pub/linux/kernel/people/jgarzik/libata/

and here:

http://gkernel.bkbits.net/



The necessary ioctls to support SMART are not in libata yet, but this patch:

http://www.ussg.iu.edu/hypermail/linux/kernel/0408.3/2304.html

will allow you to use smartctl (with the "-d ata" argument) - however it 
doesn't do the proper locking, so you probably wouldn't want to use it 
on active disks whilst a system is in production (and certainly not with 
smartd).

Tim.

