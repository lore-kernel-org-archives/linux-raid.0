From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Subject: Re: SMART detects pending sectors; take offline?
Date: Sat, 7 Oct 2017 10:21:22 +0200
Message-ID: <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

On 10/07/17 09:48, Alexander Shenkin wrote:
> My SMART monitoring has picked up some pending sectors on one of my
> RAID0 + RAID5 drives (it's one of the infamous 3TB seagate drives... my
> other 3 failed earlier... this is the last of them, that finally has
> gone as well...).  I've just ordered a replacement (Toshiba P300) that
> will arrive tomorrow... but the question is, what to do in the meantime?
>  Should I take the drive offline?  I suspect so, but would like to
> double check before taking action.  Thanks in advance for any advice.

Given this is "only" a single sector error I would keep it running as
long as you can physically install the new drive and only then take it
offline.

At least theoretically, it may be possible to force the rewrite of this
sector and use the spare sectors of the disk, but I'm not 100% sure if a
simple md check would already trigger it - usually you need to write
"new" data to defective sectors to force the drive's firmware to use the
spare sectors.

But given the replacement disk should arrive soon, I would not act
before that and run with a degraded RAID5 until then.

I'm a bit more worried about the RAID0 here, do you run RAID0 on top of
RAID5 or what is the exact set-up?

cheers

Carsten
