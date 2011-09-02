From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: freshly grown array shrinks after first reboot - major data
 loss
Date: Fri, 2 Sep 2011 12:33:35 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1109021232330.13538@uplift.swm.pp.se>
References: <4E5FA4B5.6010407@macroscoop.nl> <4E5FAEF3.60501@macroscoop.nl> <4E5FAFE9.3040604@macroscoop.nl> <4E5FB762.4050003@yuiop.co.uk> <4E5FBF08.5080709@macroscoop.nl> <4E609B8A.9030401@macroscoop.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E609B8A.9030401@macroscoop.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Cc: John Robinson <john.robinson@yuiop.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2 Sep 2011, Pim Zandbergen wrote:

> Is the latter way the way it is supposed to be done now?

I've used whole drives the past years, it's worked great. You avoid all 
the hassle of handling partitions and alignment.

So yes, go for the whole device approach. I would make sure the partition 
table is wiped and that I was using v1.2 superblocks (default by now).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
