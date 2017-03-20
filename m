From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: proactive disk replacement
Date: Mon, 20 Mar 2017 16:19:29 +0000
Message-ID: <58D00111.3090807@youngman.org.uk>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <c20d279a-62b1-2c3d-cdaf-39a838034afb@thelounge.net>
 <3df5e6da-6085-58fb-2811-cb4be843e676@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3df5e6da-6085-58fb-2811-cb4be843e676@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Reindl Harald <h.reindl@thelounge.net>, Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/03/17 15:23, Adam Goryachev wrote:
> 
> 
> On 21/3/17 02:04, Reindl Harald wrote:
>>
>>
>> Am 20.03.2017 um 15:59 schrieb Adam Goryachev:
>>> On 20/3/17 23:47, Jeff Allison wrote:
>>>> Hi all I’ve had a poke around but am yet to find something definitive.
>>>>
>>>> I have a raid 5 array of 4 disks amounting to approx 5.5tb. Now this
>>>> disks are getting a bit long in the tooth so before I get into
>>>> problems I’ve bought 4 new disks to replace them.
>>>>
>>>> I have a backup so if it all goes west I’m covered. So I’m looking for
>>>> suggestions.
>>>>
>>>> My current plan is just to replace the 2tb drives with the new 3tb
>>>> drives and move on, I’d like to do it on line with out having to trash
>>>> the array and start again, so does anyone have a game plan for doing
>>>> that.
>>> Yes, do not fail a disk and then replace it, use the newer replace
>>> method (it keeps redundancy in the array)
>>
>> how should it keep redundancy when you have to remove a disk anyways
>> except you have enough slots to at least temporary add a additional one?
> Yes, assuming you can (at least temporarily) add an additional disk,
> then you will not lose redundancy by using the replace instead of
> fail/add method.
> 
Take a look at the raid wiki. Especially this page ...

https://raid.wiki.kernel.org/index.php/Replacing_a_failed_drive

Okay, it's my work (unless people have come in since and edited it) but
I make a point of asking "the people who should know" to check my work
if I'm at all unsure. So this will have been looked over for mistakes by
various people on the list who either write the code or provide advice
and support.

And yes, as you can see from that page, I'd say add a new disk then
--replace it into the array. And upgrading the array to raid6 is a good
idea. But Adam's way I think you need two extra temporary drive slots.
What I think you can do is - the new drives you need to make the
underlying partition the full 3TB. You can then replace all four drives.
So long as 2*3TB >= 3*2TB (don't laugh - it might not be!!!) you should
be able to reduce the number of drives to three then add the fourth back
to give raid6.

The other thing is, if you've got the space for Adam's method, you could
always temporarily create a 4TB drive by combining 2*2TB in a raid0 -
probably best striped rather than linear.

Cheers,
Wol

