From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Mon, 13 Jan 2014 09:52:50 +0100
Message-ID: <52D3A962.4000308@assyoma.it>
References: <52BD8EDD.10809@assyoma.it>	<20131227151927.GA4003@www5.open-std.org>	<52BD9B4F.3000509@assyoma.it>	<20131227154952.GA6539@www5.open-std.org>	<52CE57D9.1030501@assyoma.it> <20140113102021.1ef3e203@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140113102021.1ef3e203@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, keld@keldix.com, Gionatan Danti <g.danti@assyoma.it>
List-Id: linux-raid.ids

Hi Neil,
let me recap from a previous message:

 >FAR LAYOUT
 >md(4) states:
 >"The first copy of all data blocks will be striped across the early >part
 >of all drives in RAID0 fashion, and then the next copy of all blocks
 >will be striped across a later section of all drives, always ensuring
 >that all copies of any given block are on different drives"
 >
 >The "on different drives" part let me wonder _how_ are chunks
 >distributed. On a 4-disk array, I can imagine some different schemas:
 >
 >1)	A1 A2 A3 A4
 >	.. .. .. ..
 >	A4 A1 A2 A3
 >
 >2)	A1 A2 A3 A4
 >	.. .. .. ..
 >	A2 A1 A4 A3
 >
 >The first schema is the one depicted by SuSe documentation [1], while
 >the second is the one described by Wikipedia [2].
 >
 >Question 1: as the two schema have different reliability
 >characteristics, which is really used?

SuSe entry: 
https://www.suse.com/documentation/sles11/stor_admin/data/raidmdadmr10cpx.html#b7cynnk

Wikipedia entry: 
http://en.wikipedia.org/wiki/Linux_MD_RAID_10#LINUX-MD-RAID-10 (see how 
far layout is depicted)

Keld kindly told me that the SuSe is simply not updated, as it depict a 
situation changed with newer kernels. So my two questions:
1) from which kernel the layout is the one depicted by Wikipedia?
2) it is possible, using mdadm, check what "far" layout is in use?

 From what I can see, a "mdadm --detail /dev/mdWHATEVER | grep Layout" 
tell me if using far vs near vs offset layout, but not the physical 
on-disk chunks organization (eg: far "type" 1 or 2).

Anyway, the thread started because I wonder why the OFFSET layout couple 
each disk to other two disks. Let me quote again:

 >OFFSET LAYOUT
 >md(4) states:
 >"When 'offset' replicas are chosen, the multiple copies of a given >chunk
 >are laid out on consecutive drives and at consecutive offsets.
 >Effectively each stripe is duplicated and the copies are offset by one
 >device."
 >
 >This means a schema like this:
 >	
 >3)	A1 A2 A3 A4
 >	A4 A1 A2 A3
 >	.. .. .. ..
 >
 >However, this is susceptible to any consecutive two-disk failures. A
 >schema like
 >
 >4)	A1 A2 A3 A4
 >	A2 A1 A4 A3
 >
 >would not suffer from this problem (eg: disk 2 & 3 can fail and the
 >array is still working).
 >
 >Question 2: apart from simplicity, why the offset layout use the schema
 >as n.3? I miss something?

Full thread link: http://marc.info/?t=138815504400002&r=1&w=2

Excuse me for the long email, I am simply trying to learn something :)
Thank you very much.

On 01/13/2014 12:20 AM, NeilBrown wrote:
> On Thu, 09 Jan 2014 09:03:37 +0100 Gionatan Danti <g.danti@assyoma.it> wrote:
>
>>>>
>>>> Interesting. Two question:
>>>> 1) from which kernel the layout is the one depicted by Wikipedia?
>
> Exactly what depiction in wikipedia are you referring to?  A link to the
> image might help.
>
>>>> 2) it is possible, using mdadm, check what "far" layout is in use?
>
> mdadm --detail /dev/mdWHATEVER | grep Layout
>
>
>>>
>>> I cannot answer that. Neil Brown should know.
>>>
>>> Best regards
>>> Keld
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> Hi all,
>> anyone with an update on these two questions?
>>
>> I was thinking to use the kernel block trace facility to track disk
>> access and infer the on-disk data structure, but I haven't tried for now.
>>
>> On the other hand, I carefully looked at mdadm output, without finding
>> anything related to physical block placing.
>
> Look for "Layout".
>
> NeilBrown
>
>
>>
>> Any new advices on that regard?
>> Thanks.
>>
>

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
