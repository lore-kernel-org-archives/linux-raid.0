From: Maik Zumstrull <maik@zumstrull.net>
Subject: Bug#700975: RAID barely usable on my home machine
Date: Thu, 4 Apr 2013 22:13:05 +0200
Message-ID: <CAO=zWDLfnBJBFgm4H67XEqsKPP=+Ayk3Jd4OUdEfmLXsvNGdog@mail.gmail.com>
Reply-To: Maik Zumstrull <maik@zumstrull.net>, 700975@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.700975.B700975.136510640729640@bugs.debian.org>
List-URL: <http://lists.debian.org/debian-bugs-dist/>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
Cc: 700975@bugs.debian.org
List-Id: linux-raid.ids

Hello Linux RAID and ATA people,

I've managed to find a configuration on my home desktop where a
particular RAID array is barely usable.

You can find my initial report at:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D700975

In summary:

- I create an array across four disks on a Marvell AHCI controller,
which automatically goes into rebuild mode.
- Somebody (e.g. smartd or udisks2 or me, testing) sends a SMART
command to one of the disks.
- The SMART command fails.
- The ATA subsystems freaks out all over the place, until eventually
none of the disks on that controller are responsive.
- The array is dead until reboot. (Curiously, without data loss so
far. Kudos on the RAID code, I guess.)

I've found the issue to be highly reproducible so far. Things mostly
work if the array is not under heavy load (not rebuilding, no big file
copies going on) or I make completely sure nothing sends SMART
commands. I currently do keep real files on that array, but backed-up
ones, so I could wipe it for more tests if really necessary.

I've tried various kernels from Debian (3.2, 3.7, and 3.8 series) and
found them all affected.

Here are some edited excerpts from the kernel log messages as found in
the Debian bug, see unedited transcript there.

Getting our RAID on:

[  122.707833] md127: detected capacity change from 0 to 9001374842880
[  122.707860] RAID conf printout:
[  122.707865]  --- level:5 rd:4 wd:3
[  122.707868]  disk 0, o:1, dev:sde
[  122.707870]  disk 1, o:1, dev:sdf
[  122.707872]  disk 2, o:1, dev:sdg
[  122.707873]  disk 3, o:1, dev:sdh
[  122.707965] md: recovery of RAID array md127
[  122.707968] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  122.707970] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for recovery.
[  122.707973] md: using 128k window, over a total of 2930135040k.

We see a SMART we don't like:

[  180.531641] ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 fr=
ozen
[  180.531648] ata9.00: failed command: SMART
[  180.531655] ata9.00: cmd b0/d1:01:01:4f:c2/00:00:00:00:00/00 tag 0 pio 5=
12 in
[  180.531655]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  180.531658] ata9.00: status: { DRDY }

Woops, a non-critical command failed? Best shoot the controller in the
face until it stops twitching:

[  180.531666] ata9: hard resetting link
[  185.887433] ata9: link is slow to respond, please be patient (ready=3D0)
[  190.524871] ata9: COMRESET failed (errno=3D-16)
[  190.524877] ata9: hard resetting link
[  195.872694] ata9: link is slow to respond, please be patient (ready=3D0)
[  200.510134] ata9: COMRESET failed (errno=3D-16)
[  200.510141] ata9: hard resetting link
[  205.857925] ata9: link is slow to respond, please be patient (ready=3D0)
[  235.470518] ata9: COMRESET failed (errno=3D-16)
[  235.470526] ata9: limiting SATA link speed to 3.0 Gbps
[  235.470529] ata9: hard resetting link
[  240.483102] ata9: COMRESET failed (errno=3D-16)
[  240.483110] ata9: reset failed, giving up
[  240.483112] ata9.00: disabled
[  240.483134] ata9: EH complete

So now other stuff goes wrong:

[  301.216814] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 fr=
ozen
[  301.216818] ata7.00: failed command: FLUSH CACHE EXT
[  301.216821] ata7.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  301.216821]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  301.216822] ata7.00: status: { DRDY }
[  301.216827] ata7: hard resetting link
[  301.216842] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 f=
rozen
[  301.216845] ata10.00: failed command: FLUSH CACHE EXT
[  301.216849] ata10.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  301.216849]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  301.216851] ata10.00: status: { DRDY }
[  301.216855] ata10: hard resetting link
[  301.216861] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 fr=
ozen
[  301.216864] ata8.00: failed command: FLUSH CACHE EXT
[  301.216868] ata8.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[  301.216868]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  301.216870] ata8.00: status: { DRDY }

Until eventually, the patient's dead=E2=80=A6so let's report success:

[  351.917459] md/raid:md127: Disk failure on sde, disabling device.
[  351.917459] md/raid:md127: Operation continuing on 0 devices.
[  351.921299] md: md127: recovery done.

This is on a cheapo PCIe extension board with four internal SATA3
ports. Chip is a "Marvell Technology Group Ltd. 88SE9230 PCIe SATA
6Gb/s Controller [1b4b:9230]" using the ahci driver.

It would be really good to see this fixed. I see two issues:
- That SMART command probably shouldn't fail. Weird drive firmware?
Timeout too tight?
- A failing SMART command should probably not trigger a breakdown of
the whole controller. At least, not such a messy one.

I'll make myself available, as time allows, to provide requested
additional information.
