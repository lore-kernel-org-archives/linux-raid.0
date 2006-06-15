From: "Wilson Wilson" <wilson150@gmail.com>
Subject: Raid5 software problems after loosing 4 disks for 48 hours
Date: Fri, 16 Jun 2006 00:59:31 +0100
Message-ID: <7c9ce5050606151659y219947e1g9f9034982d81221b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I run a 15 disk raid5 array. Unknowingly a contoller card failed which
had 4 disks on it. And unfortunatly the Raid5 stayed online, doing its
best.

Now after replacing the controller the raid can not be brought on
line. I would rather have corruption of anything changed on the array
in the last 2 days then loose 4 disks.

Quote:
# mdadm --examine /dev/sdc1
/dev/sdc1:
Magic : a92b4efc
Version : 00.90.01
UUID : eed326c4:6cf58a43:d1b57676:5b765f6c
Creation Time : Sun Nov 13 16:07:21 2005
Raid Level : raid5
Raid Devices : 15
Total Devices : 15
Preferred Minor : 0

Update Time : Mon Jun 12 11:08:09 2006
State : clean
Active Devices : 11
Working Devices : 11
Failed Devices : 8
Spare Devices : 0
Checksum : c967848b - correct
Events : 0.5456277

Layout : left-symmetric
Chunk Size : 32K

Number Major Minor RaidDevice State
this 1 8 33 1 active sync /dev/sdc1

0 0 8 17 0 active sync /dev/sdb1
1 1 8 33 1 active sync /dev/sdc1
2 2 8 49 2 active sync /dev/sdd1
3 3 0 0 3 faulty removed
4 4 0 0 4 faulty removed
5 5 0 0 5 faulty removed
6 6 0 0 6 faulty removed
7 7 8 129 7 active sync /dev/sdi1
8 8 8 145 8 active sync /dev/sdj1
9 9 8 161 9 active sync /dev/sdk1
10 10 8 177 10 active sync /dev/sdl1
11 11 8 193 11 active sync /dev/sdm1
12 12 8 209 12 active sync /dev/sdn1
13 13 8 225 13 active sync /dev/sdo1
14 14 8 241 14 active sync /dev/sdp1

And is there a way if more then 1 disks goes offline, for the whole
array to be taken offline? My understanding of raid5 is loose 1+ disks
and nothing on the raid would be readable. this is not the case here.

All the disks are online now, what do I need to do to rebuild the array?
