From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: which CPU for XOR?
Date: Fri, 9 Jun 2006 13:22:57 -0700 (PDT)
Message-ID: <e6clb1$dfg$1@terminus.zytor.com>
References: <200606091349.24109.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <200606091349.24109.Dexter.Filmore@gmx.de>
By author:    Dexter Filmore <Dexter.Filmore@gmx.de>
In newsgroup: linux.dev.raid
>
> What type of operation is XOR anyway? Should be ALU, right?
> So - what CPU is best for software raid? One with high integer processing 
> power? 
> 

Something with massive wide vector registers.

PowerPC with Altivec totally kicks ass; x86-64 isn't too bad either.

There are also some processors with builtin RAID accelerators; at
least Intel, Broadcom and AMCC make them.

	-hpa
