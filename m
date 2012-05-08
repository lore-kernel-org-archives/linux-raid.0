From: Nikolay Kichukov <hijacker@oldum.net>
Subject: Re: create raid10 md raid which hangs on auto-read-only with resync=PENDING
Date: Tue, 08 May 2012 17:16:39 +0300
Message-ID: <4FA92AC7.6060204@oldum.net>
References: <4FA24A31.3020703@oldum.net> <20120504072339.7742201e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120504072339.7742201e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Neil,

Yes, I confirm debian has that variable set to 1:

#cat /sys/module/md_mod/parameters/start_ro
1

It is strange that creating the array will stay in such state in the first place. As I have not seen that before I
googled for solution, before attempting to mkfs on the device.

Perhaps what you suggested might work just fine for all, thus avoid the confusion.

Cheers,
- -Nik

On 05/04/2012 12:23 AM, NeilBrown wrote:
> On Thu, 03 May 2012 12:04:49 +0300 Nikolay Kichukov <hijacker@oldum.net>
> wrote:
> 
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
> 
>> Hi all,
>> I have recently included one more drive in my system and has switched from raid0 to raid10 on 3 devices/partitions.
> 
>> I have created the raid as follows:
> 
>> mdadm --create /dev/md3 --verbose --raid-devices=3 --level=raid10 --name=cryptdata  --layout=o2 --chunk=2M /dev/sda3
>> /dev/sdb3 /dev/sdf3
>> mdadm: size set to 319434752K
>> mdadm: Defaulting to version 1.2 metadata
>> mdadm: array /dev/md3 started.
> 
> 
>> Information about the array:
> 
>> mdadm --detail /dev/md3
>> /dev/md3:
>>         Version : 1.2
>>   Creation Time : Thu May  3 11:42:57 2012
>>      Raid Level : raid10
>>      Array Size : 479152128 (456.96 GiB 490.65 GB)
>>   Used Dev Size : 319434752 (304.64 GiB 327.10 GB)
>>    Raid Devices : 3
>>   Total Devices : 3
>>     Persistence : Superblock is persistent
> 
>>     Update Time : Thu May  3 11:42:57 2012
>>           State : clean, resyncing (PENDING)
>>  Active Devices : 3
>> Working Devices : 3
>>  Failed Devices : 0
>>   Spare Devices : 0
> 
>>          Layout : offset=2
>>      Chunk Size : 2048K
> 
>>            Name : hanna64:cryptdata  (local to host hanna64)
>>            UUID : a7cc8eb7:8555b1bd:2856b686:829861be
>>          Events : 0
> 
>>     Number   Major   Minor   RaidDevice State
>>        0       8        3        0      active sync   /dev/sda3
>>        1       8       19        1      active sync   /dev/sdb3
>>        2       8       83        2      active sync   /dev/sdf3
> 
> 
>> And under /proc/mdstat:
> 
>> cat /proc/mdstat
>> Personalities : [raid0] [raid1] [raid10]
>> md3 : active (auto-read-only) raid10 sdf3[2] sdb3[1] sda3[0]
>>       479152128 blocks super 1.2 2048K chunks 2 offset-copies [3/3] [UUU]
>>       	resync=PENDING
> 
> 
>> The resync was not started due to the array being in auto-read-only mode.
> 
>> I googled the issue and found out that to be able to start the resync one should issue:
> 
>> mdadm --readwrite /dev/mdx
>> (ref.: http://wiki.xtronics.com/index.php/Raid )
> 
>> I have done it and it started resyncing:
>> cat /proc/mdstat
>> Personalities : [raid0] [raid1] [raid10]
>> md3 : active raid10 sdf3[2] sdb3[1] sda3[0]
>>       479152128 blocks super 1.2 2048K chunks 2 offset-copies [3/3] [UUU]
>>       [=>...................]  resync =  6.2% (29748096/479152128) finish=120.3min speed=62220K/sec
> 
> 
> 
>> Is this intended feature for 1.2 metadata?
> 
> This behaviour isn't a function of 1.2 metadata.
> It is a function of  /sys/module/md_mod/parameters/start_ro which
> is probably being setting by Debian early in boot because that can be a very
> sensible thing to do.
> 
> I should probably get --create to over-ride it (I thought I had, but
> obviously not).
> 
> If you write '0' to it, you'll find that the array starts normally.
> 
> Alternately, just start using the array.  As soon as you "mkfs", the array
> will start resyncing.
> 
> NeilBrown
> 
> 
> 
>> Kernel: 3.1.0-1-amd64
>> mdadm: 3.2.3-2
>> Distro: Debian testing
> 
>> Cheers,
>> - -Nik
>> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPqSrHAAoJEDFLYVOGGjgXTk0IAOL5usQPgFRlrNEUJvH7lLWV
eJxx+VFUiscwqjY3Ri7yLmEFUIylRunpM1+88gIyNH4eqVE1n/KBPmb//jUJJa/D
UPEgulqP5Dfa8I2vQGELN6m+ysyEacW8QRgpAt6KhwF4kp6Kl4dbLPvEFbkX4lMr
AMe/JlhL8GjpiiasTXSonkolM8BcVlK31UdWB/J0QyMVyzj4jz9xhXgUMq7r+sC+
/tu/yXe45Z6caXf0qABrOnfbi/PPE5lflrERRHQyC3by334jzUiAiAhK99BHPOBq
UBr7AYbI7349LyIe/nmh2Vnsh4i2gIICrAk+J5729M01JjcD+NgCYyUHvItiU/A=
=9A3L
-----END PGP SIGNATURE-----
