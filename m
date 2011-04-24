From: John Valarti <mdadmuser@gmail.com>
Subject: =?UTF-8?Q?Re=3A_Server_down=2Dfail=E2=80=8Bed_RAID5=2Dasking_for_some_assi?=
	=?UTF-8?Q?stance?=
Date: Sat, 23 Apr 2011 19:49:59 -0600
Message-ID: <BANLkTikvevtAipmEtNEGdzG4rfVeOpbLxQ@mail.gmail.com>
References: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>
	<ioq2b8$3rl$1@dough.gmane.org>
	<BANLkTim18Sx6JdZO5PiAqnrakDPzy5PNJQ@mail.gmail.com>
	<BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>
	<20110422125734.1a68a736@notabene.brown>
	<BANLkTin0SoBzRAear8Jt+26MnVJWouXoNA@mail.gmail.com>
	<20110423074411.78fef94f@notabene.brown>
	<BANLkTik_ZY4uoV3E=ua1p+tUD9g8xqQDVg@mail.gmail.com>
	<20110423184824.55ee7893@notabene.brown>
	<BANLkTi=sCfFFfmZTzj2g8-aDNhDqVK8e-A@mail.gmail.com>
	<20110424075101.6763309f@notabene.brown>
	<BANLkTimDqEWZ6843RvekRGu4Z0XvNLgOwA@mail.gmail.com>
	<4DB370E1.5030602@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DB370E1.5030602@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 23, 2011 at 6:37 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
..
>> mdadm: looking for devices for /dev/md1
>> mdadm: no devices found for /dev/md1
>
> If I can butt in here... presumably while the system can't assemble your
> array, you're running from rescue media or whatever? You may not have a
> suitable mdadm.conf in the rescue environment.

Please feel free to "butt in" , I can use any suggestions.
This is looking gloomy now.

There definitely is NO mdadm.conf
I checked.
I used "find"

This is rescue media. I can not boot off the system using local disk.
I am booting with CentOS 5.5 install media with "linux rescue"

> If you haven't already posted `mdadm --examine --scan --verbose --verbose`
> aka `mdadm -Esvv`, or at the very least `mdadm --examine --verbose
> /dev/sd[abc][12]`, then please do.

Originally there were 4 disks here. sd[abcd]
sdb was the first and worst faulty one, so I removed it.
We now see sd[abc]

HERE:
mdadm --examine --scan --verbose --verbose /dev/sd[abc]2:


   Update Time : Mon Apr 18 07:48:54 2011
         State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
 Spare Devices : 0
      Checksum : 5674ce4e - correct
        Events : 28580020

        Layout : left-symmetric
    Chunk Size : 256K

     Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

  0     0       8        2        0      active sync   /dev/sda2
  1     1       8       18        1      active sync   /dev/sdb2
  2     2       8       34        2      active sync   /dev/sdc2
  3     3       0        0        3      faulty removed

AND:
mdadm -Esvv /dev/sd[abc]2:
  mdadm: --examine/-E cannot be given with -w


> Please also try `mdadm --assemble --scan --verbose` and post the result.
HERE:
mdadm: /dev/sda2 not identified in config file.
mdadm: /dev/sdb2 not identified in config file.
mdadm: /dev/sdc2 not identified in config file.


> Another thing that occurs to me is that since you said you had CentOS 4, you
> likely have kernel 2.6.9 and mdadm 1.12 which are very old. You might try
> SystemRescueCD or similar to get a mdadm 3.1.x which will be much better at
> finding and fixing any problems.

The rescue media I am using for this is CentOS 5.5:
   uname -a:
Linux localhost.localdomain 2.6.18-238.el5 #1 SMP Thu Jan 13 15:51:15
EST 2011 x86_64 x86_64 x86_64 GNU/Linux

Hope this helps.

--
John
