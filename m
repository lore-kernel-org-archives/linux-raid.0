From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Wed, 2 Feb 2011 20:26:24 -0200
Message-ID: <AANLkTinROfr2EevWZnq3jzZCW7ctrR_1c6GSevnjQfhK@mail.gmail.com>
References: <4D4883A3.6030605@hardwarefreak.com>
	<AANLkTikcOA3hSwx29H++sayJ4PcY00_mQBw91TyYXO05@mail.gmail.com>
	<20110202092508.GA18517@cthulhu.home.robinhill.me.uk>
	<AANLkTikjKp0C6TnT7TeGRBayS=dYONWNrb-9NA71tDSe@mail.gmail.com>
	<AANLkTi=p_ke0pJhpGBgfbL8Mw9pPtAdKSRLa_AxncGWs@mail.gmail.com>
	<AANLkTink1BTeCCewZe-TywWLQAqhi0=aBF4wnSnGJh7y@mail.gmail.com>
	<AANLkTim5Y3E0=DwBRU2Tk31R-1XNXKv50ZAzpPg73Fy0@mail.gmail.com>
	<AANLkTinUMni5rNWKnc9CTH5rdaV83BQYHG=fikf9QqEV@mail.gmail.com>
	<20110202194456.GA15080@www2.open-std.org>
	<AANLkTin5o5gqogn5xHUfGpCV55D=76efpJQWs3Wmx+D8@mail.gmail.com>
	<20110202221358.GA16382@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110202221358.GA16382@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

nice, i don=B4t know if it=B4s a problem of single thread
i think it=B4s a problem about async read command being executed in par=
allel
i post again at https://bbs.archlinux.org/viewtopic.php?pid=3D887345
please see the history at the end of page
i=B4m talking about a disk with 5000rpm and a disk with 7000rpm
i think we can optimize mirror read algorithm and it=B4s not very hard
for same speed hard disk, near mirror is good
for same speed solid state, round robin is good
for anyone, time based is good

diferences?
hard disk: time to position head is high, time to read can be small
solid state: time to position is small, time to read is small (some
ssd are old, and have small read rate)
nbd: time based on server hard/solid disk, and network time, but don=B4=
t
think in nbd yet

