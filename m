From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Is shrinking raid5 possible?
Date: Fri, 06 Nov 2009 19:38:04 +0000
Message-ID: <4AF47B1C.2010100@anonymous.org.uk>
References: <44960C45.9050407@anu.edu.au>	<17558.10906.59066.196870@cse.unsw.edu.au> <449B3A80.4070602@tmr.com>	<17563.17224.85968.572754@cse.unsw.edu.au>	<bb145bd20606231116g7808e467w29a9bf273ba0df52@mail.gmail.com>	<17567.36792.303403.35943@cse.unsw.edu.au>	<bb145bd20606260433w2bafccfdu3448732f5b5c1c5f@mail.gmail.com>	<4564B5C3.9050501@idgmail.se> <20091106131740.GA30506@Toms.NET>	<4AF46BAF.3020900@anonymous.org.uk> <20091106183845.GB13412@Toms.NET> <87ljijqwn1.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ljijqwn1.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Thomas Arthur Oehser <tom@toms.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/11/2009 19:30, Goswin von Brederlow wrote:
> Thomas Arthur Oehser <tom@toms.net> writes:
>> On Fri, Nov 06, 2009 at 06:32:15PM +0000, John Robinson wrote:
[...]
>>> Are you sure it hasn't already put a copy of the superblock in the right  
>>> place, within the <smaller> size, as well as leaving a copy at the end  
>>> of the original larger partition?
[...]
>> Far as I can tell, no, because when I then shrink the partition, it can't
>> find the superblock.
> 
> And you would have to shrink it to exactly the right size to the block
> so that the shrunk superblock ends up at the end of the resized
> device. Something most people won't be able to do right.

The thing is, I'm sure I've done it, and while I don't remember the 
details, I don't think I had to either recreate the array nor drop and 
re-add members. You're right though, getting the numbers right is the 
tricky bit, because the filesystem's smaller than the md, which in turn 
may be smaller than the partition, even when everything's "tight".

Cheers,

John.
