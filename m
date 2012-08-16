From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid5 to utilize upto 8 cores
Date: Thu, 16 Aug 2012 19:29:29 -0300
Message-ID: <CABYL=TogcrbB0jOxzCJORzmG8d=t-zn+uK8uCzK=yPHmwVfGyQ@mail.gmail.com>
References: <CAEyJA_sSzmgcK6miWfxC4jgvbH7WJ_hgZhnmFABaK9r7X=SLDQ@mail.gmail.com>
	<CAD9gYJLwuai2kGw1D1wQoK8cOvMOiCCcN3hAY=k_jj0=4og3Vg@mail.gmail.com>
	<CAEyJA_tGFtN2HMYa=vDV7m9N8thA-6MJ5TFo20X1yEpG3HQWYw@mail.gmail.com>
	<CAD9gYJK09kRMb_v25uwmG7eRfFQLQyEd4SMXWBSPwYkpP56jcw@mail.gmail.com>
	<CAEyJA_stW3i9df5ivWFN6a4Yx0YWnaCX_=dA_qKw2J5bcou04A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEyJA_stW3i9df5ivWFN6a4Yx0YWnaCX_=dA_qKw2J5bcou04A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: vincent Ferrer <vincentchicago1@gmail.com>
Cc: =?UTF-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maybe you will need a syslinux boot loader, instead grub
i tryed archlinux devel version, and only worked with syslinux boot
loader, grub didn=C2=B4t work with rootfs on md device
i didn=C2=B4t tryed to understand, I just changed the bootloader and it=
 works
just a help if you can=C2=B4t boot your system...

and yes, you can download the last kernel and patch it with last raid
changes (just get the right one =3D]  )
try booting from a external harddisk to don=C2=B4t change something
important in your server configuration
good look =3D)

2012/8/16 vincent Ferrer <vincentchicago1@gmail.com>:
> On Thu, Aug 16, 2012 at 1:34 AM, =E7=8E=8B=E9=87=91=E6=B5=A6 <jinpuwa=
ng@gmail.com> wrote:
>> Hi vikas,
>>
>> I suggest you can pull from  git://neil.brown.name/md.git and checko=
ut to
>> for-next branch, test if that works for you.
>>
>> I'm not sure the patches can cleanly apply to 2.6.32, good luck to t=
ry.
>>
>> Jack
>>
>> 2012/8/16 vincent Ferrer <vincentchicago1@gmail.com>
>>>
>>> Hi Jin,
>>> Thanks
>>> Which kernel  version these patches are expected in linux tree?
>>> Can I apply these patches into  2.6.32 kernel ?
>>>
>>> regards
>>> -vikas
>>>
>>> On Wed, Aug 15, 2012 at 8:09 PM, =E7=8E=8B=E9=87=91=E6=B5=A6 <jinpu=
wang@gmail.com> wrote:
>>> > Hi
>>> >
>>> > You may not notice Shaohua have address this
>>> >
>>> > http://neil.brown.name/git?p=3Dmd;a=3Dcommitdiff;h=3D45e2c516a2ff=
d5d477d42f3cc6f6e960b3ae14de
>>> >
>>> > Jack
>>> >
>
> Hello Forum,
>   Can I download any  "Released or non-released"  linux kernel versio=
n
>  which has  multi thread raid5  support (for now don't care about
> stability).  Just want to try it out for benchmarking my storage
> server.
>   This will help in testing your patch and also will save me effort
> having to patch a kernel which I am on (  kernel 3.3 (Fedora 17)  or
> kernel 2.6.32)
>
> regards
> vincy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
