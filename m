From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Raid Array with 3.5Tb
Date: Thu, 15 Jan 2004 17:25:43 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401152225.i0FMPli09930@dns1.watkins-home.com>
References: <1074196167.1382.8.camel@e-linux>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1074196167.1382.8.camel@e-linux>
To: 'Evan Felix' <evan.felix@pnl.gov>, 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

3.5Tb cool!
I bet there is a 2Tb limit.  Or 2^31-1 blocks.  But just a guess!

If you have time, create an array with 8 disks.  I think this will work.
The size will be just under 2T.  If it does work, then create an array with
9 disks.  This will be just over 2T.  I think this will fail.

Even if there were not a 2T limit with md, I bet the filesystem has a limit.
You may need to create 2 arrays of 8 disks each, and create 1 filesystem on
each array.


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Evan Felix
Sent: Thursday, January 15, 2004 2:49 PM
To: linux-raid
Subject: Raid Array with 3.5Tb

I've been attempting to create a large raid 5 device using the linux
2.6.1 kernel, with the Large Block Device configured on.  I have in the
system 16 250G disks.  I built an array with mdadm -C -n 15 -x 1
/dev/md2 /dev/sd[a-p]

The resync/recovery seemed to be going fine, but at some point i started
seeing:

kernel: compute_blocknr: map not correct
kernel: compute_blocknr: map not correct

thousands of time in my logs.

I had hoped this message was not bad, so i tried a mkfs on the system, 
the mkfs just seemed to hang(no output at all), i left it for 15 hours
or so but it never output anything.

I rebooted and restarted the array, and am running a simple dd of the
entire block now, but it will take sometime.

Has anyone else made an array this large? and does anybody have any
pointers on where i can start looking at code to fix this?

Evan
-- 
-------------------------
Evan Felix
Administrator of Supercomputer #5 in Top 500, Nov 2003
Environmental Molecular Sciences Laboratory
Pacific Northwest National Laboratory
Operated for the U.S. DOE by Battelle
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


