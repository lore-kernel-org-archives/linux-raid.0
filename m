From: AndyLiebman@aol.com
Subject: Re: Firewire RAID bootparameters?
Date: Sat, 13 Dec 2003 08:26:44 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <84.1e86c0b2.2d0c6d94@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just want to mention that I have two large firewire RAID 5 arrays (800 GB 
and 500 GB) and I use Mandrake 9.2 (and have done the same with Redhat 9) and I 
didn't have to mess around with ANY initrd or rc.sysinit or any other 
settings to make them work properly as NON BOOT devices. 

My comments, some specific to Mandrake, woud be: 

-- disable supermount with"supermount -i disable".  With supermount enabled 
(Mandrake default) you run the risk of accidentally mounting individual drives 
that are part of a RAID in addition to mounting them as the RAID. That will 
surely lead to data corruption. 

-- use mdadm to make, start, stop, and maintain your RAIDs. DO NOT use 
raidtools. And certainly do not use the Mandrake Control Center wizzard to make and 
maintain your RAIDS. Both are inadequate for the job, and the Mandrake wizzard 
will write all sorts of configuration information to various files -- without 
your knowing it -- that will later get you into trouble. THIS IS VERY 
IMPORTANT. I can't stress it enough, and I learned by many bad experiences. The 
device IDs of firewire drives (/dev/sda  /dev/sdb, etc. ) can change from one boot 
to the next -- even if you don't change your hardware! I've had it happen. But 
if you do change your hardware -- add a new PCI card, add an additional 
firewire drive, plug in a camera, etc -- your device IDs will definitely change. 
Starting up RAIDS based on their devices ids -- which is what raidtools and the 
Mandrake wizzard do -- is suicide for firewire RAIDs. You MUST use mdadm and 
start your RAIDs by referring to the drives by their Superblock ID (something 
that mdadm can do and the other methods cannot.) 

Mdadm is a little difficult to get through. I found it harder to learn than 
raidtools -- ironically because it's simpler and you don't spell out as much to 
initially set up your RAID. In fact, I found it more logical to create my 
first array with raidtools (specifying that there should be a persistent 
superblock), and then erase all the raidtools configuration information from 
/etc/raidtab and use mdadm from there. Once I understood what mdadm was doing, then I 
understood how to use it to make new RAIDs. It's very easy, really.  The most 
important command for understanding your RAIDS is:   mdadm -E /dev/sdxx   which 
will reveal to you the long string of letters and numbers that's the 
"superblock information".  As you will see, that same string of numbers and letters is 
recorded on every drive in your RAID array. If you have two arrays, then the 
drives (or partitions) in the second array will all have the same string of 
letters and numbers. It's a pretty much foolproof way to identify your drives so 
that Linux RAID knows which drives go together.  mdadm -E /dev/sdxx will also 
tell you which device ids go with which array. If you ever add drives and 
want to create a second array, you will need mdadm -E /dev/sdxx to reveal to you 
which device ids are NOT part of your existing RAIDs, because when you create 
the new array you do have to tell mdadm or raidtools which drives to use!   
mdadm -- detail -- scan  is also useful for getting basic information. 

-- remove any references to your RAID in the /etc/fstab file -- if you made 
your RAID with the Mandrake Wizard, you probably have references there. You 
probably also want to remove references to the individual firewire drives. I 
haven't done that in my own system, but I'm thinking of doing that so that 
programs like KwicDisc won't list them as available to mount. Again, another 
possibility for accidentally mounting an individual hard drive that's part of a RAID. 
I think if the listing is NOT in /etc/fstab, then KwicDisc won't give me the 
option of mounting it. 

-- you can autostart your raids at the end of the boot process by putting in 
the mdadm startup and mount commands in /etc/rc.d/??? I don't remember the 
name of the file but it's where you can specify commands to automatically run at 
the very end of the boot process. If you don't need your firewire RAIDs for 
booting, I would suggest making them start, and mounting them, there. The 
default Mandrake installation puts a message at the head of the file explaining that 
this file is for automatically running commands at the end of the boot 
process. 

-- if you are looking at the verbose output on your screen during bootup, you 
will see a reference to "skipping your RAIDs" fly by.  Don't worry about it. 
Linux knows you have RAIDs but it won't try to start them at that point in the 
boot process. 

I was planning on writing up a HOW-TO on making NON-BOOT firewire RAIDs in 
Linux -- to add to the existing Linux Software RAID HOW-TOs.  It took a lot of 
work to get my RAIDs working reliably -- and I needed a lot of help from the 
linux-raid list -- so soon I will write up my experiences. 

Andy Liebman
Resolute Films, Boston Masschusetts


In a message dated 12/13/2003 7:17:19 AM Eastern Standard Time, 
bluca@comedia.it writes:
On Sat, Dec 13, 2003 at 06:19:47AM -0500, Christer Backstrom wrote:
>Yes, this is new information for me. I never considered (or knew how
>to) manipulate the initrd loading. I got two more mails saying about
>the same thing, but they weren't cc:ed to the list. (Thanks Joe Pruett
>and David Haring) This would enable me to put even my root-filesystem
>on the firewire drive. Very nice. In my case, as I only keep my /home
>on the raid1 mirror, it was even simpler. I looked into the initrd man
>page, and found  a reference to append "noinitrd" to lilo.conf, which
>stops loading of modules by initrd altogether. The rc.sysinit will
>then, in my case (Mandrake-9.2), load the modules in the right order. I
>stiil wonder if the loading sequence should not be different when
>loading compiled-in modules. Nowadays firewire and usb2 drives are fast
>and commonplace, and an excellent way of securing the regular
>harddrive. Especially on a laptop, where the regular drives are small
>and singular. To load the raid subsystem before these systems can't be
>right. I wonder if i t should not be changed? Anyways: Me happy. Thanks
>all for the help!

uhm, you should not need to modify the initrd scripts by hand to make it
do what you need, (and mdk-9.2 initrd should not load raid modules if it
does not need it to boot, but this i already fixed).
having a correct scsi_hostadapter line in /etc/modules_conf should deal
with loading the firewire module before, or you could use --preload
<module> argument.
i don't have firewire hw to test this, and i'll never buy an usb drive
if i can avoid it :-)
would you be willing to test the alternative mkinitrd/initscripts/mdadm
packages i built for mandrake cooker and report success/failure on your
configuration?
they are found at: http://www.comedia.it/~bluca/cooker/lvm2/

Regards,
L.
