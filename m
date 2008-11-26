From: "Greg Cormier" <gcormier@gmail.com>
Subject: Re: Updated MDADM, array dies.
Date: Wed, 26 Nov 2008 17:24:36 -0500
Message-ID: <29a863790811261424l5499eaf8h2271d8bdf30a213a@mail.gmail.com>
References: <29a863790811260840w2533f6dcy244ce58d81bbc27e@mail.gmail.com>
	 <8e5c241f1ae50a7d6aa5da15b10fd322.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8e5c241f1ae50a7d6aa5da15b10fd322.squirrel@neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

YES. THANK YOU. :)

It worked.

Correct, it is Fedora 9.

I just stopped MD0_d0 - I have no idea where that device came from.
Then performed my assemble command.

[root@zeus ~]# mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
mdadm: /dev/md0 has been started with 4 drives.
[root@zeus ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb1[0] sde1[3] sdd1[2] sdc1[1]
      1465150464 blocks level 5, 512k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>


Mounted just peachy.

Now, if I could rollback, I'd see what broke it. But in this case,
from what you're saying, perhaps the kernel changed? I've pasted below
my update log so we can see all components changed. Also as an aside -
 this from /var/log/messages - this segfault occured once I noticed
the missing array, freaked, and rebooted, forcing an earlier kernel
instead of the most recently updated.

Nov 25 19:34:09 zeus kernel: scsi 9:0:0:0: Direct-Access     ATA
WDC WD5000YS-01M 09.0 PQ: 0 ANSI: 5
Nov 25 19:34:09 zeus kernel: sd 9:0:0:0: [sde] 976773168 512-byte
hardware sectors (500108 MB)
Nov 25 19:34:09 zeus kernel: sd 9:0:0:0: [sde] Write Protect is off
Nov 25 19:34:09 zeus kernel: sd 9:0:0:0: [sde] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Nov 25 19:34:09 zeus kernel: sd 9:0:0:0: [sde] 976773168 512-byte
hardware sectors (500108 MB)
Nov 25 19:34:09 zeus kernel: sd 9:0:0:0: [sde] Write Protect is off
Nov 25 19:34:09 zeus kernel: sd 9:0:0:0: [sde] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Nov 25 19:34:09 zeus kernel: sde: sde1
Nov 25 19:34:09 zeus kernel: sd 9:0:0:0: [sde] Attached SCSI disk
Nov 25 19:34:09 zeus kernel: sd 9:0:0:0: Attached scsi generic sg5 type 0
Nov 25 19:34:09 zeus kernel: mdadm[1445]: segfault at 102 ip 004b271b
sp bf82c360 error 4 in libc-2.8.so[43d000+163000]
Nov 25 19:34:09 zeus kernel: md: bind<sdd1>


Thanks,
Greg

Packages Installed:
    kernel-devel-2.6.27.5-41.fc9.i686
    kernel-firmware-2.6.27.5-41.fc9.noarch
    kernel-2.6.27.5-41.fc9.i686

 Packages Updated:
    gnome-python2-gtkhtml2-2.19.1-21.fc9.i386
    ql2400-firmware-4.04.05-1.fc9.noarch
    rpmfusion-nonfree-release-9-12.noarch
    setroubleshoot-plugins-2.0.11-1.fc9.noarch
    libnetfilter_conntrack-0.0.97-1.fc9.i386
    libxml2-python-2.7.2-2.fc9.i386
    bluez-utils-alsa-3.36-1.fc9.i386
    mplayer-1.0-0.98.20080903svn.fc9.i386
    faac-1.25-7.fc9.i386
    selinux-policy-targeted-3.3.1-107.fc9.noarch
    bouncycastle-1.41-2.fc9.i386
    libxml2-2.7.2-2.fc9.i386
    texlive-texmf-fonts-2007-24.fc9.noarch
    texlive-latex-2007-32.fc9.i386
    python-genshi-0.5.1-2.fc9.i386
    kernel-headers-2.6.27.5-41.fc9.i386
    libpurple-2.5.2-1.fc9.i386
    2:tar-1.19-5.fc9.i386
    yelp-2.22.1-6.fc9.i386
    mdadm-2.6.7.1-1.fc9.i386
    texlive-dvips-2007-32.fc9.i386
    xorg-x11-server-common-1.5.2-3.fc9.i386
    xorg-x11-server-Xorg-1.5.2-3.fc9.i386
    rpmfusion-free-release-9-12.noarch
    gnutls-2.0.4-4.fc9.i386
    xulrunner-1.9.0.4-1.fc9.i386
    texlive-utils-2007-32.fc9.i386
    sudo-1.6.9p13-7.fc9.i386
    gnome-python2-libegg-2.19.1-21.fc9.i386
    elfutils-libelf-0.137-3.fc9.i386
    gdb-6.8-23.fc9.i386
    kpathsea-2007-32.fc9.i386
    gstreamer-plugins-base-0.10.19-4.fc9.i386
    libraw1394-1.3.0-8.fc9.i386
    totem-mozplugin-2.23.2-8.fc9.i386
    paps-0.6.8-8.fc9.i386
    totem-xine-2.23.2-8.fc9.i386
    imlib2-1.4.2-1.fc9.i386
    paps-libs-0.6.8-8.fc9.i386
    firefox-3.0.4-1.fc9.i386
    texlive-texmf-dvips-2007-24.fc9.noarch
    1:wpa_supplicant-0.6.4-2.fc9.i386
    texlive-texmf-latex-2007-24.fc9.noarch
    texlive-texmf-2007-24.fc9.noarch
    selinux-policy-devel-3.3.1-107.fc9.noarch
    bluez-utils-3.36-1.fc9.i386
    totem-2.23.2-8.fc9.i386
    smplayer-0.6.4-1.fc9.i386
    1:quota-3.15-8.fc9.i386
    totem-nautilus-2.23.2-8.fc9.i386
    bluez-utils-cups-3.36-1.fc9.i386
    smolt-1.1.1.1-8.fc9.noarch
    xorg-x11-drv-i810-2.3.2-3.fc9.i386
    unrar-3.7.8-3.fc9.i386
    ql23xx-firmware-3.03.27-1.fc9.noarch
    libtirpc-0.1.7-21.fc9.i386
    1:faad2-libs-2.6.1-6.fc9.i386
    texlive-2007-32.fc9.i386
    podsleuth-0.6.3-1.fc9.i386
    gnome-python2-extras-2.19.1-21.fc9.i386
    taglib-sharp-2.0.3.0-7.fc9.1.i386
    vnc-libs-4.1.2-32.fc9.i386
    selinux-policy-3.3.1-107.fc9.noarch
    pidgin-2.5.2-1.fc9.i386
    bluez-libs-3.36-1.fc9.i386
    smolt-firstboot-1.1.1.1-8.fc9.noarch
    totem-gstreamer-2.23.2-8.fc9.i386
    vnc-server-4.1.2-32.fc9.i386




On Wed, Nov 26, 2008 at 5:18 PM, NeilBrown <neilb@suse.de> wrote:
> On Thu, November 27, 2008 3:40 am, Greg Cormier wrote:
>> I have a RAID5 array of 4 disks. Was working well. I did a "yum
>> update" and noticed it updated mdadm to mdadm 2.6.7.1, amongst other
>> things (new kernel 2.2.27 instead of .26) , and now my array won't
>> mount.
>>
>> mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
>> mdadm: cannot open device /dev/sdb1: Device or resource busy
>> mdadm: /dev/sdb1 has no superblock - assembly aborted
>>
>> [root@zeus ~]# cat /proc/mdstat
>> Personalities :
>> md_d0 : inactive sdb1[0](S) sdd1[2](S)
>>       976766976 blocks
>>
>> unused devices: <none>
>>
>>
>> Yet, if I examine, it looks okay?
>
> Strange.
> It looks like something else tried to assemble the array and only found
> sdb1 and sdd1 so it couldn't assemble it completely.  But now those
> devices appear "in use" so you cannot assemble the array.
> One option would be
>   mdadm -S /dev/md_d0
> and try again.
> Another which I would like you to try is
>  mdadm --incremental /dev/sdc1
>  mdadm --incremental /dev/sde1
>
> That should add those devices to the array and start it.
>
> You didn't say what distro you were using, though as you mention "yum"
> I assume a redhat based distro.  I think they might be using "--incremental"
> to start arrays these days.  Maybe something when wrong somewhere.
>
> Doug Ledford might be interested in more details.
>
> NeilBrown
>
>
>
