From: Jonathan Tripathy <jonnyt@abpni.co.uk>
Subject: Which Disks can fail?
Date: Tue, 21 Jun 2011 11:24:20 +0100
Message-ID: <4E007154.9030107@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Everyone,

Use md's "single process" RAID10 with the standard near layout (which is 
apperently the same as RAID1+0 in industry), which 2 drives could fail 
without loosing the array?

This is what I have:

Number   Major   Minor   RaidDevice State
        0       8        5        0      active sync   /dev/sda5
        1       8       21        1      active sync   /dev/sdb5
        2       8       37        2      active sync   /dev/sdc5
        3       8       53        3      active sync   /dev/sdd5

Thanks
