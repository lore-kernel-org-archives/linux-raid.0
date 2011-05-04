From: Liam Kurmos <quantum.leaf@gmail.com>
Subject: Re: mdadm raid1 read performance
Date: Thu, 5 May 2011 00:08:59 +0100
Message-ID: <BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>
	<20110504105822.21e23bc3@notabene.brown>
	<BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>
	<4DC0F2B6.9050708@fnarfbargle.com>
	<BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Drew <drew.kay@gmail.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks to all who replied on this.

I somewhat naively assumed that having 2 disks with the same data
would mean a similar read speed to raid0 should be the norm (and i
think this is a very popular miss-conception).
I was neglecting the seek time to skip alternate blocks which i guess
must the flaw.

In theory though if i was reading a larger file, couldn't one disk
start reading at the beginning to a buffer and one start reading from
half way ( assuming 2 disks) and hence get close to 2x single disk
speed?

as a separate question, what should be the theoretical performance of r=
aid5?

in my tests i read 1GB and throw away the data.
dd if=3D/dev/md0 of=3D/dev/null bs=3D1M count=3D1000

With 4 fairly fast hdd's i get

raid0: ~540MB/s
raid10: 220MB/s
raid5: ~165MB/s
raid1: ~140MB/s  (single disk speed)

for 4 disks raid0 seems like suicide, but for my system drive the
speed advantage is so great im tempted to try it anyway and try and
use rsync to keep constant back up.

cheers for you responses,

Liam



On Wed, May 4, 2011 at 8:42 AM, Roberto Spadim <roberto@spadim.com.br> =
wrote:
> hum...
> at user program we use:
> file=3Dfopen(); var=3Dfread(file,buffer_size);fclose(file);
>
> buffer_size is the problem since it can be very small (many reads), o=
r
> very big (small memory problem, but very nice query to optimize at
> device block level)
> if we have a big buffer_size, we can split it across disks (ssd)
> if we have a small buffer_size, we can't split it (only if readahead
> is very big)
> problem: we need memory (cache/buffer)
>
> the problem... is readahead better for ssd? or a bigger 'buffer_size'
> at user program is better?
> or... a filesystem change of 'block' size to a bigger block size, wit=
h
> this don't matter if user use a small buffer_size at fread functions,
> filesystem will always read many information at device block layer,
> what's better? others ideas?
>
> i don't know how linux kernel handle a very big fread with memory
> for example:
> fread(file,1000000); // 1MB
> will linux split the 'single' fread in many reads at block layer? eac=
h
> read with 1 block size (512byte/4096byte)?
>
> 2011/5/4 Brad Campbell <lists2009@fnarfbargle.com>:
>> On 04/05/11 13:30, Drew wrote:
>>
>>> It seemed logical to me that if two disks had the same data and we
>>> were reading an arbitrary amount of data, why couldn't we split the
>>> read across both disks? That way we get the benefits of pulling fro=
m
>>> multiple disks in the read case while accepting the penalty of a wr=
ite
>>> being as slow as the slowest disk..
>>>
>>>
>>
>> I would have thought as you'd be skipping alternate "stripes" on eac=
h disk
>> you minimise the benefit of a readahead buffer and get subjected to =
seek and
>> rotational latency on both disks. Overall you're benefit would be sl=
im to
>> immeasurable. Now on SSD's I could see it providing some extra oomph=
 as you
>> suffer none of the mechanical latency penalties.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
