From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Adding a new disk after disk failure on raid6 volume
Date: Tue, 20 Dec 2011 11:39:35 +0000
Message-ID: <4EF073F7.50805@anonymous.org.uk>
References: <75d55f4581b6ae45b8131ff989836028@systella.fr> <20111220092146.GA10387@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111220092146.GA10387@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/12/2011 09:21, Robin Hill wrote:
> On Tue Dec 20, 2011 at 09:46:13AM +0100, BERTRAND Jo=EBl wrote:
>
>> Hello,
>>
>> I use several softraid volumes for a very long time. Last week, a di=
sk
>> has crashed on a raid6 volume and I have tried to replace faulty dis=
k.
>> Today, when Linux boots, it only assembles this volume if the new di=
sk
>> is marked as 'faulty' or 'removed', and I don't understand...
>>
>> System is a sparc64-smp server running linux debian/testing :
>>
>> Root rayleigh:[~]>  uname -a
>> Linux rayleigh 2.6.36.2 #1 SMP Sun Jan 2 11:50:13 CET 2011 sparc64
>> GNU/Linux
>> Root rayleigh:[~]>  dpkg-query -l | grep mdadm
>> ii  mdadm                                 3.2.2-1
>>
>> Faulty device is /dev/sde1 :
>>
>> Root rayleigh:[~]>  cat /proc/mdstat
>> Personalities : [raid1] [raid6] [raid5] [raid4]
>> md7 : active raid6 sdc1[0] sdi1[6] sdh1[5] sdg1[4] sdf1[3] sdd1[1]
>>         359011840 blocks level 6, 64k chunk, algorithm 2 [7/6] [UU_U=
UUU]
>>
>> All disks (/dev/sd[cdefghi]) are same model (Fujitsu SCA-2 73 GB) an=
d
>> each disk only contains one partition (type FD, linux autodetect). I=
f I
>> add /dev/sde1 to raid6 with mdadm -a /dev/md7 /dev/sde1, disk is add=
ed
>> and my raid6 runs with all disks. But I obtain the same superblock o=
n
>> /dev/sde1 and /dev/sde ! If I remove /dev/sde superblock, /dev/sde1 =
one
>> disappears also (i think that both superblocks are the same).
>>
> <- SNIP info ->
>>
>> All disks return same information except /dev/sde when it is running
>> (mdadm --examine /dev/sde and mdadm --examine /dev/sde1 return the s=
ame
>> information). What is my mistake ? Is this a known issue ?
>>
> It's a known issue with 0.9 superblocks, yes. There's no information =
in
> the superblock with allows md to tell whether it's on the partition o=
r
> the disk, so for full-disk partitions the same superblock could be va=
lid
> for both. 0.1 superblocks contain extra information which can be used=
 to
> differentiate between these. I'm a little surprised that the other
> drives don't get detected in the same way though.

I think the above issue only occurs on partitions with particular=20
alignments, iirc starting at multiples of 8 sectors. Old fdisk would=20
always create the first partition starting at sector 63, and that was=20
the case with the output we saw for /dev/sdc, but a new fdisk will=20
likely create the partition starting at sector 2048.

Alternatively, or additionally, the problem may be that very old fdisk=20
had a bug where it miscounted and didn't create partitions right up to=20
the last "cylinder" of the disc, so the md metadata on the last=20
partition wasn't in the the same place as it would have been if it was=20
for the whole disc.

Either way, I would recommend that the OP --fail, --remove and=20
--zero-superblock his /dev/sde1, then copy a working partition table=20
from sdc with `dd if=3D/dev/sdc of=3D/dev/sde bs=3D512 count=3D1`, then=
=20
`blockdev --rereadpt /dev/sde`, then `fdisk -lu /dev/sde` just to make=20
sure that there is now an sde1 that's identical to sdc1, then --add the=
=20
new /dev/sde1.

Hope this helps!

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
