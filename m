From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: Autorebuild - many instances of Monitor?
Date: Fri, 29 Oct 2010 08:50:53 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0BCA@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Thursday, October 28, 2010 2:14 AM
To: Czarnowska, Anna
Cc: linux-raid@vger.kernel.org
Subject: Re: Autorebuild - many instances of Monitor?

On Wed, 27 Oct 2010 08:55:05 +0100
"Czarnowska, Anna" <anna.czarnowska@intel.com> wrote:

> Hi Neil,
> As a result of our internal discussion on autorebuild we decided to introduce new parameter for mdadm -F to be able to run monitoring without moving spares.
> It doesn't seem reasonable to have two processes juggling disks at the same time so we also think we should allow only one spare sharing process.
> Our current version only allows one Monitor to move spares.
> 
> When introducing parameter that indicates there will be no spare sharing, I think it would be confusing to have spare-group based code still move spares.
> So I think the option should also disable old style spare migration. With the option there is no problem having several Monitors on the same devices. 
> Without the option Monitor will move spares as before and also based on new config domains.
> 
> However there is one issue we would like to get your opinion on. 
> Allowing only one instance of Monitor moving spares would not be fully backward compatible i.e. with spare-group based spare migration it was possible to run multiple instances of Monitor. 
> If run on different sets of devices there is no conflict between many instances, but if the sets of monitored devices overlap, then for example two or more monitors could add spares to the same array that just needs one.
> Do you think we should allow user to run multiple instances of Monitor that does spare sharing, possibly introducing a conflict between instances?
> 

The possibility of confusion clearly isn't a new issue.  It has always been
possible to run multiple monitor processes that could confuse each other.
But it doesn't seem to be a problem in practice - people just don't do that.

So it isn't clear to me why you now want to prevent people from doing
something that they didn't do anyway.


It would be reasonable to ensure that only one instance of 
    "mdadm --monitor --scan" 
was running, as '--scan' gives mdadm permission to monitor anything that it
finds.  Maybe that is where you should put the locking if you really think
some is needed.
i.e. if Monitor is run with 'scan' set, then fail if you cannot claim a lock
file.

NeilBrown

-----------------------

Ok then. I left locking for scan mode only and issue a warning in other cases if one process with --scan is already running.
Updated code for autorebuild is coming later today.
Thanks
Anna

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

