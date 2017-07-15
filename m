From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Superblocks lost on all disks in array.
Date: Sun, 16 Jul 2017 00:03:32 +0100
Message-ID: <f18f569d-88fe-d35d-8c85-319d431af770@youngman.org.uk>
References: <CAH_1ubwzXd9C8OBheZv+Z5oFTVt2rG+RATHrhKy6uiVv84y_SA@mail.gmail.com>
 <20170715172643.GA24000@metamorpher.de>
 <CAH_1ubxjJzNzhV7JCjspPruUv7uJxTwVeYrjOCQv4wUMcfZBrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH_1ubxjJzNzhV7JCjspPruUv7uJxTwVeYrjOCQv4wUMcfZBrQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Jean-Pierre Human <jphuman@gmail.com>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 15/07/17 19:05, Jean-Pierre Human wrote:
> On Sat, Jul 15, 2017 at 7:26 PM, Andreas Klauer
> <Andreas.Klauer@metamorpher.de> wrote:

> Hi Andreas
> 
> Thanks for the prompt response,
> 
> Yes I did not use a partition table. I have always in the past used
> partitions but recently noticed a trend to use the device, wont do
> that again.
> 
> I am really not sure what wrote those partitions there. I only see
> free space in them if I check with fdisk.
> 
> I am sure it was metadata version 1.2
> 
> I will attempt to recover using the overlay, will post my results.

Good call. The whole point of overlays is to enable you to write-protect 
the physical disks. That means (of course) that you can't make matters 
worse. That's always the worry - that an attempt at a fix will damage 
the content of the disks and make a recovery harder/impossible.
> 
> Thanks again for your help.
> 
A little more (hopefully) help - on the wiki the last entry in the "When 
things go wrogn" section is about recovering a trashed array. As it 
says, it's a work in progress, but it gives you various hints about how 
to search the disk for clues as to where your data is, and hence what 
all those things like offsets are.

Have you ever added disks to your array? Rebuilt and changed its 
configuration? This can mess about with the superblock values changing 
them from the defaults. This is information the list will want.

If you have trouble getting overlays to work, search for clues like this 
on your list and get back here for help. ON NO ACCOUNT do anything that 
will actually write to your disks unless you are absolutely confident 
that you've found the correct magic incantation.

There are plenty of people here who will help you get your data back - 
and they've got a good track record! Unfortunately, I'm "learning by 
documenting" so I'm quite happy to give you hints and guidance, but I 
can't say for certain what is likely to work.

Cheers,
Wol
