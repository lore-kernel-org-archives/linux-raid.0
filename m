From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Tue, 29 Mar 2011 09:22:01 -0300
Message-ID: <AANLkTimKAF8NxrrFTC-LV3=dVwqucc=UJHiw_Fb9g5Na@mail.gmail.com>
References: <201103251725.21180.thomas.jarosch@intra2net.com>
	<4D90E580.7020406@intra2net.com>
	<AANLkTinvf_WM+9J6hoCHkz-qjMEaXOvv20ZyVLwmMsPV@mail.gmail.com>
	<201103291406.09405.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103291406.09405.thomas.jarosch@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-raid@vger.kernel.org, Tejun Heo <tj@kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

it boot without problem, work with apache,mysql,softraid(md) without pr=
oblem
but after some time, it 'crash', many messages like
kernel not tainted
kernel tainted
<0x0000fffff> messages

and some debug information on console
i tested with xfs,reiserfs3,ext4 and nothing changed, maybe it=B4s a
lower layer problem: softraid, hardware module, kernel thread/process
options, i didn=B4t diff the old and the new kernel config file, maybe
something changed and i was sleeping, changing to old kernel solved
the problem, i didn=B4t found performace problems, just kernel messages=
,
and sometimes it stop working and i must reboot

2011/3/29 Thomas Jarosch <thomas.jarosch@intra2net.com>:
> Hello Roberto,
>
> On Monday, 28. March 2011 21:59:37 Roberto Spadim wrote:
>> i had some problems with hp server (the same model but G5) and new
>> intel core i7 desktops with archlinux and kernel 2.6.37, try to get =
a
>> older kernel version, just to make your production server stable
>
> Can you describe in more detail what kind of issue you were having?
>
> Didn't it boot at all or was it just slow / unusable?
> Was the issue related to md?
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
