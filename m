From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Care and feeding of RAID?
Date: Wed, 6 Sep 2006 09:33:14 +0200
Message-ID: <edltjq$jo4$3@sea.gmane.org>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net> <44FD91D1.7090501@maine.edu> <20060905154156.GB28548@scavenger.homeip.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Benjamin Schieder <blindcoder@scavenger.homeip.net> wrote:
> I have made the experience that long tests slow down the raid to a point
> where the system becomes unusable.

Even though we're quite off-topic here with that since it's more
SMART-related... this is at least unusual.
I'm also running regular SMART selftests (short daily, long weekly) and
usually they don't affect drive's performance very much. However,
whenever I experienced massive slow-downs while selftests are running,
this did always point to disk problems... too much (and strategic
disadvantageous) reallocated sectors (keep an ear on the disks, hear
them seek()ing :)), non-reallocatable sectors or just temperature (for
example, WD drives tend to show a bad performance when getting too hot).


regards
   Mario
-- 
But after a while I learned the trick of speaking fast. You don't have
to think any faster; just use twice as many words to say everything.
                                -- Paul Graham

