From: "Vince W." <listacct1@lvwnet.com>
Subject: Re: linux/raid problem, linux not recognizing bios raid
Date: Wed, 20 Oct 2004 06:42:44 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41764124.2080707@lvwnet.com>
References: <000401c4b3f4$47bc9570$6101a8c0@renoir>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000401c4b3f4$47bc9570$6101a8c0@renoir>
To: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robert E. Singer wrote:

>im building a system containing:
>- abit ic7g motherboard
>- 2 wd 160gb sata hard drives
>- red hat linux workstation version 3
>
>  
>
>the drives have been physically installed and the bios configured to run the
>disks as a raid (either raid0 or raid1). this is verified during the post.
>
>when i try to install linux, the disk partitioning program reports two disks
>/dev/sda & /dev/sdb individually with 160gb capacities available for
>partitioning, not one.  whether using bios raid0 or raid1, only 1 disk
>should be available (with 160 or 320 gb available, depending on the raid
>flavor).
>
>whats wrong?
>  
>
We're seeing a lot of this lately.

As has been basically mentioned by the other two, you do not have a real 
hardware RAID controller built into your motherboard.

You may find some humor, as well as some excellent technical advice, at 
the following URL, and at other links on Jeff Garzik's site:

http://linux.yyz.us/sata/faq-sata-raid.html

(Jeff Garzik is doing most (or all) of the work on writing the libata 
SATA drivers for the Linux kernel, and is, therefore, an authority on 
the subject matter).

RHEL 3 Workstation is detecting your SATA controller, but ONLY as a SATA 
controller, not as a SATA RAID controller, and therefore seeing both 
physical drives connected to it.  Linux is not fooled as easily by mere 
BIOS hacks as Win-Doze is.

As the other person mentioned, you will be better off disabling the 
"RAID" functions of your onboard SATA controller, enabling it only as a 
SATA controller instead, and setting up a software RAID at install 
time.  Three things to keep in mind:

1) You should create a separate ~100MB /boot partition to put the Grub 
files and kernels in, make it your first partition, and force it to be 
primary.  /boot can be a software RAID1, but it cannot be a software 
RAID0 or RAID5

2) The root filesystem ( "/" ) can be a software RAID1, but not a 
software RAID0 or RAID5 filesystem, as best I recall.

3) The rest of your filesystems, any others you break out, like /usr, 
/var, /tmp, etc. can be RAID0, RAID1, or anything else that races your 
motor.

If I am "off" on any of these details, I am sure someone will correct me. ;)

If you find items 1 and 2 to be an unacceptable limitation, you should 
look into a REAL hardware RAID solution. 

As a general rule, at least right now, if it's a SATA controller, it 
ain't REAL hardware RAID.  The one exception that comes to mind: 3Ware 
makes real hardware RAID SATA controllers, but I would confirm that the 
exact model number you are interested in has open-source kernel driver 
support before plunking down the cash if I were you.


Good Luck,
Vince
RHCE, Linux Technical Engineer

