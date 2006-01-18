From: Sander <sander@humilis.net>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Wed, 18 Jan 2006 09:14:07 +0100
Message-ID: <20060118081407.GC18945@localhost.localdomain>
References: <20060117174531.27739.patches@notabene> <43CCA80B.4020603@tls.msk.ru> <20060117095019.GA27262@localhost.localdomain> <43CCD453.9070900@tls.msk.ru> <20060117160829.GA16606@lug.udel.edu> <43CD3388.9050107@tls.msk.ru>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43CD3388.9050107@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Ross Vandegrift <ross@lug.udel.edu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote (ao):
> Most problematic case so far, which I described numerous times (like,
> "why linux raid isn't Raid really, why it can be worse than plain
> disk") is when, after single sector read failure, md kicks the whole
> disk off the array, and when you start resync (after replacing the
> "bad" drive or just remapping that bad sector or even doing nothing,
> as it will be remapped in almost all cases during write, on real
> drives anyway),

If the (harddisk internal) remap succeeded, the OS doesn't see the bad
sector at all I believe.

If you (the OS) do see a bad sector, the disk couldn't remap, and goes
downhill from there, right?

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
