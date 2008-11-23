From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Why does the md/raid subsystem does not remap bad sectors in a raid
 array?
Date: Sat, 22 Nov 2008 19:02:39 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811221859210.14817@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757268AbYKWACu@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

I asked before but it was kind of clobbered in the velociraptor mess:

On a colleague's box:

Aug 02, 2008 12:15.30AM(0x04:0x0023): Sector repair completed: port=7, 
LBA=0x4A0387F5

SMART Self-test log structure revision number 0
Warning: ATA Specification requires self-test log structure revision 
number = 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed: read failure       90%       305 
1241745397

Even though this disk has a bad sector:
198 Offline_Uncorrectable   0x0030   100   100   000    Old_age   Offline 
-       1

The controller does not drop the drive from the array when it hits an 
error, the 3ware card "takes care of it" and the user need not worry about 
it, whereas with md/raid every time it hits a bad sector, it breaks the 
raid and it goes degraded, is this correct?  Will/can something like what 
3ware does be possible in a sw-raid based configuration or is a HW raid 
card required?

Justin.
