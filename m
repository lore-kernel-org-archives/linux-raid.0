From: Derek Piper <derek.piper@gmail.com>
Subject: RAID5 on different sized disks on low-end machine
Date: Tue, 11 Jan 2005 13:47:20 -0500
Message-ID: <eaa6dfe050111104772af6240@mail.gmail.com>
Reply-To: Derek Piper <derek.piper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am new to RAID / md devices, although I've used Linux for a number
of years. I decided it was high-time I had a RAID at home for
important things (email, web-sites, son's baby pics, mp3s etc.). I
happen to have a 3 Seagate 60GB hds and 1 80GB Seagate hd that I am
considering using for a RAID.

My question is this, is it possible (and even a good idea) to use all
4 hard drives as members of a 4 x 60GB RAID5 array by leaving 20GB of
the 80GB drive as a non-raided partition? I'll be using a Promise
Ultra TX2/100 controller.

i.e.

hde -> 60
hdf -> 60
hdg -> 60
hdh -> 60/20

I heard about RAID6 too, though I'm assuming that will use up another
disk's worth of disk space too.

i.e. RAID5 = 180GB usable size,wherease RAID6 = 120GB .. am I correct
in my thinking?

I know many of you use far larger hard drives, I'm just trying to use
the components I already had spare from a number of machines and
reorganize to a RAID-backed fileserver.

The machine is a dual pentium-pro 200 (320MB RAM) .. would that be a
dumb idea to use RAID5 on it because of the parity calculations
needed?

Further to that, would it be a smarter idea to use RAID1 on all 4 of
some small partition(s) at the start of the disks to house
boot/root/usr partitions, and only RAID5 on a larger 'data' area of
the drive that is more likely to be read than written to?

Comments are appreciated.

Thanks,

Derek
