From: "Nathanial A. Byrnes" <nate@qabal.org>
Subject: Re: RAID 5 on four IDE channels doesn't work
Date: Mon, 11 Oct 2004 00:02:23 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1097467343.8389.10.camel@vilya>
References: <1097432092.1294.8.camel@qabal.org>
	 <Pine.LNX.4.56.0410101951040.9395@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0410101951040.9395@lion.drogon.net>
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Gordon, 
	Thanks for your reply. Actually, I used mknod directly, I got the major
and minor numbers from /sys/block/hd?/dev, and just made the block file
entries, then I was able to use fdisk to see the drives. So the entries
in /sys tell me the kernel saw the devices, and fdisk would lead me to
believe that the entries in /dev were OK. 

root@qabal:~# ls -Fal /dev/hd[ik]
brw-r--r--    1 root     root      56,   0 Oct 10 02:19 /dev/hdi
brw-r--r--    1 root     root      57,   0 Oct 10 02:20 /dev/hdk

For some reason, when I run autostart (sorry no output, I have to
reconfigure and reboot to be able to e-mail) it doesn't even mention the
higher drives, it just tells me that there is something wrong with the
super-blocks on the devices with the major and minor numbers of
/dev/hd[eg] and then tries to start the array with just those two
devices. Any ideas?

	Thanks Again,
	Nate

On Sun, 2004-10-10 at 14:56, Gordon Henderson wrote:
> On Sun, 10 Oct 2004, Nathanial A. Byrnes wrote:
> 
> > 	Where hde-hdh are on my PCI promise controller, and hdi-hdl are on my
> > onboard HighPoint 366 controller. (The same array worked on just the
> > Highpoint 366 controller as well)
> 
> Assuming you have the right driver compiled into the kernel, /dev doesn't
> list hdi-l by default (at least not on my Debian systems) Check the dmesg
> output to make sure the driver is compiled in and it's recognising the
> drives.
> 
> You might need to run MAKEDEV with the right runes - but worse, I've had
> to hand-edit this file to insert the right major/minor device numbers for
> some really high alphabetical letters.
> 
> I have this:
> 
> brw-rw----    1 root     disk       3,   0 Mar 14  2002 hda
> brw-rw----    1 root     disk       3,  64 Mar 14  2002 hdb
> brw-rw----    1 root     disk      22,   0 Mar 14  2002 hdc
> brw-rw----    1 root     disk      22,  64 Mar 14  2002 hdd
> brw-rw----    1 root     disk      33,   0 Mar 14  2002 hde
> brw-rw----    1 root     disk      33,  64 Mar 14  2002 hdf
> brw-rw----    1 root     disk      34,   0 Mar 14  2002 hdg
> brw-rw----    1 root     disk      34,  64 Mar 14  2002 hdh
> brw-rw----    1 root     disk      56,   0 May 24 15:31 hdi
> brw-rw----    1 root     disk      56,  64 May 24 15:31 hdj
> brw-rw----    1 root     disk      57,   0 May 24 15:31 hdk
> brw-rw----    1 root     disk      57,  64 May 24 15:31 hdl
> brw-rw----    1 root     disk      88,   0 May 24 16:00 hdm
> brw-rw----    1 root     disk      88,  64 May 24 16:00 hdn
> brw-rw----    1 root     disk      89,   0 May 24 16:00 hdo
> brw-rw----    1 root     disk      89,  64 May 24 16:00 hdp
> brw-rw----    1 root     disk      90,   0 May 24 16:00 hdq
> brw-rw----    1 root     disk      90,  64 May 24 16:00 hdr
> 
> I think I had to dig in the kernel originally to get the major/minor
> devices. Hope this is of use.
> 
> You can get the MAKEDEV I used to create these from
>   http://www.drogon.net/MAKEDEV
> 
> Gordon
> 
> !DSPAM:4169860d14355587716053!

