From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadmin can't re-sync a mirror?!
Date: Sat, 25 Jan 2003 15:47:50 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15922.5878.154835.39402@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.44.0301241529360.26021-100000@pcmy.sei.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from James Ralston on Friday January 24
To: James Ralston <qralston+ml.linux-raid@andrew.cmu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday January 24, qralston+ml.linux-raid@andrew.cmu.edu wrote:
> Either I've grossly understood how Linux RAID and/or the mdadmin
> command works, or this is horribly wrong:
...
> 
> But the mirror doesn't sync (!):

Very odd.  What you do should have the desired result, but obviously
doesn't.

You didn't say which kernel you are running - 2.4 or 2.5.xx
I assume there aren't any other RAID arrays present.  Is this correct
(or did you edit the output of /proc/mdstat).

NeilBrown
