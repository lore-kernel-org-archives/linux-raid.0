From: "Lundy, Mike (HIS)" <MLundy@gbhs.on.ca>
Subject: raidstop --all not working?
Date: Sun, 1 Jun 2003 22:23:47 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <73087A05DEEAD6118A65000476E3B9FF0443B6@ongbmail.gbrhc>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Is this a feature, or a bug?  I noticed that on my gentoo system (Linux
linux 2.4.20-gentoo-r5  i686 Pentium II (Deschutes) GenuineIntel GNU/Linux),
raidstart -a works great, however raidstop -a (or -all) doesen't work, even
though /etc/raidtab looks good...see:

linux root # cat /etc/raidtab
raiddev /dev/md0
        raid-level      0
        persistent-superblock   1
        chunk-size      64
        nr-raid-disks   2
        device  /dev/ide/host0/bus1/target0/lun0/part2
                raid-disk       0
        device  /dev/ide/host0/bus1/target1/lun0/part1
                raid-disk       1
linux root #

I am trying to set up an init.d script to start and stop things.  I'll post
the script so far, let me know if there's a better way.

linux root # cat /etc/init.d/raid
#!/sbin/runscript
# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or
# later
# $Header:
/home/cvsroot/gentoo-x86/net-firewall/iptables/files/iptables.init,v 1.2
2003/05/04 18:19:03 aliz Exp $

opts="start stop"

depend() {
        need logger
}


start() {
        ebegin "Starting RAID Devices"
                /sbin/raidstart --all
        eend $?
}

stop() {
        ebegin "Stopping RAID Devices"
                /sbin/raidstart --all
        eend $?
}


linux root #

Oh, almost forgot version is:  raidstop v0.3d compiled for md
raidtools-1.00.3

Thanks,
Mike
