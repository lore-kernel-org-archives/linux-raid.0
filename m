From: Anu Matthew <anu.matthew@bms.com>
Subject: Re: multipath md devices
Date: Wed, 22 Sep 2004 18:20:54 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4151FAC6.8090204@bms.com>
References: <4151E37B.8040207@bms.com>
 <1095888922.4196.1548.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1095888922.4196.1548.camel@compaq.xsintricity.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

// 
Yeah, IBM wrote a little app to help with that.  We stuffed it into the
mdadm package we ship since that seemed the most appropriate place for
it.  It's called mdmpd and that's it's job basically.  Very simple app,
but doesn't run on upstream kernels at the moment (it wants the md event
interface which hasn't yet been submitted upstream by Neil). 
//


Doug, thanks a lot, we appreciate your response.

One of our boxes with the multipath problem (sic) runs on RHEL ES3.0 
with active RHN subscription and is at 2.4.21-15.ELsmp, and has 
mdadm-1.5.0-3, with mdmpd running. Yet it crashed last week as the paths 
went away from a SAN switch f/w upgrade, as they took off the paths one 
4 hours after another, but never both the paths at the same time.

I saw your post on Bugzilla, dated 2004-06-07 about the md Event 
Interface Patch. Do we still have to throw that patch in, manually? Or 
does 2.4.21-20.ELsmp have it already? I tried to read up the Change Log 
and File lists, could gather nothing much.

Thanks,

--Anu Matthew

