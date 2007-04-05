From: Casey Boone <caseyboone@gmail.com>
Subject: Re: raidtools to mdadm
Date: Wed, 04 Apr 2007 22:26:20 -0500
Message-ID: <46146C5C.8080502@gmail.com>
References: <46103C8B.4030001@gmail.com> <46142D1B.2080401@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46142D1B.2080401@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>> i do not want to actually change any of the contents of these drives, 
>> just mount very simply as a raid0.  the raid was originally created 
>> using an onboard nvidia raid on the motherboard these drives used to 
>> be hooked to.  my friend thought he could shove them into another 
>> windows box (that is what he was running on them) and have windows 
>> recover the raid.  all this did was totally destroy the superblock on 
>> one of the two drives.  dmraid now wont see them as a matched pair so 
>> that is out.  the actual data areas of both drives seems to be 
>> intact, but unless i can get them into raid0 i dont know how i can 
>> recover the data.  it figures he gives me the drives after he makes 
>> it a notch or two more of a pain :\
>>
> I have friends like that too. ;-)
>

gotta love 'em

wish i was getting paid for this one



>>
>> now before the advent of mdadm i would use /etc/raidtab and have no 
>> issues setting up the raid device. \
>
> I haven't used raidtools for ages, but can't you bring yourself to 
> using them now? I seem to remember that there was no superblock to be 
> written in a bad place, which might be an advantage. mdadm has several 
> versions which write the superblock in various places on the drives, 
> and you may want "none of the above."
>
> Alternatively, if these are fairly small, write a tiny program to open 
> both physical devices, read a chunk from one, then the other, repeat 
> while writing to something not hosed.


at the suggestion of another on the list (thanks neil brown!) i tried 
modprobing a slew of things related to the disk mapper to no avail, then 
i gave up using knoppix and tried with a fedora 6 box (after i dd-ed the 
drives off to a larger drive) and it worked great.  i can definitely say 
that while mdadm is quite foreign territory for me, i love the fact i 
can specify everything i want to happen on one command line.

btw once i actually did get the drives raided it turns out that while 
the partition table was intact, somehow the partition itself was 
fubarred enough that i couldnt mount it to save my life.  finally just 
told the guy "you screwed it by trying to recover it, next time bring me 
the drives the MOMENT you have a problem"

Casey


