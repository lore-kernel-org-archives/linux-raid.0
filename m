From: Brad Campbell <brad@wasp.net.au>
Subject: Partiy error detection - was Re: ext3 journal on software raid (was
 Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 03 Jan 2005 14:18:21 +0400
Message-ID: <41D91BED.5020302@wasp.net.au>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es> <41D45C1F.5030307@tls.msk.ru> <u59ea2-4qr.ln1@news.it.uc3m.es> <20050102194240.GE99565@caffreys.strugglers.net> <5h1ma2-asq.ln1@news.it.uc3m.es> <20050103003005.GG99565@caffreys.strugglers.net> <2rana2-0if.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2rana2-0if.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:

> And there is a risk of silent corruption on all raid systems - that is
> well known. DIfferent raid systems do different thigs to compensate,
> such as periodically recalculating the parity on everything. But when
> you have redundant data and a corruption occurs, which of the two
> datasets do you believe? You have to choose one of them! You guess
> wrong half the time, if you guess ("you" is a raid system). Hence
> "silent corruption".

Just on this point. With RAID-6 I guess you can get a majority rules type of ruling on which data 
block is the dud. Unless you come up with 3 different results in which case something is really not 
right in lego land.

I wonder perhaps about a userspace app that you can run to check all the parity blocks. On RAID-5 it 
should be able to tell you, you have a naff stripe, but on RAID-6 in theory if it's only a single 
drive that is a problem you should be able to correct the block.

Regards,
Brad
