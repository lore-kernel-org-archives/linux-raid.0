From: Sharif Islam <mislam@ux1.cso.uiuc.edu>
Subject: bad /proc/mdstat message
Date: Mon, 12 Jan 2004 12:28:37 -0600 (CST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.31.0401121226350.29377-100000@staff2.cso.uiuc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am getting the following message:
mdadm: bad /proc/mdstat line starts : Event:


I wasn't able to figure out the reason. My array is acting normal and
/proc/mdstat looks ok to me.

# cat /proc/mdstat
Personalities : [linear] [raid0]
read_ahead 1024 sectors
Event: 1
md0 : active linear hdl[5] hdk[4] hdh[3] hdg[2] hdf[1] hde[0]
      703324416 blocks 64k rounding

unused devices: <none>

Any hints?

