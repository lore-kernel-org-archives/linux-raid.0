From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: Size limitation?
Date: Fri, 1 Jan 2010 21:31:48 +0000
Message-ID: <73e903671001011331jd4d1fbau306e61f89c8b9009@mail.gmail.com>
References: <201001011457.24334.mmclagan@invlogic.com> <73e903671001011328t24405d6oaf418d2b75cd42ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903671001011328t24405d6oaf418d2b75cd42ca@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: mmclagan+reply@invlogic.com
List-Id: linux-raid.ids

On Fri, Jan 1, 2010 at 9:28 PM, Kristleifur Da=F0ason
<kristleifur@gmail.com> wrote:
> On Fri, Jan 1, 2010 at 7:57 PM, Michael McLagan <mmclagan@invlogic.co=
m> wrote:
>> Hello,
>>
>> =A0 I'm trying to set up a large array but isn't working. =A0I tried
>> Googling size limits, etc and came up empty.
>>
>> Any suggestions appreciated
>

Ah, one more thing,
also try creating an actual filesystem on the weirdly "small" array.
Who knows, the size might only be misreported to mdadm. If you do get
the correct size of filesystem, well, at least it's useful to know.
I'd be uneasy about deploying it into production in that state, but
it's good info to have.

-- Kristleifur
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
