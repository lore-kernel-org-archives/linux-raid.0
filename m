From: lingli tang <tanglingli001@gmail.com>
Subject: Re: is mdadm RAID1 disk full sync
Date: Mon, 23 Mar 2015 16:34:46 +0800
Message-ID: <CAN+bsqghYy1PyWpg9KRJan3RJZr0WMPLZCZtf01h0YR-_Jo_-w@mail.gmail.com>
References: <CAN+bsqhy0Bao1hAn3R-KtXWOjYb8O2LDo+E1jNdktWdduUL4vw@mail.gmail.com>
	<20150322142033.0af10b1a@notabene.brown>
	<CAN+bsqg2wp4VMCA8O0b2rUfbGDGXZY=mFvj1hA=tWaVkdCMXtA@mail.gmail.com>
	<550E6F02.3090800@websitemanagers.com.au>
	<CAN+bsqherPsEAPNrmYJ7o7DWP90gO4vv-sbmxCmthh_QU8qpcw@mail.gmail.com>
	<550EBAEE.6070608@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <550EBAEE.6070608@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have test multi times of:
1. mysql binlog write only on remote disk (without mdadm raid), there
are not any mysql binlog lost.
2. mysql binlog write on RAID1 of only remote disk (no local disk),
there are not any mysql binlog lost.
mysql will return error immediately with error message "Error writing
file '/home/mysql/data/mysqldata1/binlog/mysql-bin.000001' (Errcode: 5
- Input/output error)" in the upper two case

but when MySQL binlog run on RAID1 of local and remote disk, test
program which continued commit to mysql will run for 3 second and
hang in mysql_query() after reboot server. The error messge is also
not the same with upper case: "Lost connection to MySQL server during
query"

Should it be iscsi exit before mdadm, So mysql continue to write
binlog to a downgrade RAID1, which has only a local disk but  the
remote disk was just delete from mdadm.

I will try to test it.
Thanks very much.


2015-03-22 20:51 GMT+08:00 Adam Goryachev <mailinglists@websitemanagers.com.au>:
>
>
> On 22/03/2015 23:29, lingli tang wrote:
>>
>> Thanks very much.
>> I will try DRBD later
>> But I want to figure this out.
>>
>> I have export disk using tgtd and load disk on another server using
>> iscsiadm with infiniband  of iser protocol.
>> Does ISCSI/Iser have any cache on it.
>
> Can you test that by removing the local disk from the MD array, or changing
> your test so writes are directly to the remote device. Then run the test,
> shutdown, and check the remote disk to see if it has all the expected data,
> or still only some of the expected data. This will remove MD as a suspect.
> Continue to try and get "closer" to the remote until you can find the
> culprit. You might also use tcpdump or similar to sniff the network, which
> will tell you if the expected data is being sent to the remote (and when).
>
> Sorry, I don't know anywhere near enough to comment on things like
> infiniband/iser, but these are the steps I would look into. Hope that it is
> helpful.
>
> PS, I do use DRBD, and iSCSI, and it has been working well in my environment
> for the last year or so, I have no commercial interest/benefit from you
> using it, just a happy customer.
>
> Regards,
> Adam
>>
>>
>> 2015-03-22 15:28 GMT+08:00 Adam Goryachev
>> <mailinglists@websitemanagers.com.au>:
>>>
>>>
>>> On 22/03/2015 16:00, lingli tang wrote:
>>>>
>>>> Thanks for reply.
>>>>
>>>> I have create a raid1 with two fusion io PCIe flash disk:
>>>> mdadm --create /dev/md/master --name=master --level=1 --raid-devices=2
>>>> /dev/fioa2 /dev/mapper/mpathc
>>>> /dev/fioa2 is local disk on server A and /dev/mapper/mpathc is a iscsi
>>>> load disk export from server B.
>>>>
>>>> After that we mkfs.ext4 on /dev/md/master and mount with 'sync' option
>>>> on
>>>> /data1
>>>> and we will run mysql binlog on it.
>>>> In order to avoid data loss  of mysql binlog we have set
>>>> sync_binlog=1. so every sql commit will call fsync() to flush to disk.
>>>>
>>>> according to your description. if we reboot the server A, the two disk
>>>> data on different server will be the same.
>>>> but after the server A restarted, we assemble the two disk on two
>>>> server, data is different on the two server, disk on server B lost
>>>> more than one sql commit.
>>>>
>>>> I have checked it with strace 'mysqld' on Server A.
>>>> I found a sql commit and fsync() on binlog file handle on server A but
>>>> this sql can not find in assembled disk on server B.
>>>>
>>>> I also test it with two SAS disk, Server B still has more than one sql
>>>> commit lost.
>>>
>>> Sounds like you might be better using something like DRBD (www.drbd.org)
>>> which has different modes, one of which will do what you are asking (not
>>> respond until both systems have confirmed the data is written to the
>>> local
>>> disk).
>>>
>>> In your current case, even if md is correctly writing to both underlying
>>> 'devices' you have multiple layers under one of the devices, so you
>>> should
>>> confirm that *all* of those layers are properly passing through the data
>>> without any caching/etc.
>>>
>>> Regards,
>>> Adam
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
