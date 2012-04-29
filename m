From: Shaya Potter <spotter@gmail.com>
Subject: recovering from raid5 corruption
Date: Sun, 29 Apr 2012 18:38:29 -0400
Message-ID: <4F9DC2E5.1090509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

somehow my raid5 got corrupted in the contexts of a main disk failure 
(which wasn't raid related).

compounding this issue was that I had already had one disk in the raid5 
go bad and was in the process of getting it replaced.

this raid array was 5 disks.

What I mean by corrupted is that the superblock of 3 of the remaining 4 
devices seemed to have been wiped out (i.e. had a UUID of all 0s, though 
still enough that it knew it was part of an md device)

now, the one whose superblock seems fine, places it at position disk 3 
(of 0-4) and the missing disk at disk 2.

this would imply that there are only 6 permutations possible for the 
other 3 disks.   (even if that assumptions is wrong, there are only 120 
permutations possible, which I should easily be able to iterate over).

further compounding this, is that there were 2 LVM logical disks on the 
physical raid device.

I've tried being cute and trying all 6 permutations to force recreate 
the array, but lvm isn't picking up anything. (pvscan/lvscan/lvmdiskscan)

The original raid had a version of 0.90.00 (created in 2008), while the 
new one has a version 1.20.

have I ruined any chances of recovery by shooting in the dark with my 
cute attempts, am I SOL or is there a better/proper way I can try to 
recover this data?

Luckily for me, I've been on a backup binge of late, but there still 
about 500-1TB of stuff that wasn't backed up.

thanks, any help would be appreciated.
