From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: Re: /proc/mdstat status documentation and md: export_rdev
Date: Thu, 28 Nov 2013 19:11:25 +0200
Message-ID: <CB92E3E9-672C-456F-9767-719159BC0CE5@gmail.com>
References: <E90CEDA2-1AF7-4FCF-91F6-346D644CF674@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E90CEDA2-1AF7-4FCF-91F6-346D644CF674@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hey guys,

bumping my question in an attempt to get some attention and love :D

I would appreciate it if someone pointed out if there is a documentation that can be used to interpret all the codes that appear in /proc/mdstat output. For example, I know that (F) means that an array member's status is Failed, but what about (S)? Are there any other status codes like that? What are their meanings?

Also, what about the kernel messages like export_rdev? What do they mean? What is export of rdev? What kind of device is considered to be an rdev? etc. Please, see my first message in this thread for more details to understand what I'm referring to.

Ivan



On Nov 15, 2013, at 11:28 AM, Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com> wrote:

> Hi everyone,
> 
> as some of you already know I run a non-typical configuration that involves external USB drives assembled as raid1 array. I'm still smoothing out the edges of my setup because of all the challenges associated with not so perfect pm-utils/combination of software and hardware I have.
> 
> Anyway, I've been successfully resuming from sleep for a while now but this morning something new happened, namely this:
> 
> % cat /proc/mdstat 
> Personalities : [raid1] 
> md0 : inactive sdc1[1](S)
>      1953276928 blocks super 1.2
> 
> unused devices: <none>
> 
> which made me realize I have no clue what this message mean and what inactive, [1] and (S) mean in "md0 : inactive sdc1[1](S)".
> 
> So, I was wondering if somebody could possibly explain how to read this particular instance of mdstat output, and if there is chance there is a documentation somewhere out there that will let me do this myself?
> 
> If you're curious (like myself lol) this is what I observed had happened in dmesg/kernel log prior to cat /proc/mdstat
> 
> Nov 15 08:25:52 localhost kernel: [29863.901108] mdadm: sending ioctl 800c0910 to a partition!
> Nov 15 08:25:52 localhost kernel: [29863.901115] mdadm: sending ioctl 800c0910 to a partition!
> Nov 15 08:25:52 localhost kernel: [29863.901328] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:25:52 localhost kernel: [29863.901335] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:25:52 localhost kernel: [29863.904392] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:25:52 localhost kernel: [29863.904400] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:25:52 localhost kernel: [29863.905078] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:25:52 localhost kernel: [29863.905086] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:25:52 localhost kernel: [29863.905690] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:25:52 localhost kernel: [29863.905697] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:25:52 localhost kernel: [29863.918128] md: bind<sdc1>
> Nov 15 08:25:58 localhost kernel: [29869.976304] scsi_verify_blk_ioctl: 30 callbacks suppressed
> Nov 15 08:25:58 localhost kernel: [29869.976309] mdadm: sending ioctl 800c0910 to a partition!
> Nov 15 08:25:58 localhost kernel: [29869.976314] mdadm: sending ioctl 800c0910 to a partition!
> Nov 15 08:25:58 localhost kernel: [29869.976323] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:25:58 localhost kernel: [29869.976325] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:25:59 localhost kernel: [29870.115516] mdadm: sending ioctl 800c0910 to a partition!
> Nov 15 08:25:59 localhost kernel: [29870.115528] mdadm: sending ioctl 800c0910 to a partition!
> Nov 15 08:25:59 localhost kernel: [29870.115543] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:25:59 localhost kernel: [29870.115549] mdadm: sending ioctl 1261 to a partition!
> 
> So at this point the system resumed from sleep, and I ran cat /proc/mdstat. Realized that something went wrong and I did not know what to do, so I disconnected the drives, plugged them back in:
> 
> Nov 15 08:28:34 localhost kernel: [30025.749558] usb 1-1: USB disconnect, device number 7
> Nov 15 08:28:37 localhost kernel: [30028.112008] usb 1-2: USB disconnect, device number 5
> Nov 15 08:28:57 localhost kernel: [30048.990409] usb 1-2: new high-speed USB device number 8 using ehci_hcd
> Nov 15 08:28:58 localhost kernel: [30049.117229] scsi11 : usb-storage 1-2:1.0
> Nov 15 08:28:59 localhost kernel: [30050.121248] scsi 11:0:0:0: Direct-Access     WD       Elements 1048    1022 PQ: 0 ANSI: 6
> Nov 15 08:29:00 localhost kernel: [30050.126571] sd 11:0:0:0: [sdb] Spinning up disk....
> Nov 15 08:29:00 localhost kernel: [30051.187081] usb 1-1: new high-speed USB device number 9 using ehci_hcd
> Nov 15 08:29:00 localhost kernel: [30051.312832] scsi12 : usb-storage 1-1:1.0
> Nov 15 08:29:01 localhost kernel: [30052.133739] .
> Nov 15 08:29:01 localhost kernel: [30052.314419] scsi 12:0:0:0: Direct-Access     WD       Elements 1048    1022 PQ: 0 ANSI: 6
> Nov 15 08:29:04 localhost kernel: [30052.320765] sd 12:0:0:0: [sde] Spinning up disk........ready
> Nov 15 08:29:04 localhost kernel: [30055.144571] sd 11:0:0:0: [sdb] 3907024896 512-byte logical blocks: (2.00 TB/1.81 TiB)
> Nov 15 08:29:04 localhost kernel: [30055.144581] sd 11:0:0:0: [sdb] 4096-byte physical blocks
> Nov 15 08:29:04 localhost kernel: [30055.145433] sd 11:0:0:0: [sdb] Write Protect is off
> Nov 15 08:29:04 localhost kernel: [30055.145442] sd 11:0:0:0: [sdb] Mode Sense: 47 00 10 08
> Nov 15 08:29:04 localhost kernel: [30055.146305] sd 11:0:0:0: [sdb] No Caching mode page present
> Nov 15 08:29:04 localhost kernel: [30055.146314] sd 11:0:0:0: [sdb] Assuming drive cache: write through
> Nov 15 08:29:04 localhost kernel: [30055.149807] sd 11:0:0:0: [sdb] No Caching mode page present
> Nov 15 08:29:04 localhost kernel: [30055.149816] sd 11:0:0:0: [sdb] Assuming drive cache: write through
> Nov 15 08:29:04 localhost kernel: [30055.163711]  sdb: sdb1
> Nov 15 08:29:04 localhost kernel: [30055.169937] sd 11:0:0:0: [sdb] No Caching mode page present
> Nov 15 08:29:04 localhost kernel: [30055.169948] sd 11:0:0:0: [sdb] Assuming drive cache: write through
> Nov 15 08:29:04 localhost kernel: [30055.169957] sd 11:0:0:0: [sdb] Attached SCSI disk
> Nov 15 08:29:04 localhost kernel: [30055.330370] .
> Nov 15 08:29:04 localhost kernel: [30055.345968] mdadm: sending ioctl 800c0910 to a partition!
> Nov 15 08:29:04 localhost kernel: [30055.345978] mdadm: sending ioctl 800c0910 to a partition!
> Nov 15 08:29:04 localhost kernel: [30055.346186] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:29:04 localhost kernel: [30055.347627] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:29:04 localhost kernel: [30055.348234] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:29:04 localhost kernel: [30055.348242] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:29:04 localhost kernel: [30055.348838] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:29:04 localhost kernel: [30055.348845] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:29:04 localhost kernel: [30055.360590] md: bind<sdb1>
> Nov 15 08:29:06 localhost kernel: [30056.333730] ..ready
> Nov 15 08:29:06 localhost kernel: [30057.337894] sd 12:0:0:0: [sde] 3907024896 512-byte logical blocks: (2.00 TB/1.81 TiB)
> Nov 15 08:29:06 localhost kernel: [30057.337904] sd 12:0:0:0: [sde] 4096-byte physical blocks
> Nov 15 08:29:06 localhost kernel: [30057.338753] sd 12:0:0:0: [sde] Write Protect is off
> Nov 15 08:29:06 localhost kernel: [30057.338762] sd 12:0:0:0: [sde] Mode Sense: 47 00 10 08
> Nov 15 08:29:06 localhost kernel: [30057.339502] sd 12:0:0:0: [sde] No Caching mode page present
> Nov 15 08:29:06 localhost kernel: [30057.339511] sd 12:0:0:0: [sde] Assuming drive cache: write through
> Nov 15 08:29:06 localhost kernel: [30057.342516] sd 12:0:0:0: [sde] No Caching mode page present
> Nov 15 08:29:06 localhost kernel: [30057.342525] sd 12:0:0:0: [sde] Assuming drive cache: write through
> Nov 15 08:29:06 localhost kernel: [30057.354130]  sde: sde1
> Nov 15 08:29:06 localhost kernel: [30057.359369] sd 12:0:0:0: [sde] No Caching mode page present
> Nov 15 08:29:06 localhost kernel: [30057.359381] sd 12:0:0:0: [sde] Assuming drive cache: write through
> Nov 15 08:29:06 localhost kernel: [30057.359369] sd 12:0:0:0: [sde] No Caching mode page present
> Nov 15 08:29:06 localhost kernel: [30057.359381] sd 12:0:0:0: [sde] Assuming drive cache: write through
> Nov 15 08:29:06 localhost kernel: [30057.359390] sd 12:0:0:0: [sde] Attached SCSI disk
> Nov 15 08:29:06 localhost kernel: [30057.565248] md: export_rdev(sde1)
> Nov 15 08:29:06 localhost kernel: [30057.566615] md: export_rdev(sde1)
> Nov 15 08:30:57 localhost kernel: [30168.336551] md: md0 stopped.
> Nov 15 08:30:57 localhost kernel: [30168.336562] md: unbind<sdb1>
> Nov 15 08:30:57 localhost kernel: [30168.336669] md: export_rdev(sdb1)
> Nov 15 08:30:57 localhost kernel: [30168.336689] md: unbind<sdc1>
> Nov 15 08:30:57 localhost kernel: [30168.340361] md: export_rdev(sdc1)
> 
> The array did not assemble automatically this time either, and mdstat showed the same state. So, this time I decided to run
> 
> % mdadm --stop --scan
> mdadm: stopped /dev/md0
> % mdadm --assemble --scan
> mdadm: /dev/md0 has been started with 2 drives.
> 
> and it assembled just fine
> 
> % cat /proc/mdstat 
> Personalities : [raid1] 
> md0 : active raid1 sdb1[2] sde1[1]
>      1953276736 blocks super 1.2 [2/2] [UU]
>      bitmap: 0/15 pages [0KB], 65536KB chunk
> 
> unused devices: <none>
> 
> Here's the corresponding kernel log
> 
> Nov 15 08:31:06 localhost kernel: [30177.083700] scsi_verify_blk_ioctl: 48 callbacks suppressed
> Nov 15 08:31:06 localhost kernel: [30177.083709] mdadm: sending ioctl 800c0910 to a partition!
> Nov 15 08:31:06 localhost kernel: [30177.083717] mdadm: sending ioctl 800c0910 to a partition!
> Nov 15 08:31:06 localhost kernel: [30177.083737] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:31:06 localhost kernel: [30177.083743] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:31:06 localhost kernel: [30177.086150] mdadm: sending ioctl 800c0910 to a partition!
> Nov 15 08:31:06 localhost kernel: [30177.086158] mdadm: sending ioctl 800c0910 to a partition!
> Nov 15 08:31:06 localhost kernel: [30177.086168] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:31:06 localhost kernel: [30177.086174] mdadm: sending ioctl 1261 to a partition!
> Nov 15 08:31:06 localhost kernel: [30177.087982] mdadm: sending ioctl 800c0910 to a partition!
> Nov 15 08:31:06 localhost kernel: [30177.087992] mdadm: sending ioctl 800c0910 to a partition!
> Nov 15 08:31:06 localhost kernel: [30177.923752] md: md0 stopped.
> Nov 15 08:31:07 localhost kernel: [30177.936426] md: bind<sde1>
> Nov 15 08:31:07 localhost kernel: [30177.937166] md: bind<sdb1>
> Nov 15 08:31:07 localhost kernel: [30178.382401] md/raid1:md0: active with 2 out of 2 mirrors
> Nov 15 08:31:07 localhost kernel: [30178.463060] created bitmap (15 pages) for device md0
> Nov 15 08:31:07 localhost kernel: [30178.470165] md0: bitmap initialized from disk: read 1/1 pages, set 0 of 29805 bits
> Nov 15 08:31:07 localhost kernel: [30178.959261] md0: detected capacity change from 0 to 2000155377664
> Nov 15 08:31:08 localhost kernel: [30179.019629]  md0: unknown partition table
> 
> So, I think these messages are the gist of it all:
> 
> Nov 15 08:29:06 localhost kernel: [30057.565248] md: export_rdev(sde1)
> Nov 15 08:29:06 localhost kernel: [30057.566615] md: export_rdev(sde1)
> Nov 15 08:30:57 localhost kernel: [30168.336551] md: md0 stopped.
> Nov 15 08:30:57 localhost kernel: [30168.336562] md: unbind<sdb1>
> Nov 15 08:30:57 localhost kernel: [30168.336669] md: export_rdev(sdb1)
> Nov 15 08:30:57 localhost kernel: [30168.336689] md: unbind<sdc1>
> Nov 15 08:30:57 localhost kernel: [30168.340361] md: export_rdev(sdc1)
> 
> What do they mean? What is export of rdev? What kind of device is considered to be an rdev? What does this sequence of message tell me in human language? :)
> 
> I know, some of you feel very strongly about using USB for this sort of thing, but so far I've been enjoying my ride. Both in terms of stability and how it is pushing me to learn more about mdadm and RAID technology in general. Yes, the stability is far from enterprise grade systems, but I'm an enthusiast like perhaps many of you here and this has proven to be a very good training wheels. Besides, even though it is a bumpy ride, it is kinda fun, you know? ;D
> 
> Ivan

