From: David Anderson <david.anderson@calixo.net>
Subject: Software RAID within RAID
Date: Fri, 25 Jul 2003 03:48:42 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030725034842.52114001.david.anderson@calixo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

First of all I would like to thank the developers of the linux software
RAID system for their excellent work which has saved my data on several
occasions.

Recently I lost one of the disks on my software RAID5 (3x2Gb SCSI on a
2.4.21 Debian Woody). Seeking replacements, I came across two 4Gb SCSI
drives. After inserting one of them as a temporary replacement for the
dead 2Gb, I am now looking into ways of better integrating these two new
disks into my existing setup.

The most best solution I came up with was to extend the array's overall
capacity from 4 to 8Gb. To do this I would first combine the two
remaining 2Gb disks into a RAID0 array, and then combine that array and
the two 4Gb disks into a RAID5 array. To clarify this, here is a diagram
of this solution: http://polaris-outpost.net/vrac/Solution.png .

However, there are a few things I would like to know before I make an
attempt at this setup. First of all, would the software-raid driver
handle disk failures properly even with the RAID within RAID? I do not
see why not, but I'd rather be sure before I jump...
The other question I have is about performances. Would the RAID0 array
significantly impact on the overall I/O perfomances of the RAID5 array?
If anyone has already had the opportunity of comparing performances on a
regular RAID5 and a RAID5 containing a RAID0, I would be interested in
the results. I will of course conduct my own tests once this setup is in
place.

Thanks in advance for your help
David Anderson
