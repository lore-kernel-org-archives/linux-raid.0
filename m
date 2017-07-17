From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Superblocks lost on all disks in array.
Date: Mon, 17 Jul 2017 10:41:20 +1000
Message-ID: <e8e9fdef-54bf-5674-dfa7-f353edb31a3e@websitemanagers.com.au>
References: <CAH_1ubwzXd9C8OBheZv+Z5oFTVt2rG+RATHrhKy6uiVv84y_SA@mail.gmail.com>
 <20170715172643.GA24000@metamorpher.de>
 <CAH_1ubxjJzNzhV7JCjspPruUv7uJxTwVeYrjOCQv4wUMcfZBrQ@mail.gmail.com>
 <f18f569d-88fe-d35d-8c85-319d431af770@youngman.org.uk>
 <CAH_1uby=5GvrRfE5v_UYNyNev_5ZLWP1Sr48me5siR+Gm_yrGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH_1uby=5GvrRfE5v_UYNyNev_5ZLWP1Sr48me5siR+Gm_yrGA@mail.gmail.com>
Content-Language: en-CA
Sender: linux-raid-owner@vger.kernel.org
To: Jean-Pierre Human <jphuman@gmail.com>, Anthony Youngman <antlists@youngman.org.uk>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/07/17 02:46, Jean-Pierre Human wrote:
> On Sun, Jul 16, 2017 at 1:03 AM, Anthony Youngman
> <antlists@youngman.org.uk> wrote:
>>
>> On 15/07/17 19:05, Jean-Pierre Human wrote:
>>> On Sat, Jul 15, 2017 at 7:26 PM, Andreas Klauer
>>> <Andreas.Klauer@metamorpher.de> wrote:
>>
>>> Hi Andreas
>>>
>>> Thanks for the prompt response,
>>>
>>> Yes I did not use a partition table. I have always in the past used
>>> partitions but recently noticed a trend to use the device, wont do
>>> that again.
>>>
>>> I am really not sure what wrote those partitions there. I only see
>>> free space in them if I check with fdisk.
>>>
>>> I am sure it was metadata version 1.2
>>>
>>> I will attempt to recover using the overlay, will post my results.
>>
>> Good call. The whole point of overlays is to enable you to write-protect the
>> physical disks. That means (of course) that you can't make matters worse.
>> That's always the worry - that an attempt at a fix will damage the content
>> of the disks and make a recovery harder/impossible.
>>>
>>> Thanks again for your help.
>>>
>> A little more (hopefully) help - on the wiki the last entry in the "When
>> things go wrogn" section is about recovering a trashed array. As it says,
>> it's a work in progress, but it gives you various hints about how to search
>> the disk for clues as to where your data is, and hence what all those things
>> like offsets are.
>>
>> Have you ever added disks to your array? Rebuilt and changed its
>> configuration? This can mess about with the superblock values changing them
>> from the defaults. This is information the list will want.
>>
>> If you have trouble getting overlays to work, search for clues like this on
>> your list and get back here for help. ON NO ACCOUNT do anything that will
>> actually write to your disks unless you are absolutely confident that you've
>> found the correct magic incantation.
>>
>> There are plenty of people here who will help you get your data back - and
>> they've got a good track record! Unfortunately, I'm "learning by
>> documenting" so I'm quite happy to give you hints and guidance, but I can't
>> say for certain what is likely to work.
>>
>> Cheers,
>> Wol
> Hello List
>
> I am happy to say I managed to recover all the data and it was perfectly intact.
>
> To address some of the above questions, the array and server install
> are relatively new 3 months or so. There have been no disk additions,
> replacements or failures. I had issues getting the overlay working
> mainly due to my lack of understanding  and time restraints (used dd
> and sfdisk to kinda make backups of the important bits).
>
> Using the same disk order, mdadm version and settings when it was
> initially installed it started perfectly with a --create
> --assume-clean. The existing LVM was also still intact and once the
> ISCSI connection was back online the data was there. I feel I got very
> lucky mainly due to the server being in a roughly constant error free
> state since install.
>
> The odd thing was that after I had the array running and before I had
> started the ISCSI, I had to reboot the server, when it came up the
> newly written superblocks were gone again and I had to --create
> --assume-clean to get it running again. Once I have secured this data
> I will find out why this is happening.

I can't be sure, but I suspect what happened is this:
1) setup the write overlay
2) Do the rapairs/etc
3) Export drive and test
4) Reboot - everything is lost

The reason for this is that the write overlay has been lost by the 
reboot, which is the point of the write overlay, it can easily be thrown 
away if you accidentally messed up.
What you need to verify now is that:
1) You are not using a write overlay for your current/live data, or else 
you will lose it after the next reboot
2) Reboot and make sure everything works properly, so you are not left 
in a similar issue next time

Regards,
Adam


-- 
-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
-- 
The information in this e-mail is confidential and may be legally privileged.
It is intended solely for the addressee. Access to this e-mail by anyone else
is unauthorised. If you are not the intended recipient, any disclosure,
copying, distribution or any action taken or omitted to be taken in reliance
on it, is prohibited and may be unlawful. If you have received this message
in error, please notify us immediately. Please also destroy and delete the
message from your computer. Viruses - Any loss/damage incurred by receiving
this email is not the sender's responsibility.
