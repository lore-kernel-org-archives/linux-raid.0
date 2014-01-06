From: Fabian Knorr <knorrfab@fim.uni-passau.de>
Subject: Re: Recovering an Array with inconsistent Superblocks
Date: Mon, 06 Jan 2014 15:00:46 +0100
Message-ID: <1389016846.25272.5.camel@vessel>
References: <1388829881.16265.20.camel@vessel> <52C835C9.3050707@turmel.org>
		 <1388873143.7641.20.camel@vessel> <52C8C433.5030403@turmel.org>
		 <1388912870.3591.4.camel@vessel> <20140105205612.093276ef@notabene.brown>
	 <1388918703.3591.20.camel@vessel> <52C9A399.5040802@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C9A399.5040802@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Many thanks to both of you, Phil and Neil!

Everything works flawlessly now and I had no data loss whatsoever.

> Long term, consider creating a new array with metadata type 1.x so you
> can use a bitmap.  If you ever have an event like this, where one or
> more devices are disconnected then reconnected, it'll greatly shorten
> the recovery time.

But it's not possible to upgrade the metadata version of an existing
array, is it? 

Fabian


