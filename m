From: "Calvin Webster" <cwebster@ec.rr.com>
Subject: SCSI parity error detected [sym53c875-0] Aurora Sparc Linux
Date: Tue, 12 Nov 2002 16:12:10 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <CPEAKNIMKMJOCFPEOBGAIEJACHAA.cwebster@ec.rr.com>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello List:

This plea for help relates to a SCSI software RAID that failed over the
Veteran's Day weekend. Details of what I believe are the relevant facts
surrounding the failure are listed below.

I believe that the failure was caused by an overheating condition. Sunday
and Monday of this week were unseasonably warm for Coastal North Carolina
this time of year. The office space in which this system lives has poor
environmental controls and ventilation.

I usually login from my home office over the weekends to catch up on various
projects. I had begun to build a new kernel on this machine on 10 Nov, but
had only gotten as far as "make dep" before I had to stop (there had been no
errors on the terminal). By the time I got back to it the next day (11th) it
was not responding at all. When I went in to the office to check on
it, it was very hot in the computer room (estimate btwn 85-90 degrees). I
shut down power to the computer and RAID overnight and restarted again this
morning.

Temperature in the enclosed, louvered, 19-inch rack today was 85 degrees
with fans blowing directly on the equipment. Same errors were reporting in
the logs so I disabled raid auto startup to allow the system to boot.

I think there are a few possible causes. As you can see from the sample log
entries below, all drives are reporting parity errors. I doubt that there
was a catastrophic failure of all 9 drives at the same time.

	(1) It is possible that we are looking at a SCSI controller error. This is
an integrated controller, though, and I would expect that, if heat related,
there would be other subsystems on the Sparc motherboard failing too.

	(2) It is possible that the ambient temperature is still too high for this
machine to function properly and I should shut it down until it drops below
70 degrees.

	(3) However unlikely, it is possible that the preparations for the kernel
build somehow affected the SCSI kernel module causing it to malfunction,
making it appear that there is a multiple disk failure.

	(4) On Friday, November 8, I disconnected this computer from the RAID, took
it from the rack, opened the case and added a 3Com NIC while attempting to
improve poor network performance of the integrated SunHME interface.
Following the installation, the machine was reinstalled and tested without
any
SCSI errors noted so I don't think this is a likely cause. I only mention it
because the timeframe is close to the RAID failure.

I would deeply appreciate any help that will lead to reconstruction of the
RAID and returning the system to service, preferably without loss of data.
If you need more information please let me know.

Thanks!

--Cal Webster
Network Manager
NavAir TSD ISEO
(Aircraft Simulator Support)
MCAS Cherry Point, NC
cwebster@ec.rr.com

##########################
# Begin Hardware Profile #
##########################

cpu             : TI UltraSparc IIi
fpu             : UltraSparc IIi integrated FPU
promlib         : Version 3 Revision 14
prom            : 3.14.0
type            : sun4u
ncpus probed    : 1
ncpus active    : 1
Cpu0Bogo        : 599.65
Cpu0ClkTck      : 0000000011e1ad41
MMU Type        : Spitfire

IDE Boot drive:

-
class: HD
bus: IDE
detached: 0
device: hdb
driver: ignore
desc: "ST380021A"
physical: 155061/16/63
logical: 155061/16/63
-

SCSI Software RAID Drives:

## 6 of these:
-
class: HD
bus: SCSI
detached: 0
device: sda
driver: ignore
desc: "Fujitsu MAA3182S SUN18G"
host: 0
id: 0
channel: 0
lun: 0
-

## 3 of these:

-
class: HD
bus: SCSI
detached: 0
device: sdg
driver: ignore
desc: "Seagate ST318438LW"
host: 0
id: 6
channel: 0
lun: 0
-

########################
# End Hardware Profile #
########################

##########################
# Begin Software Profile #
##########################

Operating System: Aurora Linux 0.42 (with updates & errata)

Linux version 2.4.19-1.2sparc (root@fry.rdu.redhat.com) (gcc driver version
egcs
-2.91.66 19990314/Linux (egcs-1.1.2 release) executing gcc version
egcs-2.92.11)
 #1 Thu Oct 24 16:15:15 EDT 2002


