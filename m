From: CoolCold <coolthecold@gmail.com>
Subject: Re: mdadm raid1 read performance
Date: Fri, 6 May 2011 08:14:28 +0400
Message-ID: <BANLkTi=x3kC+66JKUkEAPrPBC3aH+ZB_Xg@mail.gmail.com>
References: <BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>
	<4DC0F2B6.9050708@fnarfbargle.com>
	<BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com>
	<BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>
	<20110505094538.0cef02cc@notabene.brown>
	<BANLkTi=W=DNdqOBiGwbu67P1EgoEqNy+sg@mail.gmail.com>
	<BANLkTimNxTnf2xW8hbEWK2iA6axqjnjT+A@mail.gmail.com>
	<BANLkTi=2WCfoXTtyRzpBN06ph6HCsy_ShQ@mail.gmail.com>
	<BANLkTinoK0fhm-a7QAu5UdJNhbRO+mv2Jw@mail.gmail.com>
	<iptjde$92f$1@dough.gmane.org>
	<20110505104156.GA11441@www2.open-std.org>
	<ipu25h$s1b$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ipu25h$s1b$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 5, 2011 at 3:38 PM, David Brown <david@westcontrol.com> wro=
te:
> On 05/05/2011 12:41, Keld J=F8rn Simonsen wrote:
>>
>> On Thu, May 05, 2011 at 09:26:45AM +0200, David Brown wrote:
>>>
>>> On 05/05/2011 02:40, Liam Kurmos wrote:
>>>>
>>>> Cheers Roberto,
>>>>
>>>> I've got the gist of the far layout from looking at wikipedia. The=
re
>>>> is some clever stuff going on that i had never considered.
>>>> i'm going for f2 for my system drive.
>>>>
>>>> Liam
>>>>
>>>
>>> For general use, raid10,f2 is often the best choice. =A0The only
>>> disadvantage is if you have applications that make a lot of synchro=
nised
>>> writes, as writes take longer (everything must be written twice, an=
d
>>> because the data is spread out there is more head movement). =A0For=
 most
>>> writes this doesn't matter - the OS caches the writes, and the app
>>> continues on its way, so the writes are done when the disks are not
>>> otherwise used. =A0But if you have synchronous writes, so that the =
app
>>> will wait for the write to complete, it will be slower (compared to
>>> raid10,n2 or raid10,o2).
>>
>> Yes syncroneous writes would be significantly slower.
>> I have not seen benchmarks on it, tho.
>> Which applications typically use syncroneous IO?
>> Maybe not that many.
>> Do databases do that, eg postgresql and mysql?
>>
>
> Database servers do use synchronous writes (or fsync() calls), but I =
suspect
> that they won't suffer much if these are slow unless you have a great=
 deal
> of writes - they typically write to the transaction log, fsync(), wri=
te to
> the database files, fsync(), then write to the log again and fsync().=
 =A0But
> they will buffer up their writes as needed in a separate thread or pr=
ocess -
> it should not hinder their read processes.
>
> Lots of other applications also use fsync() whenever they want to be =
sure
> that data is written to the disk. =A0A prime example is sqlite, which=
 is used
> by many other programs. =A0If you have your disk systems and file sys=
tems set
> up as a typical home user, there is little problem - the disk write c=
aches
> and file system caches will ensure that the app thinks the write is c=
omplete
> long before it hits the disk surfaces anyway (thus negating the whole=
 point
> of using fsync() in the first place...). =A0But if you have a more pa=
ranoid
> setup, so that your databases or other files will not get corrupted b=
y power
> fails or OS crashes, then you have write barriers enabled on the file=
systems
> and write caches disabled on the disks.
I guess you mess things a bit - one should disable write cache or
enable barriers at one time, not both. Here goes quote from XFS faq:
"Write barrier support is enabled by default in XFS since kernel
version 2.6.17. It is disabled by mounting the filesystem with
"nobarrier". Barrier support will flush the write back cache at the
appropriate times (such as on XFS log writes). "
http://xfs.org/index.php/XFS_FAQ#Write_barrier_support.

>=A0fsync() will then take time - and it will slow down programs that w=
ait for fsync().
>
> I've not done (or seen) any benchmarks on this, and I don't think it =
will be
> noticeable to most users. =A0But it's a typical tradeoff - if you are=
 looking
> for high reliability even with power failures or OS crashes, then you=
 pay
> for it in some kinds of performance.
>
>
>>> The other problem with raid10 layout is booting - bootloaders don't=
 much
>>> like it. =A0The very latest version of grub, IIRC, can boot from ra=
id10 -
>>> but it can be awkward. =A0There are lots of how-tos around the web =
for
>>> booting when you have raid, but by far the easiest is to divide you=
r
>>> disks into partitions:
>>>
>>> sdX1 =3D 1GB
>>> sdX2 =3D xGB
>>> sdX3 =3D yGB
>>>
>>> Put all your sdX1 partitions together as raid1 with metadata layout
>>> 0.90, format as ext3 and use it as /boot. =A0Any bootloader will wo=
rk fine
>>> with that (don't forget to install grub on each disk's MBR).
>>>
>>> Put your sdX2 partitions together as raid10,f2 for swap.
>>>
>>> Put the sdX3 partitions together as raid10,f2 for everything else. =
=A0The
>>> most flexible choice is to use LVM here and make logical partitions=
 for
>>> /, /home, /usr, etc. =A0But you can also partition up the md device=
 in
>>> distinct fixed partitions for /, /home, etc. if you want.
>>
>> there is a similar layout of your disks described in
>>
>> https://raid.wiki.kernel.org/index.php/Preventing_against_a_failing_=
disk
>>
>
> They've stolen my ideas! =A0Actually, I think this setup is fairly ob=
vious
> when you think through the workings of raid and grub, and it's not
> surprising that more than one person has independently picked the sam=
e
> arrangement.
>
>>> Don't try and make sdX3 and sdX4 groups and raids for separate / an=
d
>>> /home (unless you want to use different raid levels for these two
>>> groups). =A0Your disks are faster near the start (at the outer edge=
 of the
>>> disk), so you get the best speed by making the raid10,f2 from almos=
t the
>>> whole disk.
>>
>> Hmm, I think the root partition actually would have more accesses th=
an
>> /home and other partitions, so it may be beneficial to give the fast=
est
>> disk sectors to a separate root partition. Comments?
>>
>
> If you make the root logical volume first, then the home logical volu=
me (or
> fixed partitions within the raid), then you will automatically get fa=
ster
> access for it. =A0The arrangement on the disk (for a two disk raid10,=
far) will
> then be:
>
> Boot1 SwapA1 SwapB2 RootA1 HomeA1 <spareA1> RootB2 HomeB2 <spareB2>
> Boot2 SwapB1 SwapA2 RootB1 HomeB1 <spareB1> RootA2 HomeA2 <spareA2>
>
> Here "A" and "B" are stripes, while "1" and "2" are copies.
>
> <spare> is unallocated LVM space.
>
> Since Boot is very small, it negligible for performance - it doesn't =
matter
> that it takes the fastest few tracks. =A0Swap gets as high speed as t=
he disk
> can support. =A0Then root will be faster than home, but both will sti=
ll be
> better than the disk's average speed since one copy of the data is wi=
thin
> the outer half of the disk.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
