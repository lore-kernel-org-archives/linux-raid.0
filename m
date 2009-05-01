From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Query regarding stripe management in linux md-raid
Date: Fri, 01 May 2009 23:41:17 +0200
Message-ID: <87zldwjybm.fsf@frosties.localdomain>
References: <fbae8f520904280702h736197d6ibfdf0212bf1923d2@mail.gmail.com>
	<18935.36392.65600.930716@notabene.brown>
	<fbae8f520904290027x6b65419co164c61db7b249223@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fbae8f520904290027x6b65419co164c61db7b249223@mail.gmail.com>
	(Kunal Kushwaha's message of "Wed, 29 Apr 2009 15:27:28 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Kunal Kushwaha <kunal.kushwaha@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kunal Kushwaha <kunal.kushwaha@gmail.com> writes:

> Hi Neil,
>
> Thanks for your reply. I am trying to find out  problems that I could
> face later on.
>
> On Wed, Apr 29, 2009 at 7:15 AM, Neil Brown <neilb@suse.de> wrote:
>> On Tuesday April 28, kunal.kushwaha@gmail.com wrote:
>>> Hi,
>>>
>>> I am trying to put Linux raid in Box with 256 MB of RAM. The kernel=
 is
>>> compiled with non-swappable memory management option. I looked into
>>> raid5.c and found, it allocates one page for each chunk. =A0I am us=
ing 5
>>> disks for 64k chunk size. considering my kernel is within 30 MB.
>>
>> That isn't quite right. =A0 It is not 1 page per chunk.
>> raid5 maintains a stripe cache. =A0Each entry in the cache has one p=
age
>> per device, and there are 256 entries by default.
>> So for a 5-disk array, that is 5*256 =3D=3D 1280 pages or 5MB (plus
>> overhead).
>>
>
> Sorry I missed to mention about stripe cache. Yes we will be using
> only 5MB if we
> consider page size is of 4k.
>
> I have one more doubt regarding this. How a page of 4k will be able t=
o
> store data of
> 64k( my chunk size if of 64k) ?

A chunk size of 64k does in no way mean all transactions are done in
64k chunks.

What effect does chunk size actually do have? Was it just the amount
of sequential data before the parity is rotated in a raid5/6.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
