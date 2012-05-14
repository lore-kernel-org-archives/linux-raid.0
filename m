From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: ANNOUNCE: mdadm 3.2.4 - A tool for managing Soft RAID under Linux
Date: Mon, 14 May 2012 22:58:58 +0200
Message-ID: <4FB17212.3000308@redhat.com>
References: <2598499.YYnUQlf0Se@localhost> <4FB16B68.3000201@redhat.com> <1714869.L4aqWfddyq@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1714869.L4aqWfddyq@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@agmk.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/14/12 22:57, Pawe=C5=82 Sikora wrote:
> On Monday 14 of May 2012 22:30:32 Jes Sorensen wrote:
>> On 05/12/12 08:36, Pawe=C5=82 Sikora wrote:
>>> fyi, this release contains a hidden strict-aliasing-violation bug [=
1].
>>> please fix this correctly or build mdadm with -fno-strict-aliasing =
option.
>>>
>>> [1] http://www.spinics.net/lists/raid/msg37298.html
>>
>> If you provide a patch, you're more likely to get the issue fixed th=
an
>> by just telling other people to fix it for you.
>=20
> i have sent you a revert request with a proper fix 3 months ago
> and you have finally rejected it with "invalid commit message",
> so feel free to keep broken mdadm sources as long as you wish :>
>=20

If you post a patch without including a proper commit message and
signed-off-by lines, which is standard practice, then that is equivalen=
t
to you not having posted a patch in the first place.

Don't blame others for not doing the basic work everybody else does whe=
n
posting patches. It really isn't hard to comply with the standard patch
posting rules!

Jes
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
