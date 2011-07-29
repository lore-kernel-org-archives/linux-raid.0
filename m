From: David Brown <david.brown@hesbynett.no>
Subject: Re: data scrubbing
Date: Sat, 30 Jul 2011 00:16:55 +0200
Message-ID: <j0vbgn$n5e$1@dough.gmane.org>
References: <4E327445.9080404@oldum.net>	<alpine.DEB.2.00.1107291200580.22537@uplift.swm.pp.se>	<4E32B4D3.3030905@oldum.net>	<CADc_k_uV2eOpK+tNxpph3ky2J0OOf_LPF7cNK7f5fPAFpy4Dpw@mail.gmail.com> <CADNH=7EXh1JSbbJ6nzDsnva7+-Ug6YdqDrVX2aSd5ezJVzvsTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7EXh1JSbbJ6nzDsnva7+-Ug6YdqDrVX2aSd5ezJVzvsTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/07/11 23:51, Mathias Bur=C3=A9n wrote:
> On 29 July 2011 21:48, Beolach<beolach@gmail.com>  wrote:
>> On Fri, Jul 29, 2011 at 07:25, Nikolay Kichukov<hijacker@oldum.net> =
 wrote:
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA1
>>>
>>> Hi,
>>>
>>> This is a good to know!
>>>
>>> Just performed a check on a raid1 and got:
>>>
>>> Jul 29 15:37:36 hanna64 mdadm[2277]: RebuildFinished event detected=
 on md device /dev/md1, component device  mismatches
>>> found: 128
>>>
>>> So I presume those mismatches have now been rewritten to both disks=
 successfully. Am I wrong there?
>>>
>>> cat /sys/block/md1/md/mismatch_cnt
>>> 128
>>>
>>>
>>
>> That depends on if you did a "check" or a "repair" - see the SCRUBBI=
NG
>> AND MISMATCHES section of the md(4) man page:
>> "If  check  was used, then no action is taken to handle the mismatch=
,
>> it is simply recorded.  If repair  was  used,  then  a  mismatch  wi=
ll
>>   be repaired  in  the same way that resync repairs arrays."
>>
>>
>> Good luck,
>> Beolach
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Sorry to chime in like this. After reading the above, is there a
> reason why anyone shouldn't _always_ use repair instead of check on a
> weekly RAID6 check? You have to run repair anyway after a check if an=
y
> issues are found, right?
>
> Or does the system become vulnerable during a repair? (less redundant=
)
>
> Thanks,
> Mathias

If you do a repair, then when a mismatch is found one of the disks is=20
taken as the "bad" one, and re-created.  For raid1, the first copy is=20
assumed correct.  For raid5/6, the data blocks are assumed correct and=20
the parities re-created.  As Neil Brown explained on his blog, without=20
any more information then this is as good as md raid can do.  However,=20
it is not necessarily as good as /you/ can do.  For example, you might=20
be able to determine which files use the blocks in the mismatched=20
stripe, and figure out which block was bad.  Or for 3-disk raid1 you=20
could pick the bad block as the odd one out (assuming the other two=20
matched).  For raid6, it's possible to spot if it is a single-disk=20
mismatch and correct that one disk (for each disk in turn, assume it is=
=20
missing and re-create it from the other disks using normal raid6=20
recovery.  If the stripe is then consistent, you've fixed the mismatch)=
=2E=20
  However, such approaches are not necessarily the correct one.  Thus=20
the "repair" just does the simplest and fastest correction of the=20
mismatch, and "check" does not change the stripe in case you want to=20
manually pick a different method.

<http://neil.brown.name/blog/20100211050355>



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
