From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Is shrinking raid5 possible?
Date: Fri, 06 Nov 2009 20:30:10 +0100
Message-ID: <87ljijqwn1.fsf@frosties.localdomain>
References: <44960C45.9050407@anu.edu.au>
	<17558.10906.59066.196870@cse.unsw.edu.au> <449B3A80.4070602@tmr.com>
	<17563.17224.85968.572754@cse.unsw.edu.au>
	<bb145bd20606231116g7808e467w29a9bf273ba0df52@mail.gmail.com>
	<17567.36792.303403.35943@cse.unsw.edu.au>
	<bb145bd20606260433w2bafccfdu3448732f5b5c1c5f@mail.gmail.com>
	<4564B5C3.9050501@idgmail.se> <20091106131740.GA30506@Toms.NET>
	<4AF46BAF.3020900@anonymous.org.uk> <20091106183845.GB13412@Toms.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091106183845.GB13412@Toms.NET> (Thomas Arthur Oehser's message
	of "Fri, 6 Nov 2009 13:38:46 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Arthur Oehser <tom@toms.net>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Arthur Oehser <tom@toms.net> writes:

> On Fri, Nov 06, 2009 at 06:32:15PM +0000, John Robinson wrote:
>> On 06/11/2009 13:17, Thomas Arthur Oehser wrote:
>> [...]
>>>  - resize2fs /dev/md3 <smaller>
>>>  - mdadm -G -z <smaller> /dev/md3
>>>  - fdisk /dev/sd[a-c]3 <smaller>
>>>
>>> It _almost_ works fine... but... the mdadm -G keeps the (0.90) superblock
>>> at the _end_ of the _device_ ... which hasn't been resized yet ...
>>>
>>> How do I put the superblock back after fdisk, or make -G move or recreate?
>>
>> Are you sure it hasn't already put a copy of the superblock in the right  
>> place, within the <smaller> size, as well as leaving a copy at the end  
>> of the original larger partition? That's what I would do if I was the  
>> author, so the partition can still be recognised as a md one before the  
>> partition is resized; you wouldn't want the parition to become  
>> unrecognisable or unusable.
>
> Far as I can tell, no, because when I then shrink the partition, it can't
> find the superblock.

And you would have to shrink it to exactly the right size to the block
so that the shrunk superblock ends up at the end of the resized
device. Something most people won't be able to do right.

As alternative for fail/resync I mentioned in my last mail you could
also repartition and create a new raid with --assume-clean if you like
experimenting. Either way is bad.

MfG
        Goswin
