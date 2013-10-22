From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: raid5 trim OOPS / use after free?
Date: Tue, 22 Oct 2013 10:36:54 +0200
Message-ID: <wrfjzjq1d7mh.fsf@redhat.com>
References: <CE884D0C.64F9%shli@fusionio.com> <wrfj38nug63y.fsf@redhat.com>
	<96619C4E5865E4479F08FA01268918B346FC62F4@FMSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <96619C4E5865E4479F08FA01268918B346FC62F4@FMSMSX106.amr.corp.intel.com>
	(Michael J. DeGon's message of "Mon, 21 Oct 2013 18:23:12 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: "DeGon, Michael J" <michael.j.degon@intel.com>
Cc: Shaohua Li <ShLi@fusionio.com>, "stan@hardwarefreak.com" <stan@hardwarefreak.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, Jeff Moyer <jmoyer@redhat.com>
List-Id: linux-raid.ids

"DeGon, Michael J" <michael.j.degon@intel.com> writes:
> All, 
>
> On Friday, I installed and tested the pre- 3.7 raid5 trim kernel,
> 3.6.10 kernel.
>
> I was able to create an xfs filesystem on a RAID5 SSD array without
> the kernel panic.
>
> This leads me to believe that the raid5 trim feature added in kernel
> 3.7 may have caused the issue I reported.

It is will understand that the crash problem appeared with the TRIM
patches for RAID5, so no surprise.

Regards,
Jes

>
> Regards, 
>
> Michael 
>   
>
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jes Sorensen
> Sent: Monday, October 21, 2013 5:29 AM
> To: Shaohua Li
> Cc: stan@hardwarefreak.com; linux-raid@vger.kernel.org; NeilBrown; Jeff Moyer
> Subject: Re: raid5 trim OOPS / use after free?
>
> Shaohua Li <ShLi@fusionio.com> writes:
>> On 10/18/13 2:03 PM, "Jes Sorensen" <Jes.Sorensen@redhat.com> wrote:
>>
>>>Stan Hoeppner <stan@hardwarefreak.com> writes:
>>>> On 10/17/2013 4:58 PM, Jes Sorensen wrote:
>>>>> Hi,
>>>>> 
>>>>> I have been trying out the trim code in recent kernels and I am 
>>>>> consistently seeing crashes with the raid5 trim implementation.
>>>>> 
>>>>> I am seeing 3-4 different OOPS outputs which are very different in 
>>>>>their  output. This makes me suspect this is a memory corruption of 
>>>>>use after  free problem?
>>>>> 
>>>>> Basically I have a system with an AHCI controller and 4 SATA SSD 
>>>>> drives hooked up to it. I create a raid5 and then run mkfs.ext4 on 
>>>>> it and the fireworks display starts.
>>>>> 
>>>>> I first saw this with an older kernel with some backports applied, 
>>>>>but I  am able to reproduce this with the current top of tree out of 
>>>>>Linus'
>>>>> tree.
>>>>> 
>>>>> Any ideas?
>>>>
>>>> See a nearly identical problem posted to this list yesterday:
>>>>
>>>> http://www.spinics.net/lists/raid/msg44686.html
>>>
>>>Looks the same - I believe I have seen that variation of the problem 
>>>as well.
>>
>> Ok, looks we have some problems with request merge in SCSI. I just 
>> posted some patches to linux-raid maillist, please test and report back.
>
> Hi Shaohua,
>
> Thanks for the quick reply. I will test them as soon as I can, but it probably wont be until the end of the week.
>
> Regards,
> Jes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
