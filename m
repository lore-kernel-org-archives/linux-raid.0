From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: with raid-6 any writes access all disks
Date: Thu, 27 Oct 2011 14:22:55 +0200
Message-ID: <4EA94D1F.8080507@zytor.com>
References: <CAGtzr3c65BXDfWZq4ejKwCZv7hPZmdCpvQP17RgFS-Vrn2YF5Q@mail.gmail.com> <20111027082331.01e1fc7a@notabene.brown> <4EA889FF.90002@zytor.com> <4EA92493.1060107@westcontrol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EA92493.1060107@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: NeilBrown <neilb@suse.de>, Chris Pearson <kermit4@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/27/2011 11:29 AM, David Brown wrote:
> 
> Q_new can be simplified to:
> 
> Q_new = Q_old + 2^(i-1) . (Di_old + Di_new)
> 
> "Multiplying" by 2 is relatively speaking quite time-consuming in
> GF(2^8).  "Multiplying" by 2^(i-1) can be done by either pre-calculating
> a multiply table, or using a loop to repeatedly multiply by 2.
> 

Multiplying by 2 is cheap.  Multiplying by an arbitrary number is more
expensive, in the absence of tricks that can be played on specific
hardware implementations (e.g. SSSE3) as mentioned in my paper.

> 
> I don't know what compiler versions are typically used to compile the
> kernel, but from gcc 4.4 onwards there is a "target" function attribute
> that can be used to change the target cpu for a function.  What this
> means is that the C code can be written once, and multiple versions of
> it can be compiled with features such as "sse", "see4", "altivec",
> "neon", etc.  And newer versions of the compiler are getting better at
> using these cpu features automatically.  It should therefore be
> practical to get high-speed code suited to the particular cpu you are
> running on, without needing hand-written SSE/Altivec assembly code. That
> would save a lot of time and effort on writing, testing and maintenance.
> 

Nice in theory; doesn't work in practice in my experience.

	-hpa

