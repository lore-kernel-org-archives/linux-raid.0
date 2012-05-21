From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Mon, 21 May 2012 15:54:55 -0300
Message-ID: <CABYL=TqBeC+D_FHBGNO5WmdhP5zArQsNVY4v1xwHy9Zz0w4M1w@mail.gmail.com>
References: <4FAAE8F1.8000600@pocock.com.au>
	<CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
	<4FABC7C6.4030107@turmel.org>
	<4FAC2FF2.5060305@hardwarefreak.com>
	<4FAC40BC.1060300@hesbynett.no>
	<CABYL=ToORULrdhBVQk0K8zQqFYkOomY-wgG7PpnJnzP9u7iBnA@mail.gmail.com>
	<4FACBB68.2080304@hesbynett.no>
	<4FACCAC8.4020206@pocock.com.au>
	<4FAD9283.7020809@hardwarefreak.com>
	<CAGqmV7oJg8vwKPJEYJhPANzaN-xxVW6Lw2gLTEKmMfG=pqCHuA@mail.gmail.com>
	<4FBA8EA9.40203@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBA8EA9.40203@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: CoolCold <coolthecold@gmail.com>, Daniel Pocock <daniel@pocock.com.au>, David Brown <david.brown@hesbynett.no>, Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hum, does anyone could explain what a 'multi thread' version of raid1
could be implemented?
for example, how to scale it? and why this new implementation could
scale it better

2012/5/21 Stan Hoeppner <stan@hardwarefreak.com>:
> On 5/21/2012 10:20 AM, CoolCold wrote:
>> On Sat, May 12, 2012 at 2:28 AM, Stan Hoeppner <stan@hardwarefreak.c=
om> wrote:
>>> On 5/11/2012 3:16 AM, Daniel Pocock wrote:
>>>
>> [snip]
>>> That's the one scenario where I abhor using md raid, as I mentioned=
=2E =A0At
>>> least, a boot raid 1 pair. =A0Using layered md raid 1 + 0, or 1 + l=
inear
>>> is a great solution for many workloads. =A0Ask me why I say raid 1 =
+ 0
>>> instead of raid 10.
>> So, I'm asking - why?
>
> Neil pointed out quite some time ago that the md RAID 1/5/6/10 code r=
uns
> as a single kernel thread. =A0Thus when running heavy IO workloads ac=
ross
> many rust disks or a few SSDs, the md thread becomes CPU bound, as it
> can only execute on a single core, just as with any other single thre=
ad.
>
> This issue is becoming more relevant as folks move to the latest
> generation of server CPUs that trade clock speed for higher core coun=
t.
> =A0Imagine the surprise of the op who buys a dual socket box with 2x =
16
> core AMD Interlagos 2.0GHz CPUs, 256GB RAM, and 32 SSDs in md RAID 10=
,
> only to find he can only get a tiny fraction of the SSD throughput.
> Upon investigation he finds a single md thread peaking one core while
> the rest are relatively idle but for the application itself.
>
> As I understand Neil's explanation, the md RAID 0 and linear code don=
't
> run as separate kernel threads, but merely pass offsets to the block
> layer, which is fully threaded. =A0Thus, by layering md RAID 0 over m=
d
> RAID 1 pairs, the striping load is spread over all cores. =A0Same wit=
h
> linear, avoiding the single thread bottleneck.
>
> This layering can be done with any md RAID level, creating RAID50s an=
d
> RAID60s, or concatenations of RAID5/6, as well as of RAID 10.
>
> And it shouldn't take anywhere near 32 modern SSDs to saturate a sing=
le
> 2GHz core with md RAID 10. =A0It's likely less than 8 SSDs, which yie=
ld
> ~400K IOPS, but I haven't done verufication testing myself at this po=
int.
>
> --
> Stan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
