From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: 5 drives lost in an inactive  15 drive raid 6 system due to cable
 problem - how to recover?
Date: Wed, 08 Sep 2010 13:47:19 -0500
Message-ID: <4C87DA37.5000608@hardwarefreak.com>
References: <4C87C656.2030405@stern.nyu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C87C656.2030405@stern.nyu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Norman White put forth on 9/8/2010 12:22 PM:
> We have a 15 drive addonics array with 3 5 port sata multiplexors, one
> of the sas cables was knocked out to one of the port multiplexors...

Exactly how/why was the SAS cable "knocked out".  Is this racked gear?
Fix that problem before worrying about the array state, as you may find
yourself here again in the future.

Bringing the array back up with guess work vs starting a restore now, if
you blow the array trying to fix it with mdadm hacks, you can always
still run the restore later.  Just make sure you do a lot of
verification after you bring the arrays back up and they _seem_ fine.
Don't trust surface appearances, esp when talking about 30TB of data.

Just my $0.02.

-- 
Stan
