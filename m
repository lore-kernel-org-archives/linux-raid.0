From: Tide <lovetide@qq.com>
Subject: Re: Array created by mdadm 3.2 & 3.3 have different array size
Date: Thu, 27 Mar 2014 06:41:53 +0000 (UTC)
Message-ID: <loom.20140327T070926-524@post.gmane.org>
References: <tencent_66C345191B9B49B92956F243@qq.com> <alpine.DEB.2.02.1403261937480.747@uplift.swm.pp.se> <loom.20140326T205013-837@post.gmane.org> <53334347.4050108@hardwarefreak.com> <loom.20140327T033039-0@post.gmane.org> <5333BC86.8090205@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner <stan <at> hardwarefreak.com> writes:

> 
> > "The RAID6/RAID5 array", do you mean my RAID array (just this instance), or
> > you mean "all RAID6/RAID5 arrays created by mdadm" ?
> 
> My reply above is unambiguous.  I quoted your array data and gave an
> answer that applies to your provided array data.
> 
> WRT your other questions, I do not have time to research the answer to
> those, and wouldn't spend it on that if I did.  I have never used CentOS
> nor Fedora, and don't plan to ever use either.  For those answers,
> either wait for someone to answer, or research it yourself.
> 
> Cheers,
> 
> Stan

Thank you Stan!

Now I'm going to try remove the write-intent bitmap and bad block log in the
RAID 6 array to reshape two arrays to same size.

