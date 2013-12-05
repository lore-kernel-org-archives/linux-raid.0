From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: accidently pulled to many devices, raid6 wont start.
Date: Thu, 5 Dec 2013 14:48:17 +0000
Message-ID: <BLU0-SMTP1805E84F975401A46BC9B5298D70@phx.gbl>
References: <BLU0-SMTP16236357B62A13D8FFAC14198D70@phx.gbl>
	 <52A08162.3080706@fastmail.fm>
	 <BLU0-SMTP2081DE3677BA1FD887C35BC98D70@phx.gbl>
	 <52A08E50.30609@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A08E50.30609@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> > Hopefully I have not totally killed the array by my mistakes.
> 
> I would simply try again with the correct order - 'missing' as last 
> argument. Then check your data, i.e. test if it mounts (read-only) and 
> run fsck (read-only).
> 
> I'm also a bit suprised why you went the '--create' way at all, why 
> didn't you simply try to assemble with 4 drives only?

A combination of factors, most notably this being a home server for
myself and my son, a few glasses of wine, and cries of "dad I can't get
to my games folder" from his bedroom... then reading misleading web
pages suggesting that if assemble fails to use create and compounding
the issue by not understanding that an assemble can be used with force
and a list of devices (at least as far as I understand) which no doubt I
would have still put in the wrong order in my haste to get it back up
and running...

With hindsight I should have just turned the thing off, gone to bed, and
posted here in the morning before trying anything.

I shall try as you suggest, run the create with the disks in the correct
order and ignore re-inserted sdc and see what happens once I have got
back from the shops.

Thanks for the help so far.

> 
> 
> Cheers,
> Bernd
> 


