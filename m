From: David Brown <david@westcontrol.com>
Subject: Re: mdadm raid1 read performance
Date: Thu, 05 May 2011 13:38:31 +0200
Message-ID: <ipu25h$s1b$1@dough.gmane.org>
References: <BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com> <4DC0F2B6.9050708@fnarfbargle.com> <BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com> <BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com> <20110505094538.0cef02cc@notabene.brown> <BANLkTi=W=DNdqOBiGwbu67P1EgoEqNy+sg@mail.gmail.com> <BANLkTimNxTnf2xW8hbEWK2iA6axqjnjT+A@mail.gmail.com> <BANLkTi=2WCfoXTtyRzpBN06ph6HCsy_ShQ@mail.gmail.com> <BANLkTinoK0fhm-a7QAu5UdJNhbRO+mv2Jw@mail.gmail.com> <iptjde$92f$1@dough.gmane.org> <20110505104156.GA11441@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110505104156.GA11441@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/05/2011 12:41, Keld J=F8rn Simonsen wrote:
> On Thu, May 05, 2011 at 09:26:45AM +0200, David Brown wrote:
>> On 05/05/2011 02:40, Liam Kurmos wrote:
>>> Cheers Roberto,
>>>
>>> I've got the gist of the far layout from looking at wikipedia. Ther=
e
>>> is some clever stuff going on that i had never considered.
>>> i'm going for f2 for my system drive.
>>>
>>> Liam
>>>
>>
>> For general use, raid10,f2 is often the best choice.  The only
>> disadvantage is if you have applications that make a lot of synchron=
ised
>> writes, as writes take longer (everything must be written twice, and
>> because the data is spread out there is more head movement).  For mo=
st
>> writes this doesn't matter - the OS caches the writes, and the app
>> continues on its way, so the writes are done when the disks are not
>> otherwise used.  But if you have synchronous writes, so that the app
>> will wait for the write to complete, it will be slower (compared to
>> raid10,n2 or raid10,o2).
>
> Yes syncroneous writes would be significantly slower.
> I have not seen benchmarks on it, tho.
> Which applications typically use syncroneous IO?
> Maybe not that many.
> Do databases do that, eg postgresql and mysql?
>

Database servers do use synchronous writes (or fsync() calls), but I=20
suspect that they won't suffer much if these are slow unless you have a=
=20
great deal of writes - they typically write to the transaction log,=20
fsync(), write to the database files, fsync(), then write to the log=20
again and fsync().  But they will buffer up their writes as needed in a=
=20
separate thread or process - it should not hinder their read processes.

Lots of other applications also use fsync() whenever they want to be=20
sure that data is written to the disk.  A prime example is sqlite, whic=
h=20
is used by many other programs.  If you have your disk systems and file=
=20
systems set up as a typical home user, there is little problem - the=20
disk write caches and file system caches will ensure that the app think=
s=20
the write is complete long before it hits the disk surfaces anyway (thu=
s=20
negating the whole point of using fsync() in the first place...).  But=20
if you have a more paranoid setup, so that your databases or other file=
s=20
will not get corrupted by power fails or OS crashes, then you have writ=
e=20
barriers enabled on the filesystems and write caches disabled on the=20
disks.  fsync() will then take time - and it will slow down programs=20
that wait for fsync().

I've not done (or seen) any benchmarks on this, and I don't think it=20
will be noticeable to most users.  But it's a typical tradeoff - if you=
=20
are looking for high reliability even with power failures or OS crashes=
,=20
then you pay for it in some kinds of performance.


>> The other problem with raid10 layout is booting - bootloaders don't =
much
>> like it.  The very latest version of grub, IIRC, can boot from raid1=
0 -
>> but it can be awkward.  There are lots of how-tos around the web for
>> booting when you have raid, but by far the easiest is to divide your
>> disks into partitions:
>>
>> sdX1 =3D 1GB
>> sdX2 =3D xGB
>> sdX3 =3D yGB
>>
>> Put all your sdX1 partitions together as raid1 with metadata layout
>> 0.90, format as ext3 and use it as /boot.  Any bootloader will work =
fine
>> with that (don't forget to install grub on each disk's MBR).
>>
>> Put your sdX2 partitions together as raid10,f2 for swap.
>>
>> Put the sdX3 partitions together as raid10,f2 for everything else.  =
The
>> most flexible choice is to use LVM here and make logical partitions =
for
>> /, /home, /usr, etc.  But you can also partition up the md device in
>> distinct fixed partitions for /, /home, etc. if you want.
>
> there is a similar layout of your disks described in
>
> https://raid.wiki.kernel.org/index.php/Preventing_against_a_failing_d=
isk
>

They've stolen my ideas!  Actually, I think this setup is fairly obviou=
s=20
when you think through the workings of raid and grub, and it's not=20
surprising that more than one person has independently picked the same=20
arrangement.

>> Don't try and make sdX3 and sdX4 groups and raids for separate / and
>> /home (unless you want to use different raid levels for these two
>> groups).  Your disks are faster near the start (at the outer edge of=
 the
>> disk), so you get the best speed by making the raid10,f2 from almost=
 the
>> whole disk.
>
> Hmm, I think the root partition actually would have more accesses tha=
n
> /home and other partitions, so it may be beneficial to give the faste=
st
> disk sectors to a separate root partition. Comments?
>

If you make the root logical volume first, then the home logical volume=
=20
(or fixed partitions within the raid), then you will automatically get=20
faster access for it.  The arrangement on the disk (for a two disk=20
raid10,far) will then be:

Boot1 SwapA1 SwapB2 RootA1 HomeA1 <spareA1> RootB2 HomeB2 <spareB2>
Boot2 SwapB1 SwapA2 RootB1 HomeB1 <spareB1> RootA2 HomeA2 <spareA2>

Here "A" and "B" are stripes, while "1" and "2" are copies.

<spare> is unallocated LVM space.

Since Boot is very small, it negligible for performance - it doesn't=20
matter that it takes the fastest few tracks.  Swap gets as high speed a=
s=20
the disk can support.  Then root will be faster than home, but both wil=
l=20
still be better than the disk's average speed since one copy of the dat=
a=20
is within the outer half of the disk.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
