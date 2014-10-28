From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Very small bug on assemble --force
Date: Tue, 28 Oct 2014 15:27:02 +0100
Message-ID: <544FA7B6.7030100@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Very small bug report:
mdadm assemble --force fails to assemble at the very last step after 
having adjusted the event count:


root@storage1:/root# mdadm --assemble /dev/md106 --config 
/etc/mdadm/mdadm.secondary.conf --force
mdadm: forcing event count in 
/dev/mapper/mpathid-350014ee0ac5a112e-part1(3) from 1058 upto 1061
mdadm: forcing event count in 
/dev/mapper/mpathid-350014ee056feaaf4-part1(4) from 1058 upto 1061
mdadm: forcing event count in 
/dev/mapper/mpathid-350014ee001a93ede-part1(6) from 1058 upto 1061
mdadm: clearing FAULTY flag for device 1 in /dev/md106 for 
/dev/mapper/mpathid-350014ee0ac5a112e-part1
mdadm: clearing FAULTY flag for device 5 in /dev/md106 for 
/dev/mapper/mpathid-350014ee056feaaf4-part1
mdadm: clearing FAULTY flag for device 8 in /dev/md106 for 
/dev/mapper/mpathid-350014ee001a93ede-part1
mdadm: Marking array /dev/md106 as 'clean'
mdadm: /dev/md106 assembled from 8 drives - not enough to start the array.

mdadm is wrong here: 8 devices is indeed the total number of devices for 
this array.
the last command started it inactive like this:

md106 : inactive dm-101[0](S) dm-24[9](S) dm-107[6](S) dm-103[5](S) 
dm-123[4](S) dm-95[3](S) dm-105[2](S) dm-106[1](S)
       4193255424 blocks super 1.2
(maybe the blocks count is also wrong? Not adjusted for parity maybe? 
4193255424  / 8.0 * 6.0 == 3144941568.0 almost correct)

it can be fixed simply by doing:

root@storage1:/root# mdadm --stop /dev/md106
mdadm: stopped /dev/md106

root@storage1:/root# mdadm --assemble /dev/md106 --config 
/etc/mdadm/secondary.conf --no-degraded
mdadm: /dev/md106 has been started with 8 drives.

now it works:

md106 : active raid6 dm-101[0] dm-24[9] dm-107[6] dm-103[5] dm-123[4] 
dm-95[3] dm-105[2] dm-106[1]
       3144938496 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[8/8] [UUUUUUUU]
       bitmap: 0/1 pages [0KB], 1048576KB chunk

Regards
EW
