From: "Erik Boettcher" <tehfoo@gmail.com>
Subject: Re: Raid 5 Recovery
Date: Tue, 30 Dec 2008 00:23:26 -0500
Message-ID: <125ed8800812292123nf0b26a8lbba930e2607f46a9@mail.gmail.com>
References: <125ed8800812272221y44e77849l886a80f32cbcfbec@mail.gmail.com>
	 <3513de790812280753k5c46799cj92a0e9566227fadc@mail.gmail.com>
	 <125ed8800812281002t6eecb5cbu2173efab36418c92@mail.gmail.com>
	 <125ed8800812281004o4d179064r735e46315481775a@mail.gmail.com>
	 <125ed8800812281013t59a3dc8cte44091d262cb8905@mail.gmail.com>
	 <0751481ab32bd9084154902b6ca31e9f.squirrel@neil.brown.name>
	 <125ed8800812281359r3050d001g5936a65e2fa27d21@mail.gmail.com>
	 <125ed8800812281553gc75cadfv91ea1cda46de96f9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <125ed8800812281553gc75cadfv91ea1cda46de96f9@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there a way to recover that metadata and edit only the parts that
need to be fixed?

On Sun, Dec 28, 2008 at 6:53 PM, Erik Boettcher <tehfoo@gmail.com> wrote:
> oops, forgot to send it here...
>
>
> ---------- Forwarded message ----------
> From: Erik Boettcher <tehfoo@gmail.com>
> Date: Sun, Dec 28, 2008 at 4:59 PM
> Subject: Re: Raid 5 Recovery
> To: NeilBrown <neilb@suse.de>
>
>
>>
>> Yes, specifics are good.  I'm afraid I need a few more though.
>>  mdadm -Esvvv
>
> livecd ~ # mdadm -Esvvv
> /dev/sde3:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : b2cca5f0:59a04cfc:a3bbe707:108124a2
>  Creation Time : Thu Jan 18 02:29:09 2007
>    Raid Level : raid5
>  Used Dev Size : 195093248 (186.06 GiB 199.78 GB)
>    Array Size : 780372992 (744.22 GiB 799.10 GB)
>  Raid Devices : 5
>  Total Devices : 5
> Preferred Minor : 0
>
>   Update Time : Tue Dec  9 02:11:56 2008
>         State : clean
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>  Spare Devices : 0
>      Checksum : 46384ff - correct
>        Events : 0.4508
>
>        Layout : left-asymmetric
>    Chunk Size : 32K
>
>     Number   Major   Minor   RaidDevice State
> this     2       8       67        2      active sync   /dev/sde3
>
>  0     0       8       35        0      active sync   /dev/sdc3
>  1     1       8       51        1      active sync   /dev/sdd3
>  2     2       8       67        2      active sync   /dev/sde3
>  3     3       8       19        3      active sync   /dev/sdb3
>  4     4       8        3        4      active sync   /dev/sda3
> mdadm: No md superblock detected on /dev/sde2.
> mdadm: No md superblock detected on /dev/sde1.
> mdadm: No md superblock detected on /dev/sde.
> /dev/sdd3:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : b2cca5f0:59a04cfc:a3bbe707:108124a2
>  Creation Time : Thu Jan 18 02:29:09 2007
>    Raid Level : raid5
>  Used Dev Size : 195093248 (186.06 GiB 199.78 GB)
>    Array Size : 780372992 (744.22 GiB 799.10 GB)
>  Raid Devices : 5
>  Total Devices : 5
> Preferred Minor : 0
>
>   Update Time : Tue Dec  9 02:11:56 2008
>         State : clean
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>  Spare Devices : 0
>      Checksum : 46384ed - correct
>        Events : 0.4508
>
>        Layout : left-asymmetric
>    Chunk Size : 32K
>
>     Number   Major   Minor   RaidDevice State
> this     1       8       51        1      active sync   /dev/sdd3
>
>  0     0       8       35        0      active sync   /dev/sdc3
>  1     1       8       51        1      active sync   /dev/sdd3
>  2     2       8       67        2      active sync   /dev/sde3
>  3     3       8       19        3      active sync   /dev/sdb3
>  4     4       8        3        4      active sync   /dev/sda3
> mdadm: No md superblock detected on /dev/sdd2.
> mdadm: No md superblock detected on /dev/sdd1.
> mdadm: No md superblock detected on /dev/sdd.
> /dev/sdc3:
>         Magic : a92b4efc
>       Version : 00.88.00
>          UUID : b2cca5f0
>  Creation Time : Thu Jan 18 02:29:09 2007
>    Raid Level : raid5
>  Used Dev Size : 195093248 (186.06 GiB 199.78 GB)
>    Array Size : 780372992 (744.22 GiB 799.10 GB)
>  Raid Devices : 5
>  Total Devices : 5
> Preferred Minor : 0
>
>   Update Time : Tue Dec  9 02:11:56 2008
>         State : clean
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>  Spare Devices : 0
>      Checksum : 46384b9 - correct
>        Events : 0.4508
>
>        Layout : left-asymmetric
>    Chunk Size : 32K
>
>     Number   Major   Minor   RaidDevice State
> this     0       8       33        0      sync   /dev/sdc1
>
>  0     0       8       33        0      active sync   /dev/sdc1
>  1     1       8       49        1      active sync   /dev/sdd1
>  2     0       8       65        0      sync   /dev/sde1
>  3     1       8       17        1      sync   /dev/sdb1
>  4     4       8        1        4      active sync   /dev/sda1
> mdadm: No md superblock detected on /dev/sdc2.
> mdadm: No md superblock detected on /dev/sdc1.
> mdadm: No md superblock detected on /dev/sdc.
> /dev/sdb3:
>         Magic : a92b4efc
>       Version : 00.88.00
>          UUID : b2cca5f0
>  Creation Time : Thu Jan 18 02:29:09 2007
>    Raid Level : raid5
>  Used Dev Size : 195093248 (186.06 GiB 199.78 GB)
>    Array Size : 780372992 (744.22 GiB 799.10 GB)
>  Raid Devices : 5
>  Total Devices : 5
> Preferred Minor : 0
>
>   Update Time : Tue Dec  9 02:11:56 2008
>         State : clean
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>  Spare Devices : 0
>      Checksum : 46384d1 - expected 46384a5
>        Events : 0.4508
>
>        Layout : left-asymmetric
>    Chunk Size : 32K
>
>     Number   Major   Minor   RaidDevice State
> this     1       8       17        1      sync   /dev/sdb1
>
>  0     0       8       33        0      sync   /dev/sdc1
>  1     1       8       49        1      sync   /dev/sdd1
>  2     0       8       65        0      sync   /dev/sde1
>  3     1       8       17        1      sync   /dev/sdb1
>  4     4       8        1        4      sync   /dev/sda1
> mdadm: No md superblock detected on /dev/sdb2.
> mdadm: No md superblock detected on /dev/sdb1.
> mdadm: No md superblock detected on /dev/sdb.
> /dev/sda3:
>         Magic : a92b4efc
>       Version : 00.88.00
>          UUID : b2cca5f0
>  Creation Time : Thu Jan 18 02:29:09 2007
>    Raid Level : raid5
>  Used Dev Size : 195093248 (186.06 GiB 199.78 GB)
>    Array Size : 780372992 (744.22 GiB 799.10 GB)
>  Raid Devices : 5
>  Total Devices : 5
> Preferred Minor : 0
>
>   Update Time : Tue Dec  9 02:11:56 2008
>         State : clean
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>  Spare Devices : 0
>      Checksum : 46384c1 - expected 463849b
>        Events : 0.4508
>
>        Layout : left-asymmetric
>    Chunk Size : 32K
>
>     Number   Major   Minor   RaidDevice State
> this     4       8        1        4      sync   /dev/sda1
>
>  0     0       8       33        0      sync   /dev/sdc1
>  1     1       8       49        1      sync   /dev/sdd1
>  2     0       8       65        0      sync   /dev/sde1
>  3     1       8       17        1      sync   /dev/sdb1
>  4     4       8        1        4      sync   /dev/sda1
> mdadm: No md superblock detected on /dev/sda2.
> mdadm: No md superblock detected on /dev/sda1.
> mdadm: No md superblock detected on /dev/sda.
> mdadm: No md superblock detected on /dev/loop0.
>
>> and
>>  dmesg | tail -20
> dmesg only reports what's shown in the first message and this after
> each assemble attempt:
> md: md0 stopped.
>
