From: "michael@kmaclub.com" <michael@kmaclub.com>
Subject: Confused about UUID mounting and mirrors
Date: Mon, 16 Jun 2008 10:54:14 -0700
Message-ID: <4856A8C6.3030609@kmaclub.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am making the transition from hardware raid to software raid and 
things have gone pretty well.

I am trying to mount everything by UUID to account for devices moving 
around, etc.

I have moved all mounts in /etc/fstab to uuid except /boot which is a 
mirror sitting on /dev/md0.

Since it is a mirror, blkid returns the same uuid for /dev/md0, 
/dev/sda1, and /dev/sdb1.

This confuses mount at boot time.

How to I get it to correctly find md0 and not the components of the mirror?

Michael
