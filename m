From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
Date: Sat, 17 Mar 2012 14:14:43 -0400
Message-ID: <4F64D493.9010404@teksavvy.com>
References: <20120312030412.375458948@fusionio.com> <20120314132422.3aeb6d49@notabene.brown> <4F6006C3.4010204@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F6006C3.4010204@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-raid.ids

On 12-03-13 10:47 PM, Shaohua Li wrote:
> On 3/14/12 10:24 AM, NeilBrown wrote:
>>  On Mon, 12 Mar 2012 11:04:12 +0800 Shaohua Li <shli@fusionio.com> wrote:
..
>>  Also I wonder about handling failure in RAID1.
>>  I think the code will currently treat it like a write error, and
>>  maybe record a bad block (then fail the device is writing the badblock
>>  record fails). Is that what were want?
> Mainly to simplify the code. And I thought a normal discard should not fail.
> If it fails, something is wrong, marked it as badblock maybe not bad.

That sounds like a VERY bad idea.
Failures happen for lots of reasons,
but generic comm errors are not an excuse to suddenly mark sectors as bad.