RAID Software:

raidtools-1.00.2-1.3
mdadm-1.0.1-2

Swap:	256 MB partition

-----------------------
/etc/raidtab
-----------------------
#
# 'persistent' RAID5 setup, with one spare disk:
#
raiddev /dev/md0
    raid-level                5
    nr-raid-disks             8
    nr-spare-disks            1
    persistent-superblock     1
    chunk-size                128

    device                    /dev/sda1
    raid-disk                 0
    device                    /dev/sdb1
    raid-disk                 1
    device                    /dev/sdc1
    raid-disk                 2
    device                    /dev/sdd1
    raid-disk                 3
    device                    /dev/sde1
    raid-disk                 4
    device                    /dev/sdf1
    raid-disk                 5
    device                    /dev/sdg1
    raid-disk                 6
    device                    /dev/sdh1
    raid-disk                 7
    device                    /dev/sdi1
    spare-disk                0
-----------------------
-----------------------
/etc/mdadm.conf
-----------------------
# mdadm configuration file
#
(usual commented section)
DEVICE /dev/sd[abcdefghi]1
ARRAY /dev/md0 UUID=714b16c1:5fb9be28:e5a24a26:38f9f531
MAILADDR root@localhost
-----------------------

########################
# End Software Profile #
########################

########################################
# Begin excerpt from /var/log/messages #
########################################

Synopsis:

No SCSI errors show up until after the hourly cron job on [Nov 10 14:01:00]
around the hottest part of the day. I never saw these errors when I logged
in from my home office on Sunday evening [Nov 10 18:06:34] (disadvantage of
not having a console screen).

Some curious "Correctable ECC Error" messages appeared at [Nov 11 02:16:00],
followed immediately by "TRAPLOG" errors.

SCSI parity errors begin precisely at [Nov 12 10:30:00] again. This time
there are many more of them and the messages seem much more ominous.

I have clipped out the span of time before the SCSI errors started, the
period of time after the first occurrence and before the fatal last
occurrence, and subsequent duplicate reboot messages.

