From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: why not make everything partitionable?
Date: Wed, 15 Nov 2006 22:26:10 +0300
Message-ID: <455B69D2.4040008@tls.msk.ru>
References: <20061115172234.GA32276@piper.oerlikon.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061115172234.GA32276@piper.oerlikon.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

martin f krafft wrote:
> Hi folks,
> 
> you cannot create partitions within partitions, but you can well use
> whole disks for a filesystem without any partitions.

It's usually better to have a partition table in place, at least on x86.
Just to stop possible confusion - be it from kernel, or from inability
to identify disks properly (think [c]fdisk displaying labels) or from
anything else.  But ok.

> Along the same lines, I wonder why md/mdadm distinguish between
> partitionable and non-partitionable in the first place. Why isn't
> everything partitionable?

It's both historic (before, there was no partitionable md arrays),
and due to the fact that the number of partitions is limited by
only single major number (ie, 256 (sub)partitions max).

Maybe there are other reasons - I don't have a defite answer.

/mjt
