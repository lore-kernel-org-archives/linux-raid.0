From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Shrinking raid array
Date: Tue, 12 Feb 2013 14:13:53 -0500
Message-ID: <511A9471.7070405@ubuntu.com>
References: <511A6554.1010100@ubuntu.com> <511A7052.9020802@ubuntu.com> <alpine.DEB.2.00.1302121852000.32644@uplift.swm.pp.se> <511A85D8.5070803@ubuntu.com> <alpine.DEB.2.00.1302121942490.32644@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1302121942490.32644@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/12/2013 1:43 PM, Mikael Abrahamsson wrote:
> On Tue, 12 Feb 2013, Phillip Susi wrote:
> 
>> You move the superblock, then shrink the partition...
> 
> As far as I know, mdadm has no code to shrink partitions?

Of course not, you would use fdisk or parted or whatever else to do that.

>> But it looks like mdadm doesn't move the superblock even though
>> it no longer is using the full partition.
> 
> I think that is perfectly reasonable. Otherwise the superblock
> wouldn't be found next time if the partition wasn't resized.

Yes, but the way it is now the superblock won't be found if the
partition *is* resized.  What is the use of reducing the amount of the
partition mdadm is using if you can't then shrink the partition itself?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRGpRxAAoJEJrBOlT6nu750k8IAMwCbeO6rhWP+6pg0nPmgeyI
HM5E1X9bJTqV9MfmvSKYjL8QBp6flYqd0bm++lbeOxFiujxKQ5QVSHIF8no6psVe
wLLeGy3ltFJ41QnuQAIf2YwR0jhUAd2Wxoeqwq7pnGnSVb8er3Y2ACuj7SNN7SwL
pe8DbrUQGpDydnLSH/Rzj/ioQ8BtWt6Uq/xZ8+3j5t3pqAJGmdnQroRJJ6W+0oKN
IwK7IK0SVP8fExSjDM2Lo3YfFXfgpan81GADNwYo5ZwEtPTfxvcuXrGVLbjXyN4o
Ae6DAMpNihSDKzTXvpPqnzimqpMDtue01zQQdDgkYfcheoQ1DsHnfO8aCnS/mIg=
=i9j8
-----END PGP SIGNATURE-----
