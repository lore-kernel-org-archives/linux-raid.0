From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: raid10: unfair disk load?
Date: Mon, 24 Dec 2007 08:22:31 +1300
Message-ID: <476EB577.5090708@sauce.co.nz>
References: <476BA4FD.6080401@msgid.tls.msk.ru>	 <476BA942.40406@msgid.tls.msk.ru> <20071221174902.6fc02c4e@absurd>	 <476C2869.1080903@msgid.tls.msk.ru> <20071222130559.68b773fd@absurd>	 <cccedfc60712220504t1d720330p6f8ecf9bfd0f3163@mail.gmail.com>	 <beb6123c0712222034g68743afv31c644ff4dd9aaff@mail.gmail.com>	 <476E5634.4050607@msgid.tls.msk.ru>	 <beb6123c0712230521r2a8a43aboe097fc2fc943c3ae@mail.gmail.com> <cccedfc60712230623q6779369x851f0eb2587321e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60712230623q6779369x851f0eb2587321e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Nelson wrote:

> My own tests on identical hardware (same mobo, disks, partitions,
> everything) and same software, with the only difference being how
> mdadm is invoked (the only changes here being level and possibly
> layout) show that raid0 is about 15% faster on reads than the very
> fast raid10, f2 layout. raid10,f2 is approx. 50% of the write speed of
> raid0.

Have you tested a stacked RAID 10 made up of 2 drive RAID1 arrays, 
striped together into a RAID0.

I have found this configuration to offer very good performance, at the 
cost of slightly more complexity.

Regards,

Richard
