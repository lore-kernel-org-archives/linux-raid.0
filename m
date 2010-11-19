From: Tim Small <tim@seoss.co.uk>
Subject: Re: faulty array member
Date: Fri, 19 Nov 2010 10:47:01 +0000
Message-ID: <4CE655A5.4050802@seoss.co.uk>
References: <4CE55D9E.4070406@supsi.ch> <4CE57E8E.2040902@buttersideup.com> <4CE640C6.3090607@supsi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CE640C6.3090607@supsi.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


>> then copy those individual blocks (only) over from sda2 (e.g. using
>> dd).  Once sdb1 has no pending sectors left, you should then be able to
>> re-add sda2 back into md0.
>
> that is exactly what I was trying to do.. but as the two drives
> partitioning are not the same, I don't know how to find the
> corresponding blocks/sectors in the two drives.

Under later kernels, you can definitely do something like:

cat /sys/block/sda/sda2/start

to find what the offset is from the start of the drive for each partition.

>> I don't know what the bad-block remapping is like on the CentOS4 kernel,
>
> I believe in this case, the bad-block remapping is done by the
> hd firmware.. please correct me if I'm wrong.

Yes it is, but the remap is triggered by a write to the block, so when
it happens automatically due to md, the following has to happen:

md tries to read from a sector, the read fails, so md reads from the
other drive, and then writes that data back to the original drive


> By the way, why it is not possible to re-add /dev/sda2 into the raid?

You should be able to do that, but md would in that case start a rebuild
from the other drive (i.e. copy all blocks from the other drive), and as
there are currently pending sectors on that drive, the rebuild will fail
- so you have to eliminate those faulty sectors on the source drive first.

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.  
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

