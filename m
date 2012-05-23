From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: SSSE6 / RAID6
Date: Wed, 23 May 2012 01:30:16 +0100
Message-ID: <CADNH=7EH-6eS++xh1Swis7qBu6x1OjXpND+bseowjwau-Ae=Qg@mail.gmail.com>
References: <CADNH=7HByQyQy=Bbn5AjO=nz8437QOCjGbkVhiUAKwp61_is0A@mail.gmail.com>
	<4FBC10AC.3000803@zytor.com>
	<CADNH=7HtXPqwe_MDPg=hwPTjFgBUcXkyv3WkhZyJ2cpv4J1aqA@mail.gmail.com>
	<20120523002655.GA2701@jtkukuna_gentoo_sb.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120523002655.GA2701@jtkukuna_gentoo_sb.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23 May 2012 01:26, Jim Kukunas <james.t.kukunas@linux.intel.com> wro=
te:
> On Wed, May 23, 2012 at 12:37:32AM +0100, Mathias Bur=C3=A9n wrote:
>> On 22 May 2012 23:18, H. Peter Anvin <hpa@zytor.com> wrote:
>> > On 05/22/2012 02:27 PM, Mathias Bur=C3=A9n wrote:
>> >> Hi list,
>> >>
>> >> I just compiled 3.4 for my little Atom box. Is there any way I ca=
n
>> >> confirm if the RAID6 check is using SSSE6 instructions?
>
> <snip>
>
> The _SSSE3_ RAID6 recovery functions are in Neil's for-next tree. The=
y aren't
> in 3.4.
>
> If they were, you'd see something like:
>
> % dmesg | grep ssse3
> [ =C2=A0 =C2=A00.167849] raid6: using ssse3x1 recovery algorithm
>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
> --
> Jim Kukunas
> Intel Open Source Technology Center

Aha, that makes sense now. (Neil; I meant SSSE3. Obviously SSSE3 +
RAID6 becomes SSSE6 ;))

Perhaps I can cherry pick these patches and apply them to 3.4.

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
