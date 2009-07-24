From: Thanassis Tsiodras <ttsiodras@gmail.com>
Subject: Handling mismatch_cnt
Date: Fri, 24 Jul 2009 19:01:28 +0300
Message-ID: <f1d2d9ca0907240901y60c8d8bdlfb9938de9b374561@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Handling mismatch_cnt<>0

I have been a casual user of Software RAID: RAID1 on two disks, to be
exact. Like many others, eventually I got to see non-zero "mismatch_cnt"
errors. I searched on the web, and found the comments made by Neil,
explaining how it could happen for swap (it wasn't swap) - how it
could happen if the data changed in memory during the time that the
DMA transfer to the first drive was taking place (doubtful in my case),
how it could happend during a crash (data written on one drive only
and then system crashes - maybe) etc.

In the end, one thing was clear: when mismatch_cnt<>0 happens,
you might be lucky and the report refers to unimportant sectors,
or you might be unlucky and indeed only one of the sector copies
is the right one.

The question is... which one?  And how do we fix things?

To which I'm afraid, there's no answer. As Neil says:
(http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07179.html)

    When performing a check/repair md looks for consistencies and
    fixes them 'arbitrarily'.  For raid5/6, it just 'corrects' the
    parity.  For raid1/10, it chooses one block and over-writes the
    other(s) with it.

That quote made my heart sink - at random?
Then what is the point of my RAID1, if not preserving my data?
I don't want a random process deciding what data is good and what isn't!

Also - unless something changed in the last kernels - when mismatch_cnt
is non-zero, there's no way for me to learn about what sectors this
is about. I can't ask my filesystem whether these sectors are in use
or not, whether they point to free-space or not - and I most definitely
can't read them to see if it's the last incarnation of my code (or
the one before last). I have no say in the "fixup" process.

Around the same time, I heard of ZFS, and played around with both
OpenSolaris/ZFS and Linux/ZFS-Fuse. Suffice to say, that the thought
of checksums was enough to put my heart at ease - as long as the
FS is mountable, whatever data are shown there are in fact, data
with correct checksums behind them. And if I use a ZFS mirror, or even
a "copies=2" option (which stores two copies of each sector even if
you only have one disk) I am pretty sure that my data will survive
the occasional bad sector.

So, my point:

Am I missing something? Is MD RAID1 in fact better than what I
have understood? Is there an answer that would allow me to use it
without the uncertainty of "russian-roulette" fixes when the
inevitable mismatch_cnt<>0 occurs?

In other words, is there anything a Linux guy can do besides wait
for btrfs or trust a FUSE version of ZFS?

Thanks for any feedback,
Thanassis.


--
What I gave, I have; what I spent, I had; what I kept, I lost. -Old Epitaph
