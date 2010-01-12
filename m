From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Minor mdadm fixes
Date: Mon, 11 Jan 2010 15:49:20 -0900 (AKST)
Message-ID: <alpine.LNX.2.01.1001111541200.3360@filesrv1.baby-dragons.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1263242294-5353-1-git-send-email-dledford@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 	Hello Doug ,

On Mon, 11 Jan 2010, Doug Ledford wrote:
> These are a number of minor fixes we carry in our mdadm at the moment.  Would
> prefer not to carry them ourselves ;-)
>
> Neil, any clue when you think might release mdadm-3.1.2?
 	Would you please annotate the git diffs you sent out ?
 	For one I am very confused about the change of

-       sprintf(path, "/var/run/mdadm/%s.pid", devname);
+       sprintf(path, "/dev/.mdadm/%s.pid", devname);

 	why ?  For one .

 	None of the other patches has a annotation either .  While if one is a 
kernel coding guru they are probably very readable .  I am not but would like to 
know what the intention is for the change(s) .

 		Tia ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
