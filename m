From: Brendan Hide <brendan@swiftspirit.co.za>
Subject: making a hot spare ... hot
Date: Wed, 21 Sep 2011 05:30:17 +0200
Message-ID: <4E795A49.1060000@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

To the point: When a disk is designated as a hot spare, would it be of 
benefit to spread copies of data chunks from the other disks onto the 
hot spare even before a failure? Has this been tried before?

If its not already being done, it'd have a small positive consequence 
for performance as well as data integrity, with relatively little to no 
negative consequences. Benefits would diminish the larger the array, 
much like the performance difference between raid3 and raid5. Read 
speeds would theoretically increase and write speeds should not decrease 
except in the case of poor hardware.

Given a 6-disk raid5 (5 "data" disks + 1 spare) array, a re-sync will 
start at 25% progress from the moment a disk gets dropped out of the 
array. The theoretical max read speed will also increase by 16% by 
reading from 6 disks instead of 5. The cons will be that, when writing, 
an extra write will need to occur to the "spare" disk. Though this 
shouldn't have any performance penalties on modern hardware I can still 
see it as being a concern.

I suspect something like this might have been suggested before - but I 
haven't been able to find any reference to something along these lines 
online. I'll welcome any discussion or links to relevant information.

Thanks.

Key:
0-F: Data Chunks
P: Parity

Layout of standard RAID5 + 1 standard spare

Disk0: 048C
Disk1: 159P
Disk2: 26PD
Disk3: 3PAE
Disk4: P7BF
Disk5: Spare (empty)

Chunks read per read "cycle": 5
Time to read all 16 data chunks: 4 cycles

Layout of standard RAID5 + 1 "hot" spare:
Disk0: 048C
Disk1: 159P
Disk2: 26PD
Disk3: 3PAE
Disk4: P7BF
Disk5: 05AF

Chunks read per "cycle": 6
Time to read all 16 data chunks: 3 cycles

-- 
__________
Brendan Hide
Mobile: brendan.cell@swiftspirit.co.za (plain text only please)
Web Africa - Internet Business Solutions
http://www.webafrica.co.za/?AFF1E97

