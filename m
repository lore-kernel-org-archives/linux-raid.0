From: Alan Worstell <aworstell@a-1networks.com>
Subject: Assistance needed with a failed RAID-5 array
Date: Mon, 07 Apr 2014 11:41:34 -0700
Message-ID: <5342F15E.5040509@a-1networks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
This morning I discovered that a raid-5 array I had created last week is
listing all 3 drives in a failed state:

md1 : active raid5 sdm1[4](F) sdp1[3](F) sdl1[1](F) sdo1[0](F)
        3726024192 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/0]
[___]

This array has some pretty critical stuff on it I would like to get
back. Here is a link with /var/log/messages, dmesg, and the output
of|mdadm --examine on all of the members: |||
http://filebin.net/ryi7vq7reg
Any assistance would be greatly appreciated.

Thanks,

-- 
Alan Worstell
A1 Networks - Systems Administrator
VTSP, VCA-DCV, dCAA, LPIC-1, Linux+, CLA, DCTS
(707)570-2021 x204
For support issues please email support@a-1networks.com or call 707-703-1050

