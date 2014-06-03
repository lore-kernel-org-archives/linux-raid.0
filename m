From: David Brown <david.brown@hesbynett.no>
Subject: Re: Home desktop/server RAID upgrade
Date: Tue, 03 Jun 2014 09:58:33 +0200
Message-ID: <538D8029.5050404@hesbynett.no>
References: <CAK2H+ef2YNuy9aoipDjYGWJKMi=soW393dKz00iMN8cUuBd+Og@mail.gmail.com>	<20140530212907.0b00e8a3@netstation>	<CAK2H+efDHKGVEdNHUXcDjbHSLKBLDu-DZTTxH9aN2vt+TLHy3A@mail.gmail.com>	<5389B463.5020100@hesbynett.no>	<8mtskybo2j1i4l2bqu51l7ll.1401554092920@email.android.com>	<CAK2H+ecb=HXRKgcguyRF_V0peoN9BPKb81e4rye1+xzONfLe0w@mail.gmail.com>	<538B4173.3030202@hesbynett.no> <CAK2H+ecPFA4yOm+PWoq-jF20KJh1xMKqyRB0WOTdFAVE7t0W1A@mail.gmail.com> <538D0306.8060608@hesbynett.no> <E78FE8BDBAD07C43A60163E7D1716EEC01839CFA3D@PROSIS-W2K8-1.prosis.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E78FE8BDBAD07C43A60163E7D1716EEC01839CFA3D@PROSIS-W2K8-1.prosis.local>
Sender: linux-raid-owner@vger.kernel.org
To: Craig Curtin <craigc@prosis.com.au>, Mark Knecht <markknecht@gmail.com>
Cc: "L.M.J" <linuxmasterjedi@free.fr>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

It's not that SSD's are /bad/ for VM images - it is simply that they ar=
e
not so much better than HD's that they are worth the money.  VM files
are big - it costs a lot to get that much SSD space, so you have to be
sure that the faster IOPs and faster random access is actually worth
that cost.  SSD's are not significantly faster in bandwidth than HD's -
for the price of one high throughput SSD, you can buy four HD's in
raid10,f2 with a higher throughput.

The OP needs HD's for the space.  So the question is whether he should
spend additional money on two good quality SSDs - or should he spend it
on an extra HD, more ram, and perhaps a little UPS?  (I'm assuming he
has a limited budget.)

I don't think the IOPs rate of SSDs will make such a difference over th=
e
layers of indirection - Windows on the VM's, the VM's disk caching
system, the VM image file format, the caches on the host ram, the raid
layers, etc.  These all conspire to add latency and reduce the peak IOP=
s
- within the VM, you are never going to see anything like the SSD's
theoretical IOPs rate.  You will get a little higher IOPs than with HD'=
s
at the back end, but not much more.  The VM's will see high IOP's if an=
d
only if the data is in ram cache somewhere, regardless of the disk type
- so more ram will always help.

Of course, there are other reasons you might prefer SSD's - size, space=
,
power, noise, reliability, etc.

mvh.,

David



