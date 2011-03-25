From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: grow MULTIPATH RAID
Date: Fri, 25 Mar 2011 03:06:48 -0300
Message-ID: <AANLkTinyvk8sheTY4kuWov2R3d=N2L=8NfP5H=RR6B8c@mail.gmail.com>
References: <loom.20110325T041239-956@post.gmane.org>
	<20110325162916.0c47ec71@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110325162916.0c47ec71@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: shamim <shamim_99@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hum, what diference about dmraid and mdraid? dm and md what's the
diference? (md=3D multiple devices?! dm=3D? )

2011/3/25 NeilBrown <neilb@suse.de>:
> On Fri, 25 Mar 2011 03:13:41 +0000 (UTC) shamim <shamim_99@yahoo.com>=
 wrote:
>
>> Hello Experts,
>>
>> Please help me to grow MULTIPATH RAID.
>> My problem:
>> I've Linux box which have MULTIPATH RAID created on them. Now we nee=
d to remove
>> those old LUN and move data onto new LUN presented to those boxes.
>>
>> My initially thought was to grow the =A0current MULTIPATH RAID (/dev=
/md0) and
>> make old LUN as spare and then =A0failed and then remove(Is this a r=
ight
>> approach?). =A0When I=92m try adding new LUNs to it, they are gettin=
g added as spare
>> ( as shown below). =A0And when I try to grow , it refuse to do so. =A0=
Below are the
>> steps that I performed and error message.(Cannot reshaped!!)
>> ( I read somehwere =A0that we can=92t grow MULTIPATH RAID, if it is =
TRUE, then what
>> would be suggested solution to move data from old LUNs to new LUNs)
>> Please help
>
> No, you cannot grow an md/multipath device.
> However you can simply create a new multipath config across
> the set of paths that you want to use.
>
> mdadm --stop /dev/md0
> mdadm --create /dev/md0 --l multipath -n 4 ..list..of..paths...
>
> However I recommend that you stop using md/multipath and look in to
> using dm-multipath instead. =A0See the 'multipath' command.
>
> dm-multipath is actively developed. =A0md/multipath is not.
>
> NeilBrown
>
>
>> --------------------------------------------------
>>
>> # mdadm --detail /dev/md0
>> /dev/md0:
>> =A0 =A0 =A0 =A0 Version : 0.90
>> =A0 Creation Time : Thu Mar 24 13:54:41 2011
>> =A0 =A0 =A0Raid Level : multipath
>> =A0 =A0 =A0Array Size : 10486016 (10.00 GiB 10.74 GB)
>> =A0 =A0Raid Devices : 2
>> =A0 Total Devices : 4
>> Preferred Minor : 0
>> =A0 =A0 Persistence : Superblock is persistent
>>
>> =A0 =A0 Update Time : Thu Mar 24 13:54:41 2011
>> =A0 =A0 =A0 =A0 =A0 State : clean
>> =A0Active Devices : 2
>> Working Devices : 4
>> =A0Failed Devices : 0
>> =A0 Spare Devices : 2
>>
>> =A0 =A0 =A0 =A0 =A0 =A0UUID : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
>> =A0 =A0 =A0 =A0 =A0Events : 0.3
>>
>> =A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
>> =A0 =A0 =A0 =A00 =A0 =A0 =A065 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0active sync =A0 /dev/sdq
>> =A0 =A0 =A0 =A01 =A0 =A0 =A0 8 =A0 =A0 =A0 96 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdg
>> --------------------------------------------------------------------
>> # mdadm /dev/md0 --add /dev/sdr /dev/sdh
>> mdadm: added /dev/sdr
>> mdadm: re-added /dev/sdh
>>
>> --------------------------------------------------------------------
>> # mdadm --detail /dev/md0
>> /dev/md0:
>> =A0 =A0 =A0 =A0 Version : 0.90
>> =A0 Creation Time : Thu Mar 24 13:54:41 2011
>> =A0 =A0 =A0Raid Level : multipath
>> =A0 =A0 =A0Array Size : 10486016 (10.00 GiB 10.74 GB)
>> =A0 =A0Raid Devices : 2
>> =A0 Total Devices : 4
>> Preferred Minor : 0
>> =A0 =A0 Persistence : Superblock is persistent
>>
>> =A0 =A0 Update Time : Thu Mar 24 13:54:41 2011
>> =A0 =A0 =A0 =A0 =A0 State : clean
>> =A0Active Devices : 2
>> Working Devices : 4
>> =A0Failed Devices : 0
>> =A0 Spare Devices : 2
>>
>> =A0 =A0 =A0 =A0 =A0 =A0UUID : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
>> =A0 =A0 =A0 =A0 =A0Events : 0.3
>>
>> =A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
>> =A0 =A0 =A0 =A00 =A0 =A0 =A065 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0active sync =A0 /dev/sdq
>> =A0 =A0 =A0 =A01 =A0 =A0 =A0 8 =A0 =A0 =A0 96 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdg
>>
>> =A0 =A0 =A0 =A02 =A0 =A0 =A065 =A0 =A0 =A0 16 =A0 =A0 =A0 =A0- =A0 =A0=
 =A0spare =A0 /dev/sdr
>> =A0 =A0 =A0 =A03 =A0 =A0 =A0 8 =A0 =A0 =A0112 =A0 =A0 =A0 =A0- =A0 =A0=
 =A0spare =A0 /dev/sdh
>>
>> --------------------------------------------------------------------
>> # mdadm --grow /dev/md0 --raid-disks=3D4
>> mdadm: multipath array /dev/md0 cannot be reshaped.
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
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
