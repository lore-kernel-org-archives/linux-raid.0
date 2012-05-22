From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Question about commit 02e7c5b75cd4ad5176441add156389c71dab6e3a -
 avoid including wayward devices
Date: Tue, 22 May 2012 15:59:50 +0300
Message-ID: <CAGRgLy6RFRQqB0VtV-=C2v+TCu4yKJEOR3i=zF_5yxTtVCHWZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,
can you pls give some details on that commit.

As far as I understand, this change attempts to protect from
split-brain, most typical to RAID1 (but also, e.g., to 4-drive RAID6)
, where part of a mirrored set was assembled independently. The code
first selects "most_recent" based on event count (as usual). Then it
applies the map check to all those devices that are not "most_recent",
and might kick them out, if it detects split-brain.
However, when there is such split-brain, and parts of mirrored sets
are assembled independently, the highest event count does not really
tell us which part of the mirrored set is "more up-to-date". This is
because event count is not tied to any hard clock or something like
that. So there is really no way to tell what part of the mirrored set
will be picked up here (WRT to user activity on the separate mirrored
sets).

What I am trying to say, I guess: don't you think that in such case,
it would be better to warn the user and abort, and not pick (more or
less) arbitrary part of the set? Or, in other words:) might you
reconsider looking at some ideas for split-brain protection I pitched
some time ago?:))

Thanks!
Alex.
