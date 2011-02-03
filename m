From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid1 - optimization
Date: Thu, 3 Feb 2011 13:20:38 -0200
Message-ID: <AANLkTikH3oMhnkemdp6ppx=6zzGn7a1NV648xT5+J_Z=@mail.gmail.com>
References: <AANLkTiknvYgckFSjgr3tE0CSLzAbH62O3x4a5Jn1dg6n@mail.gmail.com>
	<4D4AC231.8010900@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4AC231.8010900@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

nice =3D] i will test it (i think that=B4s raid-10 with offset layout i=
s
raid 1e on snia document)
the second point where could i find developers to change a bit current
read_balance of raid1 and raid10?

2011/2/3 John Robinson <john.robinson@anonymous.org.uk>:
> On 03/02/2011 14:37, Roberto Spadim wrote:
>>
>> hi guys, i another thread i read about SNIA DDF Technical Position v=
2.0
>> could we implement RAID-1E, for sequencial/random read speedup?
>>
>> http://www.snia.org/tech_activities/standards/curr_standards/ddf/SNI=
A_DDF_Technical_Position_v2.0.pdf
>> after that, could we implement some tweaks on read balance (there's
>> another thread just for it)
>
> Those RAID-1E layouts look to me like what's implemented in md RAID a=
s
> RAID-10 with near and offset layouts.
>
> As discussed frequently here, md RAID-10 also has a far layout which =
can
> provide slightly faster than RAID-0 throughput for sequential reading=
 with
> slightly slower than RAID-1 throughput for sequential writing. Please=
 see
> some of the benchmarks that have also been referred to on this list i=
n the
> last couple of days.
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
