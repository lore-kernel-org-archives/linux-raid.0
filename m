From: Maxwell Bottiger <sleepylight@jive-turkey.net>
Subject: recovery of software raid0 - continued
Date: 16 Jun 2002 20:47:33 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1024274853.2688.13.camel@jive-turkey.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The attempt to recover my missing raid arrays continues...

I have 3 arrays.  md0 is composed of sdd1 and sde1, md1 is composed of
sdd2 and sde2 and md2 is composed of sdd3 and sde3.  md0 is mounted
under /usr, md1 _should_ be mounted under /home and md2 _should_ mounted
/mnt/shared.

The problem I have right now is that md1 says that it is composed of
sdd2 and sde2, however it is not the right size.  The same is true of
md2.  It looks like the data and size of the two arrays have been
reversed, even though they say the are composed of the right physical
partitions.  Everything on /home looks fine, but /mnt/shared is empty
save the lost+found directory.

My questions are, first, what is wrong with the RAID mapping, and
second, is it possible that my data in /mnt/shared (aka md2) is still in
place?
