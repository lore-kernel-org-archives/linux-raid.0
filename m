From: Asdo <asdo@shiftmail.org>
Subject: Re: Hot-replace for RAID5
Date: Mon, 21 May 2012 11:54:43 +0200
Message-ID: <4FBA10E3.7080202@shiftmail.org>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
 <4FAB6758.5050109@hesbynett.no>
 <CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
 <20120511105027.34e95833@notabene.brown> <4FB43977.8020607@volatilevoid.net>
 <20120518134555.3a9ce08b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20120518134555.3a9ce08b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Oliver Martin <oliver@volatilevoid.net>, patrik@dsl.sk, David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/18/12 05:45, NeilBrown wrote:
> On Thu, 17 May 2012 01:34:15 +0200 Oliver Martin<oliver@volatilevoid.net>
> wrote:
>
>> Hi Neil,
>>
>> Am 11.05.2012 02:50, schrieb NeilBrown:
>>> Doing an in-place reshape with the new 3.3 code should work, though with a
>>> softer "should" than above.  We will only know that it is "stable" when enough
>>> people (such as yourself) try it and report success.  If anything does go
>>> wrong I would of course help you to put the array back together but I can
>>> never guarantee no data loss.  You wouldn't be the first to test the code on
>>> live data, but you would be the second that I have heard of.
>> I guess I'll be taking 2nd place then. I just used it on three live
>> raid6 arrays, and it worked perfectly.
> 3 arrays - so you are 2nd, 3rd, and 4th :-)

Good to know that when all is good, hot-replace works.

I wonder if all "error paths" were considered and implemented (and maybe 
even tested, but we users could help with testing if we understand the 
intended behaviour), i.e.

what happens when the disk being hot-replaced shows read errors in 
locations previously unknown to the bad-block list: does it
- immediately fall back to fail+rebuild or
- first tries a recompute + rewrite of the sector, then if rewrite fails 
it falls back to fail+rebuild
- first tries a recompute + rewrite of the sector, then if rewrite fails 
it adds the block to bad block list, then if the list is out-of-space it 
falls back to fail+rebuild
?

What happens if the destination of the hot-replace has *one* write 
error? And *lots* of write errors?

What happens if one hot-replace hits a sector for which both the disk 
being replaced and another one have an entry in the bad block list, and 
so there is not enough parity information to recompute? Does it proceed 
anyway marking the corresponding sector in the bad-block-list for the 
destination device (=nonvalid strip), or it fails the hot-replace, or what?

(this is actually more about bad block lists)
What happens if a *different* disk shows back sectors due to concomitant 
reads (simultaneous but not caused by hot-replace):
- first recomputes and rewrites, then if rewrite fails it is added to 
bad block list, then if list is full it gets failed? Or can another 
hot-replace get started when already one is running?

Thank you

