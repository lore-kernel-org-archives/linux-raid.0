From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: write-behind has no measurable effect?
Date: Tue, 15 Feb 2011 01:19:33 +0000
Message-ID: <4D59D4A5.9050106@anonymous.org.uk>
References: <20110214213817.GG836@hellgate.intra.guy> <20110215095042.51ef7e0a@notabene.brown> <20110214225754.GK19990@hellgate.intra.guy> <20110215104109.06b12b33@notabene.brown> <20110215010052.GA13135@hellgate.intra.guy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110215010052.GA13135@hellgate.intra.guy>
Sender: linux-raid-owner@vger.kernel.org
To: Andras Korn <korn@raidlist.elan.rulez.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/02/2011 01:00, Andras Korn wrote:
[...]
> Another approach to take would be to mark as dirty, on the fast devices, all
> areas being written to, and in the background continuously synch them to the
> slow devices, sequentially (marking as clean synched-and-as-yet-unwritten-to
> areas); so that the array would be resyncing continually, but be very fast
> for random writes. This would of course also require the bitmap to only be
> synchronously updated on the fast devices.
>
> Otoh, this is really a different mechanism from the current write-behind,
> aimed at a different use-case, so maybe it could be implemented
> orthogonally. (Patches welcome, I'm sure; it's times like these I hate not
> being a coder.)

I wonder whether bcache might do roughly what you want? I haven't tried 
it myself but it does sound interesting: "Hard drives are cheap and big, 
SSDs are fast but small and expensive. Wouldn't it be nice if you could 
transparently get the advantages of both? With Bcache, you can have your 
cake and eat it too." See http://bcache.evilpiepirate.org/

Cheers,

John.

