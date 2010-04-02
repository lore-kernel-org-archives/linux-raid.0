From: Jools Wills <jools@oxfordinspire.co.uk>
Subject: Re: Problems with RAID 6 across 15 disks
Date: Fri, 02 Apr 2010 02:40:13 +0100
Message-ID: <1270172413.24051.2.camel@travelmate.workshop>
References: <4BB49E4D.1090809@maxeaves.co.uk> <4BB4A461.5030704@redhat.com>
	 <4BB4A89F.7030707@maxeaves.co.uk> <20100402074325.3ce34e8f@notabene.brown>
	 <20100401224644.GA2455@lazy.lzy>
	 <1270162736.24051.0.camel@travelmate.workshop>
	 <20100401230437.GA5067@lazy.lzy>
Reply-To: jools@oxfordinspire.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100401230437.GA5067@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Neil Brown <neilb@suse.de>, max@maxeaves.co.uk, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Fri, 2010-04-02 at 01:04 +0200, Piergiorgio Sartor wrote:
> you might be unaware of the repeated neverending
> discussions about this topic.

yup :)

> It is *possible* to do it, but, as of today, it
> cannot do it.
> I mean, there is no functionality, in the RAID-6, to
> detect and correct those errors using the available
> double parity.

Is this the same for raid 5 or specifically a raid 6 issue on linux ?

I had assumed that with my raid5 array, if the raid check finds an error
it will attempt to rewrite back to the disk, and then read again, and
carry on if everything is ok.

Best Regards

Jools

Jools Wills
-- 
IT Consultant
Oxford Inspire - http://www.oxfordinspire.co.uk - be inspired
t: 01235 519446 m: 07966 577498
jools@oxfordinspire.co.uk

