From: Dylan Distasio <interzone@gmail.com>
Subject: Slow network speeds between Linux RAID box and Windows PC
Date: Tue, 29 Sep 2009 23:22:08 -0400
Message-ID: <3513de790909292022hbff20ben3d758602f12970c1@mail.gmail.com>
References: <3513de790909292020k79f6b83blf62e73aeb91d4681@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3513de790909292020k79f6b83blf62e73aeb91d4681@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I apologize that this question is not directly related to mdadm, but I
thought some of the list might have experience in a mixed
Linux/Windows environment. =A0I am running a mdadm RAID5 file server on
a Ubuntu 8.04 Linux box on a gigabit LAN. =A0I am using a Highpoint 268=
0
card at PCI-E 4x as the controller (I have also tried the motherboard
SATA connectors directly). =A0I am running SAMBA on this box to share m=
y
RAID5 with my main Windows PC running Windows 7 64 bit (although I
have gotten similar results with Vista also).
My question is related to what I consider slow speeds when reading
from or writing to the array from my Windows box. =A0I get anywhere fro=
m
20-30MB/s in either direction when transferring a single large file (3
GB as an example). =A0I haven't done detailed benchmarking on the array=
,
but spotchecks of file transfers from another drive on the same linux
box are giving me speeds above 100MB/s for reads and writes.
Does anyone have any suggestions for improving my speeds across the
network? =A0I don't know if SAMBA is causing some kind of bottleneck or
if Windows is not playing nice or if it's something with my network
configuration, but I was hoping to get alot closer to saturating the
gigabit connection. =A0Any help would be greatly appreciated.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
