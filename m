From: Alvin Oga <aoga@mail.Linux-Consulting.com>
Subject: raid5 - failed disks
Date: Fri, 1 Apr 2005 02:08:21 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050401015858.14428C-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya raiders ..

we(they) have 14x 72GB scsi disks config'd as raid5,
( no hot spare .. )

- if 1 disk dies, no problem ... ez to recover

- my dumb question is,
	- if 2 disks dies at the same time, i
	assume the entire raid5 is basically hosed 
	if it won't reassemble and resync from
	the point where it last was before the crash ??

	- i assume that the similar 2 disk failure
	also applies to hw raid controllrs, but it'd
	be more dependent upon the raid controller's 
	firmware for it's ability to recover from 
	2 of 14 simultaneous disk failures
	( lets say the dell powervault 2205 series )

- i think 4x 300GB ide disks is better ( less likely to fail ?? )

	and yes it has already crashed twice with
	2 different disks running at 78F at nights
	and weekends when the air conditioning is off

- i wish i can just change things but... its
  not yet my call :-)

c ya
alvin

