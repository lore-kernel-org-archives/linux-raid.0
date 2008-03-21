From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Redundancy check using "echo check > sync_action": error	reporting?
Date: Fri, 21 Mar 2008 18:35:43 +0100
Message-ID: <47E3F1EF.3030705@rabbit.us>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu> <47E2EE64.5080101@rabbit.us> <47E3C504.3010700@tmr.com> <47E3CBAF.4090808@rabbit.us> <20080321171348.GK7991@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080321171348.GK7991@mit.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Cc: Bill Davidsen <davidsen@tmr.com>, Bas van Schaik <bas@tuxes.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Theodore Tso wrote:
> On Fri, Mar 21, 2008 at 03:52:31PM +0100, Peter Rabbitson wrote:
>> I was actually specifically advocating that md must _not_ do anything on 
>> its own. Just provide the hooks to get information (what is the current 
>> stripe state) and update information (the described repair extension). The 
>> logic that you are describing can live only in an external app, it has no 
>> place in-kernel.
> 
> Why not?  If md doesn't do anything on its own, then when it detects a
> disagreement between the data and the two parity blocks, it has two
> choices (a) return possibly incorrect data to the application, or (b)
> return an I/O error and cause the application to blow up.
> 
> <snip>
> 
> So what's the harm in having an option where md does exactly what ECC
> memory does, which is when it can fix things up, to do so?  I bet most
> system administrators would turn it on in a heartbeat.
> 

With ECC memory you are checking for inconsistency on _every_single_read_ 
whereas the md scrubbing happens at best once a month if the admin turned the 
feature on. Moreover when md actually detects a mismatch the overwhelming 
chance is nobody needs this block at this moment, and might not need it for 
days to come. I think what is eluding this thread is the fact that md does not 
read _any_ redundant blocks unless it absolutely has to. And when it has to - 
you already have a missing chunk and can not apply ECC techniques either.


Of course it would be possible to instruct md to always read all data+parity 
chunks and make a comparison on every read. The performance would not be much 
to write home about though.

Peter
