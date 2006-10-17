From: Bobby S <at7max@hotmail.com>
Subject: Re: Needing help with Raid 5 array with 2 failed disks of 4
 [Solved]
Date: Tue, 17 Oct 2006 13:32:20 -0700 (PDT)
Message-ID: <6863604.post@talk.nabble.com>
References: <6857614.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6857614.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Bobby S wrote:
> 
> Hello, I had a software raid 5 array of 4 disks drop two last night and
> was curious of what help I may find.
> 
> I have 4 250GB maxtor drives in software raid 5 array and I seem to get
> the dma_timer_expiry error comming up every few weeks and I was curious as
> to how I may recover what I can from the array.
> 
> I am running the array on an Abit AT7 Max motherboard with an AMD 2400XP+
> CPU, 1 GB ddr266 ram and a HPT 374 onboard raid controller with 4
> channels.
> 
> Centos 4.3 with Vanilla Sources (2.6.17) is the current linux flavor.
> 
> So far I have left the affected system running without doing anything to
> it and was curious where I should start?
> 
> 
> 
> Here are the dmesg and at the end the cat/proc/mdtstat outputs:
> 
> [root@localhost ~]# dmesg
> 
> [17429656.684000] hde: dma_timer_expiry: dma status == 0x21
> [17429656.684000] hdg: dma_timer_expiry: dma status == 0x21
> 
> [17429711.052000] end_request: I/O error, dev hdg, sector 126026191
> [17429711.052000] raid5: read error not correctable.
> [17429711.096000] RAID5 conf printout:
> [17429711.096000]  --- rd:4 wd:2 fd:2
> [17429711.096000]  disk 0, o:0, dev:hde1
> [17429711.096000]  disk 1, o:0, dev:hdg1
> [17429711.096000]  disk 2, o:1, dev:hdi1
> [17429711.100000]  disk 3, o:1, dev:hdk1
> [17429711.116000] Aborting journal on device md0.
> [17429711.116000] RAID5 conf printout:
> [17429711.116000]  --- rd:4 wd:2 fd:2
> [17429711.116000]  disk 0, o:0, dev:hde1
> [17429711.116000]  disk 2, o:1, dev:hdi1
> [17429711.116000]  disk 3, o:1, dev:hdk1
> [17429711.116000] RAID5 conf printout:
> [17429711.116000]  --- rd:4 wd:2 fd:2
> [17429711.116000]  disk 0, o:0, dev:hde1
> [17429711.116000]  disk 2, o:1, dev:hdi1
> [17429711.116000]  disk 3, o:1, dev:hdk1
> [17429711.116000] ext3_abort called.
> [17429711.116000] EXT3-fs error (device md0): ext3_journal_start_sb:
> Detected aborted journal
> [17429711.116000] Remounting filesystem read-only
> [17429711.128000] RAID5 conf printout:
> [17429711.128000]  --- rd:4 wd:2 fd:2
> [17429711.128000]  disk 2, o:1, dev:hdi1
> [17429711.128000]  disk 3, o:1, dev:hdk1
> 
> [root@localhost ~]# cat /proc/mdstat
> Personalities : [raid5] [raid4] [raid6] [multipath] [faulty] 
> md0 : active raid5 hdk1[3] hdi1[2] hdg1[4](F) hde1[5](F)
>       735334656 blocks level 5, 256k chunk, algorithm 2 [4/2] [__UU]
>       
> unused devices: <none>
> 
> Thank you for your time,
> 
> Bobby
> 


I read through the archives ... did a forced assemble and then re-added the
final disk that did not want to auto assemble ... I'll have to check the
data when I wake up ...

Thanks to all those who came before me and those that helped them.

Commands Used in my case:

mdadm -A --force /dev/md0 /dev/hd[egik]1
G was not accepted as fresh enough so I readded it ...
mdadm -a /dev/md0 /dev/hdg1
and it is rebuilding over the next 3 hours as I type ...


sorry for the waste of bandwidth ... now I hunt the elusive dma_timer_expiry
solution ... but alas that exists elseware

Bobby

can you tell I don't get enough sleep ;-)
-- 
View this message in context: http://www.nabble.com/Needing-help-with-Raid-5-array-with-2-failed-disks-of-4-tf2460295.html#a6863604
Sent from the linux-raid mailing list archive at Nabble.com.

