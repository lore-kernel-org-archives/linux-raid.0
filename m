From: Brad Campbell <brad@wasp.net.au>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Wed, 18 Jan 2006 12:37:11 +0400
Message-ID: <43CDFE37.504@wasp.net.au>
References: <20060117174531.27739.patches@notabene> <43CCA80B.4020603@tls.msk.ru> <20060117095019.GA27262@localhost.localdomain> <43CCD453.9070900@tls.msk.ru> <20060117160829.GA16606@lug.udel.edu> <43CD3388.9050107@tls.msk.ru> <20060118081407.GC18945@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060118081407.GC18945@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: sander@humilis.net
Cc: Michael Tokarev <mjt@tls.msk.ru>, Ross Vandegrift <ross@lug.udel.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

linux-kernel snipped from cc list.

Sander wrote:
> Michael Tokarev wrote (ao):
>> Most problematic case so far, which I described numerous times (like,
>> "why linux raid isn't Raid really, why it can be worse than plain
>> disk") is when, after single sector read failure, md kicks the whole
>> disk off the array, and when you start resync (after replacing the
>> "bad" drive or just remapping that bad sector or even doing nothing,
>> as it will be remapped in almost all cases during write, on real
>> drives anyway),

This particular case has been addressed in the latest kernels. md will now attempt to write the bad 
block back using reconstructed data and the disk will only be punted after multiple failures or a 
write failure (if my understanding of the patches is any good anyway)

> If the (harddisk internal) remap succeeded, the OS doesn't see the bad
> sector at all I believe.

If the disk can get a good read then it will re-map on the fly and the OS has no idea there was an 
issue. If not then it returns a read error to the OS. When that sector is next written it will be 
re-mapped by the drive and the error disappears.

> If you (the OS) do see a bad sector, the disk couldn't remap, and goes
> downhill from there, right?

With the older md code, yes, however as stated above this should almost become a non-issue now. (yay!)

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
