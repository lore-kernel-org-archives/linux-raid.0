From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: some general questions on RAID
Date: Sat, 06 Jul 2013 03:52:42 -0500
Message-ID: <51D7DADA.50200@hardwarefreak.com>
References: <1372962602.8716.56.camel@heisenberg.scientia.net>  <51D5F22C.70007@turmel.org> <1373074400.10569.49.camel@fermat.scientia.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1373074400.10569.49.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/5/2013 8:33 PM, Christoph Anton Mitterer wrote:
> One more on that, which I've just thought about:
> 
> On Thu, 2013-07-04 at 18:07 -0400, Phil Turmel wrote:
>> I believe dmcrypt is single-threaded, too.
> Even if that is still true... and it with dmcrypt below MD it would run
> with _one_ thread _per_ physical device... while the other way round
> (dmcrypt on top of MD) it would run with _only one_ thread over the
> _whole_ MD device (and thus also all disks)...
> 
> ...would the former really give a performance benefit (or wouldn't it be
> actually much worse).

Yes.

> Since even though you'd have one dmcrypt thread per disk now,... each of
> them would have to en/decrypt the "same" actual data for different
> devices... so while you have 4x threads... you need to do 4x
> en/decryption works.

This would only be true if using n-way mirroring.

> Which wouldn't be the case when having dmcrypt on top of MD... sure
> you'd only have one thread...

You misunderstand the way this works.  With striped md RAID each chunk
goes to a different disk.  All chunks contain dissimilar data.  If you
use dmcrypt at the lowest level of the stack you have one dmcrypt thread
per chunk, each processing 1/n of the load.  There is no duplication of
work.

-- 
Stan

