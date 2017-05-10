From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 9 May 2017 21:06:49 -0600
Message-ID: <CAJCQCtSYMcMpySc9YCaExXxhSTB5XgRRhuEM2Drh1qosTPqnsw@mail.gmail.com>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee> <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee> <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee> <590DC905.60207@youngman.org.uk>
 <87h90v8kt3.fsf@esperi.org.uk> <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
 <87vapb6s9h.fsf@esperi.org.uk> <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
 <CAJCQCtQyLjcut=DvPz1QeL8axRMrewkFm3JAOKB66uqWMRHePg@mail.gmail.com> <59120114.6080702@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59120114.6080702@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Chris Murphy <lists@colorremedies.com>, Nix <nix@esperi.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 9, 2017 at 11:49 AM, Wols Lists <antlists@youngman.org.uk> wrote:
> On 09/05/17 17:05, Chris Murphy wrote:
>>> Yes you have saved a sector sparing. Note that a consumer 3TB drive can
>>> > return, on average, one error every time it's read from end to end 3 times,
>>> > and still be considered "within spec" ie "not faulty" by the manufacturer.
>
>> All specs say "less than" which means it's a maximum permissible rate,
>> not an average. We have no idea what the minimum error rate is - we
>> being consumers. It's possible high volume users (e.g. Backblaze) have
>> data on this by now.
>>
> In other words, an error rate that high is "acceptable".

It's acceptable in that the manufacturer sells products with such
specification and consumers buy them. It's totally voluntary. There
are drives with one and two orders of magnitude lower unrecoverable
error rates and some people buy them and pay extra to get that spec as
a feature among other features.


> And to design software that quite explicitly expects greater perfection
> than the hardware itself is guaranteed to provide is, in my humble
> opinion, downright negligent!!!

How does the software expect a lower error rate than the drive specification?




-- 
Chris Murphy
