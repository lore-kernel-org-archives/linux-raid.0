From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 9 May 2017 10:05:33 -0600
Message-ID: <CAJCQCtQyLjcut=DvPz1QeL8axRMrewkFm3JAOKB66uqWMRHePg@mail.gmail.com>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee> <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee> <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee> <590DC905.60207@youngman.org.uk>
 <87h90v8kt3.fsf@esperi.org.uk> <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
 <87vapb6s9h.fsf@esperi.org.uk> <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: Nix <nix@esperi.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 8, 2017 at 2:27 PM, Anthony Youngman
<antlists@youngman.org.uk> wrote:


> Yes you have saved a sector sparing. Note that a consumer 3TB drive can
> return, on average, one error every time it's read from end to end 3 times,
> and still be considered "within spec" ie "not faulty" by the manufacturer.

All specs say "less than" which means it's a maximum permissible rate,
not an average. We have no idea what the minimum error rate is - we
being consumers. It's possible high volume users (e.g. Backblaze) have
data on this by now.



> And that's a *brand* *new* drive. That's why building a large array using
> consumer drives is a stupid idea - 4 x 3TB drives and a *within* *spec*
> array must expect to handle at least one error every scrub.

The requirement for any large array is quickly abandoning reattempted
reads in favor of reporting a read error. That's the main reason why
consumer drives are a bad idea, is that it can hang user space waiting
on the long recovery of a drive.


-- 
Chris Murphy
