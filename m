From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Tue, 14 Jan 2014 10:06:13 +0100
Message-ID: <52D4FE05.3020709@assyoma.it>
References: <52BD8EDD.10809@assyoma.it>	<20131227151927.GA4003@www5.open-std.org>	<52BD9B4F.3000509@assyoma.it>	<20131227154952.GA6539@www5.open-std.org>	<52CE57D9.1030501@assyoma.it>	<20140113102021.1ef3e203@notabene.brown>	<52D3A962.4000308@assyoma.it>	<20140113204534.737a98f6@notabene.brown>	<52D3BCB1.1010200@assyoma.it> <20140114092751.09464b7b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140114092751.09464b7b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, keld@keldix.com, Gionatan Danti <g.danti@assyoma.it>
List-Id: linux-raid.ids

On 01/13/2014 11:27 PM, NeilBrown wrote:
>>
>> Mmm... they seem different to me.
>>
>> SeSe FAR Layout:
>>
>> sda1 sdb1 sdc1 sde1
>>     0    1    2    3
>>     4    5    6    7
>>     . . .
>>     3    0    1    2
>>     7    4    5    6
>>
>> Notice how (for example) sdb1 is coupled both to sda1 (0,4) and
>> sdc1(1,5). If sdb1 fails, any sda1 or sdc1 failure lead to data loss.
>>
>> Now, Wikipedia FAR Layout:
>>
>> 4 drives (sda1, sdb1, sdc1, sdd1)
>> --------------------
>> A1   A2   A3   A4
>> A5   A6   A7   A8
>> A9   A10  A11  A12
>> ..   ..   ..   ..
>> A2   A1   A4   A3
>> A6   A5   A8   A7
>> A10  A9   A12  A11
>> ..   ..   ..   ..
>>
>> Notice now how a single disk (eg: sdb1) is coupled to only another
>> _single_ disk (eg: sda1). In this case, if sdb1 fails, you had to lose
>> sda1 to have a data loss. Losing sdc1 or sdd1 will _not_ lead to data loss.
>>
>
> Thanks for being explicit - it is much easier to answer explicit questions :-)
>
> Yes, they are different.  So the wikipedia article is wrong, or at least
> misleading.  That is not what the "f2" layout looks like.
>
> The md driver does support that layout.  I don't know yet what mdadm will
> call it, but it won't be called "f2".
>
> So this change:
>
> http://en.wikipedia.org/w/index.php?title=Non-standard_RAID_levels&diff=501908270&oldid=501604733
>
> was wrong.
>
> NeilBrown
>

Ok, so let recap:

1) FAR layout is the one depicted by SuSe documentation, while the 
Wikipedia entry is wrong

2) MD _can_ produce a FAR layout as depicted by Wikipedia, but we don't 
know how the user-space mdadm tool call it (maybe it is not implemented 
yet?)

3) There are any reasons why FAR and OFFSET layout scramble data in this 
manner, coupling any disk with two more disks? It was done for 
simplicity, or I am missing something?

4) you confirm that currently we can _not_ create a FAR layout as the 
one depicted by wikipedia by no means? What about OFFSET layout?

Thank you very much.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
