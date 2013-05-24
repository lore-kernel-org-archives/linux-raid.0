From: Jim Santos <iluvgadgets@gmail.com>
Subject: Moving RAID1 disks between systems
Date: Fri, 24 May 2013 12:53:31 -0400
Message-ID: <CAGPLN=s0nBeuHk75KSaKV2LS1MxYrdVmXjG7eM+dP36bOSbA-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Let's say that two people each have a system with a RAID1 array made
up of two disks
(/dev/sda & /dev/sdb).  Now let's say that one of the systems
experiences a failure that
keeps it from being able to be started (e.g. blown motherboard).  Is
there a way to get the
data off of the failed system's disks after putting them in the
working system?  It seems to
me that the disk device names stored in the superblock are going to
conflict with the device
names of the existing disks.  But then again, I'm not a SW RAID expert ;-)

TIA
