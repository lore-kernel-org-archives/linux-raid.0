From: "Micheal Blue" <mblue@gmx.us>
Subject: Seeking advice to convert RAID5 to RAID10 adding a drive in the
 process
Date: Sun, 13 Dec 2015 15:47:23 +0100
Message-ID: <trinity-e29048a1-862f-4ae7-a1a2-e4e826b37f95-1450018043035@3capp-mailcom-bs10>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 3 disk RAID5 currently that uses LUKS. I would like to add a new disk and covert the array to RAID10 but cannot find any walk-through of this process. I am grateful for any input from the list be it links or a personal summary.


Below is a graphic of how my current 3 drive array is setup:
 ---------------------------------------
[          ext4 file system             ]
 ---------------------------------------
[          LUKS cryptdevice             ]
 ---------------------------------------
[               /dev/dm0                ]
 ---------------------------------------
[ /dev/sdb1 ] [ /dev/sdc1 ] [ /dev/sdd1 ]
 ---------------------------------------
