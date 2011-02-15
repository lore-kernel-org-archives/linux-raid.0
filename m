From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: high throughput storage server?
Date: Tue, 15 Feb 2011 14:44:43 -0200
Message-ID: <AANLkTim4cdNjk0Avw-TgvvSKK7GpkpJYRKq5BUEG_6wm@mail.gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
	<4D5A8415.5000905@gmail.com>
	<AANLkTimT=JLvBTU52aZDYC5gwryXmsp4F+WbzsJNbSCC@mail.gmail.com>
	<27EC7D7C61444EC6A29D95E88A8AF2AC@ManiePC>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27EC7D7C61444EC6A29D95E88A8AF2AC@ManiePC>
Sender: linux-raid-owner@vger.kernel.org
To: "A. Krijgsman" <a.krijgsman@draftsman.nl>
Cc: Zdenek Kaspar <zkaspar82@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

10Gbyte ~ 80Gbit, i don=B4t know if 50Gbit is possible
you have SO cpu time to read and write many things not just memory,
check filesystem cache, etc. etc. etc., maybe you can=B4t get this spee=
d
with just 80Gbit memory

2011/2/15 A. Krijgsman <a.krijgsman@draftsman.nl>:
> Just ran memcheck 2 weeks ago.
>
> If you triple-lane your memory you get 10GByte (!) per second memory.
> ( This is memory from 2010 ;-) 1333 Mhz )
>
> -----Oorspronkelijk bericht----- From: Roberto Spadim Sent: Tuesday,
> February 15, 2011 3:29 PM To: Zdenek Kaspar Cc: linux-raid@vger.kerne=
l.org
> Subject: Re: high throughput storage server?
> first, run memtest86 (if you use x86 cpu)
> check ram memory speed
> my hp (ml350g5 very old: 2005) get 2500MB/s (~20 Gbits/s)
>
> maybe ram is a bottleneck for 50gbits....
> you will need a multi computer raid or stripe fileaccess operations
> (database on one machine, s.o. on another...)
>
> for hobby =3D SATA2 disks, 50USD disks of 1TB 50MB/s
> the today state of art, in 'my world' is: http://www.ramsan.com/produ=
cts/3
>
>
> 2011/2/15 Zdenek Kaspar <zkaspar82@gmail.com>:
>>
>> Dne 15.2.2011 0:59, Matt Garman napsal(a):
>>>
>>> For many years, I have been using Linux software RAID at home for a
>>> simple NAS system. =A0Now at work, we are looking at buying a massi=
ve,
>>> high-throughput storage system (e.g. a SAN). =A0I have little
>>> familiarity with these kinds of pre-built, vendor-supplied solution=
s.
>>> I just started talking to a vendor, and the prices are extremely hi=
gh.
>>>
>>> So I got to thinking, perhaps I could build an adequate device for
>>> significantly less cost using Linux. =A0The problem is, the require=
ments
>>> for such a system are significantly higher than my home media serve=
r,
>>> and put me into unfamiliar territory (in terms of both hardware and
>>> software configuration).
>>>
>>> The requirement is basically this: around 40 to 50 compute machines
>>> act as basically an ad-hoc scientific compute/simulation/analysis
>>> cluster. =A0These machines all need access to a shared 20 TB pool o=
f
>>> storage. =A0Each compute machine has a gigabit network connection, =
and
>>> it's possible that nearly every machine could simultaneously try to
>>> access a large (100 to 1000 MB) file in the storage pool. =A0In oth=
er
>>> words, a 20 TB file store with bandwidth upwards of 50 Gbps.
>>>
>>> I was wondering if anyone on the list has built something similar t=
o
>>> this using off-the-shelf hardware (and Linux of course)?
>>>
>>> My initial thoughts/questions are:
>>>
>>> =A0 =A0(1) We need lots of spindles (i.e. many small disks rather t=
han
>>> few big disks). =A0How do you compute disk throughput when there ar=
e
>>> multiple consumers? =A0Most manufacturers provide specs on their dr=
ives
>>> such as sustained linear read throughput. =A0But how is that number
>>> affected when there are multiple processes simultanesously trying t=
o
>>> access different data? =A0Is the sustained bulk read throughput val=
ue
>>> inversely proportional to the number of consumers? =A0(E.g. 100 MB/=
s
>>> drive only does 33 MB/s w/three consumers.) =A0Or is there are more
>>> specific way to estimate this?
>>>
>>> =A0 =A0(2) The big storage server(s) need to connect to the network=
 via
>>> multiple bonded Gigabit ethernet, or something faster like
>>> FibreChannel or 10 GbE. =A0That seems pretty straightforward.
>>>
>>> =A0 =A0(3) This will probably require multiple servers connected to=
gether
>>> somehow and presented to the compute machines as one big data store=
=2E
>>> This is where I really don't know much of anything. =A0I did a quic=
k
>>> "back of the envelope" spec for a system with 24 600 GB 15k SAS dri=
ves
>>> (based on the observation that 24-bay rackmount enclosures seem to =
be
>>> fairly common). =A0Such a system would only provide 7.2 TB of stora=
ge
>>> using a scheme like RAID-10. =A0So how could two or three of these
>>> servers be "chained" together and look like a single large data poo=
l
>>> to the analysis machines?
>>>
>>> I know this is a broad question, and not 100% about Linux software
>>> RAID. =A0But I've been lurking on this list for years now, and I ge=
t the
>>> impression there are list members who regularly work with "big iron=
"
>>> systems such as what I've described. =A0I'm just looking for any ki=
nd of
>>> relevant information here; any and all is appreciated!
>>>
>>> Thank you,
>>> Matt
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>> If you really need to handle 50Gbit/s storage traffic, then it's not=
 so
>> easy for hobby. For good price you probably want multiple machines w=
ith
>> lots hard drives and interconnects..
>>
>> Might be worth to ask here:
>> Newsgroups: gmane.comp.clustering.beowulf.general
>>
>> HTH, Z.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
