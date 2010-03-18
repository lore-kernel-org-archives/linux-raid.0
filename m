From: Randy Terbush <randy@terbush.org>
Subject: Re: Possibility for a parallel relaxed RAID?
Date: Thu, 18 Mar 2010 17:00:04 -0600
Message-ID: <7db987b31003181600v30e7efeboaf7c8d0d40dde429@mail.gmail.com>
References: <4BA27898.4010907@panix.com> <20100319085414.6cdddd29@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100319085414.6cdddd29@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Berkey B Walker <berk@panix.com>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

How does md make the decision to drop a drive from the array? Is it a
fail message back from the ATA layer? Quickly getting over my head
here, but I would like to think there are different types of failures
and a failure to complete error correction on the drive should not be
a fatal error to md.

This request is the same as the post I have made earlier this week
regarding "RAID class" drives which I would love to get your response
to.

Tks

On Thu, Mar 18, 2010 at 3:54 PM, Neil Brown <neilb@suse.de> wrote:
> On Thu, 18 Mar 2010 15:01:44 -0400
> Berkey B Walker <berk@panix.com> wrote:
>
>> There maybe many folks out there who want to use RAID on their perso=
nal,
>> non-production systems. =A0Assuming access and thru-put values are n=
ot
>> critical a problem might be "You can't use Desktop drives for RAID".
>> Which, I think, most of us know is not really true, but - - If the
>> timing issues were to be relaxed, allowing the drive to fix itself,
>> before being kicked by the md process, might not the average Joe be
>> better served? =A0There is a big difference between going a mile and
>> buying a commodity drive, and being "up" in an hour vs. finding a
>> working system, going online, paying price+, and getting/paying fast
>> shipping. Which might resolve the issue in days instead of hours.
>>
>> Any possibility of a parallel, less critical to drive response, rele=
ase
>> of md? =A0Or a patch to allow same?
>
> This is not a function of 'md'. =A0md has no timeouts for drives resp=
onding.
> It just submits a request and waits for a success/fail reply.
>
> It may be a function of the lower level SATA/SCSI/FC/whatever driver.=
 =A0You
> would do better to ask the developers of those drivers, maybe start w=
ith the
> maintainer of libata.
>
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
