From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Subject: Re: LVM performance
Date: Mon, 10 Mar 2008 00:27:32 +0100
Message-ID: <47D47264.4070404@student.tuwien.ac.at>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>	<18360.8065.335494.142060@tree.ty.sabi.co.UK>	<20080217074526.29d3c5c5@hardcode42.net>	<20080218062604.05ae4821@szpak>	<aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com>	<20080218154203.6e2d1483@szpak>	<47BB30DF.1080006@student.tuwien.ac.at>	<18364.6868.854623.613958@tree.ty.sabi.co.UK>	<47BED119.4070000@student.tuwien.ac.at> <18384.63840.605334.155518@tree.ty.sabi.co.UK> <47D440D6.90509@student.tuwien.ac.at> <8D0FC34E-F0B0-4BAF-A466-2C8BC439E7FF@it-loops.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8D0FC34E-F0B0-4BAF-A466-2C8BC439E7FF@it-loops.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Guntsche <mike@it-loops.com>
Cc: linux-raid@vger.kernel.org, Oliver Martin <oliver.martin@student.tuwien.ac.at>
List-Id: linux-raid.ids

Michael Guntsche schrieb:
> 
> On Mar 9, 2008, at 20:56, Oliver Martin wrote:
> 
>> * LVM/md first extent stripe alignment: when creating the PV, specify 
>> a --metadatasize that is divisible by all anticipated stripe sizes, 
>> i.e., the least common multiple. For example, to accommodate for 3, 4 
>> or 5 drive configurations with 64KB chunk size, that would be 768KB.
>>
> 
> Aligning it on chunk-size should be enough so in your case 64KB. 
> Personally I did a lot of tests during  the last few weeks and this 
> seemed to make not that big of a difference.

Hmm. Stripe alignment of the beginning of a file system would seem to 
make sense. Otherwise, even if I tell the file system the stripe size, 
how should it know where it's best to start writes? If my stripes are 
128KB, and I tell the fs, it can make an effort to write 128KB blocks 
whenever possible. But if the fs starts 64KB into a 128KB stripe, every 
128KB write will cause two RMW cycles.
At least, that's how I understand it. Maybe there's something else 
involved and it really doesn't make a difference?
> 
> 
>> * Alignment of other extents: for the initial array creation with 3 
>> drives the default 4MB extent size is fine. When I add a fourth drive, 
>> I can resize the extents with vgchange - though I'm a bit hesitant as 
>> the manpage doesn't explicitly say that this doesn't destroy any data. 
>> The bigger problem is that the extent size must be a power of two, so 
>> the maximum I can use with 192KB stripe size is 64KB. I'll see if that 
>> hurts performance. The vgchange manpage says it doesn't...
>>
> 
> Why make the extents so small? You do not normally increase your LVs by 
> 4MB. I use 256MB or 512MB extends.

I was under the impression that aligning the LVM extents to RAID stripes 
was crucial ("What matters most is whether the starting physical address 
of each logical volume extent is stripe aligned"). If the LVM extents 
have nothing to do with how much is read/written at once, but rather 
only define the granularity with which LVs can be created, aligning the 
first extent could be enough.
Of course, I don't extend my LVs by 4MB, much less 64KB. The only reason 
I use LVM at all is because I might one day add larger drives to the 
array. Suppose I have 3 500GB drives and 2 750GB ones. In this 
configuration I would use a 5-drive array with 500GB from each, and a 
2-drive array with the rest on the larger ones. These two arrays would 
then be joined by LVM to form one file system.
Thinking it all through again, I see that trying to align things to 
stripes is utterly pointless as soon as I join arrays with different 
stripe sizes together. Maybe I should revise my plan, or just accept 
that I won't be getting optimal performance.

> 
>> * Telling the file system that the underlying device is striped. ext3 
>> has the stride parameter, and changing it doesn't seem to be possible. 
>> XFS might be better, as the swidth/sunit options can be set at 
>> mount-time. This would speed up writes, while reads of existing data 
>> wouldn't be affected too much by the misalignment anyway. Right?
>>
> 
> You can change the stride parameter of ext3 with tune2fs take a look at 
> the -E switch, even after you created the filesystem.

Ah, I see that's a very recent addition to 1.40.7. Thanks for pointing 
that out!

> That said bonnie++ results showed that while setting a correct stride 
> for EXT3 increased the creation and deletion of files, the big 
> sequential read and write tests suffered. But this is bonnie++......

Sorry, no idea why.

-- 
Oliver
