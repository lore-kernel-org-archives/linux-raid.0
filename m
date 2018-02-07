From: John Pittman <jpittman@redhat.com>
Subject: Re: [PATCH] mdadm: Expose Kill() return codes to user
Date: Wed, 7 Feb 2018 15:07:12 -0500
Message-ID: <CA+RJvhy3bWL7MLtzkn0bwFMsd2x2-zLvcK-bwPB1Zz-oBTxAVA@mail.gmail.com>
References: <1517587617-2978-1-git-send-email-jpittman@redhat.com> <821a08de-bbe9-d775-acec-0c0f07de2b84@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <821a08de-bbe9-d775-acec-0c0f07de2b84@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Terribly sorry Jes, got pulled away and did not get back.
Unfortunately this patch is incorrect.  Please revert.
It causes the return value of even a successful wipe to be 2.
If I can figure out why, I will re-submit.  Apologies again.

On Wed, Feb 7, 2018 at 2:51 PM, Jes Sorensen <jes.sorensen@gmail.com> wrote:
> On 02/02/2018 11:06 AM, John Pittman wrote:
>> In misc_list(), case KillOpt, the return values from the Kill()
>> function are saved, but soon after cleared with a bitwise OR
>> assignment.  Expose these return values to the user, indicating
>> success of the zeroing operation or an error value to accompany
>> the error message printed to the console.
>>
>> Before:
>>
>>    # mdadm -C /dev/md0 -l 1 -n 2 -e 1.2 /dev/sda /dev/sdb
>>    mdadm: array /dev/md0 started.
>>    # mdadm --zero-superblock /dev/sdb
>>    mdadm: Couldn't open /dev/sdb for write - not zeroing
>>    # echo $?
>>    0
>>
>> After:
>>
>>    # mdadm -C /dev/md0 -l 1 -n 2 -e 1.2 /dev/sda /dev/sdb
>>    mdadm: array /dev/md0 started.
>>    # mdadm --zero-superblock /dev/sdb
>>    mdadm: Couldn't open /dev/sdb for write - not zeroing
>>    # echo $?
>>    2
>>
>> Signed-off-by: John Pittman <jpittman@redhat.com>
>
> Seems reasonable to me!
>
> Applied!
>
> Thanks,
> Jes
>
