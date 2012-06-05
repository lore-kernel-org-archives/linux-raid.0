From: "Joachim Otahal (privat)" <Jou@gmx.net>
Subject: RAID5 with two drive sizes question
Date: Tue, 05 Jun 2012 19:27:53 +0200
Message-ID: <4FCE4199.7030705@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Debian 6.0.4 / superblock 1.2
sdc1 = 1.5 TB
sdd1 = 1.5 TB (cannot be used during --create, contains still data)
sde1 = 1 TB
sdf1 = 1 TB
sdg1 = 1 TB

Target: RADI5 with 4.5 TB capacity.

The normal case would be:
mdadm -C /dev/md3 --bitmap=internal -l 5 -n 5 /dev/sdc1 /dev/sdd1 
/dev/sde1 /dev/sdf1 /dev/sdg1
What I expect: since the first and the second drive are 1.5 TB size the 
third fouth and fifth drive are treated like 2*1.5 TB, creating a 4.5 TB 
RAID.
What would really be created: I know here are people that know and not 
guess : ).

What my case actually is:
mdadm -C /dev/md3 --bitmap=internal -l 5 -n 5 /dev/sdc1 missing 
/dev/sde1 /dev/sdf1 /dev/sdg1
Expected: Still create a 4.5 TB since sdc1 is 1.5 TB, though sdd1 is yet 
missing.
Will it work as expected?
Then format md3, and copy content of sdd1 (which is yet still /dev/md2) 
into the raid, then --add /dev/sdd1 to the raid and wait until the 
rebuild is done.

Jou
