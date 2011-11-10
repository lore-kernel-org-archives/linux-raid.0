From: Chris Purves <chris@northfolk.ca>
Subject: Re: unable to recover RAID 5 due to bad block
Date: Thu, 10 Nov 2011 13:04:51 -0400
Message-ID: <4EBC0433.8040607@northfolk.ca>
References: <4EBBF60F.4030606@northfolk.ca> <20111110172003.Horde.byVZeZk8pphOu-mzTQXxKL8@cakebox.homeunix.net> <20111110165020.GB3639@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111110165020.GB3639@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2011-11-10 12:50, Robin Hill wrote:
> On Thu Nov 10, 2011 at 05:20:03PM +0100, Alexander K=FChn wrote:
>
>> ddrescue to the rescue!
>> Get a another new disk, then ddrescue the one with the read error to
>> the new disk.
>> Assemble the array using the new disk instead of the one with the re=
ad error.
>> You will loose the blocks that can't be read of course.
>> And in the future do run raid check/scrubbing at regular intervals. =
;)
>> Alex.
>>
> You may be better cloning the original failed disk - that way it will
> have a chance of actually recovering the read error (rather than havi=
ng
> to lose the blocks). It depends on why/how/when the original disk fai=
led
> though.
>
> Cheers,
>      Robin

The original failed disk can't be recognized by the controller.  I trie=
d to read the disk on another machine with no luck.  It appears to be c=
ompletely dead.

--=20
Chris Purves
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
