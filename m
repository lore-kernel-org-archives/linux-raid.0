From: "Marc L. de Bruin" <marc@debruin.org>
Subject: Re: md/mdadm fails to properly run on 2.6.15 after upgrading from
 2.6.11
Date: Mon, 10 Apr 2006 09:54:34 +0200
Message-ID: <443A0F3A.90104@debruin.org>
References: <4438FFA9.4030907@debruin.org> <Pine.LNX.4.64.0604090736170.4668@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0604090736170.4668@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

dean gaudet wrote:

>On Sun, 9 Apr 2006, Marc L. de Bruin wrote:
>
>...
>  
>
>>Okay, just pressing Control-D continues the boot process and AFAIK the root
>>filesystemen actually isn't corrupt. Running e2fsck returns no errors and
>>booting 2.6.11 works just fine, but I have no clue why it picked the wrong
>>partitions to build md[01234].
>>
>>What could have happened here?
>>    
>>
>
>i didn't know sarge had 2.6.11 or 2.6.15 packages... but i'm going to 
>assume you've installed one of initramfs-tools or yaird in order to use 
>the unstable 2.6.11 or 2.6.15 packages... so my comments might not apply.
>  
>
You are right about this. Sarge does not contain 2.6.11 or 2.6.15. 
'linux-image-2.6.15-1-686-smp' depends on "initramfs-tools | yaird | 
linux-initramfs-tool". I picked initramfs-tools, but in the future I 
might go for yaird because initramfs-tools depends on udev and I may not 
want to lose hotplug.

>initramfs-tools generates an "mdrun /dev" which starts all the raids it 
>can find... but does not include the mdadm.conf in the initrd so i'm not 
>sure it will necessarily start them in the right minor devices.  try doing 
>an "mdadm --examine /dev/xxx" on some of your partitions to see if the 
>"preferred minor" is what you expect it to be...
>  
>
blah@frodo:~# sudo mdadm --examine /dev/md[01234]
mdadm: No super block found on /dev/md0 (Expected magic a92b4efc, got 
5e4cff37)
mdadm: No super block found on /dev/md1 (Expected magic a92b4efc, got 
940922e3)
mdadm: No super block found on /dev/md2 (Expected magic a92b4efc, got 
00000000)
mdadm: No super block found on /dev/md3 (Expected magic a92b4efc, got 
006c038d)
mdadm: No super block found on /dev/md4 (Expected magic a92b4efc, got 
00000000)
blah@frodo:~#

Is this a problem (for 2.6.15)? The system seems to work without a 
problem, at least with 2.6.11...

>if the preferred minors are wrong there's some mdadm incantation to update 
>them... see the man page.
>
>or switch to yaird (you'll have to install yaird and purge 
>initramfs-tools) and dpkg-reconfigure your kernel packages to cause the 
>initrds to be rebuilt.  yaird starts only the raid required for the root 
>filesystem, and specifies the correct minor for it.  then later after the 
>initrd /etc/init.d/mdadm-raid will start the rest of your raids using your 
>mdadm.conf.
>
Yeah, this is what is happening today with 2.6.11 as well.

Thanks for your time,

Marc.
