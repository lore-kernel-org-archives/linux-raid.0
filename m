From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: resync starts over after each reboot (2.6.18.1)?
Date: Mon, 23 Oct 2006 18:43:01 +0200
Message-ID: <453CF115.4020003@wpkg.org>
References: <45349861.4010208@wpkg.org>	<17716.41259.239292.413627@cse.unsw.edu.au>	<4534A236.4080907@wpkg.org> <17724.19056.601329.815951@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17724.19056.601329.815951@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday October 17, mangoo@wpkg.org wrote:
>> Neil Brown wrote:
>>> On Tuesday October 17, mangoo@wpkg.org wrote:
>>>> I just set up a new Debian unstable box.
>>>> It's running 2.6.18.1 kernel.
>>>>
>>>> I created RAID-1 on two disks, with no data or filesystem on it.
>>>> As I'm still experimenting with the box, I reboot it quite frequently.
>>>>
>>>> I noticed that RAID-1 resync starts from the very beginning after each 
>>>> reboot. Is it normal?
>>> No.
>>> Has the resync finished when you shut down?
>> No, it was still running.
>>
> 
> Ok, so obviously it should start after a reboot, but maybe not at the
> very beginning.
> 
>>> How do you shut down?
>> I simply type "reboot", so it should shutdown/reboot cleanly.
>>
> 
> "should".
> Do you have kernel logs of the shutdown process?  Do they mention md0
> at all?

Looks like they are stopped properly:

Deactivating swap...done.
Shutting down LVM Volume Groups...
   0 logical volume(s) in volume group "LVM2" now active
md: md0 stopped.
md: unbind<sda1>
md: export_rdev(sda1)
md: unbind<sdb1>
md: export_rdev(sdb1)
Stopping MD array md0...done (stopped).
Will now restart.
md: stopping all md devices.
Synchronizing SCSI cache for disk sdb:
Synchronizing SCSI cache for disk sda:


Now that it's synchronized for the very first time, it reboots correctly.

When I mark the array as faulty, remove it, and add it:

# mdadm /dev/md0 -f /dev/sda1
# mdadm /dev/md0 -r /dev/sda1
# mdadm /dev/md0 -a /dev/sda1

It begins to rebuild:

  cat /proc/mdstat
Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid1 sda1[0] sdb1[1]
       312568576 blocks [2/1] [_U]
       [>....................]  recovery =  1.2% (3911680/312568576) 
finish=103.7min speed=49558K/sec

unused devices: <none>
superthecus:~# reboot


When I reboot, it's not rebuilding anymore:

# cat /proc/mdstat
Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid1 sdb1[1]
       312568576 blocks [2/1] [_U]

unused devices: <none>
# cat /proc/mdstat
# mdadm --detail /dev/md0
/dev/md0:
         Version : 00.90.03
   Creation Time : Mon Oct 16 15:23:12 2006
      Raid Level : raid1
      Array Size : 312568576 (298.09 GiB 320.07 GB)
     Device Size : 312568576 (298.09 GiB 320.07 GB)
    Raid Devices : 2
   Total Devices : 1
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Mon Oct 23 18:31:45 2006
           State : clean, degraded
  Active Devices : 1
Working Devices : 1
  Failed Devices : 0
   Spare Devices : 0

            UUID : df1bff84:2c0da484:f2202985:660e4c4d
          Events : 0.6

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        1       8       17        1      active sync   /dev/sdb1
# mdadm /dev/md0 -a /dev/sda1
md: bind<sda1>
RAID1 conf printout:
  --- wd:1 rd:2
  disk 0, wo:1, o:1, dev:sda1
  disk 1, wo:0, o:1, dev:sdb1
mdadm: re-added md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
/dev/sda1
md: using maximum available idle IO bandwidth (but not more than 200000 
KB/sec) for reconstruction.
md: using 128k window, over a total of 312568576 blocks.
# cat /proc/mdstat
Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid1 sda1[0] sdb1[1]
       312568576 blocks [2/1] [_U]
       [>....................]  recovery =  0.0% (113728/312568576) 
finish=91.5min speed=56864K/sec

unused devices: <none>


# dmesg|grep dm
md: kicking non-fresh sda1 from array!

Why was it kicked? I added it to the array, but it didn't fully sync.

Curious. Is it normal?


>>> Can you post the kernel logs from boot up to when the resync has
>>> started?
>> # dmesg|grep md
>>
> ....
> 
> That looks OK except there is no
> 
>  md: resuming recovery of md0 from checkpoint
> 
> as I would expect....
> Are you creating the array with an internal bitmap?

Frankly, I don't know...
It was created by the Debian installer, and once it's synchronized, it
works fine.


>> (it has so many raid levels, as I'm still experimenting with it).
>>
> 
> Experimentation is good!! It helps you find my bugs :-)

:)


-- 
Tomasz Chmielewski
http://wpkg.org


