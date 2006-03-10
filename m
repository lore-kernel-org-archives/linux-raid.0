From: Raphael Delaporte <jordanrudess@free.fr>
Subject: Re: Did --zero-superblock by mistake ... How can I get back data
 ?
Date: Fri, 10 Mar 2006 21:23:52 +0100
Message-ID: <4411E058.7000601@free.fr>
References: <4411BF56.7010801@free.fr> <4411D5AB.2030609@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4411D5AB.2030609@us.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Tran <mhtran@us.ibm.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Tran a =E9crit :
> Raphael Delaporte wrote:
>
>> Hi,
>>
>> On a RAID 5 array which is composed by 5 hdd, I did mdadm=20
>> --zero-superblocks on each hdd because I thought it was required to=20
>> use the array on a new system....
>>
>> But now, I cannot mdadm --assemble the array. It says :
>>
>> mdadm: no RAID superblock on /dev/sda
>> mdadm: /dev/sda has no superblock - assembly aborted
>>
>> Is it possible to assemble this array because I don't want to lose m=
y=20
>> data... Someone told me that I can do a :
>>
>> mdadm -Cv /dev/md0 -l5 -n5 /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/=
hdc
>>
>> But if do that, all the data on the raid will be lost or not ?
>>
>> Is there an other way to get back these data ?
>>
>> Thank you very much for your help.
>>
> I would try to recreate the raid5 array with *1 missing disk,* then=20
> try to mount the array (read only) and verify the data.
>
> For example,
> mdadm -C /dev/md0 -l 5 -c 32 -p ls -n 5 /dev/sda /dev/sdb /dev/sdc=20
> /dev/sdd missing
>
> Notes:
> If you used /etc/mdadm.conf, specify the disk order on the ARRAY line=
=20
> with 1 missing disk to be safe.
> I specified the mdadm default chunk size (32K) and default parity=20
> algorithm (left-symmetric). You may have to use other values.
> You should change the order of the disks if your data is invalid.
>
> --=20
> Regards,
> Mike T.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

Yeah, thank you, it worked perfectly !
Thank you for your help !

--
Raph


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
