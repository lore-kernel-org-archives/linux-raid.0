From: David Brown <david.brown@hesbynett.no>
Subject: Re: Home desktop/server RAID upgrade
Date: Tue, 03 Jun 2014 01:04:38 +0200
Message-ID: <538D0306.8060608@hesbynett.no>
References: <CAK2H+ef2YNuy9aoipDjYGWJKMi=soW393dKz00iMN8cUuBd+Og@mail.gmail.com>	<20140530212907.0b00e8a3@netstation>	<CAK2H+efDHKGVEdNHUXcDjbHSLKBLDu-DZTTxH9aN2vt+TLHy3A@mail.gmail.com>	<5389B463.5020100@hesbynett.no>	<8mtskybo2j1i4l2bqu51l7ll.1401554092920@email.android.com>	<CAK2H+ecb=HXRKgcguyRF_V0peoN9BPKb81e4rye1+xzONfLe0w@mail.gmail.com>	<538B4173.3030202@hesbynett.no> <CAK2H+ecPFA4yOm+PWoq-jF20KJh1xMKqyRB0WOTdFAVE7t0W1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ecPFA4yOm+PWoq-jF20KJh1xMKqyRB0WOTdFAVE7t0W1A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Craig Curtin <craigc@prosis.com.au>, "L.M.J" <linuxmasterjedi@free.fr>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mark,

I would say forget the SSD's - they are not ideal for VM files, and I=20
don't think they would be worth the cost.  Raid 10 (any arrangement) is=
=20
likely to give the best speed for such files, and would do a lot better=
=20
than raid 6.  Raid 10,f2 is probably a good choice - but you might want=
=20
to test things out a bit if that is possible.

