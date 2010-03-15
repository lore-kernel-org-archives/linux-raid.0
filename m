From: rj <ratnadeep@gmail.com>
Subject: RAID0 on disks with different sizes
Date: Mon, 15 Mar 2010 11:56:24 +0530
Message-ID: <d19eda751003142326j7bfec447ne64cfa50e22f089c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

How does MD RAID0 layer support disks with different sizes?
1. Does it take the size of smallest disk and do the striping
accordingly?  This way there would be wastage of space in bigger
disks.
Or
2. Does it stripe across all the space of disks? This way, if striping
is not possible for a disk because it has exhausted the space,
striping will continue or remaining devices (although with
compromising performance for these stripes because they have one disk
less).

What approach md chooses? Also, what approach is taken for RAID5 in such cases?

Thanks in advance.
