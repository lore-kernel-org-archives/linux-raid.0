From: Michael Robinton <michael@bizsystems.com>
Subject: (unknown)
Date: Tue, 16 Jul 2002 16:14:10 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0207161610410.29896-100000@pandora.is.bizsystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> replied:
>> i86 2.4.17 kernel
>> 2 - 1de 20 gig western digital drives on separate channels (ASUS-me99)
>> There are several raid partitions on this drive, one managed to get out
>of
>> sync when the cpu failed. The ext2 file system is fine but the arrray
>will
>> not reconstruct -- I have 7 linux boxes running various flavors or raid
>1
>> and 5 for several years, and this is the first time I've seen anything
>> like this.
>>
>> The reconstruction proceeds until /proc/mdstat says 99.9% complete
>> (2015872,2015936) finish 0.0 min
.> then the speed keeps going down with each successive query. There is no
>> disk activity per the "red" light. Tried this twice with identical
.results
>> each time.
>>
>> Any suggestions??>>
.
>Sounds like a bug that was fixed recently...
>It may be that you just need to encourage some other disc activity on
>that system and it will spring to life and finish.
>
>NeilBrown

hmmm.... seems when I rebooted the array is now happy. That didn't happen
the first time I tried it.

What version of the 2.4 kernel is the fix in?? Did it make it into
2.4.18??

Michael

