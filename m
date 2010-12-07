From: hansbkk@gmail.com
Subject: General Q on adding new PVs to existing striped RAID set
Date: Tue, 7 Dec 2010 16:15:52 +0700
Message-ID: <AANLkTiktmuWTBC-s1Qi4KBjQOyhYh+TtLxiu0hPhNh+K@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LVM general discussion and development <linux-lvm@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

According to the advice I've been given so far - I should use RAID
"under" my LVM configuration, not only for fault tolerance but also
for the performance benefits of striping, and leave LVM as a "top
layer" for disk space management efficiency and flexibility, plus of
course the benefits of snapshots.

One of LVM's biggest wins is the fact that if you're running out of
space you can just slap in more disks, add them to your VG and extend
your LVs. But I can see how this may result in performance or fault
tolerance issues.

Example - if I have say 6TB of RAID10 managed by LVM, and then find I
need to add another 2TB, I might add a RAID1 mirror of 2x 2TB drives
and extend my VG to get more space. However it seems for optimum
performance and fault tolerance I should  consider this a somewhat
temporary workaround. Ultimately I would want to get back to a
coherent single 8TB RAID set, and take the RAID1 mirror out.

This seems to be better from multiple POVs - more space efficient,
more consistently predictable performance (if not actually faster),
and most importantly more fault tolerant.

I realize if I was using RAID6 as many have advised I should, I could
grow the underlying RAID itself directly and then expand the VG, and
obviously this would be ideal. But I wanted to clarify regarding those
RAID flavors that can't be grown in place, as a principle of best
practice.

Please confirm if my thinking on this is on the right track.
