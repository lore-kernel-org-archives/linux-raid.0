From: Igor Podlesny <for.poige+linux@gmail.com>
Subject: Re: Hi! Is "container" more efficient in terms of I/O op. numbers ...
Date: Fri, 25 May 2012 09:52:52 +0800
Message-ID: <CA+sTkh68eo6by40uPYm7r+xVLLFRKvwSZYJji8x75cqW7JjJ9w@mail.gmail.com>
References: <CA+sTkh55N8YKL5R-a70U9jYrj17hAdLbSoKPy-Xuz2-2S5_P0g@mail.gmail.com>
 <20120525101424.3cb40eb2@notabene.brown>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120525101424.3cb40eb2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25 May 2012 08:14, NeilBrown <neilb@suse.de> wrote:
> On Thu, 24 May 2012 23:30:54 +0800 Igor Podlesny <for.poige+linux@gma=
il.com>
> wrote:
>
>> =C2=A0 =C2=A0... then several "stand-alone" RAIDs on the same HDDs? =
-- Say, when
>> using write intent bitmaps.
>>
>
> I'm not sure you question exactly makes sense, but the answer would b=
e "no"
> if it did :-)

   Well, due to disks seeks are expensive, hot data locality is
preferable and valuable thing, isn't it?
   And it makes sense not only for WIB, but other frequent metadata
updates, doesn't it?

--=20
End of message. Next message?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
