From: Schuett Thomas EXT <Thomas.Schuett.extern@mchh.siemens.de>
Subject: AW: RAID1 and data safety?
Date: Thu, 7 Apr 2005 17:35:10 +0200
Message-ID: <76592C4D3DA1AC4FB8424084D10D31A8061152B0@mchh2c4e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Doug Ledford' <dledford@xsintricity.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[Please excuse, my mailtool breaks threads ...]
Reply to mail from 2005-04-05

Hello Doug,

many thanks for this highly detailed and structured posting.

A few questions are left: Is it common today, that a (eide) HD does
not state a write as finished (aka send completion events, if I got this 
right), before it was written to *media*?

I am happy to hear about this "write barriers", even as I am astonished, that 
it doesn't bring down the whole system performance (at least for raid1).


> This is where the event counters
> come into play.  That's what md uses to be able to tell which drives in
> an array are up to date versus those that aren't, which is what's needed
> to satisfy C.

So event counters are the 2nd type of information, that gets written with write 
barriers. One is the journal data from the (j)fs (and actually the real data 
too, to make it gain sence, otherwise the end-of-transaction-write is like a 
semaphor with only one of the two parties using it), and the other is the event 
counter.

> Now, if I recall correctly, Peter posted a patch that changed this
> semantic in the raid1 code.  The raid1 code does not complete a write to
> the upper layers of the kernel until it's been completed on all devices
> and his patch made it such that as soon as it hit 1 device it returned
> the write to the upper layers of the kernel.

I am glad to hear, that the behaviour is such, that the barrier stops, until 
*all* media got written. That was one of the things that really made me 
worrying. I hope, the patch is backed out and didn't went into any distros.

> had in its queue.  Being a nice, smart SCSI disk with tagged queuing
> enabled, it then proceeds to complete the whole queue of writes in
> whatever order is most efficient for it.

But just to make sure: Your previous statement "...when the linux block layer 
did not provide any means of write barriers. As a result, they used completion 
events as write barriers." indicates, that even "nice, smart SCSI disk with 
tagged queuing enabled" will act as demanded, because the special way of write 
with appended "completion events testing" will make sure they do?

---

You mentioned data journaling, and it sounded like it is reliable working. 
Which one of the existing journaling fs did you have in your mind?

---

Afaik a read only reads from *one* HD (in raid1). So how to be sure, 
that *both* HDs are still perfectly o.k.? Am I am fine to do a 
   cat /dev/hda2 > /dev/null ; cat /dev/hdb2 > /dev/null
even *during* the md is active and getting used r/w?

best regards,
  Thomas


