From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Busted disks caused healthy ones to fail
Date: Wed, 15 Dec 2004 09:22:12 +0400
Message-ID: <41BFCA04.40102@wasp.net.au>
References: <200412150504.iBF54P912209@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412150504.iBF54P912209@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Jim Paris' <jim@jtan.com>, comsatcat@earthlink.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> Maxtor drives....and no problems....You must be crazy!  :)
> 
> Well then, uh, it could...., humm....  That only leaves crazy!  :)
> 
> I give up!  You defended yourself well.  I have no idea.
> 

Note that it was not me who had the failing disk in the first place. I was just responding to the 
comment that 14 drives in a case sounded ludicrous. If the setup is reasonably well thought out and 
well cooled I see no issue. Yes, I do exceed my PSU continuous rating every time I spin up, but as I 
said I timed that overload at about 1.5 seconds and the PSU does not make any form of complaint.

I hope I'm more than just lucky with the Maxtor drives, but honestly I have had just as bad a run 
with every brand except Quantum (and who owns them now?). I figure by keeping the drives as cool as 
practical, in a stable environment with minimal temperature fluctuation and power cycling (this 
machine is a 24x7 server) then I'm probably fairly likely to get a better than average lifetime.

Sure with 29 Identical Maxtor drives I expect failures. I have a cold spare on standby just in case 
and the new 15 drive box will run Raid-6. In addition, this is a home entertainment system, it's not 
mission critical. Just a bit of fun on the weekends.

It's also a good test of the md and libata drivers. All up between the 29 drives I now have 7 
Promise SATA150TX4 controllers. Looking forward to hotswap :p)

-- 
Brad
                    /"\
Save the Forests   \ /     ASCII RIBBON CAMPAIGN
Burn a Greenie.     X      AGAINST HTML MAIL
                    / \
