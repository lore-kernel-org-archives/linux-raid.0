From: Christoph Dittmann <linux-raid@christoph-d.de>
Subject: Re: Triple-parity raid6
Date: Fri, 10 Jun 2011 14:20:40 +0200
Message-ID: <4DF20C18.3030604@christoph-d.de>
References: <isp2g2$rf$1@dough.gmane.org>	<20110609114954.243e9e22@notabene.brown>	<isqb2o$g0s$1@dough.gmane.org>	<20110609220438.26336b27@notabene.brown> <87aadq5q1l.fsf@gmail.com> <isslla$o2i$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <isslla$o2i$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/10/2011 10:45 AM, David Brown wrote:
> Making multiple parity syndromes is easy enough mathematically:

Adam Leventhal, who wrote the double parity and triple parity code for 
ZFS, mentioned on his blog [1] that going beyond triple parity poses 
significant challenges if write performance should not suffer.

In particular, it looks like a relevant math paper (originally) had a 
flaw in the claim that quad parity and above can be implemented just 
like triple parity.

I don't know the implementation you were going to use, neither am I 
knowledgeable about multi-parity in general. I only thought it might be 
relevant to add to the current discussion that other people had issues 
with implementing N-parity for N > 3.


Christoph

[1] http://blogs.oracle.com/ahl/entry/triple_parity_raid_z
