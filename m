From: Neil Brown <neilb@suse.de>
Subject: Re: raid10 on three discs - few questions.
Date: Mon, 4 Feb 2008 10:11:27 +1100
Message-ID: <18342.18975.229866.860765@notabene.brown>
References: <20080203235043.3dbb6433@szpak>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Janek Kozicki on Sunday February 3
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 3, janek_listy@wp.pl wrote:
> Hi,
> 
> Maybe I'll buy three HDDs to put a raid10 on them. And get the total
> capacity of 1.5 of a disc. 'man 4 md' indicates that this is possible
> and should work.
> 
> I'm wondering - how a single disc failure is handled in such configuration?
> 
> 1. does the array continue to work in a degraded state?

Yes.

> 
> 2. after the failure I can disconnect faulty drive, connect a new one,
>    start the computer, add disc to array and it will sync automatically?
> 

Yes.

> 
> Question seems a bit obvious, but the configuration is, at least for
> me, a bit unusual. This is why I'm asking. Anybody here tested such
> configuration, has some experience?
> 
> 
> 3. Another thing - would raid10,far=2 work when three drives are used?
>    Would it increase the read performance?

Yes.

> 
> 4. Would it be possible to later '--grow' the array to use 4 discs in
>    raid10 ? Even with far=2 ?
> 

No.

Well.... if by "later" you mean "in five years", then maybe.  But the
code doesn't currently exist.

NeilBrown
