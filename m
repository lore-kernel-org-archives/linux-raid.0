From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Mon, 13 Jan 2014 11:15:13 +0100
Message-ID: <52D3BCB1.1010200@assyoma.it>
References: <52BD8EDD.10809@assyoma.it>	<20131227151927.GA4003@www5.open-std.org>	<52BD9B4F.3000509@assyoma.it>	<20131227154952.GA6539@www5.open-std.org>	<52CE57D9.1030501@assyoma.it>	<20140113102021.1ef3e203@notabene.brown>	<52D3A962.4000308@assyoma.it> <20140113204534.737a98f6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140113204534.737a98f6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, keld@keldix.com, Gionatan Danti <g.danti@assyoma.it>
List-Id: linux-raid.ids

On 01/13/2014 10:45 AM, NeilBrown wrote:
> On Mon, 13 Jan 2014 09:52:50 +0100 Gionatan Danti <g.danti@assyoma.it> wrote:
>
>> Hi Neil,
>> let me recap from a previous message:
>>
>>   >FAR LAYOUT
>>   >md(4) states:
>>   >"The first copy of all data blocks will be striped across the early >part
>>   >of all drives in RAID0 fashion, and then the next copy of all blocks
>>   >will be striped across a later section of all drives, always ensuring
>>   >that all copies of any given block are on different drives"
>>   >
>>   >The "on different drives" part let me wonder _how_ are chunks
>>   >distributed. On a 4-disk array, I can imagine some different schemas:
>>   >
>>   >1)	A1 A2 A3 A4
>>   >	.. .. .. ..
>>   >	A4 A1 A2 A3
>>   >
>>   >2)	A1 A2 A3 A4
>>   >	.. .. .. ..
>>   >	A2 A1 A4 A3
>>   >
>>   >The first schema is the one depicted by SuSe documentation [1], while
>>   >the second is the one described by Wikipedia [2].
>>   >
>>   >Question 1: as the two schema have different reliability
>>   >characteristics, which is really used?
>>
>> SuSe entry:
>> https://www.suse.com/documentation/sles11/stor_admin/data/raidmdadmr10cpx.html#b7cynnk
>>
>> Wikipedia entry:
>> http://en.wikipedia.org/wiki/Linux_MD_RAID_10#LINUX-MD-RAID-10 (see how
>> far layout is depicted)
>>
>> Keld kindly told me that the SuSe is simply not updated, as it depict a
>> situation changed with newer kernels. So my two questions:
>
> I cannot see an important difference between the two pages you reference.
> Both appear to be correct.

Mmm... they seem different to me.

SeSe FAR Layout:

sda1 sdb1 sdc1 sde1
   0    1    2    3
   4    5    6    7
   . . .
   3    0    1    2
   7    4    5    6

Notice how (for example) sdb1 is coupled both to sda1 (0,4) and 
sdc1(1,5). If sdb1 fails, any sda1 or sdc1 failure lead to data loss.

Now, Wikipedia FAR Layout:

4 drives (sda1, sdb1, sdc1, sdd1)
--------------------
A1   A2   A3   A4
A5   A6   A7   A8
A9   A10  A11  A12
..   ..   ..   ..
A2   A1   A4   A3
A6   A5   A8   A7
A10  A9   A12  A11
..   ..   ..   ..

Notice now how a single disk (eg: sdb1) is coupled to only another 
_single_ disk (eg: sda1). In this case, if sdb1 fails, you had to lose 
sda1 to have a data loss. Losing sdc1 or sdd1 will _not_ lead to data loss.

I am wrong?

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
