From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 10:27:47 +0100
Message-ID: <4DDE1D13.2060404@anonymous.org.uk>
References: <4DDDC301.7090608@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDDC301.7090608@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>
List-Id: linux-raid.ids

On 26/05/2011 04:03, Phil Turmel wrote:
> Hi All,
>
> Last November, I shared a shell script that helped me keep track of the specific hot-swap drives I had in the various slots of my servers.  Although encouraged by Roman and John, I declined to make a project out of it.
>
> I've since kicked it around some more, and thought a bit about supporting more than just the SCSI subsystem.  The latest and greatest is still built around some standard executables:  blkid, lspci, lsusb, sginfo, and smartctl.  The original was similar to "lsscsi", but with controller details and device serial numbers.
>
> New features:
> 	Supports non-SCSI storage devices
> 	Describes layered block devices
> 		MD raid
> 		LVM
> 		generic device mapper
> 		loop (partial)
> 	Shows UUIDs
> 	Shows mountpoints
> 	Avoids repeating subtrees when enumerating raid devices
>
> I struggled with the last item, until I gave up on bash.  I needed to pass data to subroutines by reference, and bash is sorely lacking in that area.  The new script is in python.  I'm releasing this one under the GPL version 2.
>
> Please give it a whirl.

On CentOS 5:

[root@beast lsdrv]# ./lsdrv
Traceback (most recent call last):
   File "./lsdrv", line 17, in ?
     import os, io, re
ImportError: No module named io
[root@beast lsdrv]# python -V
Python 2.4.3

Maybe this is too old, so I got Python 2.6.5 from EPEL. Trying again:

[root@beast lsdrv]# python2.6 lsdrv
Traceback (most recent call last):
   File "./lsdrv", line 192, in <module>
     for x in os.listdir(sysclassblock):
OSError: [Errno 2] No such file or directory: '/sys/class/block/'

So I changed sysclassblock to '/sys/block/' to suit EL5's 2.6.18 kernel 
(so it might be nice ;-) if you could auto-detect which was present):

[root@beast lsdrv]# python2.6 lsdrv
Traceback (most recent call last):
   File "lsdrv", line 198, in <module>
     dev.phy = probe_device(sysclassblock+x+'/device', nodestr)
   File "lsdrv", line 170, in probe_device
     vendor=io.FileIO(devpath+'/vendor').read().split("\n",1)[0].strip(),
   File "/usr/lib64/python2.6/io.py", line 631, in __init__
     _fileio._FileIO.__init__(self, name, mode, closefd)
IOError: [Errno 2] No such file or directory: 
'/sys/devices/platform/floppy.0/vendor'

This looks like the same error Roman had.

Cheers,

John.

