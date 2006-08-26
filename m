From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: Linux: Why software RAID?
Date: Sat, 26 Aug 2006 15:18:37 +0300
Message-ID: <5d96567b0608260518j3c6e36cdx8c7e8c7bda34ee5c@mail.gmail.com>
References: <20060826035034.13307.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060826035034.13307.qmail@science.horizon.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: "linux@horizon.com" <linux@horizon.com>
List-Id: linux-raid.ids

Furthremore , hw controller are much less feaure rich than sw raid.
many different stripe sizes, stripe cache tunning ....

On 25 Aug 2006 23:50:34 -0400, linux@horizon.com <linux@horizon.com> wrote:
> > Hardware RAID can be (!= is) more tolerant of serious drive failures
> > where a single drive locks up the bus. A high-end hardware RAID card
> > may be designed with independent controllers so a single drive failure
> > cannot take other spindles down with it. The same can be accomplished
> > with sw RAID of course if the builder is careful to use multiple PCI
> > cards, etc. Sw RAID over your motherboard's onboard controllers leaves
> > you vulnerable.
>
> Which is exactly why I *like* SW RAID - I can, and do, have the mirrors
> span controllers so a whole controller can fail without taking down
> the system.
>
> With HW RAID cards, if your controller dies, you're SOL.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Raz
