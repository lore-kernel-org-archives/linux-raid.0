From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: raid1 missing disk
Date: Thu, 12 Oct 2017 18:48:30 +0200
Message-ID: <e3ac851f-347f-ee63-c58d-02d8a1afb4c7@thelounge.net>
References: <85523B4D-6691-44F1-A609-A5280224E352@jjd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <85523B4D-6691-44F1-A609-A5280224E352@jjd.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: James J Dempsey <jjd@jjd.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Am 12.10.2017 um 16:58 schrieb James J Dempsey:
> I have a simple problem with a 2-disk raid-1 configuration that I can’t find the solution for on the internet so I hope someone can help.
> 
> One disk failed on my 2-disk raid-1 and I foolishly (physically) removed the disk before software removing it from the array.
> 
> The current state is that the array is running degraded with 1 disk.  My goal is to add a new disk and return it to a non-degraded 2-disk array

what do you mean by "I foolishly (physically) removed the disk before 
software removing it from the array"?

if a disk explodes it also disappears unannounced

"My theory of this is that the computer switched it?s idea of which disk 
was /dev/sda and which was /dev/sdb as a result of the original removal" 
does not matter at all since you need the botaloader anyways on both 
(grub-install) and on a RAID1 it must not matter at all which is sda and 
wich is sdb, both can die at any point in time and both need to be 
bootable at any point in time
