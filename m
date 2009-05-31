From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: RAID5 reconstruction ?
Date: Sun, 31 May 2009 13:54:29 +0200
Message-ID: <87ljod7aiy.fsf@frosties.localdomain>
References: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com>
	<4A213612.7080206@anonymous.org.uk>
	<1243699735.5740.103.camel@localhost>
	<878wkezagw.fsf@frosties.localdomain>
	<1243712247.5740.105.camel@localhost>
	<37d33d830905310102m451f26aaw8e233227cda491c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830905310102m451f26aaw8e233227cda491c@mail.gmail.com>
	(sandeepksinha@gmail.com's message of "Sun, 31 May 2009 13:32:03
	+0530")
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Redeeman <redeeman@metanurb.dk>, Goswin von Brederlow <goswin-v-b@web.de>, John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

SandeepKsinha <sandeepksinha@gmail.com> writes:

> On Sun, May 31, 2009 at 1:07 AM, Redeeman <redeeman@metanurb.dk> wrot=
e:
>> On Sat, 2009-05-30 at 20:55 +0200, Goswin von Brederlow wrote:
>>> And just when I hit send I thought of something else.
>>>
>>> Instead of the initial sync when creating a raid the bitmap could j=
ust
>>> mark all blocks as unused. Much faster raid creation.
>>
>
>
> This really sounds like a good option. This would have a slight hit
> for writes which I believe will compensate for later re-constructions=
,
> replacing a disk, mirror resysnc and many more operation.

What hit? Currently with bitmap support a write will set the block to
"unclean", write the data, write the parity and set the block to
"clean". Setting the "used" bit along the way should not cost much.

Only difference I see is that the bitmap would have to have finer
granularity so one "used" bit covers one filesystem block (4k usualy).
Otherwise you could only "use" blocks but not "unuse" them again when
the filesystem frees them in 4k chunks.

> Neil any comments on this?
>
> I mean, how difficult would it be to maintain such a bitmap. This can
> though of making something optional as this will incur space.
>
>
>> A filesystem-coexist mode could also do this, by simply refusing
>> operation until such a time that a filesystem is detected, or i supp=
ose
>> in worst case, mounted...
>
>
>>
>>>
>>> MfG
>>> =A0 =A0 =A0 =A0 Goswin

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