--------------------------------------------------
Nov 10 13:01:00 winggear CROND[10853]: (root) CMD (run-parts
/etc/cron.hourly)
Nov 10 14:01:00 winggear CROND[10864]: (root) CMD (run-parts
/etc/cron.hourly)
Nov 10 14:02:57 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000c00 SBCL=ae
Nov 10 14:02:57 winggear kernel: sym53c875-0-<5,*>: FAST-10 WIDE SCSI 20.0
MB/s(100.0 ns, offset 16)
Nov 10 14:02:57 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000c00 SBCL=ae
Nov 10 14:02:57 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 10 14:02:57 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 10 14:02:57 winggear kernel: sym53c8xx_reset: pid=303922 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 10 14:02:57 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 10 14:02:57 winggear kernel: sym53c875-0-<5,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:02:57 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:02:57 winggear kernel: sym53c875-0-<0,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:02:57 winggear kernel: sym53c875-0-<2,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:02:58 winggear kernel: sym53c875-0-<4,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:02:58 winggear kernel: sym53c875-0-<1,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:03:39 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000e00 SBCL=ae
Nov 10 14:03:39 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:04:16 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:04:46 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000e00 SBCL=ae
Nov 10 14:04:46 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:04:46 winggear kernel: sym53c875-0-<3,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:08:37 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000e00 SBCL=ae
Nov 10 14:08:37 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:08:53 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000e00 SBCL=ae
Nov 10 14:08:53 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:08:53 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000e00 SBCL=ae
Nov 10 14:08:55 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 10 14:08:55 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 10 14:08:55 winggear kernel: sym53c8xx_reset: pid=304685 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 10 14:08:55 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 10 14:08:55 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:08:55 winggear kernel: sym53c875-0-<0,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:08:55 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000e00 SBCL=ae
Nov 10 14:08:55 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:08:55 winggear kernel: sym53c875-0-<1,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:09:38 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:09:38 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000e00 SBCL=ae
Nov 10 14:09:40 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 10 14:09:40 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 10 14:09:40 winggear kernel: sym53c8xx_reset: pid=304716 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 10 14:09:40 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 10 14:09:40 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:09:40 winggear kernel: sym53c875-0-<4,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:09:40 winggear kernel: sym53c875-0-<0,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:09:40 winggear kernel: sym53c875-0-<2,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:09:40 winggear kernel: sym53c875-0-<1,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:09:40 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:09:40 winggear kernel: sym53c875-0-<5,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:09:40 winggear kernel: sym53c875-0-<3,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:09:45 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000e00 SBCL=ae
Nov 10 14:09:45 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000c00 SBCL=ae
Nov 10 14:09:45 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:09:45 winggear kernel: sym53c875-0-<0,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:10:45 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000c00 SBCL=ae
Nov 10 14:10:45 winggear kernel: sym53c875-0-<1,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:11:15 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:11:15 winggear kernel: sym53c875-0-<1,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:14:28 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000e00 SBCL=ae
Nov 10 14:14:28 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:14:28 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000e00 SBCL=ae
Nov 10 14:14:30 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 10 14:14:30 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 10 14:14:30 winggear kernel: sym53c8xx_reset: pid=304954 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 10 14:14:30 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 10 14:14:30 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 14:14:30 winggear kernel: sym53c875-0-<1,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 10 15:01:00 winggear CROND[11099]: (root) CMD (run-parts
/etc/cron.hourly)
Nov 10 16:01:00 winggear CROND[11110]: (root) CMD (run-parts
/etc/cron.hourly)
Nov 10 17:01:00 winggear CROND[11121]: (root) CMD (run-parts
/etc/cron.hourly)
Nov 10 18:01:00 winggear CROND[11132]: (root) CMD (run-parts
/etc/cron.hourly)
Nov 10 18:06:34 winggear sshd(pam_unix)[11141]: session opened for user
cwebster by (uid=0)
Nov 10 18:50:15 winggear su(pam_unix)[11193]: session opened for user root
by cwebster(uid=500)
Nov 10 19:01:00 winggear CROND[11270]: (root) CMD (run-parts
/etc/cron.hourly)
Nov 10 20:01:00 winggear CROND[11527]: (root) CMD (run-parts
/etc/cron.hourly)
Nov 10 20:15:43 winggear gdm[11603]: run_pictures: Directory
/home/slape/.gnome/
gdm does not exist.
...
Nov 11 02:01:00 winggear CROND[5708]: (root) CMD (run-parts
/etc/cron.hourly)
Nov 11 02:16:00 winggear kernel: CPU[0]: Correctable ECC Error
AFSR[180300000] AFAR[000000000cb98030] UDBL[2a0] UDBH[0]
Nov 11 02:16:00 winggear kernel: TRAPLOG: Error at trap level 0x3, dumping
track
 stack.
