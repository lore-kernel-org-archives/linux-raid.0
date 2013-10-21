From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: raid5 trim OOPS / use after free?
Date: Mon, 21 Oct 2013 14:29:05 +0200
Message-ID: <wrfj38nug63y.fsf@redhat.com>
References: <CE884D0C.64F9%shli@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CE884D0C.64F9%shli@fusionio.com> (Shaohua Li's message of "Sat,
	19 Oct 2013 06:54:49 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <ShLi@fusionio.com>
Cc: "stan@hardwarefreak.com" <stan@hardwarefreak.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, Jeff Moyer <jmoyer@redhat.com>
List-Id: linux-raid.ids

Shaohua Li <ShLi@fusionio.com> writes:
> On 10/18/13 2:03 PM, "Jes Sorensen" <Jes.Sorensen@redhat.com> wrote:
>
>>Stan Hoeppner <stan@hardwarefreak.com> writes:
>>> On 10/17/2013 4:58 PM, Jes Sorensen wrote:
>>>> Hi,
>>>> 
>>>> I have been trying out the trim code in recent kernels and I am
>>>> consistently seeing crashes with the raid5 trim implementation.
>>>> 
>>>> I am seeing 3-4 different OOPS outputs which are very different in
>>>>their
>>>> output. This makes me suspect this is a memory corruption of use after
>>>> free problem?
>>>> 
>>>> Basically I have a system with an AHCI controller and 4 SATA SSD drives
>>>> hooked up to it. I create a raid5 and then run mkfs.ext4 on it and the
>>>> fireworks display starts.
>>>> 
>>>> I first saw this with an older kernel with some backports applied, but
>>>>I
>>>> am able to reproduce this with the current top of tree out of Linus'
>>>> tree.
>>>> 
>>>> Any ideas?
>>>
>>> See a nearly identical problem posted to this list yesterday:
>>>
>>> http://www.spinics.net/lists/raid/msg44686.html
>>
>>Looks the same - I believe I have seen that variation of the problem as
>>well.
>
> Ok, looks we have some problems with request merge in SCSI. I just posted
> some patches to linux-raid maillist, please test and report back.

Hi Shaohua,

Thanks for the quick reply. I will test them as soon as I can, but it
probably wont be until the end of the week.

Regards,
Jes