On 03/06/14 01:13, Craig Curtin wrote:
> Dave,
>=20
> What part of a VM is not ideally suited to running from SSDs. The
> right SSDs support a high level of IOPS (much higher sustained that
> any SATA based RAID array is going to get to) and has he has
> predefined (preallocated/thick) disks already defined for the VMs
> they are ideal candidates to move onto SSDs.
>=20
> As a real world example - I have 4 HP N40L microservers running in a
> VMware Cluster at home - they all source their VMs from another N40L
> that has a HP P410 RAID controller in it and dual gigabit Ethernet
> ports.
>=20
> The box running as the disk store is running Centos 6.3.
>=20
> It has two RAID sets defined on the P410 - a pair of Samsung EVO
> 240GB SSDs in RAID 1 and 4 x WD (Enterprise Series) 500GB SATA drives
> in RAID0+1
>=20
> I can categorically state that the throughput from the SSD VMs is
> approx. 4 times more than I can sustain to the SATA drives - the SATA
> drives come out at around 1/2 the throughput of a single Gigabit card
> whilst the SSDs flood both channels of the card. You can also see the
> point where the cache on the controller is flooded when writing to
> the SATA drives as everything slows down - whereas with the SSDs this
> never happens. This is doing disk intensive operations like live
> state migrating VMs etc.
>=20
> Craig
>=20
> -----Original Message----- From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Brown=20
> Sent: Tuesday, 3 June 2014 9:05 AM To: Mark Knecht Cc: Craig Curtin;
> L.M.J; Linux-RAID Subject: Re: Home desktop/server RAID upgrade
>=20
> Hi Mark,
>=20
> I would say forget the SSD's - they are not ideal for VM files, and I
> don't think they would be worth the cost.  Raid 10 (any arrangement)
> is likely to give the best speed for such files, and would do a lot
> better than raid 6.  Raid 10,f2 is probably a good choice - but you
> might want to test things out a bit if that is possible.
>=20
> I don't know how much ram you've got in the machine, but if you can
> afford more, it will always help (especially if you make sure the
> VM's use the host's cache rather than direct writes).
>=20
> mvh.,
>=20
> David
>=20
>=20
> On 01/06/14 17:59, Mark Knecht wrote:
>> David, You are correct and I'm sorry I didn't do that. I started
>> this question on a Gentoo list where I put a lot more information
>> about the machine/ When I came here I should have included more.
>>=20
>> The machine is used 7 days a week. I'm self employed writing=20
>> software analyzing the stock & futures markets. Most of it is
>> written in R in Linux, some of it in proprietary languages in
>> Windows. Some of it is quite computational but mostly it's just
>> looking at a _lot_ of locally stored financial data. Almost all
>> financial data is currently stored on the machine in Linux in ext4.
>> Over the past year this data has been growing at around 30GB/month.
>> With 100GB left on my current RAID6 I don't have much time before
>> I'm full.
>>=20
>> When I'm actually trading in the market I have a few Virtualbox VMs
>> running Windows 7. They aren't overly large in terms of disk
>> space. (Currently about 150GB total.) The VMs are each stored in
>> massive single files which I suspect basically represent a hard
>> drive to Virtualbox. I have no idea what size any IO might be
>> coming from the VM. The financial data in the previous paragraph is
>> available to these Windows VMs as a network mount from the Windows
>> perspective. Read & write speeds of this data in Windows is not
>> overly high.
>>=20
>> These VMs are the area where my current RAID6 (5 drive, 16k chunk=20
>> size) seems to have been a bad decision. The machine is powered
>> off every night. Loading these VMs takes at least 10-15 minutes
>> each morning where I see disk activity lights just grinding away
>> the whole time. If I had a single _performance_ goal in upgrading
>> the disks it would be to improve this significantly. Craig's SSD
>> RAID1 suggestion would certainly help here but at 240GB there
>> wouldn't be a lot of room left. That may be OK though.
>>=20
>> The last area is video storage. Write speed is unimportant, read=20
>> speeds are quite low. Over time I hope to migrate it off to a NAS
>> box but for now this is where it's stored. This is currently using
>> about 1/2 the storage my RAID6 provides.
>>=20
>> Most important to me is data safety. I currently do weekly=20
>> rotational backups to a couple of USB drives. I have no real-time=20
>> issues at all if the machine goes down. I have 2 other machines I
>> can do day-to-day work on while I fix this machine. What I am most=20
>> concerned about is not losing anything more than a couple of
>> previous days work. If I took a week to rebuild  the machine after
>> a failure it's pretty much a non-issue to me.
>>=20
>> Thanks, Mark
>>=20
>> On Sun, Jun 1, 2014 at 8:06 AM, David Brown
>> <david.brown@hesbynett.no> wrote:
>>> Hi Mark,
>>>=20
>>> What would be really useful here is a description of what you=20
>>> actually /want/.  What do you want to do with these drives?
>>> What sort of files are they - big or small?  Do you need fast
>>> access for large files?  Do you need fast access for many files
>>> in parallel? How important is the data?  How important is uptime?
>>> What sort of backups do you have?  What will the future be like -
>>> are you making one big system to last for the foreseeable future,
>>> or do you need something that can easily be expanded?  Are you
>>> looking for "fun, interesting and modern" or "boring but
>>> well-tested" solutions?
>>>=20
>>> Then you need to make a list of the hardware you have, or the
>>> budget for new hardware.
>>>=20
>>> Without know at least roughly what you are looking for, it's easy
>>> to end up with expensive SSDs because they are "cool", even
>>> though you might get more speed for your money with a couple of
>>> slow rust disks and a bit more ram in your system.  It may be
>>> that there is no need for any sort of raid at all - perhaps one
>>> big main disk is fine, and the rest of the money spent on a
>>> backup disk (possibly external) with rsync'd copies of your data.
>>> This would mean longer downtime if your main disk failed - but it
>>> also gives some protection against user error.
>>>=20
>>> And perhaps btrfs with raid1 would be the best choice.
>>>=20
>>> A raid10,f2 is often the best choice for desktops or
>>> workstations with 2 or 3 hard disks, but it is not necessarily
>>> /the/ best choice.
>>>=20
>>> mvh.,
>>>=20
>>> David
>>>=20
>>>=20
>>>=20
>>> On 01/06/14 16:25, Mark Knecht wrote:
>>>>=20
>>>> Hi Craig, Responding to both you and David Brown. Thanks for
>>>> your ideas.
>>>>=20
>>>> - Mark
>>>>=20
>>>> On Sat, May 31, 2014 at 9:40 AM, Craig Curtin
>>>> <craigc@prosis.com.au> wrote:
>>>>>=20
>>>>> It sounds like the op has additional data ports on his MOBO
>>>>> - wouldn't he be better off looking at a couple of SSDs in
>>>>> raid 1 for his OS, swap etc and his VMs and then leave the
>>>>> rest for data as raid5 - By moving the things from the
>>>>> existing drives he gets back space and only purchases a
>>>>> couple of good sized fast SSDs now
>>>>>=20
>>>>=20
>>>> It's a possibility. I can get 240GB SSDs in the $120 range so
>>>> that's $240 for RAID1. If I take the five existing 500GB drives
>>>> and reconfigure for RAID5 that's 2TB. Overall it's not bad
>>>> going from 1.4TB to about 2.2TB but being it's not all one big
>>>> disk I'll likely never use it all as efficiently. Still, it's
>>>> an option.
>>>>=20
>>>> I do in fact have extra ports:
>>>>=20
>>>> c2RAID6 ~ # lspci | grep SATA 00:1f.2 IDE interface: Intel
>>>> Corporation 82801JI (ICH10 Family) 4 port SATA IDE Controller
>>>> #1 00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10
>>>> Family) 2 port SATA IDE Controller #2 03:00.0 SATA controller:
>>>> Marvell Technology Group Ltd. 88SE9123 PCIe SATA 6.0 Gb/s
>>>> controller (rev 11) 06:00.0 SATA controller: JMicron Technology
>>>> Corp. JMB363 SATA/IDE Controller (rev 03) 06:00.1 IDE
>>>> interface: JMicron Technology Corp. JMB363 SATA/IDE Controller
>>>> (rev 03) c2RAID6 ~ #
>>>>=20
>>>> Currently my 5-drive RAID6 uses 5 of the Intel ports. The 6th
>>>> port goes to the CD/DVD drive. Some time ago I bought the SATA3
>>>> Marvell card and a smaller (120GB) SSD. I put Gentoo on it and
>>>> played around a bit but I've never really used it day-to-day.
>>>> Part of my 2-drive RAID1 thinking was that I could build the
>>>> new RAID1 on the SATA3 controller not even touch the existing
>>>> RAID6. If it works reliably on that controller I'd be done and
>>>> have 3TB.
>>>>=20
>>>> I think David's RAID10 3-drive solution could possibly work if
>>>> I buy 3 of the lower cost new WD drives. I'll need to think
>>>> about that. Not sure.
>>>>=20
>>>> Thanks, Mark
>>>>=20
>>>>=20
>>>> On Sat, May 31, 2014 at 9:40 AM, Craig Curtin
>>>> <craigc@prosis.com.au> wrote:
>>>>>=20
>>>>> It sounds like the op has additional data ports on his MOBO
>>>>> - wouldn't he be better off looking at a couple of SSDs in
>>>>> raid 1 for his OS, swap etc and his VMs and then leave the
>>>>> rest for data as raid5 - By moving the things from the
>>>>> existing drives he gets back space and only purchases a
>>>>> couple of good sized fast SSDs now
>>>>>=20
>>>>>=20
>>>>> Sent from my Samsung tablet
>>>>>=20
>>>>> .
>>>>>=20
>>>>>=20
>>>>> -------- Original message -------- From: David Brown=20
>>>>> Date:31/05/2014 21:01 (GMT+10:00) To: Mark Knecht ,"L.M.J"=20
>>>>> Cc: Linux-RAID Subject: Re: Home desktop/server RAID upgrade
>>>>>=20
>>>>> On 30/05/14 22:14, Mark Knecht wrote:
>>>>>>=20
>>>>>> On Fri, May 30, 2014 at 12:29 PM, L.M.J
>>>>>> <linuxmasterjedi@free.fr> wrote:
>>>>>>>=20
>>>>>>> Le Fri, 30 May 2014 12:04:07 -0700, Mark Knecht=20
>>>>>>> <markknecht@gmail.com> a =C3=A9crit :
>>>>>>>=20
>>>>>>>> In a RAID1 would a 3-drive Red RAID1 possibly be faster
>>>>>>>> than the 2-drive Se RAID1 and at the same time give me
>>>>>>>> more safety?
>>>>>>>=20
>>>>>>>=20
>>>>>>> Just a question inside the question : how do you manager
>>>>>>> a RAID1 with 3 drives ? Maybe you're talking about RAID5
>>>>>>> then ?
>>>>>>=20
>>>>>>=20
>>>>>> OK, I'm no RAID expert but RAID1 is just drives in parallel
>>>>>> right. 2 drives, 3 drives, 4 drives, all holding exactly
>>>>>> the same data. In the case of a 3-drive RAID1 - if there is
>>>>>> such a beast - I could safely lose 2 drives. You ask a
>>>>>> reasonable question though as maybe the way this is
>>>>>> actually done is 2 drives + a hot spare in the box that
>>>>>> gets sync'ed if and only if one drive fails. Not sure and
>>>>>> maybe I'm totally wrong about that.
>>>>>>=20
>>>>>> A 3-drive RAID5 would be 2 drives in series - in this case
>>>>>> making 6TB - and then the 3rd drive being the redundancy.
>>>>>> In the case of a 3-drive RAID5 I could safely lose 1
>>>>>> drive.
>>>>>>=20
>>>>>> In my case I don't need more than 3TB, so an option would
>>>>>> be a 3-drive RAID5 made out of 2TB drives which would give
>>>>>> me 4TB but I don't need the space as much as I want the
>>>>>> redundancy and I think RAID5 is slower than RAID1.
>>>>>> Additionally some more mdadm RAID knowledgeable people on
>>>>>> other lists say Linux mdadm RAID1 would be faster as it
>>>>>> will get data from more than one drive at a time. (Or=20
>>>>>> possibly get data from which ever drive returns it the
>>>>>> fastest. Not sure.)
>>>>>>=20
>>>>>> I believe one good option if I wanted 4 physical drives
>>>>>> would be RAID10 but that's getting more complicated again
>>>>>> which I didn't really want to do.
>>>>>>=20
>>>>>> So maybe it is just 2 drives and the 3 drive version isn't
>>>>>> even a possibility? Could be.
>>>>>=20
>>>>>=20
>>>>> With 3 drives, you have several possibilities.
>>>>>=20
>>>>> Raid5 makes "stripes" across the three drives, with 2 parts
>>>>> holding data and one part holding parity to provide
>>>>> redundancy.
>>>>>=20
>>>>> Raid1 is commonly called "mirroring", because you get the
>>>>> same data on each disk.  md raid has no problem making a
>>>>> 3-way mirror, so that each disk is identical.  This gives you
>>>>> excellent redundancy, and you can make three different reads
>>>>> in parallel - but writes have to go to each disk, which can
>>>>> be a little slower than using 2 disks.  It's not often that
>>>>> people need that level of redundancy.
>>>>>=20
>>>>> Another option with md raid is the raid10 setups.  For many
>>>>> uses, the fastest arrangement is raid10,f2.  This means there
>>>>> is two copies of all your data (f3 would be three copies),
>>>>> with a "far" layout.
>>>>>=20
>>>>> <http://en.wikipedia.org/wiki/Linux_MD_RAID_10#LINUX-MD-RAID-10>
>>>>>
>>>>>
>>>>>=20
With this arrangement, reads are striped across all three disks,
>>>>> which is fast for large reads.  Small reads can be handled
>>>>> in parallel.  Most reads while be handled from the outer half
>>>>> of the disk, which is faster and needs less head movement -
>>>>> so reading is on average faster than a raid0 on the same
>>>>> disks.  Small writes are fast, but large writes require quite
>>>>> a bit of head movement to get everything written twice to
>>>>> different parts of the disks.
>>>>>=20
>>>>> The "best" option always depends on your needs - how you want
>>>>> to access your files.  A layout geared to fast striped reads
>>>>> of large files will be poorer for parallel small writes, and
>>>>> vice versa. raid10,f2 is often the best choice for a desktop
>>>>> or small system - but it is not very flexible if you later
>>>>> want to add new disks or replace the disks with bigger ones.
>>>>>=20
>>>>> md raid is flexible enough that it will even let you make a 3
>>>>> disk raid6 array if you want - but a 3-way raid1 mirror will
>>>>> give you the same disk space and much better performance.
>>>>>=20
>>>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
