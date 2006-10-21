From: Bodo Thiesen <bothie@gmx.de>
Subject: Re: why partition arrays?
Date: Sat, 21 Oct 2006 21:25:11 +0200
Message-ID: <20061021212511.0108aa6f@30_bodo.rupinet>
References: <C59E07CE09883545BC9EC6B87E2D3C83523DBF@kdtc.tt.umist.ac.uk>
	<20061021062648.23c0bd7a@30_bodo.rupinet>
	<453A232E.8050401@idgmail.se>
Reply-To: linux-raid mailing list <linux-raid@vger.kernel.org>,
	  Ken Walker <ken.walker@manchester.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <453A232E.8050401@idgmail.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
Cc: Ken Walker <ken.walker@manchester.ac.uk>
List-Id: linux-raid.ids

Henrik Holst <henrik.holst@idgmail.se> wrote:

> Have you lost any disc (i.e. "physical volumes") since February?

In fact, we have. One disc failed, we removed it brought a new disc, set 
it up like the other ones and finally added it to the degraded RAID 
array. Now everything is fine again ;)

> Or lost the meta-data?

LVM meta-data or RAID meta-data?

LVM: In this case we may really get a problem. But on the other hand: How 
would you try to loose those meta-data?

RAID6: There we would be quite save, as we have all LVs of raid1 called 
raid?1 and so on. So if it wouldn't assemble anymore we could still fall 
back to just recreate it.

> I would not recommend anyone to use LVM if they are less than experts on
> Linux systems.

LVM is such easy to use, I'd recommend anyone to use LVM in favor of 
creating partitions etc. because I think, repartitioning a disc is MUCH 
MORE error prone, than just creating a new LV. And you can do stuff like 
enlarging an LV what you can't with partitions.

> Setting up a LVM system is easy: administrating and
> salvaging the same, was much more work. (I used it ~3 years ago)

Was that LVM on RAID? I'm talking about LVM on RAID.

Regards, Bodo
