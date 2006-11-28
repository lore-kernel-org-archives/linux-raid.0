From: peter pilsl <pilsl@goldfisch.at>
Subject: how does autoraid work ?
Date: Tue, 28 Nov 2006 19:59:36 +0100
Message-ID: <456C8718.2040406@goldfisch.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I've currently a new server (first ubuntu I set up) and I've a problem 
with a raiddevice. While the system itself (/ and /boot) do not use 
raid, a /data-partition is setup as raid1 /dev/md0

Now I'v the problem that md0 is not started during boot, but only late 
when the scripts in rc.d/ are processed for my runlevel. There is a 
script mdadm-raid that actually assemlnbles the raid based on a 
copnfig-file. This is not what I want/need.

On my other servers the raids are autodetected much earlier by the 
kernel or a module much earlier without need of a configfile.

The partitions of my raid are all labeld als linux-autoraid and I can 
manually assemble my raid with mdadm -A -a yes -m 0 /dev/md0, so 
everthing should be fine for the kernel to autostart my raid.

When exactely are the raids supposed to be assembled during boot. Which 
module/script is actually responsible for doing this?  And are there any 
  shots in the dark, why my ubuntu/debian is not doing so?

The raid is on hde and hdf - can this be the problem? that the 
raidmodule/script/whatever does not scan beyond the first two ide-buses?

I tried  raid=autodetect on the bootline but this didnt help either.

I hope I made my self a bit clear and any help is greatly appretiated...

thnx
peter




