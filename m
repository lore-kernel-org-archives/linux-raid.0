From: Asdo <asdo@shiftmail.org>
Subject: Some md/mdadm bugs
Date: Thu, 02 Feb 2012 20:08:53 +0100
Message-ID: <4F2ADF45.4040103@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello list

I removed sda from the system and I confirmed /dev/sda did not exist any 
more.
After some time an I/O was issued to the array and sda6 was failed by MD 
in /dev/md5:

md5 : active raid1 sdb6[2] sda6[0](F)
       10485688 blocks super 1.0 [2/1] [_U]
       bitmap: 1/160 pages [4KB], 32KB chunk

At this point I tried:

mdadm /dev/md5 --remove detached
--> no effect !
mdadm /dev/md5 --remove failed
--> no effect !
mdadm /dev/md5 --remove /dev/sda6
--> mdadm: cannot find /dev/sda6: No such file or directory  (!!!)
mdadm /dev/md5 --remove sda6
--> finally worked ! (I don't know how I had the idea to actually try 
this...)


Then here is another array:

md1 : active raid1 sda2[0] sdb2[2]
       10485688 blocks super 1.0 [2/2] [UU]
       bitmap: 0/1 pages [0KB], 65536KB chunk

This one did not even realize that sda was removed from the system long ago.
Apparently only when an I/O is issued, mdadm realizes the drive is not 
there anymore.
I am wondering (and this would be very serious) what happens if a new 
drives is inserted and it takes the /dev/sda identifier!? Would MD start 
writing or do any operation THERE!?

There is another problem...
I tried to make MD realize that the drive is detached:

mdadm /dev/md1 --fail detached
--> no effect !
however:
ls /dev/sda2
--> ls: cannot access /dev/sda2: No such file or directory
so "detached" also seems broken...



And here goes also a feature request:

if a device is detached from the system, (echo 1 > device/delete or 
removing via hardware hot-swap + AHCI) MD should detect this situation 
and mark the device (and all its partitions) as failed in all arrays, or 
even remove the device completely from the RAID.
In my case I have verified that MD did not realize the device was 
removed from the system, and only much later when an I/O was issued to 
the disk, it would mark the device as failed in the RAID.

After the above is implemented, it could be an idea to actually allow a 
new disk to take the place of a failed disk automatically if that would 
be a "re-add" (probably the same failed disk is being reinserted by the 
operator) and this even if the array is running, and especially if there 
is a bitmap.
Now it doesn't happen:
When I reinserted the disk, udev triggered the --incremental, to 
reinsert the device, but mdadm refused to do anything because the old 
slot was still occupied with a failed+detached device. I manually 
removed the device from the raid then I ran --incremental, but mdadm 
still refused to re-add the device to the RAID because the array was 
running. I think that if it is a re-add, and especially if the bitmap is 
active, I can't think of a situation in which the user would *not* want 
to do an incremental re-add even if the array is running.

Thank you
Asdo


