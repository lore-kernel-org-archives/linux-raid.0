From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: mdadm raid1 read performance
Date: Wed, 4 May 2011 04:42:25 -0300
Message-ID: <BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>
	<20110504105822.21e23bc3@notabene.brown>
	<BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>
	<4DC0F2B6.9050708@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DC0F2B6.9050708@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Drew <drew.kay@gmail.com>, NeilBrown <neilb@suse.de>, Liam Kurmos <quantum.leaf@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hum...
at user program we use:
file=3Dfopen(); var=3Dfread(file,buffer_size);fclose(file);

buffer_size is the problem since it can be very small (many reads), or
very big (small memory problem, but very nice query to optimize at
device block level)
if we have a big buffer_size, we can split it across disks (ssd)
if we have a small buffer_size, we can't split it (only if readahead
is very big)
problem: we need memory (cache/buffer)

the problem... is readahead better for ssd? or a bigger 'buffer_size'
at user program is better?
or... a filesystem change of 'block' size to a bigger block size, with
this don't matter if user use a small buffer_size at fread functions,
filesystem will always read many information at device block layer,
what's better? others ideas?

i don't know how linux kernel handle a very big fread with memory
for example:
fread(file,1000000); // 1MB
will linux split the 'single' fread in many reads at block layer? each
read with 1 block size (512byte/4096byte)?

2011/5/4 Brad Campbell <lists2009@fnarfbargle.com>:
> On 04/05/11 13:30, Drew wrote:
>
>> It seemed logical to me that if two disks had the same data and we
>> were reading an arbitrary amount of data, why couldn't we split the
>> read across both disks? That way we get the benefits of pulling from
>> multiple disks in the read case while accepting the penalty of a wri=
te
>> being as slow as the slowest disk..
>>
>>
>
> I would have thought as you'd be skipping alternate "stripes" on each=
 disk
> you minimise the benefit of a readahead buffer and get subjected to s=
eek and
> rotational latency on both disks. Overall you're benefit would be sli=
m to
> immeasurable. Now on SSD's I could see it providing some extra oomph =
as you
> suffer none of the mechanical latency penalties.
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
