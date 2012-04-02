From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Mon, 2 Apr 2012 18:01:55 +0800
Message-ID: <CA+res+SSJ49cPubOdmXi6Z3jnE+4wzsh1MJehs78U82e3iDhaA@mail.gmail.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com>
	<CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com>
	<4F776492.4070600@hardwarefreak.com>
	<CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com>
	<4F77D0B2.8000809@hardwarefreak.com>
	<CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com>
	<4F77EA55.6090004@hardwarefreak.com>
	<jl9ate$2me$1@dough.gmane.org>
	<4F784A06.1@anonymous.org.uk>
	<CA+res+QkLi7sxZrD-XOcbR47CeJ5gADf7P6pa1w1oMf8CKSB4g@mail.gmail.com>
	<4F795CE2.9050106@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F795CE2.9050106@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2012/4/2 John Robinson <john.robinson@anonymous.org.uk>
>
> On 02/04/2012 04:15, Jack Wang wrote:
>>
>> 2012/4/1 John Robinson <john.robinson@anonymous.org.uk
>> <mailto:john.robinson@anonymous.org.uk>>
>
> [...]
>>
>> =C2=A0 =C2=A0Now that you've suggested that, it occurs to me that fo=
r an
>> =C2=A0 =C2=A0application like this, the OP might be better doing his=
 multiple
>> =C2=A0 =C2=A0slow streams to a spool folder on SSD, and copying over=
 to the big
>> =C2=A0 =C2=A0array of spinning rust when each stream completes. 200 =
streams of
>> =C2=A0 =C2=A0500MB is 100GB of data, so a pair of slightly larger SS=
Ds in RAID1
>> =C2=A0 =C2=A0(or RAID10, to balance the reads coming off) would do n=
icely as a
>> =C2=A0 =C2=A0spool area.
>>
>> =C2=A0 =C2=A0This might also be a good application for bcache, Flash=
Cache or
>> =C2=A0 =C2=A0whatever.
>>
>> Using bcache/flashcache is what I'm considering, does above
>> configuration option still needed?
>
>
> Using a pair of SSDs? I think if you're adding a cache to a redundant=
 array, you ought to make the cache redundant too.
>
> Using RAID10 to balance reads coming off the redundant pair of SSDs? =
That would depend on how bcache or flashcache is written; if it's singl=
e-threaded or does large copies from cache to the backing, then yes, yo=
u may see better performance or at least more balanced usage of the two=
 SSDs, and surely won't see worse performance.
>
> Cheers,
>
> John.


John,

Thanks for reply=C2=A0, I mean using SSD as cache device, and raid5
16*7200rpm disks, is this works for streaming workload above?

I know bcache is try to turn rand write to seqencial write, but most
ssd is not good at RAND write as I know.

Cheers,

Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
