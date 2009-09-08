From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: mdadm and TLER (Time Limited Error Recovery)
Date: Tue, 8 Sep 2009 16:17:58 +0200
Message-ID: <slrnhacpsm.2i5.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <299cc2790909071735x6eefd8bsc05ad76fa782cae1@mail.gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tim Rutter <timrutter@gmail.com> wrote:
> Is the TLER on drives like Western Digital's WD2002FYPS a problem or
> benefit for mdadm(RAID5/RAID6)?

Neither nor with a very very small drift to "problem", IMHO.
A (not so little) while ago when md did not automatically correct
read-errors, the drift to "problem" was a bit less small ;) This could
be the reason for some of the vague answers you mentioned.

Anyways, clarification...
The only reason for TLER (Time Limited Error Recovery) is to behave
"friendly" toward RAID controllers that timeout disks.
In fact, md does not timeout disks as many Hardware RAID controllers do.
So, from md's point of view, TLER is useless, i.e. it has no benefit.

On the other hand, TLER leads to the disk not trying as hard to recover
from (read-)errors (i.e. get the data back) as it could - usually,
there's just no need to do it in a RAID, because another component (the
RAID controller) has a far easier way to get the data back (i.e. read it
from the other disk(s)).
Of course, there are the unusual cases, like degraded RAID or two disks
being unable to read this specific data. In these rare cases it would be
nice if the disk would do as much as it can to get the data back instead
of relying on the RAID controller. This is why I think there is a very
very small drift to "problem".


regards
   Mario
-- 
File names are infinite in length where infinity is set to 255 characters.
                                -- Peter Collinson, "The Unix File System"

