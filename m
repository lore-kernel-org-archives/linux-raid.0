From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: External USB-SATA bridge rewriting logical block sizes
Date: Tue, 04 Mar 2014 00:36:35 -0600
Message-ID: <53157473.30801@hardwarefreak.com>
References: <f533c037-b72b-4039-9ef7-f2c61a0de3e6@flaska.net> <53149110.7090008@hardwarefreak.com> <29626b57-c751-4ba7-8774-b45fc090b4b6@flaska.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29626b57-c751-4ba7-8774-b45fc090b4b6@flaska.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Jan_Kundr=E1t?= <jkt@flaska.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/3/2014 9:18 AM, Jan Kundr=E1t wrote:
> On Monday, 3 March 2014 15:26:24 CEST, Stan Hoeppner wrote:
>> Presumably you have some md raid level with fault tolerance, since y=
ou
>> posted this to the linux-raid list.  Why not simply kick the drive f=
rom
>> the array, install it "direct" inside the chassis, repartition it th=
e
>> same as the other members of the array that are direct connected to =
the
>> SATA controller, re-add the partition to the array, and rebuild.
>=20
> Hi Stan, I don't run RAID on these machines. I saw a recent thread
> dealing with 4k drives on this ML which made me hope that this topic
> won't be considered OT here. Sorry if this is not appropriate -- do y=
ou
> happen to know a more suitable ML?

Such an issue should be discussed on either of these two lists:

linux-ide@vger.kernel.org
linux-usb@vger.kernel.org

http://vger.kernel.org/vger-lists.html

>> Why you prepped this drive in it with intention of moving it into th=
e
>> PC chassis leaves me scratching my head.
>=20
> My primary machine is a T420s laptop which has a USB3 port, but no
> eSATA. The throughput I can get from a drive attached there is much
> better than what I can get via network from my other box with plenty =
of
> SATA ports, but only a VIA C7 CPU (even though it has a gigabit NIC).
> Expected, I guess.

So you simply want to be able to access this 4TB drive on both your
T420s and your VIA C7 based desktop/media PC.  The solution to the
current problem is simple:  plug the USB enclosure into one of the PC's
USB ports instead of plugging the bare drive into the SATA cage.
Logical sector size problem solved.

Now, if the C7 PC only has USB 2.0 ports and you demand more throughput
than the ~50MB/s this provides, USB 3.0 PCIe, mini PCIe, and PCI cards
are available.  If your C7 system doesn't have any slots available, the=
n
you're left with only one solution:  acquire an eSATA ExpressCard/34 fo=
r
the T420s and an eSATA enclosure for the drive.  This will give you 512=
B
sectors on both platforms and the maximum throughput of the drive.
However, you'll have to blow away the contents of the drive,
repartition, reformat, etc, since it was partitioned with 4096B logical
sector size being reported by the enclosure bridge chip.

=2E..
>> Is this some habit you developed years ago?  Prepping a new drive
>> in a USB before permanently installing it in the chassis?  If so, I'=
d
>> recommend using a hot swap SATA chassis that installs in a 5.25" dri=
ve
>> bay instead.  They're $15-30 USD, cheaper, and more reliable, than a=
 USB
>> dock, by far.
>=20
> Yes, that's what I use for the direct connection. 100% passive, very
> reliable, appears to be robust, mechanically. However, I cannot conne=
ct
> that to the laptop where I do most of my work. I do have a dock, so i=
t's
> very convenient and ergonomic, but the IO options are a bit limited o=
n
> this model.

Sounds like an eSATA ExpressCard and eSATA enclosure are in your future=
=2E
 Unless of course you have no way to get your data off the drive and
restore it after wiping the drive and starting over, in which case
you're stuck with USB 2.0 speed on the C7 box.

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
