From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Wed, 23 May 2012 10:27:28 -0300
Message-ID: <CABYL=To6VqqrErKCh5MSeoMxNDyr-C9RY_1z26ksjj-hppafGg@mail.gmail.com>
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
	<20120522093404.3ffaae42@notabene.brown>
	<4FBB33D6.4010101@hardwarefreak.com>
	<4FBB406B.7040904@hesbynett.no>
	<4FBCE2C2.6030909@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBCE2C2.6030909@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: David Brown <david.brown@hesbynett.no>, NeilBrown <neilb@suse.de>, CoolCold <coolthecold@gmail.com>, Daniel Pocock <daniel@pocock.com.au>, Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

just to understand... i didn't think about a implementation yet...

what could be done to 'multi thread' md raid1,10,5,6?

i didn't understand why it is a problem, i think that the only cpu
time that it need is the time to tell what disk and what position must
be read for each i/o request

i'm just thinking about the normal read/write without resync, check,
bad read/write, or another management feature running


2012/5/23 Stan Hoeppner <stan@hardwarefreak.com>:
> On 5/22/2012 2:29 AM, David Brown wrote:
>
>> But in general, it's important to do some real-world testing to
>> establish whether or not there really is a bottleneck here. =A0It is
>> counter-productive for Stan (or anyone else) to advise against raid1=
0 or
>> raid5/6 because of a single-thread bottleneck if it doesn't actually
>> slow things down in practice.
>
> Please reread precisely what I stated earlier:
>
> "Neil pointed out quite some time ago that the md RAID 1/5/6/10 code
> runs as a single kernel thread. =A0Thus when running heavy IO workloa=
ds
> across many rust disks or a few SSDs, the md thread becomes CPU bound=
,
> as it can only execute on a single core, just as with any other singl=
e
> thread."
>
> Note "heavy IO workloads". =A0The real world testing upon which I bas=
ed my
> recommendation is in this previous thread on linux-raid, of which I w=
as
> a participant.
>
> Mark Delfman did the testing which revealed this md RAID thread
> scalability problem using 4 PCIe enterprise SSDs:
>
> http://marc.info/?l=3Dlinux-raid&m=3D131307849530290&w=3D2
>
>> On the other hand, if it /is/ a hinder to
>> scaling, then it is important for Neil and other experts to think ab=
out
>> how to change the architecture of md raid to scale better. =A0And
>
> More thorough testing and identification of the problem is definitely
> required. =A0Apparently few people are currently running md RAID 1/5/=
6/10
> across multiple ultra high performance SSDs, people who actually need
> every single ounce of IOPS out of each device in the array. =A0But th=
is
> trend will increase. =A0I'd guess those currently building md 1/5/6/1=
0
> arrays w/ many SSDs simply don't *need* every ounce of IOPS, or more
> would be complaining about single core thread limit already.
>
>> somewhere in between there can be guidelines to help users - somethi=
ng
>> like "for an average server, single-threading will saturate raid5
>> performance at 8 disks, raid6 performance at 6 disks, and raid10 at =
10
>> disks, beyond which you should use raid0 or linear striping over two=
 or
>> more arrays".
>
> This isn't feasible due to the myriad possible combinations of hardwa=
re.
> =A0And you simply won't see this problem with SRDs (spinning rust dis=
ks)
> until you have hundreds of them in a single array. =A0It requires ove=
r 200
> 15K SRDs in RAID 10 to generate only 30K random IOPS. =A0Just about a=
ny
> single x86 core can handle that, probably even a 1.6GHz Atom. =A0This
> issue mainly affects SSD arrays, where even 8 midrange consumer SATA3
> SSDs in RAID 10 can generate over 400K IOPS, 200K real and 200K mirro=
r data.
>
>> Of course, to do such testing, someone would need a big machine with
>> lots of disks, which is not otherwise in use!
>
> Shouldn't require anything that heavy. =A0I would guess that one shou=
ld be
> able to reveal the thread bottleneck with a low freq dual core deskto=
p
> system with an HBA such as the LSI 9211-8i @320K IOPS, and 8 Sandforc=
e
> 2200 based SSDs @40K write IOPS each.
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
