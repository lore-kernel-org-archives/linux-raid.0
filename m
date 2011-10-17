From: "Moshe Melnikov" <moshe@zadarastorage.com>
Subject: Potential data rollback/corruption after drive failure and re-appearance
Date: Mon, 17 Oct 2011 08:46:16 +0200
Message-ID: <C05A23992BC74BCC8037E32AB1EFF0DE@MoshePC>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="windows-1255";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am testing the following scenario: a simple RAID1 md array with drives A 
and B. Assume that drive B fails, but the array remains operational and 
services IOs. After a while, machine is rebooted. After reboot drive B comes 
back, but now drive A becomes inaccessible. Assembling the array with both 
drives results in a degraded array, with a single drive B. However, B's data 
is the array's data at the time of drive B failure, not the latest array's 
data. So the data kind of rolls back in time.

Testing a similar scenario with RAID5: A,B and C drives, C drive fails, 
RAID5 becomes degraded but operational. After reboot B and C are accessible, 
but A disappears. Assembling the array fails, unless --force is given. 
With --force, the array comes up, but the data, of course, is corrupted.

Is this behavior intentional?

Suppose I want to protect against this by first examining the MD superblocks 
(--examine). I want to find the most updated drive, and check what array 
state it shows. Which part of "mdadm --examine" output should I use to find 
the most updated drive? The "Update Time" or the "Events" counter? Or 
perhaps something else?

Thanks,
Moshe Melnikov 