2011/2/2 Keld J=F8rn Simonsen <keld@keldix.com>:
> Hmm, Roberto, I think we are close to theoretical maximum with
> some of the raid1/raid10 stuff already. and my nose tells me
> that we can gain more by minimizing CPU usage.
> Or maybe using some threading for raid modules - they
> all run single-threaded.
>
> Best regards
> keld
>
>
> On Wed, Feb 02, 2011 at 06:28:27PM -0200, Roberto Spadim wrote:
>> before, this thread i put at this page:
>> https://bbs.archlinux.org/viewtopic.php?pid=3D887267
>> to make this mail list with less emails
>>
>> 2011/2/2 Keld J=F8rn Simonsen <keld@keldix.com>:
>> > Hmm, Roberto, where are the gains?
>>
>> it?s dificult to talk... NCQ and linux scheduler don?t help a mirror=
,
>> they help a single device
>> a new scheduler for mirrors can be done (round robin, closest head, =
others)
>>
>> > I think it is hard to make raid1 better than it is today.
>> i don?t think, since head, is just for hard disk (rotational) not fo=
r
>> solid state disks, let?s not talk about ssd, just hard disk? a raid
>> with 5000rpm =A0and 10000rpm disk, we will have better i/o read with
>> 10000rpm ? we don?t know the model of i/o for that device, but
>> probally will be faster, but when it?s busy we could use 5000rpm...
>> that?s the point, just closest head don?t help, we need know what?s
>> the queue (list of i/o being processed) and the time to read the
>> current i/o
>>
>> > Normally the driver orders the reads to minimize head movement
>> > and loss with rotation latency. Where can =A0we improve that?
>>
>> no way to improve it, it?s very good! but per hard disk, not per mir=
ror
>> but since we know it?s busy we can use another mirror (another disk
>> with same information), that?s what i want
>>
>> > Also, what about conflicts with the elevator algorithm?
>> elevator are based on model of disk, think disk as: linux elevator +
>> NCQ + disks, the sum of three infomration give us time based
>> infomrations to select best device
>> maybe making complex code (per elevator) we could know the time spen=
t
>> to execute it, but it?s a lot of work,
>> for the first model, lets think about parameters of our model (linux
>> elevator + ncq + disks)
>> a second version we could implement elevator algorithm time
>> calculation (network block device NBD, have a elevator? at server si=
de
>> + tcp/ip stack at client and server side, right?)
>>
>> > There are several scheduling algorithms available, and each has
>> > its merits. Will your new scheme work against these?
>> > Or is your new scheme just another scheduling algorithm?
>>
>> it?s a scheduling for mirrors
>> round balance is a algorithm for mirror
>> closest head is a algorithm for mirror
>> my 'new' algorith will be for mirror (if anyone help me coding for
>> linux kernel hehehe, i didn?t coded for linux kernel yet, just for
>> user space)
>>
>> noop, deadline, cfq isn?t for mirror, these are for raid0 problem
>> (linear, stripe if you hard disk have more then one head on your har=
d
>> disk)
>>
>> > I think I learned that scheduling is per drive, not per file syste=
m.
>> yes, you learned right! =3D)
>> /dev/md0 (raid1) is a device with scheduling (closest head,round rob=
in)
>> /dev/sda is a device with scheduling (noop, deadline, cfq, others)
>> /dev/sda1 is a device with scheduling (it send all i/o directly to /=
dev/sda)
>>
>> the new algorithm is just for mirrors (raid1), i dont remeber about
>> raid5,6 if they are mirror based too, if yes they could be optimized
>> with this algorithm too
>>
>> raid0 don?t have mirrors, but information is per device striped (not
>> for linear), that?s why it can be faster... can make parallel reads
>>
>> with closest head we can?t use best disk, we can use a single disk a=
ll
>> time if it?s head closer, maybe it?s not the fastest disk (that?s wh=
y
>> we implent the write-mostly, we don?t make they usable for read, jus=
t
>> for write or when mirror fail, but it?s not perfect for speed, a
>> better algorithm can be made, for identical disks, a round robin wor=
k
>> well, better than closest head if it?s a solid state disk)
>> ok on a high load, maybe closest mirror is better than this algorith=
m?
>> yes, if you just use hard disk, if you mix hard disk+solid
>> state+network block device +floppy disks+any other device, you don?t
>> have the best algorithm for i/o over mirrors
>>
>>
>> > and is it reading or writing or both? Normally we are dependant on=
 the
>> > reading, as we cannot process data before we have read them.
>> > OTOH writing is less time critical, as nobody is waiting for it.
>> it must be implemented on write and read, write for just time
>> calculations, read for select the best mirror
>> for write we must write on all mirrors (sync write is better, async
>> isn?t power fail safe)
>>
>> > Or is it maximum thruput you want?
>> > Or a mix, given some restraints?
>> it?s the maximum performace =3D what?s the better strategy to spent =
less
>> time to execute current i/o, based on time to access disk, time to
>> read bytes, time to wait others i/o being executed
>>
>> that?s for mirror select, not for disks i/o
>> for disks we can use noop, deadline, cfq scheduller (for disks)
>> tcp/ip tweaks for network block device
>>
>> a model identification must execute to tell the mirror select
>> algorithm what?s the model of each device
>> model: time to read X bytes, time to move head, time to start a read=
,
>> time to write, time time time per byte per kb per units
>> calcule time and select the minimal value calculated as the device
>> (mirror) to execute our read
>>
>>
>> >
>> > best regards
>> > keld
>>
>> thanks keld
>>
>> sorry if i make email list very big
>>
>>
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
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
