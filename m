From: Kunal Kushwaha <kunal.kushwaha@gmail.com>
Subject: Re: Query regarding stripe management in linux md-raid
Date: Wed, 29 Apr 2009 15:27:28 +0800
Message-ID: <fbae8f520904290027x6b65419co164c61db7b249223@mail.gmail.com>
References: <fbae8f520904280702h736197d6ibfdf0212bf1923d2@mail.gmail.com>
	 <18935.36392.65600.930716@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18935.36392.65600.930716@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Thanks for your reply. I am trying to find out  problems that I could
face later on.

On Wed, Apr 29, 2009 at 7:15 AM, Neil Brown <neilb@suse.de> wrote:
> On Tuesday April 28, kunal.kushwaha@gmail.com wrote:
>> Hi,
>>
>> I am trying to put Linux raid in Box with 256 MB of RAM. The kernel =
is
>> compiled with non-swappable memory management option. I looked into
>> raid5.c and found, it allocates one page for each chunk. =A0I am usi=
ng 5
>> disks for 64k chunk size. considering my kernel is within 30 MB.
>
> That isn't quite right. =A0 It is not 1 page per chunk.
> raid5 maintains a stripe cache. =A0Each entry in the cache has one pa=
ge
> per device, and there are 256 entries by default.
> So for a 5-disk array, that is 5*256 =3D=3D 1280 pages or 5MB (plus
> overhead).
>

Sorry I missed to mention about stripe cache. Yes we will be using
only 5MB if we
consider page size is of 4k.

I have one more doubt regarding this. How a page of 4k will be able to
store data of
64k( my chunk size if of 64k) ?




>>
>> 1. If one page is allocated for one chunk instead of actual buffer
>> size, isn't memory lot of memory is wasted?
>
> It depends on what you mean by "wasted". =A0The memory is used to
> provide adequate performance with manageable code complexity.
> Possibly the same performance could be achieved using less memory, bu=
t
> I suspect the code would be much more complex and so probably more
> buggy. =A0It is a trade off.
>
> If the 5MB eats in to you 256MB too much, you can reduce it be writin=
g
> a number to /sys/block/mdX/md/stripe_cache_size.
> You could probably get away with as little as '4', but I suspect that
> would really kill performance. =A0With a 64K chunk size you want at
> least 16 entries, so 32 or 64 might be a suitable compromise for you.
>
>> 2. It will restrict the no. of stripes in memory (in case of
>> non-swappable memory, no will be very less) will effect performance =
of
>> IO badly.
>
> The number of (page-wide) stripes in memory is fixed by the cache
> size. =A0It defaults to 256, but you can change it. =A0A smaller size
> would be likely to negatively affect performance. =A0A larger cache c=
an
> improve performance depending on workload.
>
>>
>> Please correct me, if I am wrong, also any suggestion to overcome th=
is
>> problem is most welcomed.
>
> Do you have an actual observed problem, or are you just trying to
> discover what problems you might eventually run in to?
>
> NeilBrown
>



--=20
Thanks in Advance,
Kunal Kushwaha
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
