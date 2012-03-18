From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
Date: Sun, 18 Mar 2012 10:03:31 +0800
Message-ID: <CANejiEU5t+Gq-4c=imR9CUNbs32jdLjBZrBw4PWy_UCRGp0==g@mail.gmail.com>
References: <20120312030412.375458948@fusionio.com>
	<20120314132422.3aeb6d49@notabene.brown>
	<4F6006C3.4010204@kernel.org>
	<4F64D493.9010404@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F64D493.9010404@teksavvy.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: NeilBrown <neilb@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-raid.ids

2012/3/18 Mark Lord <kernel@teksavvy.com>:
> On 12-03-13 10:47 PM, Shaohua Li wrote:
>> On 3/14/12 10:24 AM, NeilBrown wrote:
>>> =A0On Mon, 12 Mar 2012 11:04:12 +0800 Shaohua Li <shli@fusionio.com=
> wrote:
> ..
>>> =A0Also I wonder about handling failure in RAID1.
>>> =A0I think the code will currently treat it like a write error, and
>>> =A0maybe record a bad block (then fail the device is writing the ba=
dblock
>>> =A0record fails). Is that what were want?
>> Mainly to simplify the code. And I thought a normal discard should n=
ot fail.
>> If it fails, something is wrong, marked it as badblock maybe not bad=
=2E
>
> That sounds like a VERY bad idea.
> Failures happen for lots of reasons,
> but generic comm errors are not an excuse to suddenly mark sectors as=
 bad.
Not sure if I got it, but we treat discard similar like write. Did you
mean discard
request error is common?
