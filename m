From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Thu, 6 Jan 2005 12:31:37 -0500
Message-ID: <200501061731.j06HVi932064@www.watkins-home.com>
References: <200501061516.47376.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501061516.47376.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'maarten' <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This idea of splitting larger disks into smaller partitions, then
re-assembling them seems odd.  But it should help with the "bad block kicks
out a disk" problem.

I have never used RAID0.
I have never used more than 1 pv with LVM on Linux.

However, if you are going to use LVM anyway, why not allow LVM to assemble
the disks?  I do that sort of thing all the time with HP-UX.  I create
stripped mirrors using 4 or more disks.  With HP-UX, use the -D option with
lvcreate.  No idea if Linux and LVM can strip.

You are making me think!  I hate that!  :)  Since your 6 RAID5 arrays are on
the same 4 disks, striping them will kill performance.  The poor heads will
be going from 1 end to the other, all the time.  You should use LINEAR is
you combine them with md.  If you use LVM, make sure it does not stripe
them.  With LVM on HP-UX, the default behavior is to not stripe.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of maarten
Sent: Thursday, January 06, 2005 9:17 AM
To: linux-raid@vger.kernel.org
Subject: Spares and partitioning huge disks


Hi

I just got my 4 new 250GB disks.  I have read someone on this list
advocating 
that it is better to build arrays with smaller volumes, as that decreases
the 
chance of failure, especially failures of two disks in a raid5
configuration. 

The idea behind it was that since a drive gets kicked when a read-error 
occurs, the chance is lower that a 40 GB part develops a read error than for

the full size 250 GB.  Thus, if you have 24 40GB parts, there is no fatal
two 
disk failure when part sda6 and part sdc4 develop a bad sector at the same 
time. On the other hand, if the (full-size) disk sda1 and sdc1 do fail at
the 
same time, you're in deep shit. 
I thought it was real insightful, so I would like to try that now.

(Thanks to the original poster, I don't recall your name, sorry)

Now my two questions regarding this.

1) What is better, make 6 raid5 arrays consisting of all 40GB partitions and

group them in a LVM set, or group them in a raid-0 set (if the latter is
even 
possible that is) ?

2) Seen as the 'physical' volumes are now 40 GB, I could add an older 80GB 
disk partitioned in two 40GB halves, and use those two as hot-spares. 
However, for that to work you'd have to be able to add the spares to _all_ 
raid sets, not specific ones, if you understand what I mean.  So they would 
act as 'roaming' spares, and they would get used by the first array that 
needs a spare (when a failure occurs of course).  But... is this possible ? 

Thanks for any insights!
Maarten

-- 

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

