From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 19:20:23 -0200
Message-ID: <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>
References: <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
	<AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
	<20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
	<AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>
	<AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
	<AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com>
	<20110131192858.GD27952@www2.open-std.org>
	<4D4718E1.9040607@hardwarefreak.com>
	<20110131203725.GB2283@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131203725.GB2283@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

no matter what raid1 or raid10 system we use
raid1 is mirror! let=B4s think that raid0 =3D more than one disk (not a
single disk)...

if a hard disk inside a mirror (raid1) fail (it can be a raid0 or a
single disk) the mirror is failed
for example: there=B4s no 25% survival for 2 mirrors with 4 disks!
probability, here, is mirror based, not disk based!
it=B4s not a question about linux implementation is a question for
generic raid1 (mirror) system (1 failed 2 mirrors =3D 1 mirror failed
but 1 mirror working)

you only can have 25% 'survival' if you can use 4 disks, or multiples
of 4, for raid1
if your raid0 is broken you don=B4t have a raid0! you have a broken rai=
d
=3D broken mirror (for raid1)!

should i write it again? for raid10 (raid1+0) with 4 disks you can
only lost 1 disk! 1 disk lost =3D 1 raid0 lost =3D 1 mirror lost!
should i write it again?

2011/1/31 Keld J=F8rn Simonsen <keld@keldix.com>:
> On Mon, Jan 31, 2011 at 02:17:37PM -0600, Stan Hoeppner wrote:
>> Keld J=F8rn Simonsen put forth on 1/31/2011 1:28 PM:
>> > Top-posting...
>> >
>> > How is the raid0+1 problem of only 33 % survival for 2 disk with R=
AID10?
>> >
>> > I know for RAID10,F2 the implementation in Linux MD is bad.
>> > It is only 33 % survival, while it with a probably minor fix could=
 be 66%.
>> >
>> > But how with RAID10,n2 and RAID10,o2?
>>
>> I don't care what Neil or anyone says, these "layouts" are _NOT_ RAI=
D 10. =A0If
>> you want to discuss RAID 10, please leave these non-standard Franken=
stein
>> "layouts" out of the discussion. =A0Including them only muddies thin=
gs unnecessarily.
>
> Please keep terminology clean, and non-ambigeous.
> Please refer to the old term RAID10 as RAID1+0, which is also the
> original and more precise term for that concept of multilevel RAID.
>
> RAID10 on this list refers to the RAID10 modules of the Linux kernel.
>
> I can concurr that this may be a somewhat misleading term, as it is
> easily confused with the popular understanding of RAID10, meaning
> RAID1+0. And I see Linux RAID10 as a family of RAID1 layouts.
> Indeed RAID10,n2 is almost the same as normal RAID1, and RAID10,o2
> is an implementation of a specific layout of the RAID1 standard.
> RAID10,f2 could easily also be seen as a specific RAID1 layout.
>
> But that is the naming of terms that we have to deal with on this Lin=
ux
> kernel list for the RAID modules.
>
> best regards
> Keld
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
