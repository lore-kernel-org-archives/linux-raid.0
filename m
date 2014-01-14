From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Tue, 14 Jan 2014 10:27:12 +0100
Message-ID: <52D502F0.2090703@assyoma.it>
References: <52BD8EDD.10809@assyoma.it>	<20131227151927.GA4003@www5.open-std.org>	<52BD9B4F.3000509@assyoma.it>	<20131227154952.GA6539@www5.open-std.org>	<52CE57D9.1030501@assyoma.it>	<20140113102021.1ef3e203@notabene.brown>	<52D3A962.4000308@assyoma.it>	<20140113204534.737a98f6@notabene.brown>	<52D3BCB1.1010200@assyoma.it>	<20140114092751.09464b7b@notabene.brown>	<52D4FE05.3020709@assyoma.it> <20140114201655.61f4e10b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140114201655.61f4e10b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, keld@keldix.com, Gionatan Danti <g.danti@assyoma.it>
List-Id: linux-raid.ids

>> Ok, so let recap:
>>
>> 1) FAR layout is the one depicted by SuSe documentation, while the
>> Wikipedia entry is wrong
>
> Yes.
>
>>
>> 2) MD _can_ produce a FAR layout as depicted by Wikipedia, but we don't
>> know how the user-space mdadm tool call it (maybe it is not implemented
>> yet?)
>
> Yes.  Not implemented yet.
>
>>
>> 3) There are any reasons why FAR and OFFSET layout scramble data in this
>> manner, coupling any disk with two more disks? It was done for
>> simplicity, or I am missing something?
>
> It just seemed the easiest thing to do at the time.
>
>>
>> 4) you confirm that currently we can _not_ create a FAR layout as the
>> one depicted by wikipedia by no means? What about OFFSET layout?
>
> You certainly can created the FAR layout depicted on wikipedia, e.g. by
> binary-editing the metadata on some devices, or writing some code which does
> that for you.  It requires flipping one bit in the metadata and updating the
> checksum.  You can probably even to it by writing something appropriate into
> some sysfs files.
> But mdadm cannot do it yet.
> Ditto for the new OFFSET layout.
> (The old offset layout can be created with "--layout=o2").
>
> NeilBrown
>

All clear now :)

Thank you very much Neil.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
