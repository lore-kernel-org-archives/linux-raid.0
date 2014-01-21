From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Tue, 21 Jan 2014 09:08:05 -0800
Message-ID: <CAK2H+ef3p-Vk86p0fX=54d=KfWmj3vEKvjaVy2bm6hr7Rq_f2Q@mail.gmail.com>
References: <20140121073540.GF10140@merlins.org>
	<20140121163755.GG10140@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140121163755.GG10140@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jan 21, 2014 at 8:37 AM, Marc MERLIN <marc@merlins.org> wrote:
> On Mon, Jan 20, 2014 at 11:35:40PM -0800, Marc MERLIN wrote:
>> Howdy,
>>
>> I'm setting up a new array with 5 4TB drives for which I'll use dmcrypt.
>>
>> Question #1:
>> Is it better to dmcrypt the 5 drives and then make a raid5 on top, or the opposite
>> (raid5 first, and then dmcrypt)
>> I used:
>> cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain64 /dev/sd[mnopq]1
>
> I should have said that this is seemingly a stupid question since obviously
> if you encrypt each drive separately, you're going through the encryption
> layer 5 times during rebuilds instead of just once.
> However in my case, I'm not CPU-bound, so that didn't seem to be an issue
> and I was more curious to know if the dmcrypt and dmraid5 layers stacked the
> same regardless of which one was on top and which one at the bottom.
>
> Marc

I know nothing about dmcrypt but as someone pointed out to me in
another thread recently about alternative parity methods for RAID6 you
might be able to do some tests using loopback devices instead of real
hard drives to speed up your investigation times.

Cheers,
Mark
