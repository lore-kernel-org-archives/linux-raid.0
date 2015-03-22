From: lingli tang <tanglingli001@gmail.com>
Subject: Re: is mdadm RAID1 disk full sync
Date: Sun, 22 Mar 2015 13:00:54 +0800
Message-ID: <CAN+bsqg2wp4VMCA8O0b2rUfbGDGXZY=mFvj1hA=tWaVkdCMXtA@mail.gmail.com>
References: <CAN+bsqhy0Bao1hAn3R-KtXWOjYb8O2LDo+E1jNdktWdduUL4vw@mail.gmail.com>
	<20150322142033.0af10b1a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150322142033.0af10b1a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for reply.

I have create a raid1 with two fusion io PCIe flash disk:
mdadm --create /dev/md/master --name=master --level=1 --raid-devices=2
/dev/fioa2 /dev/mapper/mpathc
/dev/fioa2 is local disk on server A and /dev/mapper/mpathc is a iscsi
load disk export from server B.

After that we mkfs.ext4 on /dev/md/master and mount with 'sync' option on /data1
and we will run mysql binlog on it.
In order to avoid data loss  of mysql binlog we have set
sync_binlog=1. so every sql commit will call fsync() to flush to disk.

according to your description. if we reboot the server A, the two disk
data on different server will be the same.
but after the server A restarted, we assemble the two disk on two
server, data is different on the two server, disk on server B lost
more than one sql commit.

I have checked it with strace 'mysqld' on Server A.
I found a sql commit and fsync() on binlog file handle on server A but
this sql can not find in assembled disk on server B.

I also test it with two SAS disk, Server B still has more than one sql
commit lost.


2015-03-22 11:20 GMT+08:00 NeilBrown <neilb@suse.de>:
> On Sat, 21 Mar 2015 19:01:54 +0800 lingli tang <tanglingli001@gmail.com>
> wrote:
>
>> I am a newbie of mdadm. I have a question but find no answer in
>> document or google for last 10 days.
>>
>> The question is : RAID1 made by mdadm is full sync? for example, I
>> have two disk(sdb and sdc) to make RAID1 disk (/dev/md127), if I
>> commit an IO to the RAID1 disk (md127), it will return back to me when
>> all the two disk commit successfully      or      it will return back
>> to me once just one of the disk successfully commit.
>
> The write request will not return until it has been submitted to all, and
> returned by, all working devices.
>
>>
>> I have test with xfs and ext4 with sync option, and it seems that two
>> disk have lots of commit difference after reboot the server. is that
>> means mdadm return success when one of the disk is commit
>> successfully?
>
> That certainly shouldn't happen.  I would need more details of the experiment
> that you performed.
>
> NeilBrown
>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
