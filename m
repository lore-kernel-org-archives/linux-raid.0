From: Jojy Varghese <jojy.varghese@gmail.com>
Subject: Re: error injection
Date: Wed, 28 Sep 2011 17:59:49 -0700
Message-ID: <CAJD3hpUNkLDRGQxNuo6m7=OQjBu3uc5xV7Fzy-XLvrUFHQJbiw@mail.gmail.com>
References: <CAJD3hpWbkSGeiWDgYHP3ewnw7akoEY-ydoRJKLxwcp8+up5zKw@mail.gmail.com>
	<20110929091128.1488f267@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110929091128.1488f267@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Neil. I tried setting my sda7 partition to generate write
errors every 40 bytes(writing 1 byte at a time). I did :

1. Create a array with:
mdadm -C /dev/md/me0 -l faulty -n1 /dev/sda7

After this step I can see /dev/md127 and when i do a mdadm -D /dev/md12=
7, i get:

/dev/md127:
        Version : 1.2
  Creation Time : Wed Sep 28 17:35:50 2011
     Raid Level : faulty
     Array Size : 969410424 (924.50 GiB 992.68 GB)
   Raid Devices : 1
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Wed Sep 28 17:35:50 2011
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : eng-dev16.lab.local:me0  (local to host eng-dev16.lab=
=2Elocal)
           UUID : 96f4be10:312f9574:f40107aa:d9f278ba
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8        7        0      active sync   /dev/sda7


2. Set write fault level with:

mdadm -G /dev/md/me0 --layout=3Dwp40



  After this when i write > 40 bytes into /dev/md127, i dont get any
I/O errors. I am sure i am doing something wrong here.


Any help is much appreciated.

Thanks
Jojy

On Wed, Sep 28, 2011 at 4:11 PM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 28 Sep 2011 12:48:37 -0700 Jojy Varghese <jojy.varghese@gmail=
=2Ecom>
> wrote:
>
>> Hi
>> =C2=A0I am trying to dynamically add error injection to my virtual
>> disk(LVM) for testing+ debugging purpose. I saw "faulty" personality
>> module in the kernel and was wondering if there was any documentatio=
n
>> on its usage. I am not looking to set up a RAID but a simple mapped
>> device. So the basic use case is that I need to be able to dynamical=
ly
>> add/remove error sectors and also be able to have granular error
>> configuration like read error, read+write error etc.
>>
>> thanks in advance
>> Jojy
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
> The 'faulty' md personality is described briefly in the 'md.4' man pa=
ge which
> is included in the mdadm distribution.
> I've included the relevant part below.
>
> Configuring the type of faults is described in mdadm.8 under the '-p
> --layout=3D' section. =C2=A0So can adjust the settings using mdadm --=
grow.
> so:
> =C2=A0mdadm -B /dev/md0 -l faulty -n1 /dev/sda
>
> will build a 'faulty' device which provides access to /dev/sda, but
> introduces faults. =C2=A0Initially no faults will be introduces.
>
> =C2=A0mdadm -G /dev/md0 --layout=3Drt400
>
> will tell md0 to generate a read error every 400 requests, but not to
> remember the error - rt =3D=3D readtransient
> =C2=A0 --layout=3Drp400
> will create a persistent error every 400 reads subsequent reads of th=
e same
> block will produce the same error. =C2=A0at most 50 persistent errors=
 can be
> recorded.
> =C2=A0mdadm -G /dev/md0 --layout=3Dclear
> will stop producing new errors
> =C2=A0mdadm -G /dev/md0 --layout=3Dflush
> will forget all persistent errors.
>
>
> from md.4:
>
> =C2=A0 FAULTY
> =C2=A0 =C2=A0 =C2=A0 The FAULTY md module is provided for testing pur=
poses. =C2=A0A faulty =C2=A0array
> =C2=A0 =C2=A0 =C2=A0 has =C2=A0exactly =C2=A0one =C2=A0component devi=
ce and is normally assembled without a
> =C2=A0 =C2=A0 =C2=A0 superblock, so the md array created provides dir=
ect access =C2=A0to =C2=A0all =C2=A0of
> =C2=A0 =C2=A0 =C2=A0 the data in the component device.
>
> =C2=A0 =C2=A0 =C2=A0 The =C2=A0FAULTY module may be requested to simu=
late faults to allow testing
> =C2=A0 =C2=A0 =C2=A0 of other md levels or of filesystems. =C2=A0Faul=
ts can be chosen to =C2=A0trigger
> =C2=A0 =C2=A0 =C2=A0 on =C2=A0read requests or write requests, and ca=
n be transient (a subsequent
> =C2=A0 =C2=A0 =C2=A0 read/write at the address will probably succeed)=
 or persistent =C2=A0(subse-
> =C2=A0 =C2=A0 =C2=A0 quent =C2=A0read/write of the same address will =
fail). =C2=A0Further, read faults
> =C2=A0 =C2=A0 =C2=A0 can be "fixable" meaning that they persist until=
 a write request at the
> =C2=A0 =C2=A0 =C2=A0 same address.
>
> =C2=A0 =C2=A0 =C2=A0 Fault =C2=A0types =C2=A0can =C2=A0be requested w=
ith a period. =C2=A0In this case, the fault
> =C2=A0 =C2=A0 =C2=A0 will recur repeatedly after the given number of =
requests of =C2=A0the =C2=A0rele-
> =C2=A0 =C2=A0 =C2=A0 vant type. =C2=A0For example if persistent read =
faults have a period of 100,
> =C2=A0 =C2=A0 =C2=A0 then every 100th read request would generate a f=
ault, =C2=A0and =C2=A0the =C2=A0faulty
> =C2=A0 =C2=A0 =C2=A0 sector =C2=A0would be recorded so that subsequen=
t reads on that sector would
> =C2=A0 =C2=A0 =C2=A0 also fail.
>
> =C2=A0 =C2=A0 =C2=A0 There is a limit to the number of faulty sectors=
 that =C2=A0are =C2=A0remembered.
> =C2=A0 =C2=A0 =C2=A0 Faults =C2=A0generated =C2=A0after =C2=A0this =C2=
=A0limit is exhausted are treated as tran-
> =C2=A0 =C2=A0 =C2=A0 sient.
>
> =C2=A0 =C2=A0 =C2=A0 The list of faulty sectors can be flushed, and t=
he active list of fail-
> =C2=A0 =C2=A0 =C2=A0 ure modes can be cleared.
>
>
> from mdadm.8:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0When setting the fail=
ure mode for level faulty, the options are:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0write-transient, wt, =
read-transient, rt, =C2=A0write-persistent, =C2=A0wp,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0read-persistent, =C2=A0=
rp, write-all, read-fixable, rf, clear, flush,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0none.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Each failure mode can=
 be followed by a number, which is used =C2=A0as
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0a =C2=A0period betwee=
n fault generation. =C2=A0Without a number, the fault
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0is generated once on =
the first relevant request. =C2=A0With a number,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0the =C2=A0fault =C2=A0=
will be generated after that many requests, and will
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0continue to be genera=
ted every time the period elapses.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Multiple failure mode=
s can be current =C2=A0simultaneously =C2=A0by =C2=A0using
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0the --grow option to =
set subsequent failure modes.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"clear" =C2=A0or =C2=A0=
"none" =C2=A0will remove any pending or periodic failure
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0modes, and "flush" wi=
ll clear any persistent faults.
>
>
>
> NeilBrown
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
