From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Stress testing system?
Date: Sat, 9 Oct 2004 12:58:14 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410091658.i99GwJN22615@www.watkins-home.com>
References: <4167B4C5.6040004@robinbowes.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4167B4C5.6040004@robinbowes.com>
To: 'Robin Bowes' <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Once a drive fails, md will not re-sync it automatically.  It will just sit
there in a failed state.  If you had a spare, then it would re-sync
automatically.  I am not 100% sure but I think...if you were to reboot,
after the reboot md will resync.

If you reboot before the re-sync is done, the re-sync will start over, at
lease with my version.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Robin Bowes
Sent: Saturday, October 09, 2004 5:52 AM
To: Guy
Cc: 'Gordon Henderson'; linux-raid@vger.kernel.org
Subject: Re: Stress testing system?

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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

