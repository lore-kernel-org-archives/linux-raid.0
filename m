From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
Date: Fri, 09 Nov 2012 12:39:05 +0100
Message-ID: <ead47490-afc3-48f1-871f-ba421eac3dd5@email.android.com>
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com> <1352460945.4387.7.camel@mattotaupa>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1352460945.4387.7.camel@mattotaupa>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Menzel <pm.debian@googlemail.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Sorry, we cannot share those at this time since the hardwarenis not yet=
 released.

Paul Menzel <pm.debian@googlemail.com> wrote:

>Dear Jim,
>
>
>Am Donnerstag, den 08.11.2012, 13:47 -0800 schrieb Jim Kukunas:
>> Optimize RAID6 recovery functions to take advantage of
>> the 256-bit YMM integer instructions introduced in AVX2.
>
>in my experiencing optimizations always have to be back up by
>benchmarks. Could you add those to the commit message please.
>
>> Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
>
>[=E2=80=A6]
>
>
>Thanks,
>
>Paul

--=20
Sent from my mobile phone. Please excuse brevity and lack of formatting=
=2E
