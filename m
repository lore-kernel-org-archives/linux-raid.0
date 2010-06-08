From: CoolCold <coolthecold@gmail.com>
Subject: Re: It is possible to put write cache on ssd?
Date: Tue, 8 Jun 2010 16:23:16 +0400
Message-ID: <AANLkTikfDks6aTLal8dJLXhMlGxHtMtZ-L_r0r8IQQ4U@mail.gmail.com>
References: <loom.20100604T102522-67@post.gmane.org>
	<4C0D44FC.8020908@tmr.com>
	<loom.20100608T092726-796@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20100608T092726-796@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario <mgiammarco@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

May be something like
http://github.com/facebook/flashcache/blob/master/doc/flashcache-doc.tx=
t
will be interesting for you.

On Tue, Jun 8, 2010 at 11:31 AM, Mario <mgiammarco@gmail.com> wrote:
> Bill Davidsen <davidsen <at> tmr.com> writes:
>
>
>> Actually playing with that now. I got an Intel SATA 40GB SSD, and I =
am
>> trying various combinations of things to put on it. One thing which =
I
>> hoped would benefit was to put a f/s journal on SSD and then use the
>> option to push all through the journal (data=3Djournal) in hopes tha=
t it
>> would then free the RAM needed for cache and thus speed operation.
>>
>>
>
> Probably it is due to two things:
>
> 1) to see advantages you have to test in a server situation where a
> lot of thread are writing AND others are reading. So in this case
> =A0writes to hard disk can be delayed a lot to give less latency to r=
eads.
> 2) A lot of tuning is due to force linux to keep data on journal
> =A0as long as it can.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
