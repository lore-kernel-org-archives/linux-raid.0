From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: Stress testing system?
Date: Sat, 09 Oct 2004 10:52:05 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4167B4C5.6040004@robinbowes.com>
References: <200410082348.i98NmlN19747@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200410082348.i98NmlN19747@www.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: 'Gordon Henderson' <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> Not normal.  Was it ever synced?
> Wait for it to re-sync, then reboot and check the status.
> Some people have problems after a reboot.
> 
> Cat /proc/mdstat for the ETA and status.

Well, the array re-synced overnight and I re-ran bonnie++ again a couple 
of times this morning with no apparent ill-effect.

To be honest, I'd just had some problems with a loose power cable so I 
suspect that the array was already re-syncing before I ran bonnie.

Thanks,

R.
-- 
http://robinbowes.com
