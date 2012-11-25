From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Suggestion for hot-replace
Date: Sun, 25 Nov 2012 15:43:17 -0800
Message-ID: <7e8a274d-cf49-4fcb-a5d5-323839171034@email.android.com>
References: <50B1BCBD.70306@zytor.com> <50B25C77.4000502@shiftmail.org> <20121126084917.0d9e447f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121126084917.0d9e447f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, joystick <joystick@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The problem with this is that without automation the array is left with a needlessly faulty drive until the administrator can manually intervene.  For automation it can be in the kernel or mdadm, but requiring an extra bit just for that is problematic.

NeilBrown <neilb@suse.de> wrote:

>On Sun, 25 Nov 2012 18:59:19 +0100 joystick <joystick@shiftmail.org>
>wrote:
>
>> On 11/25/12 07:37, H. Peter Anvin wrote:
>> > I was looking at the hot-replace (want_replacement) feature, and I
>had 
>> > a thought: it would be nice to have this in a form which *didn't*
>fail 
>> > the incumbent drive after the operation is over, and instead turned
>it 
>> > into a spare.  This would make it much easier and safer to 
>> > periodically rotate and test any hot spares in the system.  The
>main 
>> > problem with hot spares is that you don't actually know if they
>work 
>> > properly until there is a failover...
>> >
>> >     -hpa
>> >
>> 
>> Sorry I don't agree.
>> 
>> Firstly, it causes confusion. If you want a replacement in 90% of
>cases 
>> it means that the current drive is defective. If you put the replaced
>
>> drive into the spare pool instead of kicking it out then you have to 
>> remember (by serial number?) which one it was to actually remove it
>from 
>> the system. If you forget to note it down, then you are in serious 
>> troubles, because if that "spare" then gets caught in another (or the
>
>> same) array needing a recovery, you will have a high probability of 
>> exotic and unexpected multiple failures situations.
>> 
>> Also, if you are uncertain of the health of your spares, risking your
>
>> array by throwing one into the array is definitely unwise. There are 
>> other tecniques to test a spare that don't involve risking you array
>on 
>> it: you can remove one spare from the spare pool (best if you have 2+
>
>> spares but can also be done with 1), read/write all of it various
>times 
>> as a validation, then re-add it back to the spares pool. Even just 
>> reading it from beginning to end with dd could be enough and for this
>
>> you don't even have to remove it from the spare pool. And this
>doesn't 
>> degrade the array performances, while your suggestion would.
>> 
>> Thirdly, if you really want that (imho unwise) behaviour, it's easy
>to 
>> implement from userspace without asing the MD developers to do so: 
>> monitor the replacement process, as soon as you see it terminating
>and 
>> you see the target drive in Failed status, remove and re-add it back
>as 
>> a spare. That's it.
>
>I tend to agree with this position.
>
>However it might make sense to record the reason that a device is
>marked
>faulty and present this via a sysfs variable.
>  e.g.:  manual, manual_replace, write_error, read_error ...
>
>Then mdadm --monitor could notice the appearance of manual_replace
>faulty
>devices and could convert them to spares.
>
>I'm not likely to write this code myself, but I would probably accept
>patches.
>
>NeilBrown

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
