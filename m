From: Wols Lists <antlists@youngman.org.uk>
Subject: Linux raid wiki - force assembling an array where one drive has a
 different event count - advice needed
Date: Sat, 24 Sep 2016 00:15:09 +0100
Message-ID: <57E5B77D.5080608@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

As I understand it, the event count on all devices in an array should be
the same. If they're a little bit different it doesn't matter too much.
My question is how much does it matter?

Let's say I've got a raid-5 and suddenly realise that one of the drives
has failed and been kicked from the array. What happens if I force a
reassemble? Or do a --re-add?

I don't actually have a clue, and if I'm updating the wiki I need to
know. What I would HOPE happens, is that the raid code fires off an
integrity scan, reading each stripe, and updating the re-added drive if
it's out-of-date. Is this what the bitmap enables? So the raid code can
work out what changes have been made since the drive has been booted?

Or does forced re-adding risk damaging the data because the raid code
can't tell what is out-of-date and what is current on the re-added drive?

Basically, what I'm trying to get at, is that if there's one disk
missing in a raid5, is a user better off just adding a new drive and
rebuilding the array (risking a failure in another drive), or are they
better off trying to add the failed drive back in, and then doing a
--replace.

And I guess the same logic applies with raid6.

Cheers,
Wol
