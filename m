From: AndyLiebman@aol.com
Subject: Hardware vs Software and Bad Block Relocation
Date: Fri, 21 May 2004 09:05:18 EDT
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <d4.d36c2f5.2ddf588e@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From the replies I got to my last question about Hardware versus Software 
RAID, one of the big advantages of true hardware RAID can be the better handling 
of bad blocks or read errors on RAID 1 and RAID 5 arrays. 

I have encountered this situation a few times with Linux software RAID 5  
where I will get a read error on a particular sector of a particular disk. Linux 
software RAID will immediately throw this disk out of the array. And now, if I 
get a read error on another disk before I replace the first disk  (unlikely 
but it did happen to me once -- about a day after getting the first error), the 
array can be totally lost. Or at least it's not so obvious how to recover the 
data. 

Yesterday, I spoke with two tech support people at 3ware who explained that 
their hardware RAID cards will remember where a read error is encountered and 
next time you try to write to that sector the data will get relocated to 
another sector instead. As long as there is still communication with the disk after 
a read error (within 20 seconds) the disk won't get kicked out of the array 
and the RAID won't go into degraded mode. An error report will get generated 
that you can view in the 3ware 3dm or 3dm2 GUI interface -- so you can see that 
you MIGHT have to start worrying about a particular disk. But the data will 
still be intact and the array will still offer redundancy. 

This seems like a HUGE advantage to data security -- especially in my 
application. I am dealing with Terrabytes of video and audio files, and it's simply 
not practical to back them up. 

So, my question is, is there a "software equivalent" to what the 3ware card  
does with bad sectors or bad blocks. Will EVMS do that? Will the latest LVM do 
that? I have read that EVMS does have a bad block relocation function, but 
does it work the same way as the 3ware card? Will it prevent an array from going 
into degraded mode after a read error? 
