From: "Yves Glodt" <yg@mind.lu>
Subject: Re: Some raid1 questions
Date: Mon, 2 Feb 2004 08:33:07 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <24725.213.135.224.9.1075707187.squirrel@www.mind.lu>
References: <200402011438.01880.yg@mind.lu>
        <16413.54658.442268.733528@notabene.cse.unsw.edu.au>
Reply-To: yg@mind.lu
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16413.54658.442268.733528@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Sunday February 1, yg@mind.lu wrote:
>> Hello,
>>
>> I have my home partition on a raid1 device, and there is an ext3
>> filesystem on it. Some more information:
> ...
>>
>> Recently I had some freezes (due to nvidia...?), and everytime I had
>> to  make a hard reset.
>>
>> Everytime then the raid resynced completely which took about 1.5
>> hours. One time I lost some kde settings when this happened.

>> The filesystem did not complain about an unclean shutdown, it seems it
>>  did not see on bootup that the last shutdown was unclean.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

>> Now to my questions:
>> Is this the normal behaviour?
> Which behaviour?

Sorry for being unclear...
After an unclean shutdown, my raid always rebuilds, and the filesystem never
replays the journal. I just does not see that it was not properly unmounted.

Now again :)... is that the normal behaviour?


>   1.5 hour resync -- maybe. It depends on the speed and size of the
>     drives.

ok

>   lost kde settings -- maybe. It depends on how well kde copes with
>     sudden system failure.

ok

>   The filesystem didn't complain -- Yes.  ext3 doesn't complain about
>     an unclean shutdown.  It just replays the journal and keeps
>     working.

It did not replay anything in these cases.

>> Shouldn't the filesystem take care of that?
>
>   Take care of what?  I suspect it did take care of everything it
>   could.
>
>> What is the point of having a journaling filesystem on a mirror?
>   Lots.  A journaling filesystem guards against unclean shutdown.  A
> mirror guards against drive failure.  These are compliementary.
>
>> Is there anything I can change to have the filesystem handle unclean
>> shutdowns?
>
>  I think it did handle the unclean shutdown just fine.
>  The loss of kde settings is probably dud to KDE note being careful
> enough when updating it's settings file.
>
> NeilBrown
>
>>
>> TIA,
>> Yves
>>
>>
>> --
>> Linux 2.4.24 #5 Mon Jan 5 19:38:06 CET 2004 i686
>>  14:25:55 up  4:14,  1 user,  load average: 0.43, 0.40, 0.32
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid"
>> in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


