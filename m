From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Tue, 8 Feb 2011 19:33:03 -0200
Message-ID: <AANLkTimwMQjHb7yG8tjS4Re4MZbkPwSCywUwGX6FJHYH@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<AANLkTi=sgTjGMvNiZB2aqxpe8-z7V0bUks84+fMxCAoY@mail.gmail.com>
	<AANLkTik5SumqyTN5LZVntna8nunvPe7v38TSFf9eCfcU@mail.gmail.com>
	<AANLkTikrKCh3X7aLGqt8hDi2SK4LuZUykVRY2Mo4Nvm4@mail.gmail.com>
	<4D51B324.5060901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D51B324.5060901@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

yeah, we will make it :)
maurice, i was making some raid1 new read balance, could you help me
benchmark it?
it's kernel 2.6.37 based, here is the code:
www.spadim.com.br/raid1/
there's raid1.new.c raid1.new.h, raid1.old.c raid1.old.h
the old and new kernel source code

for user space we can now make this:
/sys/block/mdXXX/md/read_balance_mode
/sys/block/mdXXX/md/read_balance_stripe_shift
/sys/block/mdXXX/md/read_balance_config

at read_balance_mode we have now 4 modes:
near_head (default, working without problems, very good for hd only,
ssd should other mode)

round_robin (normal round robin, with per mirror counter (can make
round_robin) after some reads, very good for ssd only array)

stripe (like raid0, with read_balance_stripe_shift we can shift the
sector number with " >> " command and after select the disk with %
raid_disks, very good for hd or ssd, a good number for shift is >=3D5,
but not so much since this can make math formula use only the first
disk)

time_based (based on head positioning time + read time + i/o queue
time, selecting the best disk to read, work with ssd and hd very well,
current implementation don't have i/o queue time but i will study and
put it to work too)

all configurations for round_robin and time_based as sent to kernel by
read_balance_config
type cat /sys/block/mdxxx/md/read_balance_config
and send per disk the parameters
the first line on cat command is the parameters list, after | is read
only variables, you can't change it, just read
use echo "0 0 0 0 0 0 0 0 0 0"> read_balance_config to change values

thanks =3D]

2011/2/8 maurice <mhilarius@gmail.com>:
> On 2/8/2011 1:50 PM, Roberto Spadim wrote:
>>
>> =3D] now the right answer :)
>> question: maybe in future... could we make trim compatible with md?
>>
> I =A0hope that future is "real soon now"
> MLC SSD is now starting to appear in the "Enterprise space.
> Companies like Pliant have released products for that.
> Typical SAN RAID controllers have specific performance limits which c=
an be
> saturated with a not very large number of SSDs.
> To get higher IOs we need a more powerful RAID engine
> A typical 48 core, 128GB RAM box using AMD CPUs and 4 SAS HBAs to dis=
k JBD
> cases can be a ridiculously power RAID engine for a
> reasonable cost ( at least reasonable compered to NetApp, EMC, Hitach=
i SANs,
> etc) with a large number of devices.
>
> BUT: To use SSDs in the design we need mdadm to be more SSD friendly.
>
>
> --
> Cheers,
> Maurice Hilarius
> eMail: /mhilarius@gmail.com/
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