I don't know how much ram you've got in the machine, but if you can=20
afford more, it will always help (especially if you make sure the VM's=20
use the host's cache rather than direct writes).

mvh.,

David


On 01/06/14 17:59, Mark Knecht wrote:
> David,
>     You are correct and I'm sorry I didn't do that. I started this
> question on a Gentoo list where I put a lot more information about th=
e
> machine/ When I came here I should have included more.
>
>     The machine is used 7 days a week. I'm self employed writing
> software analyzing the stock & futures markets. Most of it is written
> in R in Linux, some of it in proprietary languages in Windows. Some o=
f
> it is quite computational but mostly it's just looking at a _lot_ of
> locally stored financial data. Almost all financial data is currently
> stored on the machine in Linux in ext4. Over the past year this data
> has been growing at around 30GB/month. With 100GB left on my current
> RAID6 I don't have much time before I'm full.
>
>     When I'm actually trading in the market I have a few Virtualbox V=
Ms
> running Windows 7. They aren't overly large in terms of disk space.
> (Currently about 150GB total.) The VMs are each stored in massive
> single files which I suspect basically represent a hard drive to
> Virtualbox. I have no idea what size any IO might be coming from the
> VM. The financial data in the previous paragraph is available to thes=
e
> Windows VMs as a network mount from the Windows perspective. Read &
> write speeds of this data in Windows is not overly high.
>
>     These VMs are the area where my current RAID6 (5 drive, 16k chunk
> size) seems to have been a bad decision. The machine is powered off
> every night. Loading these VMs takes at least 10-15 minutes each
> morning where I see disk activity lights just grinding away the whole
> time. If I had a single _performance_ goal in upgrading the disks it
> would be to improve this significantly. Craig's SSD RAID1 suggestion
> would certainly help here but at 240GB there wouldn't be a lot of roo=
m
> left. That may be OK though.
>
>     The last area is video storage. Write speed is unimportant, read
> speeds are quite low. Over time I hope to migrate it off to a NAS box
> but for now this is where it's stored. This is currently using about
> 1/2 the storage my RAID6 provides.
>
>     Most important to me is data safety. I currently do weekly
> rotational backups to a couple of USB drives. I have no real-time
> issues at all if the machine goes down. I have 2 other machines I can
> do day-to-day work on while I fix this machine. What I am most
> concerned about is not losing anything more than a couple of previous
> days work. If I took a week to rebuild  the machine after a failure
> it's pretty much a non-issue to me.
>
> Thanks,
> Mark
>
> On Sun, Jun 1, 2014 at 8:06 AM, David Brown <david.brown@hesbynett.no=
> wrote:
>> Hi Mark,
>>
>> What would be really useful here is a description of what you actual=
ly
>> /want/.  What do you want to do with these drives?  What sort of fil=
es are
>> they - big or small?  Do you need fast access for large files?  Do y=
ou need
>> fast access for many files in parallel?  How important is the data? =
 How
>> important is uptime?  What sort of backups do you have?  What will t=
he
>> future be like - are you making one big system to last for the fores=
eeable
>> future, or do you need something that can easily be expanded?  Are y=
ou
>> looking for "fun, interesting and modern" or "boring but well-tested=
"
>> solutions?
>>
>> Then you need to make a list of the hardware you have, or the budget=
 for new
>> hardware.
>>
>> Without know at least roughly what you are looking for, it's easy to=
 end up
>> with expensive SSDs because they are "cool", even though you might g=
et more
>> speed for your money with a couple of slow rust disks and a bit more=
 ram in
>> your system.  It may be that there is no need for any sort of raid a=
t all -
>> perhaps one big main disk is fine, and the rest of the money spent o=
n a
>> backup disk (possibly external) with rsync'd copies of your data.  T=
his
>> would mean longer downtime if your main disk failed - but it also gi=
ves some
>> protection against user error.
>>
>> And perhaps btrfs with raid1 would be the best choice.
>>
>> A raid10,f2 is often the best choice for desktops or workstations wi=
th 2 or
>> 3 hard disks, but it is not necessarily /the/ best choice.
>>
>> mvh.,
>>
>> David
>>
>>
>>
>> On 01/06/14 16:25, Mark Knecht wrote:
>>>
>>> Hi Craig,
>>>      Responding to both you and David Brown. Thanks for your ideas.
>>>
>>> - Mark
>>>
>>> On Sat, May 31, 2014 at 9:40 AM, Craig Curtin <craigc@prosis.com.au=
>
>>> wrote:
>>>>
>>>> It sounds like the op has additional data ports on his MOBO - woul=
dn't he
>>>> be
>>>> better off looking at a couple of SSDs in raid 1 for his OS, swap =
etc and
>>>> his VMs and then leave the rest for data as raid5 - By moving the =
things
>>>> from the existing drives he gets back space and only purchases a c=
ouple
>>>> of
>>>> good sized fast SSDs now
>>>>
>>>
>>> It's a possibility. I can get 240GB SSDs in the $120 range so that'=
s
>>> $240 for RAID1. If I take the five existing 500GB drives and
>>> reconfigure for RAID5 that's 2TB. Overall it's not bad going from
>>> 1.4TB to about 2.2TB but being it's not all one big disk I'll likel=
y
>>> never use it all as efficiently. Still, it's an option.
>>>
>>> I do in fact have extra ports:
>>>
>>> c2RAID6 ~ # lspci | grep SATA
>>> 00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 p=
ort
>>> SATA IDE Controller #1
>>> 00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 p=
ort
>>> SATA IDE Controller #2
>>> 03:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9123 PCI=
e
>>> SATA 6.0 Gb/s controller (rev 11)
>>> 06:00.0 SATA controller: JMicron Technology Corp. JMB363 SATA/IDE
>>> Controller (rev 03)
>>> 06:00.1 IDE interface: JMicron Technology Corp. JMB363 SATA/IDE
>>> Controller (rev 03)
>>> c2RAID6 ~ #
>>>
>>> Currently my 5-drive RAID6 uses 5 of the Intel ports. The 6th port
>>> goes to the CD/DVD drive. Some time ago I bought the SATA3 Marvell
>>> card and a smaller (120GB) SSD. I put Gentoo on it and played aroun=
d a
>>> bit but I've never really used it day-to-day. Part of my 2-drive RA=
ID1
>>> thinking was that I could build the new RAID1 on the SATA3 controll=
er
>>> not even touch the existing RAID6. If it works reliably on that
>>> controller I'd be done and have 3TB.
>>>
>>> I think David's RAID10 3-drive solution could possibly work if I bu=
y 3
>>> of the lower cost new WD drives. I'll need to think about that. Not
>>> sure.
>>>
>>> Thanks,
>>> Mark
>>>
>>>
>>> On Sat, May 31, 2014 at 9:40 AM, Craig Curtin <craigc@prosis.com.au=
>
>>> wrote:
>>>>
>>>> It sounds like the op has additional data ports on his MOBO - woul=
dn't he
>>>> be
>>>> better off looking at a couple of SSDs in raid 1 for his OS, swap =
etc and
>>>> his VMs and then leave the rest for data as raid5 - By moving the =
things
>>>> from the existing drives he gets back space and only purchases a c=
ouple
>>>> of
>>>> good sized fast SSDs now
>>>>
>>>>
>>>> Sent from my Samsung tablet
>>>>
>>>> .
>>>>
>>>>
>>>> -------- Original message --------
>>>> From: David Brown
>>>> Date:31/05/2014 21:01 (GMT+10:00)
>>>> To: Mark Knecht ,"L.M.J"
>>>> Cc: Linux-RAID
>>>> Subject: Re: Home desktop/server RAID upgrade
>>>>
>>>> On 30/05/14 22:14, Mark Knecht wrote:
>>>>>
>>>>> On Fri, May 30, 2014 at 12:29 PM, L.M.J <linuxmasterjedi@free.fr>
>>>>> wrote:
>>>>>>
>>>>>> Le Fri, 30 May 2014 12:04:07 -0700, Mark Knecht
>>>>>> <markknecht@gmail.com> a =C3=A9crit :
>>>>>>
>>>>>>> In a RAID1 would a 3-drive Red RAID1 possibly be faster than th=
e
>>>>>>> 2-drive Se RAID1 and at the same time give me more safety?
>>>>>>
>>>>>>
>>>>>> Just a question inside the question : how do you manager a RAID1
>>>>>> with 3 drives ? Maybe you're talking about RAID5 then ?
>>>>>
>>>>>
>>>>> OK, I'm no RAID expert but RAID1 is just drives in parallel right=
=2E 2
>>>>> drives, 3 drives, 4 drives, all holding exactly the same data. In
>>>>> the case of a 3-drive RAID1 - if there is such a beast - I could
>>>>> safely lose 2 drives. You ask a reasonable question though as may=
be
>>>>> the way this is actually done is 2 drives + a hot spare in the bo=
x
>>>>> that gets sync'ed if and only if one drive fails. Not sure and ma=
ybe
>>>>> I'm totally wrong about that.
>>>>>
>>>>> A 3-drive RAID5 would be 2 drives in series - in this case making
>>>>> 6TB - and then the 3rd drive being the redundancy. In the case of=
 a
>>>>> 3-drive RAID5 I could safely lose 1 drive.
>>>>>
>>>>> In my case I don't need more than 3TB, so an option would be a
>>>>> 3-drive RAID5 made out of 2TB drives which would give me 4TB but =
I
>>>>> don't need the space as much as I want the redundancy and I think
>>>>> RAID5 is slower than RAID1. Additionally some more mdadm RAID
>>>>> knowledgeable people on other lists say Linux mdadm RAID1 would b=
e
>>>>> faster as it will get data from more than one drive at a time. (O=
r
>>>>> possibly get data from which ever drive returns it the fastest. N=
ot
>>>>> sure.)
>>>>>
>>>>> I believe one good option if I wanted 4 physical drives would be
>>>>> RAID10 but that's getting more complicated again which I didn't
>>>>> really want to do.
>>>>>
>>>>> So maybe it is just 2 drives and the 3 drive version isn't even a
>>>>> possibility? Could be.
>>>>
>>>>
>>>> With 3 drives, you have several possibilities.
>>>>
>>>> Raid5 makes "stripes" across the three drives, with 2 parts holdin=
g data
>>>> and one part holding parity to provide redundancy.
>>>>
>>>> Raid1 is commonly called "mirroring", because you get the same dat=
a on
>>>> each disk.  md raid has no problem making a 3-way mirror, so that =
each
>>>> disk is identical.  This gives you excellent redundancy, and you c=
an
>>>> make three different reads in parallel - but writes have to go to =
each
>>>> disk, which can be a little slower than using 2 disks.  It's not o=
ften
>>>> that people need that level of redundancy.
>>>>
>>>> Another option with md raid is the raid10 setups.  For many uses, =
the
>>>> fastest arrangement is raid10,f2.  This means there is two copies =
of all
>>>> your data (f3 would be three copies), with a "far" layout.
>>>>
>>>> <http://en.wikipedia.org/wiki/Linux_MD_RAID_10#LINUX-MD-RAID-10>
>>>>
>>>> With this arrangement, reads are striped across all three disks, w=
hich
>>>> is fast for large reads.  Small reads can be handled in parallel. =
 Most
>>>> reads while be handled from the outer half of the disk, which is f=
aster
>>>> and needs less head movement - so reading is on average faster tha=
n a
>>>> raid0 on the same disks.  Small writes are fast, but large writes
>>>> require quite a bit of head movement to get everything written twi=
ce to
>>>> different parts of the disks.
>>>>
>>>> The "best" option always depends on your needs - how you want to a=
ccess
>>>> your files.  A layout geared to fast striped reads of large files =
will
>>>> be poorer for parallel small writes, and vice versa.  raid10,f2 is=
 often
>>>> the best choice for a desktop or small system - but it is not very
>>>> flexible if you later want to add new disks or replace the disks w=
ith
>>>> bigger ones.
>>>>
>>>> md raid is flexible enough that it will even let you make a 3 disk=
 raid6
>>>> array if you want - but a 3-way raid1 mirror will give you the sam=
e disk
>>>> space and much better performance.
>>>>
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
