From: likewhoa <likewhoa@weboperative.com>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Sat, 28 Apr 2012 11:23:18 -0400
Message-ID: <4F9C0B66.90102@weboperative.com>
References: <4F9AFBC6.7070803@weboperative.com> <4F9B14FA.1090001@weboperative.com> <20120428080522.637bc564@notabene.brown> <4F9B2BE1.5080207@weboperative.com> <4F9B3B48.8020900@weboperative.com> <4F9B57E9.2060409@weboperative.com> <20120428125506.6a2388eb@notabene.brown> <4F9B5D24.1050708@weboperative.com> <20120428132331.01396da6@notabene.brown> <4F9B695D.8030105@weboperative.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F9B695D.8030105@weboperative.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org >> \"linux-raid@vger.kernel.org\"" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/27/2012 11:51 PM, likewhoa wrote:
> On 04/27/2012 11:23 PM, NeilBrown wrote:
>> On Fri, 27 Apr 2012 22:59:48 -0400 likewhoa <likewhoa@weboperative.com> wrote:
>>
>>> On 04/27/2012 10:55 PM, NeilBrown wrote:
>>>> On Fri, 27 Apr 2012 22:37:29 -0400 likewhoa <likewhoa@weboperative.com> wrote:
>>>>
>>>>> On 04/27/2012 08:35 PM, likewhoa wrote:
>>>>>> I am not sure how to proceed now with the output that shows possible
>>>>>> pairs as it won't allow me to setup all 8 devices on the array but only
>>>>>> 4. Should I run the array creation with -x4 and set the available spare
>>>>>> devicesor or just create the array as I can remember which was one pair
>>>>>> from each controller. i.e /dev/sda3 /dev/sde3 ...?
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> ok I was able to recreate the array with correct order which I took from
>>>>> my /dev/md0's --details output and was able to decrypt the luks mapping
>>>>> but XFS didn't open and xfs_repair is currently doing the matrix. I will
>>>>> keep this posted with updates.
>>>> I hope the order really is correct.... I wouldn't expect xfs to find problems
>>>> if it was...
>>>>
>>>>> Thanks again Neil.
>>>>> WRT 3.3.3 should I just go back to 3.3.2 which seemed to run fine and
>>>>> wait until there is a release of 3.3.3 that has fix?
>>>> 3.3.4 has the fix and was just released.
>>>> 3.3.1, 3.3.2 and 3.3.3 all have the bug.  It only triggers on shutdown and
>>>> even then only occasionally.
>>>> So I recommend 3.3.4.
>>>>
>>>> NeilBrown
>>> The reason I believe it was correct was that 'cryptsetup luksOpen
>>> /dev/md1 md1' worked. I really do hope that it was correct too because
>>> after opening the luks mapping I assume there is no going back.
>> Opening the luks mapping could just mean that the first few blocks are
>> correct.  So the first disk is right but others might not be.
>>
>> There is going backup unless something has been written to the array.  Once
>> that happens anything could be corrupted.  So if the xfs check you are  doing
>> is read-only you could still have room to move.
>>
>> With a far=2 array, each first half of each device is mirrored on the second
>> half.  So you can probably recover the ordering by finding which pairs match.
>>
>> The "Used Dev Size" is 902992896 sectors.  Half of that is 451496448
>> or 231166181376 bytes.
>>
>> So to check if two devices are adjacent in the mapping you can try:
>>
>>  cmp --ignore-initial=0:231166181376 --bytes=231166181376 first-dev second-dev
>>
>> You could possibly use a smaller --bytes= number, at least on the first
>> attempt.
>> You a similar 'for' loop to before an use this command and it might tell you
>> which pairs of devices are consecutive.  From that you should be able to get
>> the full order.
>>
>> NeilBrown
>>
> I don't see why xfs_repair would write data unless it actually finds the
> superblock but I am not sure so I will take my chances since it's still
> searching for the secondary superblock now.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
After running the for loop all night which produced this output.

