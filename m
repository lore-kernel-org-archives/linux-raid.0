From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: assistance recovering failed raid6 array
Date: Mon, 20 Feb 2017 19:01:35 +0000
Message-ID: <58AB3D0F.50602@youngman.org.uk>
References: <58AA4B1E.1030809@bosner.de>
 <e01061cb-ea4c-4f64-16e8-e6027adbc70d@turmel.org>
 <E18A7C79-09E0-4361-9F89-68AE1E6FCBF6@bosner.de>
 <5cc1566c-1b4c-c663-56a1-2040b93b46d7@turmel.org>
 <231629B1-0888-4B3D-BD81-F641937AC045@bosner.de>
 <676bd1fa-4b97-2c6a-05b8-bd23290fb9a6@turmel.org>
 <54F6D166-0D54-49EF-B967-124DC582B299@bosner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54F6D166-0D54-49EF-B967-124DC582B299@bosner.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Bosner <martin@bosner.de>, Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/02/17 18:27, Martin Bosner wrote:
> 
>> On 20 Feb 2017, at 19:11, Phil Turmel <philip@turmel.org> wrote:
>>
>> Of the 36 original disks, you have 34.  You have one incomplete
>> rebuild, meaning it is still technically a spare. One of the still
>> active 34 is also showing pending relocations, meaning that disk will
>> not be able to supply all sectors to complete any recovery.
>> { /dev/sdah, serial # S1F0FPYR }
>>
>> If you have any access to the two "dead" drives, there might be
>> a slight chance. Since they were likely kicked out due to timeout
>> mismatch, not a complete failure, this could be possible.
>>
>> Otherwise, you are utterly screwed.  Sorry.
> 
> The disks are dead. I already tried different boards but that did not help.

If it had been the timeout problem, you would probably have been able to
recover the array. As it isn't :-(
> 
> What would happen if i recreate the array with —assume-clean ? Would i be able to start the array? Can I mark disks as clean? I actually have one failed disks, one nearly recovered disk and one that has been copied by 2/3 ...
> 
You can try "--assemble --force". It sounds like you might well get away
with it.

BUT! DO NOT ATTEMPT TO USE THE ARRAY IF IT LOOKS LIKE IT'S OKAY. Are all
the disks the same age? In which case, all the other drives are on the
verge of failure, too!

I don't know whether to suggest you use smartctl to see what state the
drives are in (I've seen too many reports of allegedly healthy drives
failing, so I wouldn't trust it, especially with this particular drive.)

ddrescue your remaining drives *now*, and hope you're okay. You say you
have 35GB, across 36 drives, so you should only be using the first 1GB
of each drive. We hope ...

> Martin 
> 
Cheers,
Wol

