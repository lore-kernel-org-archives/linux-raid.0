From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: RAID5 on broken RocketRaid 1640 - data format?
Date: Fri, 29 Jan 2010 19:55:14 +0000
Message-ID: <73e903671001291155g761f2dc8rb6e02541525929ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

A good pal of mine once had a 4x400GB RAID5 array running on a
RocketRaid 1640 controller. The controller broke, and due to
complexity and his understandable lack of RAID expertise, the drives
are sitting in a drawer. I want to try to help.

Do you excellent list dwellers know what data format the 1640 uses on
the disks? Is there any Linux RAID tool that can work with the data
off the disks?

In case it's relevant, the system was running Windows, and there was a
single NTFS filesystem over the array. I'm pretty sure the array was
created on the BIOS side.

Many thanks!
-- Kristleifur
