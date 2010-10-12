From: Harry Mangalam <harry.mangalam@uci.edu>
Subject: Re: can mdadm use /dev/sgX as devices?
Date: Tue, 12 Oct 2010 08:04:52 -0700
Message-ID: <201010120804.52475.harry.mangalam@uci.edu>
References: <201010091822.33148.harry.mangalam@uci.edu> <4CB467BE.3050003@seoss.co.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CB467BE.3050003@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: linux-raid@vger.kernel.org, "Majed B." <majedb@gmail.com>
List-Id: linux-raid.ids

Thanks for the suggestions.  Majed B. also suggested appending the 
'rootdelay=<delay seconds>' to the boot line, but while that sounded 
promising, it didn't change anything (tried 5s - 35s in 10s 
increments).

Tim's suggestion of using the BIOS to define each disk as a RAID0 is 
brilliant and I might yet try it, but I found an updated Adaptec 
Storage Manager RPM that converted to deb format with alien fairly 
smoothly and natively supports 64b. (And the very latest one also 
works with 64b Java so I could use the Java GUI if I wanted).

<http://goo.gl/omq3> for all StorMan downloads,

<http://www.adaptec.com/en-
US/speed/raid/storage_manager/asm_linux_x64_v5_20_17414_rpm.htm> , for 
the latest/last 64b Linux version which worked.

for those unfortunate enough to have to go thru this.  (Getting to the 
downnload page is a maze of twisty little passages, all alike, most of 
which require registering.)

StorMan provides a working commandline 'arcconf' which I can use to 
query and manipulate the RAID and while it has no email capabilities 
itself, a script to query it and send email is trivial.

So I'm afraid that I'm going to have to give up on mdadm for now (no 
fault of mdadm), as the pressure to get this particular box online is 
pretty high.  I may have the oppo to try this approach since I've also 
inherited a Dell 9650 which seems to share some of the IBM's 
characteristics.

Many thanks for your combined consideration.
harry




On Tuesday 12 October 2010 06:50:54 Tim Small wrote:
> On 10/10/10 02:22, Harry Mangalam wrote:
> > the short version:
> >    Can mdadm use /dev/sgX as devices?
> >    (and if so, how?)
> > 
> > the longer version is:
> > 
> > I inherited a 6-bay IBM x3655  with a ServeRAID-8k RAID
> > controller (from docs, it seems to be an 8-port Adaptec 9580W
> > SAS/SATA controller). I'd like to run Ubuntu 10.04.
> > 
> > I can use the controller BIOS on boot to config and set up a
> > RAID5 (which presents to the OS as '/dev/sda' - the 'very large
> > device'.
> 
> You could try:
> 
> . Looking for someone who's made a script or utility to check the
> array status of the controller (I know there were opensource tools
> for earlier adaptec controllers, so this might not be too
> difficult).
> . Configuring  each individual device as a JBOD (single device
> RAID0 etc.), and running md on top of that.
> 
> Although I'm guessing it'd probably be possible to get the sd
> driver to attach to he drives some way, you'd probably end up with
> the controller BIOS, or the RAID controller driver fighting with
> md over the device metadata.
> 
> If you wipe the adaptec metadata from the drives, do you just end
> up with 5 individual disks in Linux?
> 
> Tim.

-- 
Harry Mangalam - Research Computing, NACS, Rm 225 MSTB, UC Irvine
[ZOT 2225] / 92697  949 824-0084(o), 949 285-4487(c)
MSTB=Bldg 415 (G-5 on <http://today.uci.edu/pdf/UCI_09_map_campus.pdf>
--
Non-sarcarstic use of 'seamless' in any context having to do with 
computers immediately disqualifies the speaker as an expert.
