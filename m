From: John Powell <powellj@gmail.com>
Subject: Moving existing RAID5 disks to an alternate server
Date: Wed, 19 Jan 2011 19:05:52 -0800
Message-ID: <AANLkTim4xsHXxBERJf0qucYgAizmzB8__66RR3XnT081@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So practically speaking I don't have hardly any experience managing
RAID volumes. I have used some LSI web bios's to create RAID volumes
of various forms for functional dev/test and am familiar enough with
the terminology and implementation but when left with the choice of
building my own home NAS or buying some proprietary piece of hardware
pre-configured I chose the later in the interest of time and money.
Perhaps I made a poor choice there as my proprietary hardware died and
has left me with a seemingly intact RAID 5 volume spanned over 4 500GB
PATA disks. Seeing as how the hardware is bricked I am going to
attempt to pull out those disks and configure a RAID5 volume on a
custom built machine, (something I constructed over 5 years ago.. it
still as PATA interfaces :D ). The goal here is to copy the contents
of this volume to an alternate server that I will be using for backups
with some more updated hardware.

Anyhow, the point of my post: Is it really as simple as it sounds? Use
mdadm to recreate the RAID5 volume and away I go? Are there any
details that one can offer that I may need to be aware of or is simply
reading the man pages and various HOWTO's out on the net enough to get
started? Obviously I am taking this slow as the data on the disks is
important to me.

Thanks for your time in advance!
