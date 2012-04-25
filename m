From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Unable to grow raid10 (error -22)
Date: Wed, 25 Apr 2012 13:10:06 +0200
Message-ID: <4F97DB8E.7090105@rabbit.us>
References: <4F97B003.1060201@rabbit.us> <20120425205656.546af088@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120425205656.546af088@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> On Wed, 25 Apr 2012 10:04:19 +0200 Peter Rabbitson <rabbit+list@rabbit.us>
> wrote:
> 
>> I am facing a problem which I believe is new (I distinctly remember
>> doing the same on 2.6.somethingold couple years ago). When I try to
>> grow an array where all memembers have been replaced with large ones
>> I get an inexplicable.
>>
>>    kernel: md: couldn't update array info. -22
>>
>> Nothing else. I am using kernel 3.2.0 and mdadm 3.2.3, both from
>> debian:
>> http://packages.debian.org/sid/linux-image-3.2.0-2-amd64 (3.2.15-1)
>> http://packages.debian.org/sid/mdadm (3.2.3-2)
>>
>> Here is my full test setup replicating the problem (was replicated
>> on a different machine). Let me know if I can assist further in
>> figuring this out:
>>
>> root@Thesaurus:~/raidfail# for n in $(seq 4) ; do dd if=/dev/zero of=member_$n.img bs=1M count=256 ; done
>>
>> root@Thesaurus:~/raidfail# for n in $(seq 4) ; do losetup /dev/loop$n member_$n.img ; done
>>
>> root@Thesaurus:~/raidfail# losetup -a
>> /dev/loop1: [fd01]:1081442 (/root/raidfail/member_1.img)
>> /dev/loop2: [fd01]:1081481 (/root/raidfail/member_2.img)
>> /dev/loop3: [fd01]:1081483 (/root/raidfail/member_3.img)
>> /dev/loop4: [fd01]:1081515 (/root/raidfail/member_4.img)
>>
>> root@Thesaurus:~/raidfail# mdadm -C /dev/md1010 -l 10 -p f3 -n 4 -c 256 -e 1.2 -z 128M /dev/loop[1234]
>> mdadm: largest drive (/dev/loop1) exceeds size (131072K) by more than 1%
>> Continue creating array? y
>> mdadm: array /dev/md1010 started.
>>
>> root@Thesaurus:~/raidfail# mdadm -w /dev/md1010
>>
>> root@Thesaurus:~/raidfail# cat /proc/mdstat
>> Personalities : [raid1] [raid6] [raid5] [raid4] [raid10]
>> md1010 : active raid10 loop4[3] loop3[2] loop2[1] loop1[0]
>>        174080 blocks super 1.2 256K chunks 3 far-copies [4/4] [UUUU]
>                                              ^^^^^^^^^^^^
> 
> You cannot resize a 'far' RAID10.
> In fact in 3.2 you cannot resize *any* RAID10.  That is only available in
> 3.4-rc, and even then only for 'near' and 'offset' layouts.
> 

Ugh... >.< I guess I got confused by some other raid level then.

What are the reasons for this limitation?
