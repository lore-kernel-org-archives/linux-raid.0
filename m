From: Bhatia Amit <amitbhatia@rocketmail.com>
Subject: Re: Cannot start array on disk
Date: Thu, 21 Jul 2016 02:00:29 +0000 (UTC)
Message-ID: <1334935791.2305089.1469066429563.JavaMail.yahoo@mail.yahoo.com>
References: <1124605843.526681.1468785592654.JavaMail.yahoo.ref@mail.yahoo.com> <1124605843.526681.1468785592654.JavaMail.yahoo@mail.yahoo.com> <73583e52-ca6b-b043-cbae-02c8a122be24@turmel.org> <1436537429.1672198.1468980612541.JavaMail.yahoo@mail.yahoo.com> <1537154003.1687848.1468983169996.JavaMail.yahoo@mail.yahoo.com> <6b958d9f-ec61-3b87-fcd7-ff63c0af32fe@turmel.org>
Reply-To: Bhatia Amit <amitbhatia@rocketmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6b958d9f-ec61-3b87-fcd7-ff63c0af32fe@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> I'm not sure if this is supported, by try specifying the version along
> with --examine for each of v0.90, v1.0, v1.1, and v1.2 to see if any
> difference shows.  Paste the results from each.


Hi Phil

Only metadata v1.0 seems to be valid for sdc4.

$ sudo mdadm --examine /dev/sdc4 --metadata=0.9
mdadm: No super block found on /dev/sdc4 (Expected magic a92b4efc, got 00000000)
$ 
$ sudo mdadm --examine /dev/sdc4 --metadata=1.0
/dev/sdc4:
Magic : a92b4efc
Version : 1.0
Feature Map : 0x0
Array UUID : 374e689e:3bfd050c:ab0b0dce:2d50f5fd
Name : MyBookLiveDuo:3
Creation Time : Mon Sep 16 14:53:47 2013
Raid Level : linear
Raid Devices : 2

Avail Dev Size : 5851500528 (2790.21 GiB 2995.97 GB)
Used Dev Size : 0
Super Offset : 5851500528 sectors
State : clean
Device UUID : 9096f74b:0a8f2b61:93347be3:6d3b6c1b

Update Time : Mon Sep 16 14:53:47 2013
Checksum : 77aa5963 - correct
Events : 0

Rounding : 0K

Device Role : Active device 0
Array State : AA ('A' == active, '.' == missing)
$ 
$ sudo mdadm --examine /dev/sdc4 --metadata=1.1
mdadm: No super block found on /dev/sdc4 (Expected magic a92b4efc, got 00000000)
$ 
$ sudo mdadm --examine /dev/sdc4 --metadata=1.2
mdadm: No super block found on /dev/sdc4 (Expected magic a92b4efc, got 00000000)
$ 

$ cat /proc/mdstat 
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md126 : active raid1 sdc3[2]
500724 blocks super 1.0 [2/1] [_U]

md127 : inactive sdc4[0](S)
2925750264 blocks super 1.0

unused devices: <none>
$ 
$ sudo  mdadm --examine --scan
ARRAY /dev/md/2 metadata=1.0 UUID=7c040c5e:9c30ac6d:e534a129:20457e22 name=MyBookLiveDuo:2
ARRAY /dev/md/3 metadata=1.0 UUID=374e689e:3bfd050c:ab0b0dce:2d50f5fd name=MyBookLiveDuo:3
$ 


Thanks,
Amit
