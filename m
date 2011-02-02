From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Wed, 2 Feb 2011 19:31:22 -0200
Message-ID: <AANLkTimG4AGq9pS79t7QqzEGJQB9arqh3Jhji-fGU6mM@mail.gmail.com>
References: <ii8lcv$3jg$1@dough.gmane.org>
	<AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com>
	<4D4883A3.6030605@hardwarefreak.com>
	<AANLkTikcOA3hSwx29H++sayJ4PcY00_mQBw91TyYXO05@mail.gmail.com>
	<20110202092508.GA18517@cthulhu.home.robinhill.me.uk>
	<AANLkTikjKp0C6TnT7TeGRBayS=dYONWNrb-9NA71tDSe@mail.gmail.com>
	<AANLkTi=p_ke0pJhpGBgfbL8Mw9pPtAdKSRLa_AxncGWs@mail.gmail.com>
	<AANLkTink1BTeCCewZe-TywWLQAqhi0=aBF4wnSnGJh7y@mail.gmail.com>
	<AANLkTim5Y3E0=DwBRU2Tk31R-1XNXKv50ZAzpPg73Fy0@mail.gmail.com>
	<AANLkTinUMni5rNWKnc9CTH5rdaV83BQYHG=fikf9QqEV@mail.gmail.com>
	<20110202194456.GA15080@www2.open-std.org>
	<AANLkTin5o5gqogn5xHUfGpCV55D=76efpJQWs3Wmx+D8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin5o5gqogn5xHUfGpCV55D=76efpJQWs3Wmx+D8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

sorry pour english, it=B4s not closest head, it=B4s nearest head

2011/2/2 Roberto Spadim <roberto@spadim.com.br>:
> before, this thread i put at this page:
> https://bbs.archlinux.org/viewtopic.php?pid=3D887267
> to make this mail list with less emails
>
> 2011/2/2 Keld J=F8rn Simonsen <keld@keldix.com>:
>> Hmm, Roberto, where are the gains?
>
> it=B4s dificult to talk... NCQ and linux scheduler don=B4t help a mir=
ror,
> they help a single device
> a new scheduler for mirrors can be done (round robin, closest head, o=
thers)
>
>> I think it is hard to make raid1 better than it is today.
> i don=B4t think, since head, is just for hard disk (rotational) not f=
or
> solid state disks, let=B4s not talk about ssd, just hard disk? a raid
> with 5000rpm =A0and 10000rpm disk, we will have better i/o read with
> 10000rpm ? we don=B4t know the model of i/o for that device, but
> probally will be faster, but when it=B4s busy we could use 5000rpm...
> that=B4s the point, just closest head don=B4t help, we need know what=
=B4s
> the queue (list of i/o being processed) and the time to read the
> current i/o
>
>> Normally the driver orders the reads to minimize head movement
>> and loss with rotation latency. Where can =A0we improve that?
>
> no way to improve it, it=B4s very good! but per hard disk, not per mi=
rror
> but since we know it=B4s busy we can use another mirror (another disk
> with same information), that=B4s what i want
>
>> Also, what about conflicts with the elevator algorithm?
> elevator are based on model of disk, think disk as: linux elevator +
> NCQ + disks, the sum of three infomration give us time based
> infomrations to select best device
> maybe making complex code (per elevator) we could know the time spent
> to execute it, but it=B4s a lot of work,
> for the first model, lets think about parameters of our model (linux
> elevator + ncq + disks)
> a second version we could implement elevator algorithm time
> calculation (network block device NBD, have a elevator? at server sid=
e
> + tcp/ip stack at client and server side, right?)
>
>> There are several scheduling algorithms available, and each has
>> its merits. Will your new scheme work against these?
>> Or is your new scheme just another scheduling algorithm?
>
> it=B4s a scheduling for mirrors
> round balance is a algorithm for mirror
> closest head is a algorithm for mirror
> my 'new' algorith will be for mirror (if anyone help me coding for
> linux kernel hehehe, i didn=B4t coded for linux kernel yet, just for
> user space)
>
> noop, deadline, cfq isn=B4t for mirror, these are for raid0 problem
> (linear, stripe if you hard disk have more then one head on your hard
> disk)
>
>> I think I learned that scheduling is per drive, not per file system.
> yes, you learned right! =3D)
> /dev/md0 (raid1) is a device with scheduling (closest head,round robi=
n)
> /dev/sda is a device with scheduling (noop, deadline, cfq, others)
> /dev/sda1 is a device with scheduling (it send all i/o directly to /d=
ev/sda)
>
> the new algorithm is just for mirrors (raid1), i dont remeber about
> raid5,6 if they are mirror based too, if yes they could be optimized
> with this algorithm too
>
> raid0 don=B4t have mirrors, but information is per device striped (no=
t
> for linear), that=B4s why it can be faster... can make parallel reads
>
> with closest head we can=B4t use best disk, we can use a single disk =
all
> time if it=B4s head closer, maybe it=B4s not the fastest disk (that=B4=
s why
> we implent the write-mostly, we don=B4t make they usable for read, ju=
st
> for write or when mirror fail, but it=B4s not perfect for speed, a
> better algorithm can be made, for identical disks, a round robin work
> well, better than closest head if it=B4s a solid state disk)
> ok on a high load, maybe closest mirror is better than this algorithm=
?
> yes, if you just use hard disk, if you mix hard disk+solid
> state+network block device +floppy disks+any other device, you don=B4=
t
> have the best algorithm for i/o over mirrors
>
>
>> and is it reading or writing or both? Normally we are dependant on t=
he
>> reading, as we cannot process data before we have read them.
>> OTOH writing is less time critical, as nobody is waiting for it.
> it must be implemented on write and read, write for just time
> calculations, read for select the best mirror
> for write we must write on all mirrors (sync write is better, async
> isn=B4t power fail safe)
>
>> Or is it maximum thruput you want?
>> Or a mix, given some restraints?
> it=B4s the maximum performace =3D what=B4s the better strategy to spe=
nt less
> time to execute current i/o, based on time to access disk, time to
> read bytes, time to wait others i/o being executed
>
> that=B4s for mirror select, not for disks i/o
> for disks we can use noop, deadline, cfq scheduller (for disks)
> tcp/ip tweaks for network block device
>
> a model identification must execute to tell the mirror select
> algorithm what=B4s the model of each device
> model: time to read X bytes, time to move head, time to start a read,
> time to write, time time time per byte per kb per units
> calcule time and select the minimal value calculated as the device
> (mirror) to execute our read
>
>
>>
>> best regards
>> keld
>
> thanks keld
>
> sorry if i make email list very big
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
