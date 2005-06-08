From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: active/active vs active/passive?
Date: Wed, 08 Jun 2005 13:51:03 -0400
Message-ID: <42A73007.6060102@steeleye.com>
References: <1118189397.15459.108.camel@seki.nac.uci.edu>	 <42A641CC.9040905@steeleye.com> <1118250910.15459.132.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1118250910.15459.132.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Stromberg wrote:
> On Tue, 2005-06-07 at 20:54 -0400, Paul Clements wrote:

> What it is about active/passive that is so much easier to implement than
> active/active?

There's nothing that difficult about active/active, assuming you're 
talking about the servers operating on separate (or static) data. What's 
difficult is the cluster filesystem. Those tend to be big pieces of 
low-level (read, kernel) code, and they require a distributed lock 
manager and a membership model, which are also generally implemented 
in-kernel.

Of course, without knowing the context of the speaker's reference to 
this, it's hard to say exactly what he meant or if it's even remotely 
related to what I'm talking about... :)

--
Paul
