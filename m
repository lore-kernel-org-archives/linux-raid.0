From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Mon, 28 Mar 2011 16:59:37 -0300
Message-ID: <AANLkTinvf_WM+9J6hoCHkz-qjMEaXOvv20ZyVLwmMsPV@mail.gmail.com>
References: <201103251725.21180.thomas.jarosch@intra2net.com>
	<20110328075937.GB16530@htj.dyndns.org>
	<201103281302.20219.thomas.jarosch@intra2net.com>
	<201103281453.53382.thomas.jarosch@intra2net.com>
	<20110328155928.GB6736@htj.dyndns.org>
	<4D90E580.7020406@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D90E580.7020406@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: Tejun Heo <tj@kernel.org>, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

that=B4s what i did, not a linux raid list opnion/experience:

i had some problems with hp server (the same model but G5) and new
intel core i7 desktops with archlinux and kernel 2.6.37, try to get a
older kernel version, just to make your production server stable

maybe some changes between kernel 3.6.32 and 3.6.37 made md working
worst, i will wait some changes at kernel, since realtime works are
being developed and many modifications are in work

using the same instalation process with archilnux using a dell (i
don=B4t remember the model, but i bought it in january 2011) removed th=
e
problem (maybe a problem at hp sas interface/driver?! i didn=B4t tested
hp with dell interface)

2011/3/28 Thomas Jarosch <thomas.jarosch@intra2net.com>:
> On 03/28/2011 05:59 PM, Tejun Heo wrote:
>>> Call Trace:
>>> =A0[<c12dc808>] mutex_unlock+0x8/0x10
>>> =A0[<c11c4451>] kobj_lookup+0xe1/0x140
>>> =A0[<c11323b0>] ? exact_match+0x0/0x10
>>> =A0[<c11331b8>] get_gendisk+0x98/0xb0
>>> =A0[<c10e85aa>] __blkdev_get+0xca/0x320
>>> =A0[<c10e8843>] blkdev_get+0x43/0x2c0
>>> =A0[<c12de75d>] ? _raw_spin_unlock+0x1d/0x20
>>> =A0[<c10e8b12>] blkdev_open+0x52/0x70
>>> =A0[<c10bb12d>] __dentry_open+0x9d/0x240
>>> =A0[<c10bb3c6>] nameidata_to_filp+0x66/0x80
>>> =A0[<c10e8ac0>] ? blkdev_open+0x0/0x70
>>> =A0[<c10c781f>] finish_open+0xaf/0x190
>>> =A0[<c10c8a24>] ? do_path_lookup+0x44/0xe0
>>> =A0[<c10c9920>] do_filp_open+0x210/0x6d0
>>> =A0[<c10672e9>] ? lock_release_non_nested+0x59/0x2f0
>>> =A0[<c12de75d>] ? _raw_spin_unlock+0x1d/0x20
>>> =A0[<c10d47d8>] ? alloc_fd+0xb8/0xf0
>>> =A0[<c10baf45>] do_sys_open+0x55/0xf0
>>> =A0[<c10bb049>] sys_open+0x29/0x40
>>> =A0[<c1002e9f>] sysenter_do_call+0x12/0x38
>>
>> Hmmm... Weird.
>>
>> * blkid seems to be looping in blkdev_open() repeatedly calling
>> =A0 md_open() which keeps returning -ERESTARTSYS.
>>
>> * It triggered softlockup. =A0Even with -ERESTARTSYS looping, I can'=
t
>> =A0 see how that would be possible.
>>
>> Is this custom boot script? =A0If so, do you use RT priority in the
>> script?
>
> It's a normal dracut installation with an additional custom script
> to trigger kernel raid auto detection via mdadm.
> The custom script was part of the initial post.
>
> I've also noticed another odd thing: On a HP Proliant ML110 G6 box,
> which is quite fast / SMP, the box brings up the software
> RAID successfully. The box is slow as hell and I can see a constant l=
oad
> on a kernel process (could be "kworker", don't remember it exactly).
> I'll try tomorrow if that is also related to the RAID subsystem
> or something else turning it into a PDP11...
>
> Thanks for your help so far!
>
> Cheers,
> Thomas
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
