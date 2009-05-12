From: fibre raid <fibreraid@gmail.com>
Subject: Re: mdadm issue on Ubuntu Januty 9.04 server
Date: Mon, 11 May 2009 19:07:56 -0700
Message-ID: <5817fbed0905111907x1755a5deie9bf940eb522b69@mail.gmail.com>
References: <5817fbed0905111832u35d39a5au52482cceea53a4cb@mail.gmail.com>
	 <f6ef7d922bea762a5b2539e4d015934a.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f6ef7d922bea762a5b2539e4d015934a.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you for the additional insight Neil.

If I use partitions for my md members (like /dev/sdd1 and /dev/sdg1),
do I run the --zero-superblock on /dev/sdd1 or /dev/sdd for example?

=46inally, I am using Superblock v1.0 here, but in reviewing the mdadm
thread archives, it seems that v1.2 is more commonly recommended. Is
there any reason to use one or the other?

Thanks!
-Thomas


On Mon, May 11, 2009 at 7:01 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, May 12, 2009 11:32 am, fibre raid wrote:
>> Hi,
>>
>> I am facing an issue with mdadm on Ubuntu Jaunty 9.04 Server 64-bit
>> edition.
>>
>> Host:
>> - Dual quad-core Xeon 5450 3.0 GHz CPUs
>> - 16 GB RAM
>> - Ubuntu 9.04 server (2.6.28-11)
>> - mdadm 2.6.7.1
>> - LSI 3801E controller with 12 x Seagate Cheetah 15K.5 300GB drives
>>
>> I am trying to create a RAID 0 md device from two of the 15K.5 drive=
s.
>> When I boot my Host, it seems like there is some legacy md data in
>> /proc/mdstat. However, /etc/mdadm.conf is empty.
>>
>> root@JAUNTY:~# cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md_d1 : inactive sdx[1](S)
>> =A0=A0=A0=A0=A0 292968640 blocks
>>
>> md_d0 : inactive sdj[3](S) sdm[0](S) sdf[7](S) sdg[6](S)
>> =A0=A0=A0=A0=A0 1171874560 blocks
>>
>> unused devices: <none>
>>
>
> Presumably all these devices have md superblocks on them
> that make them look like part of some old array.
> Why jaunty partially assembled them isn't clear. =A0Maybe it
> is using --incremental and it is waiting for the rest of the
> array to appear.
> You can look at each device with --examine. =A0e.g.
> =A0mdadm --examine /dev/sdx
>
> If it reports an array that you don't want to still have, you can
> remove the metadata using
> =A0mdadm --zero-superblock /dev/sdx
>
>>
>> I proceed to stop and remove these md devices and use /proc/mdstat t=
o
>> verify that they were removed.
>>
>> root@JAUNTY:~# mdadm -S /dev/md_d1
>> mdadm: stopped /dev/md_d1
>> root@JAUNTY:~# mdadm -S /dev/md_d0
>> mdadm: stopped /dev/md_d0
>> root@JAUNTY:~# mdadm -r /dev/md_d1
>> root@JAUNTY:~# mdadm -r /dev/md_d0
>
>
> These last two commands do nothing. =A0They are asking mdadm to remov=
e
> some devices from the arrays /dev/md_d1 and then /dev/md_d0,
> =A0but don't list any devices to remove. =A0As the arrays are already
> stopped, there is nothing to remove anyway.
>
>
>> root@JAUNTY:~# cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> unused devices: <none>
>>
>>
>> Now it appears that the md devices are removed.
>
> "stopped" is the term we normally use.
>
>>
>> I then try to create an md device:
>>
>> root@JAUNTY:~# mdadm -C -f -e 1.0 -R /dev/md0 -l 0 -n 2 -c 64 /dev/s=
dd
>> /dev/sdg
>> mdadm: /dev/sdg appears to be part of a raid array:
>> =A0=A0=A0 level=3Draid0 devices=3D8 ctime=3DSun Mar 22 23:22:03 2009
>> mdadm: array /dev/md0 started.
>> root@JAUNTY:~# cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md0 : active raid0 sdg[1] sdd[0]
>> =A0=A0=A0=A0=A0 585937408 blocks super 1.0 64k chunks
>>
>> unused devices: <none>
>>
>>
>> Why does mdadm report /dev/sdg as part of a raid array? I removed al=
l
>> the md devices as shown above. Thank you for your help!
>
> Because it still has metadata on it recording the fact that it
> was recently part of an array. =A0Creating a new array using that
> device will have erased any old metadata.
> You can remove the metadata without creating an array by using
> --zero-superblock as described above.
>
> NeilBrown
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
