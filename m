From: "Richard B. Pyne" <rpyne@kinfolk.org>
Subject: Re: system startup hangs
Date: Wed, 07 Dec 2011 16:19:39 -0700
Message-ID: <4EDFF48B.20705@kinfolk.org>
References: <4EDFEACD.3010806@kinfolk.org> <CADNH=7EZo9j-raoWh9EkcuRw1sCC3YC672jpA6OTsVMgqjbCaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7EZo9j-raoWh9EkcuRw1sCC3YC672jpA6OTsVMgqjbCaw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 12/7/2011 4:01 PM, Mathias Bur=C3=A9n wrote:
> On 7 December 2011 22:38, Richard B. Pyne<rpyne@kinfolk.org>  wrote:
>> Please forgive me if I ask stupid questions, I am fairly new to linu=
x raid
>> and most of the documentation I can find is severely outdated and/or=
 written
>> for someone who already understands linux raid.
>>
>> I have successfully built a set raid 6 array with 4 drives and have =
copied
>> my system partitions onto the raid drives. I then reboot with root=3D=
/dev/md0.
>>
>> Everything looks like it is working right up through:
>>
>> md/raid:md0 raid level 6 active with 4 out of 4 devices, algorithm 2
>> md0: detected capacity change from 0 to 1000131788
>> md: autorun DONE.
>> md0: unknown partition table
>> EXT3-fs (md0): error: couldn't mount because of unsupported optional
>> features
>> EXT2-fs (md0): error: couldn't mount because of unsupported optional
>> features
>> EXT4-fs (md0): mounted filesystem with ordered data mode.  Opts: (nu=
ll)
>> VFS: Mounted root (ext4 filesystem) readonly on device 9:0.
>> freeing unused kernel memory: 472k freed
>>
>>
>> at which point it just hangs. No more disk access, no more messages.
>>
>>
>> The system has 5 WD Caviar Black 500GB drives. I did the linux insta=
ll on
>> the first drive and built the other 4 drives into the raid system, p=
lanning
>> to move everything (except the /boot partition) on to the raid array=
 and
>> then repartition everything except the /boot partition on the first =
drive
>> and add it to the raid.
>>
>> I currently have md0 for / md1 for /home md2 for /usr md3 for /var a=
nd md4
>> on which I plan on running lvm to allocate to other system needs.
>>
>> Any advice, insights and/or direction will be greatly appreciated.
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> So you created 1 RAID6 volume. That is now "1 RAID drive", i.e. md0.
>
> Did you create partitions on md0? Or did you make it a physical volum=
e
> (PV) with LVM?

I guess I should have been a bit more clear. Each drive is partitioned=20
with 7 partitions. 1,2,3,5,6,7&8. partition 1 is just a small partition=
=20
to match the original boot drive /boot partition. Partition 2 is swap=20
space. partition 3 has been made into md0 and formatted with an ext4 fo=
r=20
/, same for partitions 5 as md1 for /home, partition 6 as md2 for /usr=20
and partition 7 as md3 for /var. Once I have everything up and working,=
=20
then I will put lvm on md4 made from partition 8 and use it for other=20
server needs.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
