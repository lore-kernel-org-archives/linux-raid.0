From: Jean-Pierre Human <jphuman@gmail.com>
Subject: Re: Superblocks lost on all disks in array.
Date: Sun, 16 Jul 2017 18:46:15 +0200
Message-ID: <CAH_1uby=5GvrRfE5v_UYNyNev_5ZLWP1Sr48me5siR+Gm_yrGA@mail.gmail.com>
References: <CAH_1ubwzXd9C8OBheZv+Z5oFTVt2rG+RATHrhKy6uiVv84y_SA@mail.gmail.com>
 <20170715172643.GA24000@metamorpher.de> <CAH_1ubxjJzNzhV7JCjspPruUv7uJxTwVeYrjOCQv4wUMcfZBrQ@mail.gmail.com>
 <f18f569d-88fe-d35d-8c85-319d431af770@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f18f569d-88fe-d35d-8c85-319d431af770@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jul 16, 2017 at 1:03 AM, Anthony Youngman
<antlists@youngman.org.uk> wrote:
>
>
> On 15/07/17 19:05, Jean-Pierre Human wrote:
>>
>> On Sat, Jul 15, 2017 at 7:26 PM, Andreas Klauer
>> <Andreas.Klauer@metamorpher.de> wrote:
>
>
>> Hi Andreas
>>
>> Thanks for the prompt response,
>>
>> Yes I did not use a partition table. I have always in the past used
>> partitions but recently noticed a trend to use the device, wont do
>> that again.
>>
>> I am really not sure what wrote those partitions there. I only see
>> free space in them if I check with fdisk.
>>
>> I am sure it was metadata version 1.2
>>
>> I will attempt to recover using the overlay, will post my results.
>
>
> Good call. The whole point of overlays is to enable you to write-protect the
> physical disks. That means (of course) that you can't make matters worse.
> That's always the worry - that an attempt at a fix will damage the content
> of the disks and make a recovery harder/impossible.
>>
>>
>> Thanks again for your help.
>>
> A little more (hopefully) help - on the wiki the last entry in the "When
> things go wrogn" section is about recovering a trashed array. As it says,
> it's a work in progress, but it gives you various hints about how to search
> the disk for clues as to where your data is, and hence what all those things
> like offsets are.
>
> Have you ever added disks to your array? Rebuilt and changed its
> configuration? This can mess about with the superblock values changing them
> from the defaults. This is information the list will want.
>
> If you have trouble getting overlays to work, search for clues like this on
> your list and get back here for help. ON NO ACCOUNT do anything that will
> actually write to your disks unless you are absolutely confident that you've
> found the correct magic incantation.
>
> There are plenty of people here who will help you get your data back - and
> they've got a good track record! Unfortunately, I'm "learning by
> documenting" so I'm quite happy to give you hints and guidance, but I can't
> say for certain what is likely to work.
>
> Cheers,
> Wol

Hello List

I am happy to say I managed to recover all the data and it was perfectly intact.

To address some of the above questions, the array and server install
are relatively new 3 months or so. There have been no disk additions,
replacements or failures. I had issues getting the overlay working
mainly due to my lack of understanding  and time restraints (used dd
and sfdisk to kinda make backups of the important bits).

Using the same disk order, mdadm version and settings when it was
initially installed it started perfectly with a --create
--assume-clean. The existing LVM was also still intact and once the
ISCSI connection was back online the data was there. I feel I got very
lucky mainly due to the server being in a roughly constant error free
state since install.

The odd thing was that after I had the array running and before I had
started the ISCSI, I had to reboot the server, when it came up the
newly written superblocks were gone again and I had to --create
--assume-clean to get it running again. Once I have secured this data
I will find out why this is happening.

The documentation on the wiki is very helpful and the most concise I
came across. The overlay feature I will spend sometime with to
understand as in the future I may need this. It just left me asking a
lot of questions like if I have LVM and no filesystem on the device
will it work or how should I adopt the setup for that etc. This
exercise has opened my eyes to just how resilient and flexible mdadm
can be.

Thanks again for all the help and advice.

J-P Human
