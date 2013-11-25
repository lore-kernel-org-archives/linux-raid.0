From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Slow AVX XOR reported
Date: Mon, 25 Nov 2013 14:29:24 -0600
Message-ID: <5293B324.2050303@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The AVX XOR performance reported during boot seems wrong.

raid6: using algorithm sse2x4 (10035 MB/s)
xor: automatically using best checksumming function:
   avx       :  3468.000 MB/sec

I would expect the value to be well north of 10000MB/s. I do not get a
generic_sse performance number which I do on other non-AVX hosts.

The system is a dual AMD Opteron 6378 (16 core, 2.4GHz, piledriver). The
kernel is 3.11.8-200.fc19.x86_64.

I did read that AMD's AVX-256 implementation performs poorly compared to
AVX-128. Perhaps there are other AMD specific "optimizations" that need
to be considered.

Is there any standalone code I ran run to benchmark the various XOR
implementations?

--Larkin
