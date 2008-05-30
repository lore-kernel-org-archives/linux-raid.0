From: Neil Brown <neilb@suse.de>
Subject: Re: How to force stopping an array`
Date: Fri, 30 May 2008 11:54:30 +1000
Message-ID: <18495.24150.151366.956469@notabene.brown>
References: <200805262343.20626.Dexter.Filmore@gmx.de>
	<200805270102.15029.Dexter.Filmore@gmx.de>
	<40275.192.168.1.70.1211846736.squirrel@neil.brown.name>
	<200805271249.35965.Dexter.Filmore@gmx.de>
	<alpine.DEB.1.10.0805271542240.19633@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Piszcz on Tuesday May 27
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Dexter Filmore <Dexter.Filmore@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 27, jpiszcz@lucidpixels.com wrote:
> >>> Exactly. reboot pretty much deosn't do any good, afterwars the raid
> >>> resyncs,
> >>> which takes full 7h here.
> >>
> >> There shouldn't be a resync.  Presumably nothing is writing to the
> >> array, and moments after the last write, the array will have been
> >> flagged as 'clean' and will not require a resync after a reboot.
>                                               ^^^^^^^^^^^^^^^^^^^^^^
> 
> His host crashed != reboot so that is the reason for the resync.

If the host crashes will nothing is being written to the array, the
array would be marked clean, so a resync will still not be required.
You should only get a resync if the host crashing within 200msecs of
the last write completing.

NeilBrown
