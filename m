From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [opensuse] raid device mounting problem in Leap 42.2
Date: Fri, 14 Jul 2017 00:18:05 +0100
Message-ID: <5967FFAD.6030807@youngman.org.uk>
References: <a7cc2751c4c0b89dee040c1522590fb5@gmail.hu>
 <ok4bkp$gb0$1@saturn.local.net> <41e64fb5b9e54bf18aff2d663d0649d8@gmail.hu>
 <CAA91j0UND1UmwOc46G+o1Mh3dKMG9M_HiYxFdXwWO03D=EztpA@mail.gmail.com>
 <76df60214c0039114ba0a4b6f0f515bc@gmail.hu>
 <CAA91j0WXkBnSa+F7u95SWMCtR6nYnUN3uzRLj9jqPoCFX2LNXQ@mail.gmail.com>
 <596628E7.8020905@youngman.org.uk>
 <CAA91j0Uyz2xZkpo3YDrkQRhYt5FoG4b-Bwhc7HF3ko40i1xs3A@mail.gmail.com>
 <d71443c0d631c80af4d09c6098b85359@gmail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d71443c0d631c80af4d09c6098b85359@gmail.hu>
Sender: linux-raid-owner@vger.kernel.org
To: opensuse@opensuse.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/07/17 23:46, Istvan Gabor wrote:
> On Wed, 12 Jul 2017 17:05:17 +0300, Andrei Borzenkov wrote:
>> On Wed, Jul 12, 2017 at 4:49 PM, Wols Lists <antlists@youngman.org.uk>
>> wrote:
>>>
>>> But I suspect that going back into 12.2, and shrinking the filesystem
>>> (MAKE SURE you shrink the md device, not the sd device)
>>
>> Quite the opposite. Attempting to shrink filesystem that is already
>> effectively corrupted is potentially dangerous. So the right thing
>> here is to stop md, backup superblocks (in case they will be
> 
> I am puzzled. Do I need to backup the raid superblock or the device
> superblocks or all? How do I backup the superblock? I googled but only
> find how to recover from superblock backup.
> 
The best bet is to ask the linux-raid list what to do.

For the raid list, this is the array I mentioned where the filesystem,
and the partitions the raid was on, were the same size.

So we have a v1.0 mirror where the filesystem on the mirror uses up ALL
the space on the md device, not just the free space that it's supposed
to use, with all the issues that brings like filling up the filesystem
will overwrite the superblock.

So what's the best way to recover? Will just shrinking the filesystem
bring everything back the way it should be, or are we better just
mounting the original filesystem from one disk as if it weren't a
mirror, and then recreating the mirror on the other disk, copying the
data, and then adding the first disk back in to put everything back the
way it should have been?

Cheers,
Wol

