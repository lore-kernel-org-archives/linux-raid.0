From: John Hughes <john@Calva.COM>
Subject: Re: mdadm issue on Ubuntu Januty 9.04 server
Date: Wed, 13 May 2009 15:14:40 +0200
Message-ID: <4A0AC7C0.1020507@Calva.COM>
References: <5817fbed0905111832u35d39a5au52482cceea53a4cb@mail.gmail.com> <f6ef7d922bea762a5b2539e4d015934a.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f6ef7d922bea762a5b2539e4d015934a.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: fibre raid <fibreraid@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> that make them look like part of some old array.
> Why jaunty partially assembled them isn't clear.  Maybe it
> is using --incremental and it is waiting for the rest of the
> array to appear.
>   
In my experience mdadm --incremental just doesn't work on Jaunty.

When you run it on the first disk in the raid it sets the raid up as 
waiting for the rest, creates the /dev/md/xxx device, all looks good.

When you try the second disk (I have a raid-1) it complains that the 
/dev/md/xxx exists and does nothing.

Results - exactly as "fibre raid" complains - you're left with a partly 
set up inactive raid.

Haven't got around to doing a bugreport yet as I don't want to mess with 
my running server.

