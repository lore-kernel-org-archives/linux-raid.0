From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Pro-active replacement
Date: Sat, 14 Aug 2010 16:20:22 +0200
Message-ID: <20100814142022.GA7746@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

time to time there is the discussion about
RAID-5/6 proactive replacement of an HDD.

Reading this mailing someone suggested to
use somehow RAID-1 under the RAID-5/6.

I would like to summarize this and have some
feedback, in order to understand if this is a
feaseable way or it would be better to have it
integrated directly into the RAID-5/6.

First of all, what I understood as "proactive
replacement".

This should be the ability to add an HDD (A) to
a RAID-5/6 array, as spare and replace some other
HDD (B) without failing/removing B during the
process of resync, but only in the end.
So the array will be always, during the replacement,
fully functional with the maximum protection it can
offer (of course, until something goes wrong).

The idea would be the following.

Assuming a RAID-5 is the target, with n HDDs.

First of all, n single disk RAID-1 are created.

Second, a RAID-5 is creted using, as components,
the n RAID-1.

When a proactive replacement of HDD x is wanted,
the "spare" y is added to the correspoinding RAID-1,
i.e. the RAID-1 which is using HDD x.

After the resync of the RAID-1 takes place, the
HDD x could be failed/removed from the corresponding
RAID-1.

This should guarantee the RAID-5 has always n HDDs,
or more.

Questions:

1) Does this make sense?
2) How much performance degradation could be expected? 
3) Is there something not forseen?
4) Is there a better solution?
5) How difficult could be to integrate this into the RAID-5/6?

Thanks a lot in advance,

bye,

-- 

piergiorgio