/dev/sda3 /dev/sdb3 differ: byte 1, line 1
/dev/sda3 /dev/sdc3 differ: byte 262145, line 2
/dev/sda3 /dev/sdd3 differ: byte 1, line 1
/dev/sda3 /dev/sde3 differ: byte 1, line 1
/dev/sda3 and /dev/sdf3 seem to match
/dev/sda3 /dev/sdg3 differ: byte 262145, line 2
/dev/sda3 /dev/sdh3 differ: byte 1, line 1
/dev/sdb3 /dev/sda3 differ: byte 1, line 1
/dev/sdb3 /dev/sdc3 differ: byte 1, line 1
/dev/sdb3 /dev/sdd3 differ: byte 1, line 1
/dev/sdb3 and /dev/sde3 seem to match
/dev/sdb3 /dev/sdf3 differ: byte 1, line 1
/dev/sdb3 /dev/sdg3 differ: byte 1, line 1
/dev/sdb3 /dev/sdh3 differ: byte 1, line 1
/dev/sdc3 /dev/sda3 differ: byte 262145, line 2
/dev/sdc3 /dev/sdb3 differ: byte 1, line 1
/dev/sdc3 /dev/sdd3 differ: byte 1, line 1
/dev/sdc3 /dev/sde3 differ: byte 1, line 1
/dev/sdc3 /dev/sdf3 differ: byte 262145, line 2
/dev/sdc3 and /dev/sdg3 seem to match
/dev/sdc3 /dev/sdh3 differ: byte 1, line 1
/dev/sdd3 /dev/sda3 differ: byte 1, line 1
/dev/sdd3 /dev/sdb3 differ: byte 1, line 1
/dev/sdd3 /dev/sdc3 differ: byte 1, line 1
/dev/sdd3 /dev/sde3 differ: byte 1, line 1
/dev/sdd3 /dev/sdf3 differ: byte 1, line 1
/dev/sdd3 /dev/sdg3 differ: byte 1, line 1
/dev/sdd3 and /dev/sdh3 seem to match
/dev/sde3 /dev/sda3 differ: byte 262145, line 2
/dev/sde3 /dev/sdb3 differ: byte 1, line 1
/dev/sde3 and /dev/sdc3 seem to match
/dev/sde3 /dev/sdd3 differ: byte 1, line 1
/dev/sde3 /dev/sdf3 differ: byte 262145, line 2
/dev/sde3 /dev/sdg3 differ: byte 262145, line 2
/dev/sde3 /dev/sdh3 differ: byte 1, line 1
/dev/sdf3 /dev/sda3 differ: byte 1, line 1
/dev/sdf3 /dev/sdb3 differ: byte 1, line 1
/dev/sdf3 /dev/sdc3 differ: byte 1, line 1
/dev/sdf3 and /dev/sdd3 seem to match
/dev/sdf3 /dev/sde3 differ: byte 1, line 1
/dev/sdf3 /dev/sdg3 differ: byte 1, line 1
/dev/sdf3 /dev/sdh3 differ: byte 1, line 1
/dev/sdg3 and /dev/sda3 seem to match
/dev/sdg3 /dev/sdb3 differ: byte 1, line 1
/dev/sdg3 /dev/sdc3 differ: byte 262145, line 2
/dev/sdg3 /dev/sdd3 differ: byte 1, line 1
/dev/sdg3 /dev/sde3 differ: byte 1, line 1
/dev/sdg3 /dev/sdf3 differ: byte 262145, line 2
/dev/sdg3 /dev/sdh3 differ: byte 1, line 1
/dev/sdh3 /dev/sda3 differ: byte 1, line 1
/dev/sdh3 and /dev/sdb3 seem to match
/dev/sdh3 /dev/sdc3 differ: byte 1, line 1
/dev/sdh3 /dev/sdd3 differ: byte 1, line 1
/dev/sdh3 /dev/sde3 differ: byte 1, line 1
/dev/sdh3 /dev/sdf3 differ: byte 1, line 1
/dev/sdh3 /dev/sdg3 differ: byte 1, line 1

I manage recover my luks+xfs with this --create command \o/
> mdadm --create /dev/md1 --metadata=1.0 -l10 -n8 --chunk=256
--layout=f2 --assume-clean /dev/sdh3 /dev/sdb3 /dev/sde3 /dev/sdc3
/dev/sdg3 /dev/sda3 /dev/sdf3 /dev/sdd3

Thank you Neil for your assistance you rock! With regards to my
/etc/mdadm.conf the explicit references to the sd drives was generated
with 'mdadm -Esv', my question is do you suggest I not even populate
/etc/mdadm.conf with such output because of change in drives and just
use 'mdadm -s -A /dev/mdX'? Also after running into this nasty bug I get
the feeling that I should really keep a copy of all my future 'mdadm
--create ...' commands handy just for such situations, do you agree?

Thanks again and have a GREAT weekend.
Fernando Vasquez a.k.a likewhoa
