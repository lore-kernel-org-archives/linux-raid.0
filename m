From: Marc Bevand <bevand_m@epita.fr>
Subject: Re: RAIDn technology
Date: Fri, 13 Feb 2004 17:48:55 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <c0iv82$q5a$1@sea.gmane.org>
References: <Pine.LNX.4.44.0402111508210.8702-100000@picard.science-computing.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0402111508210.8702-100000@picard.science-computing.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oliver Tennert wrote:
> Hello,
> 
> has anybody ever heard of RAID^n technology, developed and patented by a
> company called Inostor (http://www.inostor.com)?
> 
> It is designed to offer protection against the simultaneous failure of an
> arbitrary number of arbitrary disks.
> 
> The pdf files publicly available on their homepage states that the
> algorithms used by them to implement an m+n RAID system (m data disks, n
> redundancy disks) are NOT the well-known Reed-Solomon codes as e.g.
> described in a well-known paper by J. Plank.

This paper is [1]. But AFAIK it describes only Vandermonde-based
Reed-Solomon codes, not Cauchy-based ones.

> Does anybody have a notion how RAID^n works? Their algorithms used seem to
> hold a regular US patent.

RAID^n is nothing more than FEC (Forward Error Correction). Any erasure
code can be used to implement FEC:

 - Cauchy-based Reed-Solomon codes
 - Vandermonde-based Reed-Solomon codes
 - Low-Density Parity-Check codes [2] (eg: Tornado Codes...)

Tornado codes are patented by Digital Fountain [3] (RFC 3453 contains a
list of the patents). Maybe Inostor uses them ?

[1] http://www.cs.utk.edu/~plank/plank/papers/CS-96-332.html
[2] http://www.cs.utk.edu/~plank/plank/papers/CS-03-510.html
[3] http://www.digitalfountain.com

-- 
Marc Bevand

