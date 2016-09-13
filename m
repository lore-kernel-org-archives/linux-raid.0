From: Shaohua Li <shli@kernel.org>
Subject: Re: RAID6 - CPU At 100% Usage After Reassembly
Date: Tue, 13 Sep 2016 10:43:52 -0700
Message-ID: <20160913174352.GA43576@kernel.org>
References: <CAOW94ut0uHS8+k0jutOT9bfT__WLbbOJmQC2CFa15HVVe9L4fg@mail.gmail.com>
 <CADEsfxrKeSv5dRNfBoyybHaemPSqCcamTmSZ4P+Yey-rLd8hEg@mail.gmail.com>
 <CAOW94uv4zSGs+6be3zhcQaGZdiAgg-s4ZHZ=mszcURo6pqJyqA@mail.gmail.com>
 <CAOW94ute6CZafnAC6AVauqUGsEgVrnO3B27Gn3eVzdWFBJPCQw@mail.gmail.com>
 <CAOW94utnY1zCR7gUCx1K0p2YfDhi3tXTsE6J_mT6rNz1TuTZEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOW94utnY1zCR7gUCx1K0p2YfDhi3tXTsE6J_mT6rNz1TuTZEQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Parada <advanceandconquer@gmail.com>
Cc: "Michael J. Shaver" <jmshaver@gmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Sep 13, 2016 at 11:22:17AM -0400, Francisco Parada wrote:
> Hi all,
> 
> I've tried the suggestions mentioned and also tried booting into an
> older version of Ubuntu (14.04.5 instead of my current 16.04.1), which
> has an older kernel per a private suggestion, but that too was
> unsuccessful.  Just wanted to give a quick update that all of the
> mentioned workarounds were unfruitful.

If you could rebuild kernel and apply this debug patch, I'd like to check what
happens. When the cpu is in 100% usage and reshape stalls, please capture the
/sys/kernel/debug/tracing/trace output and send to me.

Thanks,
Shaohua

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5883ef0..db484ca 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -62,6 +62,9 @@
 #include "raid0.h"
 #include "bitmap.h"
 
+#undef pr_debug
+#define pr_debug trace_printk
+
 #define cpu_to_group(cpu) cpu_to_node(cpu)
 #define ANY_GROUP NUMA_NO_NODE
 
