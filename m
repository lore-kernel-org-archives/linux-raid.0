From: Peter Jonsson <dal01pjn@mds.mdh.se>
Subject: Invalid superblock on drives in array
Date: Thu, 25 Dec 2003 17:58:15 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.44L.0312251708280.28023-100000@legolas.mdh.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I'm running a RAID-5 setup using six Seagate ST19171W SUN9.0G drives off a
Sun Multipack connected to an Adaptec 2940UW. I used to have the multipack
connected to a Sparcstation 5 but I moved it yesterday. Everything was
running fine until I rebooted the machine.

Now I get this error message :

[events: 00000000]
md: invalid raid superblock magic on sda1
md: sda1 has invalid sb, not importing!
md: could not import sda1!
md: autostart sda1 failed!

I tried to get some more information with mdadm. This is what I got :

[root@colossus root]# mdadm -E /dev/sd[abcdef]
mdadm: No super block found on /dev/sda (Expected magic a92b4efc, got 6c6c6c6c)
mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got add66bb5)
mdadm: No super block found on /dev/sdc (Expected magic a92b4efc, got add66bb5)
mdadm: No super block found on /dev/sdd (Expected magic a92b4efc, got 6c6c6c6c)
mdadm: No super block found on /dev/sde (Expected magic a92b4efc, got 6c6c6c6c)
mdadm: No super block found on /dev/sdf (Expected magic a92b4efc, got 6c6c6c6c)

I'm not really sure what happend. I think what I did was to reboot the
machine to use a new kernel. This machine was a clean RH9 installation and
I applied a 'yum upgrade' to it after installing yum. I have since tried
to use the array with the older kernel but that don't work either.

Is there anyway I can fix the super blocks and reclaim the data or is it
lost?

// peter
--
If God is real, s/he might be integer (e.g. 0). If God is complex, then s/he might be imaginary.

