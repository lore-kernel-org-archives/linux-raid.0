From: Phil Turmel <philip@turmel.org>
Subject: Re: Assistance Reviewing Proposed Recovery Measures
Date: Mon, 22 Aug 2016 08:09:32 -0400
Message-ID: <a10fd792-6484-d518-75d7-4def04a9a715@turmel.org>
References: <alpine.LRH.2.11.1608191717050.23388@bluenose.cs.dal.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1608191717050.23388@bluenose.cs.dal.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Maxwell <cmaxwell@dal.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Chris,

Very good report, btw.

On 08/19/2016 04:18 PM, Chris Maxwell wrote:

[trim /]

> The machine has a 3ware Hardware RAID controller which is showing sdb
> and sdc as disks.  (Unit 0 and Unit 1).
> Unit 0 (sdb) is made up of
> Phy 0: WD WCAW35791262
> Phy 1:  Seagate 9QJ7N744
> 
> Unit 1(sdc) is made up of
> Phy 2: Seagate 9QJ7F3PJ and
> Phy 3: Seagate 9QJ7R3Y1
> 
> These are then combined into mirror md0 made of sdb1 and sdc1
> This is the physical volume for LVM VG lvm-raid, which then has LV inside:
> lvmdata1 and gokcen

The models of the disks would be useful information, too.  Your dmesg
indicates unit 3 is very slow to report UREs, which means its probably a
desktop drive, not a raid drive.  I don't have much hardware raid
experience, but I do know that smartctl won't report properly on devices
connected to hardware raid without additional options on the command
line.  You need to do this to get a smartctl -x report on all of these
devices.

It is unclear from your description if the Phy0/1 pair are mirrored
themselves or striped.  Same with Phy2/3.  Do you have a net four copies
of your data or a net two copies of your data?

> ==========================================================================
> Figure 2: mdadm —examine of /dev/sdb1 and sdc1:
> 
> # mdadm --examine /dev/sd[bc]1 >> raid.status.latest
> 
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : fdd98007:78663948:0760cb1c:ce437c35
>   Creation Time : Mon Oct 18 10:54:29 2010
>      Raid Level : raid1
>   Used Dev Size : 976551040 (931.31 GiB 999.99 GB)
>      Array Size : 976551040 (931.31 GiB 999.99 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 0
> 
>     Update Time : Thu Aug  4 12:11:38 2016
>           State : clean
>  Active Devices : 1
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 1
>        Checksum : d3a40069 - correct
>          Events : 858
> 
> 
>       Number   Major   Minor   RaidDevice State
> this     2       8       17        2      spare   /dev/sdb1
> 
>    0     0       0        0        0      removed
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8       17        2      spare   /dev/sdb1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : fdd98007:78663948:0760cb1c:ce437c35
>   Creation Time : Mon Oct 18 10:54:29 2010
>      Raid Level : raid1
>   Used Dev Size : 976551040 (931.31 GiB 999.99 GB)
>      Array Size : 976551040 (931.31 GiB 999.99 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 0
> 
>     Update Time : Thu Aug  4 12:11:38 2016
>           State : clean
>  Active Devices : 1
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 1
>        Checksum : d3a4007d - correct
>          Events : 858
> 
> 
>       Number   Major   Minor   RaidDevice State
> this     1       8       33        1      active sync   /dev/sdc1
> 
>    0     0       0        0        0      removed
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8       17        2      spare   /dev/sdb1

I suspect that your array has scattered UREs on desktop drives.  The
hardware raid isn't kicking the drives out after 30 seconds like
software raid would (see reference threads below), but instead allows
the problem to persist.

If you have a 4-way mirror, plugging these drives directly into a mobo
w/ the driver timeout work-around might be the best way to safely
recover your data.  The 3ware card certainly isn't behaving the way I
would predict, which means my advice isn't valid with it in the mix.  If
a hardware raid expert pipes up with alternatives, that would be helpful.

Meanwhile, please supply the smartctl -x reports.  Just paste them in
your reply w/ line wrap disabled.

Phil

Readings for timeout mismatch issues:  (whole threads if possible)

http://marc.info/?l=linux-raid&m=139050322510249&w=2
http://marc.info/?l=linux-raid&m=135863964624202&w=2
http://marc.info/?l=linux-raid&m=135811522817345&w=1
http://marc.info/?l=linux-raid&m=133761065622164&w=2
http://marc.info/?l=linux-raid&m=132477199207506
http://marc.info/?l=linux-raid&m=133665797115876&w=2
http://marc.info/?l=linux-raid&m=142487508806844&w=3
http://marc.info/?l=linux-raid&m=144535576302583&w=2
