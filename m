From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
Date: Fri, 09 Nov 2012 13:24:56 +0100
Message-ID: <71d4fc0f-f147-4cc6-8626-d1f255a2f7f7@email.android.com>
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com> <1352460945.4387.7.camel@mattotaupa> <ead47490-afc3-48f1-871f-ba421eac3dd5@email.android.com> <20121109225025.13a846ca@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121109225025.13a846ca@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Paul Menzel <pm.debian@googlemail.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Linux Raid <linux-raid@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Yes, consider it an implicit Acked-by.

NeilBrown <neilb@suse.de> wrote:

>On Fri, 09 Nov 2012 12:39:05 +0100 "H. Peter Anvin" <hpa@zytor.com>
>wrote:
>
>> Sorry, we cannot share those at this time since the hardwarenis not
>yet released.
>
>Can I take that to imply "Acked-by: "H. Peter Anvin" <hpa@zytor.com>"
>??
>
>It would be nice to have at least a statement like:
>These patches have been tested both with the user-space testing tool
>and in=20
>a RAID6 md array and the pass all test.  While we cannot release
>performance
>numbers as the hardwere is not released, we can confirm that on that
>hardware
> the performance with these patches is faster than without.
>
>I guess I should be able to assume that - surely the patches would not
>be
>posted if it were not true...  But I like to avoid assuming when I can=
=2E
>
>Thanks,
>NeilBrown
>
>
>>=20
>> Paul Menzel <pm.debian@googlemail.com> wrote:
>>=20
>> >Dear Jim,
>> >
>> >
>> >Am Donnerstag, den 08.11.2012, 13:47 -0800 schrieb Jim Kukunas:
>> >> Optimize RAID6 recovery functions to take advantage of
>> >> the 256-bit YMM integer instructions introduced in AVX2.
>> >
>> >in my experiencing optimizations always have to be back up by
>> >benchmarks. Could you add those to the commit message please.
>> >
>> >> Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
>> >
>> >[=E2=80=A6]
>> >
>> >
>> >Thanks,
>> >
>> >Paul
>>=20

--=20
Sent from my mobile phone. Please excuse brevity and lack of formatting=
=2E
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
