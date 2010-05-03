From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Questions about 4k sector drives
Date: Mon, 3 May 2010 09:30:01 -0400
Message-ID: <x2v87f94c371005030630idaaad1e9ue3faff470bd318e1@mail.gmail.com>
References: <4BD42B57.9000703@kusche.de> <1272206601.7734.4.camel@faldara>
	 <4BDE0512.8070502@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BDE0512.8070502@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, Florian Kusche <flox@kusche.de>, linux-raid@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids

Adding Martin Petersen in cc since he knows as much about 4K sector
drives as anyone.

On Sun, May 2, 2010 at 7:04 PM, Bill Davidsen <davidsen@tmr.com> wrote:
<snip>
> Is there any reason not to just align partitions for all drives on 32kB
> sectors and expect that to work on 512b 4kB and SSD? Cautious testing here
> says it works fine, no anomalies, no exciting performance data, just works.

In theory 4K physical sector drives with XP alignment will eventually
ship and possibly have already.

The alignment maybe controlled via a jumper, or could be set in the
factory.  Its up to the manufacturer so there is no way to predict.

These drives will need partitions/stripes etc. aligned to 31.5K, not 1MB.

I don't know it any those drives exist yet, or if they ever will.  But
the kernel topology info specifically supports providing the above
info and aiui parted uses it to choose the best partition layout.

mdadm should as well, not just blindly say 1MB is the magic alignment
point.  (ie. linux can do better than Win2008/Win2003 which simply
disagree with each other on how to align.)

Greg
