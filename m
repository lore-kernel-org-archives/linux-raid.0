From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: disaster. raid1 drive failure rsync=DELAYED why?? please help
Date: Sun, 13 Mar 2005 02:22:00 -0500
Message-ID: <200503130222.00697.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

One more bit of information:

this was a bit of info from 

tail /var/log/kern.log

Mar 11 04:42:11 A1 kernel:
Mar 11 04:42:11 A1 kernel: hdg: drive not ready for command
Mar 11 04:42:11 A1 kernel: raid1: hdg1: rescheduling sector 215908496
Mar 11 04:42:11 A1 kernel: raid1: hdg1: redirecting sector 215908496 to 
anotherr
Mar 11 04:42:11 A1 kernel: hdg: status error: status=0x58 { DriveReady 
SeekComp}
Mar 11 04:42:11 A1 kernel:
Mar 11 04:42:11 A1 kernel: hdg: drive not ready for command
Mar 11 04:42:11 A1 kernel: raid1: hdg1: rescheduling sector 215908496
Mar 11 04:42:11 A1 kernel: raid1: hdg1: redirecting sector 215908496 to 

but that all was from Mar11 and today is Mar13....

thanks

Mitchell
