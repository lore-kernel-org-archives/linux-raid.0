From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: /sys/block/md126 still exists even after stopping the array
Date: Fri, 26 Sep 2014 12:23:27 +0200
Message-ID: <54253E9F.4070505@gmail.com>
References: <53A99B76.3020603@gmail.com>	<20140625110348.48ab2d7a@notabene.brown>	<54243ED7.6090904@gmail.com> <20140926103348.5f5ea568@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140926103348.5f5ea568@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, sebastian.riemer@profitbricks.com
List-Id: linux-raid.ids

Hello Neil,

On 09/26/2014 02:33 AM, NeilBrown wrote:
> On Thu, 25 Sep 2014 18:12:07 +0200 Francis Moreau <francis.moro@gmail.com>
> wrote:
[...]
>> I tried to find out what could have opened the md device by using fuser,
>> but fuser reports no users.
> 
> It is probably a transient open/close.
> 

If it's open/close wouldn't the 'close' part make the device disapear ?

>>
>> I took a look to the udev rules which are the one shipped by mdadm 3.3.2
>> but nothing keep the device opened during the remove event.
>>
>> Could you give me some hints here to debug this ?
> 
> Modify md_open in drivers/md/md.c to add
>    printk("Opened by %s\n", current->comm);
> 
> and build a new kernel.  That will tell you the name of the process which
> opened the device.
> 

I did that I also added a trace in md_release() but strangely no trace
were outputed from there.

Here's the details of what I did:

--- %< ---
[root@localhost ~]# cat /proc/mdstat
Personalities : [raid1]
md125 : active raid1 vdc1[1] vdb1[0]
      65472 blocks super 1.0 [2/2] [UU]

md126 : active raid1 vdc2[1] vdb2[0]
      209536 blocks super 1.2 [2/2] [UU]

md127 : active raid1 vdb3[0] vdc3[1]
      1819584 blocks super 1.2 [2/2] [UU]

unused devices: <none>

[root@localhost ~]# mdadm --stop --scan

[root@localhost ~]# dmesg | grep md_
[    1.474207] md_open(): opened by mdadm
[    1.475316] md_open(): opened by mdadm
[    1.492880] md_open(): opened by mdadm
[    1.493201] md_open(): opened by mdadm
[    1.494690] md_open(): opened by mdadm
[    1.499369] md_open(): opened by mdadm
[    1.533566] md_open(): opened by mdadm
[    1.533697] md_open(): opened by mdadm
[    1.554419] md_open(): opened by mdadm
[    1.574451] md_open(): opened by mdadm
[    1.574666] md_open(): opened by mdadm
[    1.574877] md_open(): opened by mdadm
[    1.576822] md_open(): opened by systemd-udevd
[    1.576895] md_open(): opened by systemd-udevd
[    1.577029] md_open(): opened by systemd-udevd
[    1.581850] md_open(): opened by mdadm
[    1.584054] md_open(): opened by systemd-udevd
[    1.584770] md_open(): opened by mdadm
[    1.585175] md_open(): opened by mdadm
[    1.586328] md_open(): opened by systemd-udevd
[    1.586933] md_open(): opened by systemd-udevd
[    1.651265] md_open(): opened by mdadm
[    1.651320] md_open(): opened by mdadm
[    1.651364] md_open(): opened by mdadm
[    1.651437] md_open(): opened by mdadm
[    1.652376] md_open(): opened by mdadm
[    1.652452] md_open(): opened by mdadm
[   33.486704] md_open(): opened by mdadm
[   33.489259] md_open(): opened by mdadm
[   33.491000] md_open(): opened by mdadm
[   33.491767] md_open(): opened by systemd-udevd
[   33.692255] md_open(): opened by mdadm
[   33.692288] md_open(): opened by mdadm
[   33.692606] md_open(): opened by mdadm
[   33.692858] md_open(): opened by mdadm
[   33.692942] md_open(): opened by mdadm
[   33.693237] md_open(): opened by mdadm
[   33.694254] md_open(): opened by mdadm
[   33.694275] md_open(): opened by mdadm
[   33.694373] md_open(): opened by mdadm
[   33.695558] md_open(): opened by mdadm
[   33.695679] md_open(): opened by mdadm
[   33.695855] md_open(): opened by mdadm
[   33.695894] md_open(): opened by mdadm

[root@localhost ~]# ls /dev/md125
/dev/md125

[root@localhost ~]# fuser /dev/md125

[root@localhost ~]# ps aux | grep "mdadm\|systemd-udevd"
root       366  0.0  0.1  38172  1696 ?        Ss   06:04   0:00
/usr/lib/systemd/systemd-udevd
root       465  0.0  0.0   4964   924 ?        Ss   06:04   0:00
/sbin/mdadm --monitor --scan --daemonise --syslog
--pid-file=/run/mdadm/mdadm.pid

[root@localhost ~]# ls -l /proc/366/fd/
total 0
lrwx------ 1 root root 64 Sep 26 06:04 0 -> /dev/null
lrwx------ 1 root root 64 Sep 26 06:04 1 -> /dev/null
lrwx------ 1 root root 64 Sep 26 06:04 10 -> socket:[8665]
lr-x------ 1 root root 64 Sep 26 06:04 11 -> /etc/udev/hwdb.bin
lrwx------ 1 root root 64 Sep 26 06:04 12 -> anon_inode:[eventpoll]
lrwx------ 1 root root 64 Sep 26 06:04 2 -> /dev/null
lrwx------ 1 root root 64 Sep 26 06:04 3 -> socket:[8144]
lrwx------ 1 root root 64 Sep 26 06:04 4 -> socket:[8103]
lrwx------ 1 root root 64 Sep 26 06:04 5 -> socket:[8660]
lrwx------ 1 root root 64 Sep 26 06:04 6 -> /run/udev/queue.bin
lr-x------ 1 root root 64 Sep 26 06:04 7 -> anon_inode:inotify
lrwx------ 1 root root 64 Sep 26 06:04 8 -> anon_inode:[signalfd]
lrwx------ 1 root root 64 Sep 26 06:04 9 -> socket:[8664]

[root@localhost ~]# ls -l /proc/465/fd/
total 0
lrwx------ 1 root root 64 Sep 26 06:04 0 -> /dev/null
lrwx------ 1 root root 64 Sep 26 06:04 1 -> /dev/null
lrwx------ 1 root root 64 Sep 26 06:04 2 -> /dev/null
lr-x------ 1 root root 64 Sep 26 06:06 4 -> /proc/mdstat
lrwx------ 1 root root 64 Sep 26 06:06 5 -> socket:[10038]

[root@localhost ~]# cat /proc/mdstat
Personalities : [raid1]
unused devices: <none>

[root@localhost ~]# ls /sys/block/md125/md/
array_size  array_state  bitmap/  chunk_size  component_size  layout
level  max_read_errors  metadata_version  new_dev  raid_disks
reshape_direction  reshape_position  resync_start  safe_mode_delay

--- >% ---

So in my understanding, only mdadm and udevd are opening the MD devices
and mdamd was the last to open the device. For some unknown reasons,
md_release() is never called.

This happens with:

 - kernel 3.14.19
 - mdadm 3.3.2
 - systemd 208

Can you see something wrong here ?

Thanks.
