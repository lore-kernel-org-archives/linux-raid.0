From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Sat, 23 Feb 2013 00:41:21 -0600
Message-ID: <51286491.3030808@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <51265C38.6000400@hesbynett.no>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51265C38.6000400@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/21/2013 11:41 AM, David Brown wrote:
...
> HT may not be of help in a pure file server setup, but in many other
> server applications such as web servers (and IMAP, as you mentioned), HT
> is a huge benefit.  

HT benefits workloads with more heavy active processes than cores, which
causes functional unit/pipeline contention.  If your workload has no
resource contention, then HT is of no benefit.  In these cases having it
enabled can actually decrease performance, yes, even with Intel's recent
implementation, and it can cause other issues as I described earlier,
such as simple system administration headaches.

> It is not coincidence that the big server cpu
> architectures (MIPS, Power, SPARC) all use 2 or even 4 time SMT.

Quoting Wikipedia again...but making incorrect assumptions about what it
says.  MIPS CPUs haven't been used in a "big server" for a decade, the
last machine being the Origin 3900, the CPU being the single core
R16000A, which had no SMT.  HPC workloads don't benefit from it.  The
short lived SiCortex machines were obviously "big" with up to 5832 cores
using 6-way SMP SOCs.  These cores did not have SMT either.  And yes,
the SiCortex section of the MIPS page is my edit, as well as some of the
SGI related edits.  (Hated to see SiCortex fold as their machines not
only offered performance and unique features, but had a cool aesthetic
missing in the supercomputer space since the glory days of Cray)

Imagination Technologies today offers two MIPS IP cores with SMT, of
over hundreds of cores/designs in their portfolio.  Both are used in
embedded applications only.  Both are 32 bit CPUs.  And both hit the
market within the past 2 years.  I.e. SMT is very new for MIPS chips.

WRT Power and SPARC these are targeted at consolidation workloads which
can benefit from SMT.  Note that on the Power CPUs destined for HPC
platforms SMT is typically disabled.

So again, whether HT/SMT is of benefit depends entirely on the workload.
 In Adam's iSCSI server case, it decidedly does not.

> I have no numbers of my own to back this up - but I would certainly not
> consider disabling HT on a server without very concrete reasoning.

I've demonstrated the reasoning, twice now.  People fear what they don't
understand.  You fear shutting off HT because you don't yet have a
complete understanding of how it actually works, and when it actually helps.

> (I too was a great fan of AMD, and used them almost exclusively until
> the Core 2 architecture from Intel.  And while I am glad that Intel have
> made very nice chips in recent years, I think it is a shame that they
> did so using ideas copied directly from AMD - and AMD can no longer
> seriously compete.)

Absolute performance was no longer an issue long before Intel introduced
the Core architecture.  The vast majority of cycles on all systems were
executing the idle instruction, still are.  And there were/are few
server applications deployed that performed significantly better with
Xeon than Opteron.  Thus I continued with AMD for a few reasons.  The IO
infrastructure was superior, and it wasn't until QuickPath that Intel
caught up here.  And AMD still offers a better price/performance ratio.

-- 
Stan



