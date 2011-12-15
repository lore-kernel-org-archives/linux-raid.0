From: Tao Guo <glorioustao@gmail.com>
Subject: Re: Data scribbling for raid6 is wrong?
Date: Thu, 15 Dec 2011 13:48:40 +0800
Message-ID: <CAAV8rnKb5VUEW1hNK0osK7jn1Yn3QSWxyyuxeMUvLxq+2suMdw@mail.gmail.com>
References: <CAAV8rnKoga_DM1qh28ZGEsJMZAKPYDZcVFfLBSH9kPNHysf7LQ@mail.gmail.com>
 <20111215152723.1d2bcca0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111215152723.1d2bcca0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks, excellent article.

On Thu, Dec 15, 2011 at 12:27 PM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 15 Dec 2011 11:15:42 +0800 Tao Guo <glorioustao@gmail.com> wr=
ote:
>
>> Hi all,
>>
>> Today I checked the raid6's scribbling code, and I think there may b=
e
>> some improvements to handle bad sectors:
>
> I think the common term is "scrubbing" rather than "scribbling".
>
>>
>> If we have one bad sector(with corrupted data) in the data block,
>> scribbling thread will find parity mismatch and will try to
>> recompute&rewrite P&Q, but that will cause final data loss.
>> Since we have P & Q,=C2=A0 actually we can try to use them and find =
out the
>> wrong data block then fix it.
>>
>> But the algorithm to find the bad data block seems not
>> straightforward... Does anyone know if there is any paper discussed
>> this issue before?
>>
>> Update: I just found there is one talk about this in FAST08:
>> http://www.usenix.org/events/fast08/tech/krioukov.html.
>> But that approach will add checksums.etc. For bare-bones raid6, does
>> any guru have any better ideas?
>
> http://neil.brown.name/blog/20100211050355
>
> NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
