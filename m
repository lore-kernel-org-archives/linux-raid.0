From: Anthony debeus <anthony.debeus@gmail.com>
Subject: mdadm ntfs-3g
Date: Fri, 6 Mar 2009 13:06:27 -0700
Message-ID: <e7c6e7680903061206h43a8a278g1432ae84a124b7c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry if this counts as a cross-post, I posted this comment on
http://neil.brown.name/blog/20040607123837, but perhaps emailing was
the best route to get help. Here's the problem/question:

I've greatly enjoyed using mdadm, but have been puzzled by one piece
of its behaviour. If used to to build a prexisting Windows Raid array
with -build, e.g.:

mdadm -B -c 64 -l 1 -n 2 /dev/md2 /dev/hda1 /dev/hdb1

where Windows has built a healthy RAID1 array on the first partitions
of /dev/hda1 and bdb1, all seems to go well.

The array is mountable with the kernel ntfs driver ro or rw. Using
ntfs-3g, however, is impossible as apparently the device size is
smaller than the volume size (as found by ntfsresize -i /dev/md2, for
example, see the thread below)

Thinking this to be a ntfs-3g problem, I contacted the developer,

http://forum.ntfs-3g.org/viewtopic.php?f=3&t=1125

but apparently they feel this is a mdadm problem. I did some testing,
and the problem is independent of whether dmraid is in use or not.
Searching around the web yields similar problems with Windows Raid-0
and Raid-5 arrays, all with the same issue.

Any clues?
