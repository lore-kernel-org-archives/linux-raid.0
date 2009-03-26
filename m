From: Raz <raziebe@gmail.com>
Subject: Re: Re-size RAID-10
Date: Thu, 26 Mar 2009 09:40:42 +0200
Message-ID: <5d96567b0903260040u7269749y284b66c1f495c48@mail.gmail.com>
References: <49CAA763.3050405@amfes.com> <18890.44223.469.924083@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18890.44223.469.924083@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Hello
I will be grateful for your reply. Currently I am working on raid0
code reshape.
 1. Will you be working on this functionality in the near future ?
 2. Should I save the superblocks like mdadm does in the case of 1,4,5,=
6 ?
 3. What is the heuristics of strip_zones ? why do we need them ?

=2E non-power 2 raid0 chunk sizes.
 4. Other than segments masks issues, why isn't possible ? can't i fix =
raid0
  to support 3MB chunks with a segment of 1MB ?

Thank you

On Thu, Mar 26, 2009 at 12:14 AM, Neil Brown <neilb@suse.de> wrote:
> On Wednesday March 25, dmiller@amfes.com wrote:
>> I think I asked this once before, if so I apologize for the redundan=
cy -
>> but then again maybe something's changed...
>>
>> I've got a RAID-10 array with four drives. =A0It's nearing capacity,=
 and I
>> need to explore expansion options. =A0Can I simply add a pair of new
>> drives? =A0Or do I have to archive the information first and rebuild=
 the
>> array from scratch?
>
> It is not currently possible to resize a raid-10.
>
> NeilBrown
>
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
