From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Raid 5 Recovery
Date: Sun, 28 Dec 2008 17:15:33 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812281714080.23996@p34.internal.lan>
References: <125ed8800812272221y44e77849l886a80f32cbcfbec@mail.gmail.com> <3513de790812280753k5c46799cj92a0e9566227fadc@mail.gmail.com> <125ed8800812281002t6eecb5cbu2173efab36418c92@mail.gmail.com> <125ed8800812281004o4d179064r735e46315481775a@mail.gmail.com>
 <125ed8800812281013t59a3dc8cte44091d262cb8905@mail.gmail.com> <20081228183921.GA5815@csy.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081228183921.GA5815@csy.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Shane W <shane-kernel@csy.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 28 Dec 2008, Shane W wrote:

> Hi,
>
> On Sun, Dec 28, 2008 at 01:13:15PM -0500, Erik Boettcher wrote:
>> I guess I should specify how it complains: the exact same error
>> message but sde3 instead.
>
> As others have said, definitely wait for a more
> knowledgable person to post here but if I am working on a
> machine and accidentally jar the SATA cables, mdadm
> sometimes kicks two drives from my raid5 causing it to
> display similar problems.  What works for me is a mdadm -E
> /dev/sdnx where the dev is one of the drives it kicked as
> that represents the "good" state of the array.  Then
> /recreate with one drive missing:
> mdadm --create /dev/mdx --assume-clean --level 5 /dev/sda3
> //dev/sdb3 missing /dev/sdc3 etc. with the device order
> //being the same as that listed in mdadm -E component
> //device list. and missing for the first device which was
> //kicked.  The number of devices, spares, chunk size etc
> //has to match the array of course, then verify the
> //filesystem readonly and once you're sure the order is
> //right and the FS is good, re-add the last device and let
> //the resync do its thing.
>
> I am curious as to whether there is another way to recover
> from the multiple drive nonfailure condition though because
> recreating can raise the heart rate a little.

I was also going to suggest this; however this should be marked as the 
option of last resort, I did this with an array once and used the exact same 
options and much of the FS was corrupted.  If all other options are 
exhausted and you have confirmed that, then it is your last hope I 
believe.

Justin.

