From: "Ruth Ivimey-Cook" <Ruth.Ivimey-Cook@ivimey.org>
Subject: Help resyncing/remounting raid5 array please
Date: Tue, 21 Oct 2003 19:18:51 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000d01c397ff$ca6de440$0600a8c0@Robinton>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Folks,

I have a 3-disk raid5 array that was working ok earlier and has quite a lot of
data on it. I have just built it into a new computer and, sadly, messed up the
event counter while trying to get it working. The new computer was having
problems driving one of the controllers and I'd also failed to set the
partition type to 0xfd (it was 0x83). Having now set the partition type
properly, the raid system does consider the disks as possible RAID drives.

The current state is that I have 2  disks with an event count of 0x11 and one
with an event counter of 0x77 ! (how it got that high compared to the others I
don't understand). Now, if I could persuade the system to believe the disks
with a 0x11 count are ok and create a raid drive with them, I'd be fine as I
could hot-add the last, but it wants to start with the 0x77 drive, fails
because there aren't enough disks, and gives up.

I really don't want to kill the data and start again as I don't have a
(recent) backup of the 90GB of data :-(  I'm using Linux 2.4.20 &/or 2.4.21 on
an Athlon system with 3 seagate 120GB drives; I have a fourth SATA drive
connected that I hope to get running when I can get a new kernel installed.

Is there any way forward?

Ruth


