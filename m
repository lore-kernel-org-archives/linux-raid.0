From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: raid10: unfair disk load?
Date: Sun, 23 Dec 2007 08:23:40 -0600
Message-ID: <cccedfc60712230623q6779369x851f0eb2587321e@mail.gmail.com>
References: <476BA4FD.6080401@msgid.tls.msk.ru>
	 <476BA942.40406@msgid.tls.msk.ru> <20071221174902.6fc02c4e@absurd>
	 <476C2869.1080903@msgid.tls.msk.ru> <20071222130559.68b773fd@absurd>
	 <cccedfc60712220504t1d720330p6f8ecf9bfd0f3163@mail.gmail.com>
	 <beb6123c0712222034g68743afv31c644ff4dd9aaff@mail.gmail.com>
	 <476E5634.4050607@msgid.tls.msk.ru>
	 <beb6123c0712230521r2a8a43aboe097fc2fc943c3ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <beb6123c0712230521r2a8a43aboe097fc2fc943c3ae@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: maobo <maobo1983@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Janek Kozicki <janek_listy@wp.pl>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/23/07, maobo <maobo1983@gmail.com> wrote:
> Hi,all
>
> Yes, I agree some of you. But in my test both using real life trace and
> Iometer test I found that for absolutely read requests, RAID0 is better than
> RAID10 (with same data disks: 3 disks in RAID0, 6 disks in RAID10). I don't
> know why this happen.
>
> I read the code of RAID10 and RAID0 carefully and experiment with printk to
> track the process flow. The only conclusion I report is the complexity of
> RAID10 to process the read request. While for RAID0 it is so simple that it
> does the read more effectively.
>
> How do you think about this of absolutely read requests?
> Thank you very much!

My own tests on identical hardware (same mobo, disks, partitions,
everything) and same software, with the only difference being how
mdadm is invoked (the only changes here being level and possibly
layout) show that raid0 is about 15% faster on reads than the very
fast raid10, f2 layout. raid10,f2 is approx. 50% of the write speed of
raid0.

Does this make sense?

-- 
Jon
