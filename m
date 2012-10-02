From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID6 rebuild stuck
Date: Tue, 02 Oct 2012 21:35:05 +0100
Message-ID: <506B4FF9.8070904@anonymous.org.uk>
References: <20121001112946.GB27455@nsrc.org> <20121002155642.606b2108@notabene.brown> <20121002155633.GC30589@nsrc.org> <506B45C3.4090902@anonymous.org.uk> <20121003062907.3886b2fd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121003062907.3886b2fd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/10/2012 21:29, NeilBrown wrote:
> On Tue, 02 Oct 2012 20:51:31 +0100 John Robinson
> <john.robinson@anonymous.org.uk> wrote:
>
>> On 02/10/2012 16:56, Brian Candler wrote:
>>> On Tue, Oct 02, 2012 at 03:56:42PM +1000, NeilBrown wrote:
>>>> Lesson: always do a read test as well as a write test!
>>>
>>> And there was me thinking that drives read back data after writing it -
>>> clearly they do not :-)
>>
>> Would it be worth adding a re-read onto the end of the usual read
>> failure reconstruct-write cycle?
>
> What?  Read twice?
>
> We already read after the write when attempting to fix a failure.

I didn't realise you already did that.

> I suspect it doesn't do much good though as the data is in cache in the drive.

No, maybe not. There isn't an option you can add to ask for an uncached 
read? But I dare say you'd have thought of that already if there was :-)

Cheers,

John.

