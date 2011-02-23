From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: removing AHCI SATA devices
Date: Wed, 23 Feb 2011 13:21:32 -0300
Message-ID: <AANLkTi=O5WiEAN7otofnR6+-perR9pcnAsxdrHpOxKkw@mail.gmail.com>
References: <AANLkTimkAMh9T0G_6XyajcMVv9gbNn1-gPpvmBSAAfPY@mail.gmail.com>
	<4D642C54.9040604@garzik.org>
	<4D64C503.1080304@gmail.com>
	<4D64ED3F.4050106@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D64ED3F.4050106@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: simonmcnair@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i fail disk with mdadm, remove the from computer, insert again add
disk to md array, and continue using

2011/2/23 John Robinson <john.robinson@anonymous.org.uk>:
> On 23/02/2011 08:27, Simon McNair wrote:
>>
>> thanks Jeff. It just seems like a hit and miss solution (no way of
>> knowing all data has been written to and that the device has been
>> unmounted from all filesystems). I kinda expected some kind of 'it i=
s
>> safe to remove /dev/sdb' in dmesg.
>
> I think `eject /dev/sdb` will do what you want - if it's safe to pull=
, it'll
> exit immediately and silently, but if it or any of its partitions are=
 still
> associated with any filesystem or md device, and the drive can't safe=
ly be
> ejected/unplugged, it'll complain.
>
> Cheers,
>
> John.
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