Nov 11 02:16:00 winggear kernel: TRAPLOG: Trap level 1
TSTATE[0000000011009602]
TPC[000000000040ed30] TNPC[000000000040ed34] TT[63]
Nov 11 02:16:00 winggear kernel: TRAPLOG: Trap level 2
TSTATE[0000000011009502]
TPC[0000000000408c60] TNPC[0000000000408c64] TT[10]
Nov 11 02:16:00 winggear kernel: TRAPLOG: Trap level 3
TSTATE[0000000011009502]
TPC[000000000040c200] TNPC[000000000040c200] TT[a]
Nov 11 02:16:00 winggear kernel: TRAPLOG: Trap level 4
TSTATE[0000009911049407]
TPC[0000000000408d20] TNPC[0000000000408d24] TT[68]
Nov 11 02:16:00 winggear kernel:               \|/ ____ \|/
Nov 11 02:16:00 winggear kernel:               "@'/ .. \`@"
Nov 11 02:16:00 winggear kernel:               /_| \__/ |_\
Nov 11 02:16:00 winggear kernel:                  \__U_/
Nov 11 02:16:00 winggear kernel: phosphor(5717): TL1: Instruction Access
Exception
Nov 11 02:16:00 winggear kernel: TSTATE: 0000000011009502 TPC:
000000000040c200
TNPC: 000000000040c200 Y: 0c400000    Not tainted
Nov 11 02:16:00 winggear kernel: g0: 0000000000000040 g1: 0000000000000003
g2: fffff8000f67d5e0 g3: 000000000060b090
Nov 11 02:16:00 winggear kernel: g4: fffff80000000000 g5: 0000000000000002
g6: fffff8000529c000 g7: 0000000000000002
Nov 11 02:16:00 winggear kernel: o0: 0000000000000001 o1: fffff80009de7e48
o2: 0000000000000020 o3: 0000000000000040
Nov 11 02:16:00 winggear kernel: o4: fffff8000529fe00 o5: 0000000000000001
sp: fffff8000529f4e1 ret_pc: 000000000046afd4
Nov 11 02:16:00 winggear kernel: l0: fffff8000fdfc2a0 l1: fffff8000746dd20
l2: 0000000000408648 l3: 0000000000000000
Nov 11 02:16:00 winggear kernel: l4: 0000000000001000 l5: 000000000000000c
l6: fffff8000529c000 l7: 7fffffffffffffff
Nov 11 02:16:00 winggear kernel: i0: 00000000003057f0 i1: 000000001a000015
i2: fffff8000cb98000 i3: 0000000000000014
Nov 11 02:16:00 winggear kernel: i4: 0000000000414000 i5: 0000000000000000
i6: fffff8000529f601 i7: 0000000000414000
Nov 11 02:16:00 winggear kernel: Caller[0000000000414000]
Nov 11 02:16:00 winggear kernel: Caller[000000000040ef50]
Nov 11 02:16:00 winggear kernel: Caller[000000007012db1c]
Nov 11 02:16:00 winggear kernel: Instruction DUMP: 9210200f  10680bb3
ac100000<0f001030> 10680ad7  8e11e208  400046f5  9003a87f  10680bac
Nov 12 10:30:00 winggear syslogd 1.4.1: restart.
Nov 12 10:30:00 winggear syslog: syslogd startup succeeded
Nov 12 10:30:00 winggear kernel: klogd 1.4.1, log source = /proc/kmsg
started.
Nov 12 10:30:00 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:00 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:00 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:00 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:00 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:00 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:00 winggear kernel: sym53c8xx_reset: pid=438 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:00 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 12 10:30:00 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:00 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000000 SBCL=29
Nov 12 10:30:00 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:00 winggear syslog: klogd startup succeeded
Nov 12 10:30:00 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000000 SBCL=29
Nov 12 10:30:00 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:00 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000000 SBCL=29
Nov 12 10:30:00 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:00 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000000 SBCL=29
Nov 12 10:30:00 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:00 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:00 winggear kernel: sym53c8xx_reset: pid=443 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:00 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 12 10:30:00 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:00 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000000 SBCL=29
Nov 12 10:30:00 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:00 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000000 SBCL=29
Nov 12 10:30:00 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:00 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000000 SBCL=29
Nov 12 10:30:00 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:00 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000000 SBCL=29
Nov 12 10:30:00 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:00 winggear portmap: portmap startup succeeded
Nov 12 10:30:00 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:01 winggear kernel: sym53c8xx_reset: pid=448 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:01 winggear kernel: scsi0: device driver called scsi_done() for
a s ynchronous reset.
Nov 12 10:30:01 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3  DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sdg : READ CAPACITY failed.
Nov 12 10:30:01 winggear kernel: sdg : status = 1, message = 00, host = 0,
driver = 18
Nov 12 10:30:01 winggear kernel: Current sd00:00: sense key Aborted Command
Nov 12 10:30:01 winggear kernel: Additional sense indicates Initiator
detected error message received
Nov 12 10:30:01 winggear kernel: sdg : block size assumed to be 512 bytes,
disk size 1GB.
Nov 12 10:30:01 winggear kernel:  sdg:<6>sym53c875-0-<6,*>: FAST-10 WIDE
SCSI 20.0 MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11001e00 SBCL=ae
Nov 12 10:30:01 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11001e00 SBCL=ae
Nov 12 10:30:01 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:01 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:01 winggear kernel: sym53c8xx_reset: pid=453 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:01 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 12 10:30:01 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11001e00 SBCL=ae
Nov 12 10:30:01 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11001e00 SBCL=ae
Nov 12 10:30:01 winggear kernel: SCSI disk error : host 0 channel 0 id 6 lun
0 return code = 18000002
Nov 12 10:30:01 winggear kernel: Current sd08:60: sense key Aborted Command
Nov 12 10:30:01 winggear kernel: Additional sense indicates Initiator
detected error message received
Nov 12 10:30:01 winggear kernel:  I/O error: dev 08:60, sector 0
Nov 12 10:30:01 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000200 SBCL=ae
Nov 12 10:30:01 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000200 SBCL=ae
Nov 12 10:30:01 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:01 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:01 winggear kernel: sym53c8xx_reset: pid=459 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:01 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 12 10:30:01 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000200 SBCL=ae
Nov 12 10:30:01 winggear kernel: sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear nfslock: rpc.statd startup succeeded
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000200 SBCL=ae
Nov 12 10:30:01 winggear rpc.statd[582]: Version 0.3.3 Starting
Nov 12 10:30:01 winggear kernel: SCSI disk error : host 0 channel 0 id 6 lun
0 return code = 18000002
Nov 12 10:30:01 winggear kernel: Current sd08:60: sense key Aborted Command
Nov 12 10:30:01 winggear kernel: Additional sense indicates Initiator
detected error message received
Nov 12 10:30:01 winggear kernel:  I/O error: dev 08:60, sector 0
Nov 12 10:30:01 winggear kernel:  unable to read partition table
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:01 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:01 winggear kernel: sym53c8xx_reset: pid=466 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:01 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:01 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:01 winggear kernel: sym53c8xx_reset: pid=471 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:01 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:01 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:01 winggear kernel: sym53c8xx_reset: pid=476 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:01 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sdh : READ CAPACITY failed.
Nov 12 10:30:01 winggear kernel: sdh : status = 1, message = 00, host = 0,
driver = 18
Nov 12 10:30:01 winggear kernel: Current sd00:00: sense key Aborted Command
Nov 12 10:30:01 winggear kernel: Additional sense indicates Initiator
detected error message received
Nov 12 10:30:01 winggear kernel: sdh : block size assumed to be 512 bytes,
disk size 1GB.
Nov 12 10:30:01 winggear kernel:  sdh:<6>sym53c875-0-<8,*>: FAST-10 WIDE
SCSI 20.0 MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11001e00 SBCL=ae
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11001e00 SBCL=ae
Nov 12 10:30:01 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:01 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:01 winggear kernel: sym53c8xx_reset: pid=481 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:01 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11001e00 SBCL=ae
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11001e00 SBCL=ae
Nov 12 10:30:01 winggear kernel: SCSI disk error : host 0 channel 0 id 8 lun
0 return code = 18000002
Nov 12 10:30:01 winggear kernel: Current sd08:70: sense key Aborted Command
Nov 12 10:30:01 winggear kernel: Additional sense indicates Initiator
detected error message received
Nov 12 10:30:01 winggear kernel:  I/O error: dev 08:70, sector 0
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000200 SBCL=ae
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000200 SBCL=ae
Nov 12 10:30:01 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:01 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:01 winggear kernel: sym53c8xx_reset: pid=487 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:01 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000200 SBCL=ae
Nov 12 10:30:01 winggear kernel: sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000200 SBCL=ae
Nov 12 10:30:01 winggear kernel: SCSI disk error : host 0 channel 0 id 8 lun
0 return code = 18000002
Nov 12 10:30:01 winggear kernel: Current sd08:70: sense key Aborted Command
Nov 12 10:30:01 winggear kernel: Additional sense indicates Initiator
detected error message received
Nov 12 10:30:01 winggear kernel:  I/O error: dev 08:70, sector 0
Nov 12 10:30:01 winggear kernel:  unable to read partition table
Nov 12 10:30:01 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s 100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:01 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:01 winggear kernel: sym53c8xx_reset: pid=494 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:01 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 12 10:30:01 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s 100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear keytable: Loading keymap:  succeeded
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:01 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:01 winggear kernel: sym53c8xx_reset: pid=499 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:01 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 12 10:30:01 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:01 winggear keytable: Loading system font:  succeeded
Nov 12 10:30:01 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:01 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:02 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:02 winggear kernel: sym53c8xx_reset: pid=504 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:02 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 12 10:30:02 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:02 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:02 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:02 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000000 SBCL=29
Nov 12 10:30:02 winggear kernel: sdi : READ CAPACITY failed.
Nov 12 10:30:02 winggear kernel: sdi : status = 1, message = 00, host = 0,
driver = 18
Nov 12 10:30:02 winggear kernel: Current sd00:00: sense key Aborted Command
Nov 12 10:30:02 winggear kernel: Additional sense indicates Initiator
detected error message received
Nov 12 10:30:02 winggear kernel: sdi : block size assumed to be 512 bytes,
disk size 1GB.
Nov 12 10:30:02 winggear kernel:  sdi:<6>sym53c875-0-<9,*>: FAST-10 WIDE
SCSI 20.0 MB/s (100.0 ns, offset 16)
Nov 12 10:30:02 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11001e00 SBCL=ae
Nov 12 10:30:02 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:02 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11001e00 SBCL=ae
Nov 12 10:30:02 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:02 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:02 winggear kernel: sym53c8xx_reset: pid=509 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:02 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 12 10:30:02 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:02 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11001e00 SBCL=ae
Nov 12 10:30:02 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:02 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11001e00 SBCL=ae
Nov 12 10:30:02 winggear kernel: SCSI disk error : host 0 channel 0 id 9 lun
0 return code = 18000002
Nov 12 10:30:02 winggear kernel: Current sd08:80: sense key Aborted Command
Nov 12 10:30:02 winggear kernel: Additional sense indicates Initiator
detected error message received
Nov 12 10:30:02 winggear kernel:  I/O error: dev 08:80, sector 0
Nov 12 10:30:02 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:02 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000200 SBCL=ae
Nov 12 10:30:02 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:02 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000200 SBCL=ae
Nov 12 10:30:02 winggear kernel: scsi0 channel 0 : resetting for second half
of retries.
Nov 12 10:30:02 winggear kernel: SCSI bus is being reset for host 0 channel
0.
Nov 12 10:30:02 winggear kernel: sym53c8xx_reset: pid=515 reset_flags=1
serial_number=0 serial_number_at_timeout=0
Nov 12 10:30:02 winggear kernel: scsi0: device driver called scsi_done() for
a synchronous reset.
Nov 12 10:30:02 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:02 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000200 SBCL=ae
Nov 12 10:30:02 winggear kernel: sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0
MB/s (100.0 ns, offset 16)
Nov 12 10:30:02 winggear kernel: sym53c875-0: SCSI parity error detected:
SCR1=3 DBC=11000200 SBCL=ae
Nov 12 10:30:02 winggear kernel: SCSI disk error : host 0 channel 0 id 9 lun
0 return code = 18000002
Nov 12 10:30:02 winggear kernel: Current sd08:80: sense key Aborted Command
Nov 12 10:30:02 winggear kernel: Additional sense indicates Initiator
detected error message received
Nov 12 10:30:02 winggear kernel:  I/O error: dev 08:80, sector 0
Nov 12 10:30:02 winggear kernel:  unable to read partition table
Nov 12 10:30:02 winggear kernel: md: md driver 0.90.0 MAX_MD_DEVS=256,
MD_SB_DIS KS=27
Nov 12 10:30:02 winggear kernel: raid5: measuring checksumming speed
Nov 12 10:30:02 winggear kernel:    VIS       :   128.000 MB/sec
Nov 12 10:30:02 winggear kernel: raid5: using function: VIS (128.000 MB/sec)
Nov 12 10:30:02 winggear kernel: md: raid5 personality registered as nr 4
Nov 12 10:30:02 winggear kernel: md: raid5 personality registered as nr 4
Nov 12 10:30:02 winggear kernel: Journalled Block Device driver loaded
######################################
# End excerpt from /var/log/messages #
######################################

