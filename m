From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Automatically drop caches after mdadm fails a drive out of an
 array?
Date: Thu, 13 Feb 2014 02:29:04 -0600
Message-ID: <52FC8250.4080903@hardwarefreak.com>
References: <1413719638.30344.1392138285471.JavaMail.zimbra@xes-inc.com> <1090802800.32078.1392138664718.JavaMail.zimbra@xes-inc.com> <20140212065420.4643f9a1@notabene.brown> <700319865.79921.1392160257000.JavaMail.zimbra@xes-inc.com> <52FABC1A.1010804@hardwarefreak.com> <1113712961.13129.1392216288183.JavaMail.zimbra@xes-inc.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1113712961.13129.1392216288183.JavaMail.zimbra@xes-inc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Martin <amartin@xes-inc.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/12/2014 8:44 AM, Andrew Martin wrote:
> Stan,
> 
> ----- Original Message -----
>> From: "Stan Hoeppner" <stan@hardwarefreak.com>
>> To: "Andrew Martin" <amartin@xes-inc.com>, "NeilBrown" <neilb@suse.de>
>> Cc: linux-raid@vger.kernel.org
>> Sent: Tuesday, February 11, 2014 6:11:06 PM
>> Subject: Re: Automatically drop caches after mdadm fails a drive out of an array?
>>
>> On 2/11/2014 5:10 PM, Andrew Martin wrote:
>>> Neil,
>>>
>>> ----- Original Message -----
>>>> From: "NeilBrown" <neilb@suse.de>
>>>> To: "Andrew Martin" <amartin@xes-inc.com>
>>>> Cc: linux-raid@vger.kernel.org
>>>> Sent: Tuesday, February 11, 2014 1:54:20 PM
>>>> Subject: Re: Automatically drop caches after mdadm fails a drive out of an
>>>> array?
>>>>
>>>> On Tue, 11 Feb 2014 11:11:04 -0600 (CST) Andrew Martin
>>>> <amartin@xes-inc.com>
>>>> wrote:
>>>>
>>>>> Hello,
>>>>>
>>>>> I am running mdadm 3.2.5 on an Ubuntu 12.04 fileserver with a 10-drive
>>>>> RAID6 array (10x1TB). Recently, /dev/sdb started failing:
>>>>> Feb 10 13:49:29 myfileserver kernel: [17162220.838256] sas: command
>>>>> 0xffff88010628f600, task 0xffff8800466241c0, timed out:
>>>>> BLK_EH_NOT_HANDLED
>>>>>
>>>>> Around this same time, a few users attempted to access a directory on
>>>>> this
>>>>> RAID array over CIFS, which they had previously accessed earlier in the
>>>>> day. When they attempted to access it this time, the directory was empty.
>>>>> The emptiness of the folder was confirmed via a local shell on the
>>>>> fileserver, which reported the same information. At around 13:50, mdadm
>>>>> dropped /dev/sdb from the RAID array:
>>>>
>>>> The directory being empty can have nothing to do with the device failure.
>>>> md/raid will never let bad data into the page cache in the manner you
>>>> suggest.
>>>
>>> Thank you for the clarification. What other possibilities could have
>>> triggered
>>> this behavior? I am also using LVM and DRBD on top of the the md device.
>>
>> The filesystem told you the directory was empty.  Directories and files
>> are filesystem structures.  Why are you talking about all the layers of
>> the stack below the filesystem, but not the filesystem itself?  What
>> filesystem is this?  Are there any FS related errors in dmesg?
>
> It seemed unlikely that the timing of the failure of the drive out of
> the raid array and these filesystem-level problems was coincidental. 
> Yes, there were also filesystem errors, immediately after md dropped the 
> device. This is an ext4 filesystem:

Please show all disk/controller errors in close time proximity before
the md fail event.

> 13:50:31 mdadm[1897]: Fail event detected on md device /dev/md2, component device /dev/sdb
> 13:50:31 smbd[3428]: [2014/02/10 13:50:31.226854,  0] smbd/process.c:2439(keepalive_fn)
> 13:50:31 smbd[13539]: [2014/02/10 13:50:31.227084,  0] smbd/process.c:2439(keepalive_fn)
> 13:50:31 kernel: [17162282.624858] EXT4-fs error (device drbd0): htree_dirblock_to_tree:587: inode #148638560: block 1189089581: comm smbd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2004033568, rec_len=29801, name_len=99
> 13:50:31 kernel: [17162282.823733] EXT4-fs error (device drbd0): htree_dirblock_to_tree:587: inode #148638560: block 1189089581: comm smbd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2004033568, rec_len=29801, name_len=99
> 13:50:31 kernel: [17162282.832886] /build/buildd/linux-3.2.0/drivers/scsi/mvsas/mv_sas.c 1863:port 2 slot 45 rx_desc 3002D has error info8000000080000000.
> 13:50:31 kernel: [17162282.832920] /build/buildd/linux-3.2.0/drivers/scsi/mvsas/mv_94xx.c 626:command active 30305FFF,  slot [2d].
> 13:50:31 kernel: [17162282.991884] /build/buildd/linux-3.2.0/drivers/scsi/mvsas/mv_sas.c 1863:port 3 slot 52 rx_desc 30034 has error info8000000080000000.
> 13:50:31 kernel: [17162282.991892] /build/buildd/linux-3.2.0/drivers/scsi/mvsas/mv_94xx.c 626:command active 302FFFFF,  slot [34].
> 13:50:31 kernel: [17162282.992072] /build/buildd/linux-3.2.0/drivers/scsi/mvsas/mv_sas.c 1863:port 2 slot 53 rx_desc 30035 has error info8000000080000000.
> ...
> 13:52:03 kernel: [17162374.423961] EXT4-fs error (device drbd0): htree_dirblock_to_tree:587: inode #148638560: block 1189089581: comm smbd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2004033568, rec_len=29801, name_len=99
> 13:52:04 kernel: [17162375.839851] EXT4-fs error (device drbd0): htree_dirblock_to_tree:587: inode #148638560: block 1189089581: comm smbd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2004033568, rec_len=29801, name_len=99
> 13:52:08 kernel: [17162380.135391] EXT4-fs error (device drbd0): htree_dirblock_to_tree:587: inode #148638560: block 1189089581: comm smbd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2004033568, rec_len=29801, name_len=99
> 13:52:13 kernel: [17162385.108358] EXT4-fs error (device drbd0): htree_dirblock_to_tree:587: inode #148638560: block 1189089581: comm smbd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2004033568, rec_len=29801, name_len=99
> 13:52:17 kernel: [17162388.166515] EXT4-fs error (device drbd0): htree_dirblock_to_tree:587: inode #148638560: block 1189089581: comm smbd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2004033568, rec_len=29801, name_len=99
> ...

Does drbd0 sit atop md2?

Also, the Marvel x8 SAS controllers are fine for Windows.  But the Linux
driver sucks, and has historically made the HBAs unusable.  The most
popular is probably the SuperMicro AOC-SASLP-MV8.  In the log above the
driver is showing errors on two SAS ports simultaneously.  If not for
the presence of mvsas I'd normally assume dirty power or a bad backplane
due to such errors.  The errors should not propagate up the stack to
drbd.  But the mere presence of this driver suggests it is part of the
problem.

Swap the Marvell SAS card for something decent and I'd bet most of your
problems will disappear.

-- 
Stan
