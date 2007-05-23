From: "lewis shobbrook" <lewis@blue-matrix.org>
Subject: Fwd: Identify SATA Disks
Date: Thu, 24 May 2007 09:29:04 +1000
Message-ID: <8c4e120705231629q727718f2yb0704ff33b7012c@mail.gmail.com>
References: <8c4e120705230023v71a2ffa3p182f1e02ccb9cd54@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8c4e120705230023v71a2ffa3p182f1e02ccb9cd54@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All,
I'm wondering if anyone has discovered any nice tricks to assist in
identification of hdd devices.
 I have an 8 bay hotswap array, pretty lights and have been wondering
what others out there might be doing to determine which disk in an
array is which.

I've noted that device allocation can change with the generation of
new initrd's and installation of new kernels; i.e. /dev/sdc becomes
/dev/sda depending upon what order the modules load etc.
I'm wondering if one could send a looped read/write task to a swap
partition or something to determine which the device is?

Also I've not had much joy in attempting to "hotswap" SATA on a live system.
Can anyone attest to successful hotswap (or blanket rule out as
doesn't work) using std on board SATA controllers,  cf dedicated raid
card, or suggest further reading?
I've spent considerable time here and there in recent years trying to
find some decent info on this...

Also just tried  2.6.21 mdadm (2.6.2) --grow of a raid6 array.
Currently being a test system, I had the luxury of adding 2 disks at
once.
The result is initially impressive, although the resync growing form 6
to 8 x 300 GB partitions is slow plodding on a "live system" (not
single user mode) @ 1640K/sec
and % cpu very high.  finish=3148.3 min .... ~2 days.

Cheers,

Lew
