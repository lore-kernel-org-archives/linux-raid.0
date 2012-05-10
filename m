From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: and again: broken RAID5
Date: Thu, 10 May 2012 11:19:30 +0100
Message-ID: <4FAB9632.5010206@anonymous.org.uk>
References: <4FAB7739.9000907@cgv.tugraz.at> <20120510192016.49cb9003@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120510192016.49cb9003@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Lars Schimmer <l.schimmer@cgv.tugraz.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/05/2012 10:20, NeilBrown wrote:
> On Thu, 10 May 2012 10:07:21 +0200 Lars Schimmer<l.schimmer@cgv.tugraz.at>
> wrote:
[...]
>> mdadm -E tells me e.g. for md1:
>>
>> /dev/sdh1:
>> Events : 206286
>>
>> /dev/sdf1:
>> Events : 206273
>>
>> /dev/sdi1:
>> Events : 197114
>>
>> /dev/sdj1:
>> Events : 206286
[...]
>>
>>
>> So all 4 disks see some diff state. Any chance on getting raid5
>> running again and read some data from it?
>>
>> Does the mdadm -C --assume-clean option help me in that case anyhow?
>
> Just add --force the to --assemble command.

I think I'd assemble from only 3 drives, sdh, sdf and sdj, because sdi's 
event count is so much lower it must be the one that was knocked out 
first and you probably want to resync onto it (or a fresh drive if it's 
actually faulty).

Cheers,

John.

