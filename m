From: Kunal Kushwaha <kunal.kushwaha@gmail.com>
Subject: Re: Query regarding stripe management in linux md-raid
Date: Sat, 2 May 2009 12:48:18 +0530
Message-ID: <fbae8f520905020018mc6bb23cw51301052ff164928@mail.gmail.com>
References: <fbae8f520904280702h736197d6ibfdf0212bf1923d2@mail.gmail.com>
	 <18935.36392.65600.930716@notabene.brown>
	 <fbae8f520904290027x6b65419co164c61db7b249223@mail.gmail.com>
	 <87zldwjybm.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zldwjybm.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Goswin,

My understanding of chunk size is that,  it is minimum unit of data
that is used for read/write.
Chunk size defines, amount of data written on one disk after breaking
it in equal no of chunks.
Chunk size =3D Stripe size /  (disks in array - parity disks)

so for raid 5, chunk_size =3D Stripe_Size / (total_disks -1)
and for raid 6, chunk_size =3D Stripe_Size / total_disks -2)

and parity is also written in terms of chunk size.

Now considering a case where IO request came for complete 1 stripe, we
need buffer, for 1 stripe, but since we allocated 1 page per chunk,
instead of 64k buffer we have only 4k buffer, So how this is handled?


Thanks & Regards,
Kunal

On Sat, May 2, 2009 at 3:11 AM, Goswin von Brederlow <goswin-v-b@web.de=
> wrote:
> Kunal Kushwaha <kunal.kushwaha@gmail.com> writes:
>
>> Hi Neil,
>>
>> Thanks for your reply. I am trying to find out =A0problems that I co=
uld
>> face later on.
>>
>> On Wed, Apr 29, 2009 at 7:15 AM, Neil Brown <neilb@suse.de> wrote:
>>> On Tuesday April 28, kunal.kushwaha@gmail.com wrote:
>>>> Hi,
>>>>
>>>> I am trying to put Linux raid in Box with 256 MB of RAM. The kerne=
l is
>>>> compiled with non-swappable memory management option. I looked int=
o
>>>> raid5.c and found, it allocates one page for each chunk. =A0I am u=
sing 5
>>>> disks for 64k chunk size. considering my kernel is within 30 MB.
>>>
>>> That isn't quite right. =A0 It is not 1 page per chunk.
>>> raid5 maintains a stripe cache. =A0Each entry in the cache has one =
page
>>> per device, and there are 256 entries by default.
>>> So for a 5-disk array, that is 5*256 =3D=3D 1280 pages or 5MB (plus
>>> overhead).
>>>
>>
>> Sorry I missed to mention about stripe cache. Yes we will be using
>> only 5MB if we
>> consider page size is of 4k.
>>
>> I have one more doubt regarding this. How a page of 4k will be able =
to
>> store data of
>> 64k( my chunk size if of 64k) ?
>
> A chunk size of 64k does in no way mean all transactions are done in
> 64k chunks.
>
> What effect does chunk size actually do have? Was it just the amount
> of sequential data before the parity is rotated in a raid5/6.
>
> MfG
> =A0 =A0 =A0 =A0Goswin
>



--=20
Regards,
Kunal Kushwaha
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
