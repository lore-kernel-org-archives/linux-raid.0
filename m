From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: RAID-10 array won't auto-assemble @ boot of a Xen Guest; Works just
	fine 'manually' ... Any ideas?
Date: Tue, 15 Dec 2009 15:58:00 -0800
Message-ID: <babafd2f0912151558y513b589ay5e43080ef8e697d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi

I've had my OpenSuse 11.2 box booting from /boot-on-RAID1 +
everything+else-on-RAID10 for awhile now with no issues.

I recently started experimenting with virtualized servers using Xen.

Piecing together a bunch of disjointed advice/instructions, I've set
up a Guest as a server that I want to use as a RAID-ed NAS.  In the
Guest/NAS the NAS's "/", swap & boot are all raw devices passed from
the Xen Host.

For the NAS storage, I have a Passed-through SATA/JBD pci-card that
I've connected external drives to.

I can boot the Guest, see the PCI card, create a RAID-10 array across
those external drives, create & mount LVMs with FSs on them, and
reqd/write ok.  In other words, everything works just as expected.

Except, after rebooting the Guest, the raid array is not started.  I
can re-assemble it, and rescan/mount the vols on it etc, but can't get
the setup to 'stick' across reboot.  :-/

This is what I've stored for auto-assembly,

cat /etc/mdadm
	DEVICE /dev/sd[abcd]1
	ARRAY /dev/md0 metadata=1.01 name=TESTNAS:0 UUID=b23...


and, from the NAS Guest's logs,

cat boot.msg | grep -i raid
<6>[   20.614724] md: raid0 personality registered for level 0
<6>[   20.618933] md: raid1 personality registered for level 1
<4>[   20.711986] raid6: int64x1   2386 MB/s
<4>[   20.779991] raid6: int64x2   3375 MB/s
<4>[   20.847994] raid6: int64x4   2456 MB/s
<4>[   20.915984] raid6: int64x8   2201 MB/s
<4>[   20.983976] raid6: sse2x1    3581 MB/s
<4>[   21.051979] raid6: sse2x2    5624 MB/s
<4>[   21.119978] raid6: sse2x4    6276 MB/s
<4>[   21.120691] raid6: using algorithm sse2x4 (6276 MB/s)
<6>[   21.123798] md: raid6 personality registered for level 6
<6>[   21.124550] md: raid5 personality registered for level 5
<6>[   21.125245] md: raid4 personality registered for level 4
<6>[   21.129319] md: raid10 personality registered for level 10
<notice -- Dec 16 07:34:54.215943000> service boot.device-mapper
done<notice -- Dec 16 07:34:54.216238000> service boot.dmraid
startWaiting for udev to settle...
Activating dmraid...
no raid disks
<notice -- Dec 16 07:34:54.523702000> service boot.dmraid done<notice
-- Dec 16 07:34:54.524007000> service boot.lvm startSetting up
hostname 'TESTNAS'done

I have no idea what I've missed, or even what to look for here.  I
basically followed the same procedures that work flawlessly for me for
my non-virtualized box. :-/  Any suggestions as to what I need to do
to get the RAID-10 recognized/built @ boot of the Xen Guest?  I have a
nagging suspicion that since this RAID array does not contain "/" or
"root" it's not being 'looked for' ... but nothing to back that up,
yet.

Thanks,

BenDJ
