From: "Michael Paul" <radius.mp@verizon.net>
Subject: What does this mean?
Date: Tue, 4 Mar 2003 20:55:29 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <05ac01c2e2d3$72280f40$1400020a@mike>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



    Hi there...

 I get the following message when cat'ing /proc/mdstat:

md0 : active linear [dev 08:30] [8]  [dev 08:20] [7]  hdj[6]  hdi[5]  hdh[4]
hdg[3]  hde[2]  hdc[1]  hdb[0]
182485184 blocks 4k rounding

 In my raidtab file, sdc = 7 and sdd = 8. Is there some type of error here?
The linear seems to be working properly, but since I'm such a newbie, I
can't tell for sure. I wish there was a better way to check on the raid
status.

Thanks,
Michael


