From: Marcus <nexuslite@gmail.com>
Subject: Re: Raid 5 Array
Date: Sun, 3 Apr 2011 10:46:23 -0700
Message-ID: <BANLkTik7XHyOCK8SwhPTaWxQ+K=2FRowng@mail.gmail.com>
References: <BANLkTim8620MUckc+EVCWo9FCTs=65_p8Q@mail.gmail.com>
	<4D977279.30107@gmail.com>
	<BANLkTimJfUhvkpkkAH=NLJOvLL-Jotrwqg@mail.gmail.com>
	<4D97828C.8050806@gmail.com>
	<6158157523854459259@unknownmsgid>
	<20110403040113.472838d4@natsu>
	<AANLkTikJtFb0JtS1-Je9NFXn-CRc4pi7pmYFNV7v2SEg@mail.gmail.com>
	<BANLkTi=wWAE79KOPhZ0OUWpicgcD7QNG-g@mail.gmail.com>
	<BANLkTimRSmSu2XOfQ8yUxn5r2Tsq53LCmQ@mail.gmail.com>
	<BANLkTikQai-ZwuEDQDinMcYi4ics_axd7Q@mail.gmail.com>
	<20110403174900.38de17e2@notabene.brown>
	<BANLkTi=yTeG5-E=R6wy0GZe_iyxC5_7-Fg@mail.gmail.com>
	<20110403210138.584c796c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110403210138.584c796c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Roberto Spadim <roberto@spadim.com.br>, Roman Mamedov <rm@romanrm.ru>, Simon Mcnair <simonmcnair@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I provided you all relevant information if you payed attention to
sizes and the fact that I stated that I can add a new partition to the
device you would have realized that I have already applied grow to the
raid.

1465159552 raid size
976767808 partition size

See how partition is smaller than raid by about 500GB?

nexuslite@ubuntu:~$ resize2fs -p /dev/md2p1
resize2fs 1.41.11 (14-Mar-2010)
The filesystem is already 244191952 blocks long.  Nothing to do!

There is the exact message resize2fs is returning. 244191968 is the
current end block of the partition. parted also shows 244191968 as the
maximum block size for a partition. There are no related dmesg because
it is not an error it is just undesired results.

mdstat

md0 : active raid0 sdb1[1] sdc1[0]
      732579840 blocks 64k chunks

md2 : active raid5 md0[0] sde1[2] sdd1[1]
      1465159552 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

I have grown this raid array before it isn't like I am a newbie I just
don't understand why the partition is stuck at 1TB. I keep reading
about 2TB limits but can't find anything relevant to the 1TB limit I
am experiencing.




On Sun, Apr 3, 2011 at 4:01 AM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 3 Apr 2011 01:02:40 -0700 Marcus <nexuslite@gmail.com> wrote:
>
>> The file system is ext4. The current raid drive is 1.5TB the old siz=
e
>> was 1TB. I can create a new partition on the drive it just wont let =
me
>> resize it to a larger size. It seems to be maxed out at 1TB for some
>> reason.
>
> What is "it"? =A0What command do you run? =A0What output does it gene=
rate?
>
>>
>> mdstat shows 1465159552 blocks which is the new size.
>
> Why didn't you just include the complete "cat /proc/mdstat".
> That would have been much more informative.
>
>>
>> fdisk -l shows Disk /dev/md2: 1500.3 GB, 1500323381248 bytes 2 heads=
,
>> 4 sectors/track, 366289888 cylinders.
>>
>> Current partition: /dev/md2p1 =A0 =A0 =A0 =A0 =A0 =A0 =A017 =A0 2441=
91968 =A0 976767808
>> =A083 =A0Linux
>>
>> resize2fs -p /dev/md2 returns: nothing to do
>>
>
> Is this "it"?? =A0Do you realise that you need to resize the device "=
/dev/md2"
> before you can resize the filesystem that is stored in "/dev/md2".
>
>> Nothing is failing it just seems to be at a max size. I also tried
>> resizing with parted and it seems to think 244191968 is max like
>> resize2fs does.
>>
>
>
> As you provided so little concrete details - despite me asking for lo=
ts -
> I'll have to guess.
>
> I guess that if you
> =A0mdadm -S /dev/md2
> =A0mdadm -A /dev/md2 --update=3Ddevice-size /dev/...list.of.devices
> =A0mdadm -G /dev/md2 --size=3Dmax
> =A0resize2fs /dev/md2
>
> then it might work. =A0Or maybe it'll corrupt everything. =A0I cannot=
 really be
> sure because I am being forced to guess.
>
> Commands like:
>
> =A0mdadm --examine /dev/*
> =A0mdadm --detail /dev/md*
> =A0cat /proc/partitions
> =A0cat /proc/mdstat
> =A0dmesg | tail -100
>
> are the sort of things that are useful - not "I tried something and i=
t didn't
> work"...
>
> NeilBrown
>
> (sorry, but I get grumpy when people provide so little information).
>
>
>
>>
>>
>> On Sun, Apr 3, 2011 at 12:49 AM, NeilBrown <neilb@suse.de> wrote:
>> > On Sat, 2 Apr 2011 23:41:50 -0700 Marcus <nexuslite@gmail.com> wro=
te:
>> >
>> >> Okay I have my raid extended to 1500.3GB however I can't seem to =
grow
>> >> the partition past 1TB. It will let me create a new partition but=
 it
>> >> won't let me make the current partition any bigger. Does anyone k=
now
>> >> how to fix this?
>> >
>> > Best to show exactly the command you use, exactly the results, and=
 details
>> > about the component devices (particularly size).
>> > When using any mdadm command, add "-vv" to make it as verbose as p=
ossible.
>> > Include kernel log messages (e.g. dmesg | tail -100)
>> >
>> > Prefer to send too much info rather than not enough.
>> > And just place it in-line in the email, no attachments, not 'paste=
bin' links.
>> >
>> > NeilBrown
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
