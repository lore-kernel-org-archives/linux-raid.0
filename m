From: Adeel N <adeeln@hotmail.com>
Subject: multiple raid 5 arrays using multiple partitions
Date: Sat, 25 Oct 2008 10:03:08 +0000
Message-ID: <COL106-W51C2E21BB08BA4455C26A8C82A0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,
   Originally, I setup a single RAID5 array using 3, 1 TB SATA drives a=
nd put LVM2 on top to allow for easier administration. Based upon my ne=
eds (at the time) and what I had read about RAID, I decided to use a de=
cently large chunk size (256k) for md0. Initially, I was serving predom=
inantly large files (1gb+ each) so I tried to optimize everything for t=
hat. Now my needs have changed: I need to accommodate both, large and s=
mall files. It was suggested to me to partition the drives and then cre=
ate multiple arrays from the partitions, each with their own optimized =
chunk size. However, wouldn't this cause the drives to excessively thra=
sh or is that only bound to happen under high I/O loads? This array is =
only used by 6-12 people, primarily through NFS/Samba so I'm not expect=
ing it to have incredibly high I/O loads, but I don't want the disks to=
 die prematurely due to excessive thrashing. Is there any other downsid=
e or advantages to this approach? Is it commonly used? I know the ideal=
 approach would be to have more drives and make them a separate array, =
but that's not possible yet.

Also, just to double check, I shouldn't expect any adverse performance =
(than normal) when using LVM2 with multiple arrays on multiple partitio=
ns?

One final thing, when using LVM2 & mdadm what, if any, optimizations/co=
nsiderations should be taken into account to enhance performance? I've =
come across quite a few threads that seem to address this topic, but th=
ey didn't seem to be very cohesive nor authoritative. I've tried some o=
ptimizations that I've come across, e.g. setting the read ahead paramet=
ers for each drive, stripe cache, partition offset, XFS sunit/swidth, e=
tc but I'm not sure which ones I'm missing or have a significant impact=
=2E

I apologize in advance if this topic has been covered already, but I wa=
sn't able to find a clear answer to this topic in my searches, so I tho=
ught I'd ask.

Thanks for the help,

Adeel
_________________________________________________________________
When your life is on the go=97take your life with you.
http://clk.atdmt.com/MRT/go/115298558/direct/01/--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
