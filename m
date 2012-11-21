From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: mdadm --fail doesn't mark device as failed?
Date: Wed, 21 Nov 2012 18:10:25 +0100
Message-ID: <50AD0B01.7020300@profitbricks.com>
References: <1353514677.5795.14.camel@corn.betterworld.us>  <50AD0726.9090509@profitbricks.com> <1353517421.5795.58.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1353517421.5795.58.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21.11.2012 18:03, Ross Boylan wrote:
> On Wed, 2012-11-21 at 17:53 +0100, Sebastian Riemer wrote:
>> On 21.11.2012 17:17, Ross Boylan wrote:
>>> After I failed and removed a partition, mdadm --examine seems to sh=
ow
>>> that partition is fine.
>>>
>>> Perhaps related to this, I failed a partition and when I rebooted i=
t
>>> came up as the sole member of its RAID array.
>>>
>>> Is this behavior expected?  Is there a way to make the failures mor=
e
>>> convincing?
>> Yes, it is expected behavior. Without "mdadm --fail" you can't remov=
e a
>> device from the array. If you stop the array with the failed device,
>> then the state is stored in the superblock.
> I'm confused.  I did run mdadm --fail.  Are you saying that, in addit=
ion
> to doing that, I also need to manipulate sysfs as you describe below?
> Or were you assuming I didn't mdadm --fail?

You only need to set the value in the "errors" sysfs file additionally
to ensure that this device isn't used for assembly anymore.

The kernel reports in "dmesg" then:
md: kicking non-fresh sdb1 from array!

>> There is a difference in the way mdadm does it and the sysfs method.
>> mdadm sends an ioctl to the kernel. With the sysfs command the fault=
y
>> state is stored immediately in the superblock.
>>
>> # echo faulty > /sys/block/md0/md/dev-sdb1/state
>>
>> If you reassemble that you'll get the message:
>> mdadm: device 0 in /dev/md0 has wrong state in superblock, but /dev/=
sdb1
>> seems ok
>>
>> There is a limit of how many errors are allowed on the device (usual=
ly 20).
>>
>> If you do the following additionally, your device won't be used for
>> assembly anymore.
>> # echo 20 > /sys/block/md0/md/dev-sdb1/errors
>>
>> I guess this is related to: /sys/block/md0/md/max_read_errors.
>>
>>> The drive sdb in the following excerpt does appear to be experienci=
ng
>>> hardware problems.  However, the failed partition that became the m=
d on
>>> reboot was on a drive without any reported problems.
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Sebastian Riemer
Linux Kernel Developer - Storage

We are looking for (SENIOR) LINUX KERNEL DEVELOPERS!

ProfitBricks GmbH =95 Greifswalder Str. 207 =95 10405 Berlin, Germany
www.profitbricks.com =95 sebastian.riemer@profitbricks.com
Tel.: +49 - 30 - 60 98 56 991 - 915

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
