From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Split-Brain Protection for MD arrays
Date: Mon, 12 Dec 2011 20:51:23 +0200
Message-ID: <CAGRgLy6=-naSGJw_tgiD5=ab7gWxyeQ2ysu-yCKa064Jih+cfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Neil and all the MD developers.

There've been a couple of emails asking about MD split-brain
situations (well, one from a co-worker, so that doesn't count
perhaps). A simplest example of a split-brain is a 2-drive RAID1
operating in degraded mode, but after reboot array is re-assembled
with the drive that previously failed.

I would like to propose an approach that would detect when assembling
an array may result in split-brain, and at least warn the user. The
proposed approach is documented in a 3-page googledoc, linked here:
https://docs.google.com/document/d/1sgO7NgvIFBDccoI3oXp9FNzB6RA5yMwqVN3_-LMSDNE/edit
(anybody can comment).

The approach is very much based on what MD already has today in the
kernel, with only one possible change. On the mdadm side, only code
that checks things and warns the user needs to be added, i.e., no
extra IOs or non-in-memory operations.

I would very much appreciate a review of the doc, mostly in terms of
my understanding how MD superblocks work. The doc contains some lines
in bold blue font, which are my questions, and comments are very
welcome. I am in the process of testing the code changes I made in my
system, once I am happy with them, I can post them as well for review,
if there is interest. If the community decides that this has value, I
will be happy to work out the best way to add the required
functionality.

I also have some additional questions, that popped why I was studying
the MD code; any help on these is appreciated.

- When a drive fails, the kernel skips updating its superblock, and
updates all other superblocks that this drive is Faulty. How can it
happen that a drive can mark itself as Faulty in its own superblock? I
saw code in mdadm checking for this.

- Why mdadm initializes the dev_roles[] array to 0xFFFF, but kernel
initializes it to 0xFFFE? Since 0xFFFF also indicates a spare, this is
confusing, we might think that we have 380+ spares...

- Why event margin of 1 is permitted both in user and kernel? Is this
for the case when we update all the superblocks in parallel in the
kernel, but crash in the middle?

- Why enough() function in mdadm ignores the "clean" parameter for
raid1/10? Is this because if such array is unclean, then there is no
way of knowing, even with all drives present, which copy contains the
correct data?

- In Assemble.c: update_super(st, &devices[j].i, "assemble") is called
and updates the "chosen_drive" superblock only (which might not even
write this to disk, unless force is given), but later in add_disk the
disk.state might still have the FAULTY flag set
(because it was only cleared in the "chosen_drive" superblock). What
am I missing?

- In Assemble.c: req_cnt = content->array.working_disks: taken from
the "most recent" superblock, but even the most recent superblock may
indicate a FAILED array.
This actually leads to the question that interests me most, and I also
ask it in the doc. Why do we continue updating the superblocks after
the array fails? This way we basically loose "last known good
configuration", i.e., we don't know the last good set of devices array
was operating on. Had we known that, that might be useful in assisting
people on recovering their arrays, I think. Otherwise, we need to
guess in what sequence drives failed until the array died.

Thanks to everybody for taking time reading/answering those....and
please be gentle.
  Alex.
