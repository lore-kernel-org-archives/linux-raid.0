From: Florian Schanda <ma1flfs@bath.ac.uk>
Subject: Re: 2.6.0-test{1,2,3} kernels + software raid 0 + xfs broken?
Date: Wed, 27 Aug 2003 13:21:43 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200308271321.44105.ma1flfs@bath.ac.uk>
References: <200308231916.00588.ma1flfs@bath.ac.uk>
Reply-To: ma1flfs@bath.ac.uk
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200308231916.00588.ma1flfs@bath.ac.uk>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

On Saturday 23 August 2003 19:16, Florian Schanda wrote:
> I am running a 2.4.21 kernel + xfs + raid0 (software) on 2 scsi disks. It
> works without flaws.
>
> Trying the same setup in 2.6.0-test{1,2,3} (haven't tested 4 yet) _will_
> give data corruption if I write to the array.

Looking at: 
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/must-fix/must-fix-6.txt

> o RAID0 dies on strangely aligned BIOs

Is that my problem? I'm not sure I fully undestand this -- what is strangely 
aligned here?

	Florian Schanda

