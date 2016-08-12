From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Unable to convert raid1 to raid5
Date: Fri, 12 Aug 2016 13:37:53 +0100
Message-ID: <57ADC321.20809@youngman.org.uk>
References: <57A4F436.9080402@youngman.org.uk>
 <57A679C9.3060204@youngman.org.uk>
 <CAN7jt2060xqsQB+nAnWO4LmqdUySkU_AWpq=UdFte=Ht0zuoPw@mail.gmail.com>
 <57A68815.40601@youngman.org.uk> <87a8gilqko.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a8gilqko.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/08/16 02:32, NeilBrown wrote:
> On Sun, Aug 07 2016, Wols Lists wrote:
> 
>> On 07/08/16 01:32, Glenn Enright wrote:
>>> On 7/08/2016 12:01 pm, "Wols Lists" <antlists@youngman.org.uk
>>> <mailto:antlists@youngman.org.uk>> wrote:
>>>>
>>>> On 05/08/16 21:16, Wols Lists wrote:
>>>>> In my testing of xosview, I've been mucking about with a vm and raid.
>>>>> xosview is looking quite promising (I've got a few comments about it,
>>>>> but never mind).
>>>>>
>>>>> BUT. In mucking about with raid 1, I increased my raid devices to three.
>>>>> I now just can NOT convert the array to raid 5! I've been mucking around
>>>>> with all sorts of things trying to get it to work, but finally two error
>>>>> messages make things clear.
>>>>>
>>>> Following up to myself - suddenly thought "I know what's wrong". So I
>>>> stopped the array, and of course couldn't access it, it was no longer
>>>> there. So I assembled but didn't run it, and it worked fine.
>>>>
>>>> Simples, once you realise what's wrong - you can ADD devices to a
>>>> running array, but you can't REMOVE them.
>>>>
>>>> Cheers,
>>>> Wol
>>>>
>>
>>>
>>> You can remove em if you mark em as failed first. Eg
>>>
>>> Mdadm /dev/mdx --fail /dev/sdc1 --remove /dev/sdc1
>>>
>>> Best, Glenn
>>>
>> Except - if you read my original post - I was trying to TOTALLY remove
>> the device!
>>
>> mdadm --grow -raid-devices=2
>>
>> THAT was the problem - I had a 3-device mirror, and you can't convert
>> that to raid5! Even if you've --fail --remove'd the third device!
>>
>> In other words, "--grow --raid-devices=more" will work on a running
>> device, "--grow --raid-devices=less" will only work on an array that is
>> built but not running.
> 
> I don't believe this is correct, and I could reproduce your results in
> quick tests.
> 
> If the array is not running, then you cannot reshape it at all.
> 
> You can reduce the number of devices in a RAID1 at any time as long as
> the number of active devices is not greater than the number of devices
> requested.
> 
> /dev/md0 has 3 working devices:
> 
> # mdadm -G /dev/md0 -n2
> mdadm: failed to set raid disks
> # mdadm /dev/md0 -f /dev/loop0
> mdadm: set /dev/loop0 faulty in /dev/md0
> # mdadm -G /dev/md0 -n2
> raid_disks for /dev/md0 set to 2
> 
That's my error - you've done pretty much exactly the same as me, except
my second try also failed, whereas yours has succeeded. Why? (although I
did --fail, --remove).
> 
>>
>> I now have the problem that my "--grow --level=5" has fallen foul of the
>> "reshape stuck at zero" problem, and I can now neither run the array,
>> nor get the reshape working ... :-(
> 
> We really need to fix this ... if only I knew how to reproduce it.

Mikael gave me the force-revert-reshape syntax, which worked a treat
when I did it his way (I'd tried to do it already, but obviously didn't
get the magic incantation right :-)
> 
As you'll see from my other thread, this is a test array (I was trying
to test the new raid features of xosview :-), so there's no urgency from
my point of view, but yes, I want to know what's going wrong, too. I
want to write all this up as documentation :-)

My problem is I've only got one computer with decent-enough grunt to run
the VM, and getting uninterrupted access to it (wife, two grand-kids)
isn't always easy. I'll get back to it asap - Mikael is on the case, but
I need to reset it back the way it was and try the reshape again.

I hope it's not the SuSE kernel - I'm running the latest mdadm from your
git repository.

> NeilBrown
> 
Cheers,
Wol
