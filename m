From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] klibc update
Date: Tue, 16 Mar 2004 15:02:36 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40575D5C.9000908@pobox.com>
References: <4056B0DB.9020008@pobox.com>	<20040316005229.53e08c0c.akpm@osdl.org>	<20040316153719.GA13723@kroah.com>	<20040316111026.6729e153.akpm@osdl.org>	<40575279.7040408@pobox.com>	<20040316192458.GB21172@kroah.com>	<40575631.1080006@pobox.com> <20040316115340.361f2a14.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040316115340.361f2a14.akpm@osdl.org>
To: Andrew Morton <akpm@osdl.org>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, viro@parcelfarce.linux.theplanet.co.uk, bos@serpentine.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Morton wrote:
> Jeff Garzik <jgarzik@pobox.com> wrote:
> 
>> >>Note that it isn't my intention to become klibc maintainer...  just in 
>> >>case anybody started getting ideas... :)
>> > 
>> > 
>> > I thought hpa was the klibc maintainer, you're just offering a patch to
>> > add it to the build :)
>>
>> Right...  I meant I am not going to become the maintainer of said 
>> patch/BK tree :)
> 
> 
> It would be rather handy if someone could maintain the definitive tree for
> this work for a while, until we linusify it.

Last I heard from LT direction was "OK but nothing uses it"


> I don't have a feeling for its stability/readiness/desirability/anthingelse
> at this stage.  How mergeable is it?

It still needs some testing before merging, and IMO still needs to 
resolve Linus's objection before it moves beyond the "big hunk of code 
that doesn't do much" stage.

It's IMO a 2.7 change...

	Jeff



