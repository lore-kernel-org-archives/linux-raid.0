From: Neil Cavan <nrcavan@engmail.uwaterloo.ca>
Subject: RAID5 Recovery
Date: Sat, 21 Oct 2006 21:14:32 -0400
Message-ID: <BAYC1-PASMTP06741EF4074D618C18E59FE8030@CEZ.ICE>
Reply-To: nrcavan@engmail.uwaterloo.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Message-Id: <1161479672.14505.10.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I had a run-in with the Ubuntu Server installer, and in trying to get
the new system to recognize the clean 5-disk raid5 array left behind by
the previous Ubuntu system, I think I inadvertently instructed it to
create a new raid array using those same partitions.

What I know for sure is that now, I get this:

user@host:~$ sudo mdadm --examine /dev/hda1
mdadm: No super block found on /dev/hda1 (Expected magic a92b4efc, got
00000000)
user@host:~$ sudo mdadm --examine /dev/hdc1
mdadm: No super block found on /dev/hdc1 (Expected magic a92b4efc, got
00000000)
user@host:~$ sudo mdadm --examine /dev/hde1
mdadm: No super block found on /dev/hde1 (Expected magic a92b4efc, got
00000000)
user@host:~$ sudo mdadm --examine /dev/hdg1
mdadm: No super block found on /dev/hdg1 (Expected magic a92b4efc, got
00000000)
user@host:~$ sudo mdadm --examine /dev/hdi1
mdadm: No super block found on /dev/hdi1 (Expected magic a92b4efc, got
00000000)

I didn't format the partitions or write any data to the disk, so I think
the array's data should be intact. Is there a way to recreate the
superblocks, or am I hosed?

Thanks,
Neil

