From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is this expected RAID10 performance?
Date: Fri, 07 Jun 2013 15:51:38 -0500
Message-ID: <51B247DA.5030705@hardwarefreak.com>
References: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com> <CAAMCDefb7TFXDOD7=aK-FjHVCQXMdiQKdz=CFJT4+q9rKR3KGA@mail.gmail.com> <CAGqvA+svdBvWTbwnzQjoHWQz6n0iEaAZzmu-EqKqdPx-AK0Zkg@mail.gmail.com> <CAO9HMNE3F-ZN0fQmHW7yz2JLRFaUqSYSaVpZe3KaXuaLMojV8w@mail.gmail.com> <51B1D48C.7050006@hardwarefreak.com> <CAO9HMNHdyTg-LrZB0Mtyp16Zhstw_QETS5C3mtDsfgveWwe1_g@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNHdyTg-LrZB0Mtyp16Zhstw_QETS5C3mtDsfgveWwe1_g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Given your stated needs this SATA limitation isn't an issue, but I
thought I'd pass some information along so you might understand your
Intel platform a little better,  as well as some issues with various
Linux tools.

On 6/7/2013 7:59 AM, Steve Bergman wrote:
> 66MHz/32bit matches the lshw output I posted. 

You cannot trust the bus information provided by lshw or lspci -v.  Why
it is not correct I can't say as I've not looked at the code.  This is a
known issue.  But I can tell you  a couple of things here you may want
to know.

1.  The PCI bus interface provided by the 5 Series PCH is 33MHz, not
    66MHz.  See 5.1.1 on page 123 of the 5/3400 Series chipset
    datasheet:

http://www.intel.com/content/dam/doc/datasheet/5-chipset-3400-chipset-datasheet.pdf

> And the machine does
> have 1 PCI-X slot. So I imagine they're using the same interface for
> the onboard SATA controllers. Whatever it has, each of 2 pairs of SATA
> ports seems to be on one of them.

2.  The SATA controllers do not attach to the PCI or PCIe interfaces.
    They attach to the internal bus of the Intel PCH, and communicate
    to the CPU directly via DMI at 2.5GB/s duplex.  See the diagram
    on page 60 of the PDF linked above.  Also worth noting is that there
    are two SATA controllers each with 3 SATA channels, 6 total.  Some
    motherboards may not have connectors for all 6 channels.

3.  The apparent bottleneck you're seeing is not due to the bandwidth
    available on the back side of the SATA controllers.  It could be a
    limitation within the SATA controllers themselves, or it could be
    that you're using legacy IDE mode instead of AHCI, maybe both.

As you said, performance isn't as critical as reliability.  So it's not
worth your time to address this any further.  I'm simply supplying you
with some limited information to correct a few misconceptions you have
about the PCH capabilities.

> No offense intended, 

None taken.

> but reliability is more important than
> performance in this scenario. And although the machine is on a good
> UPS with apcupsd installed, it's not sitting in a data center, but in
> an office area. And I've found XFS to have pretty bad behavior on
> unlcean shutdowns. 

No doubt you have.  Note the last bug involving unclean shutdowns was
fixed some 3-4 years ago.  You may want to take another look at XFS.

> I'm used to the rock-solid reliability of ext3 in
> ordered mode, 

Heheh.  I'm guessing you don't read the Linux rags or LWN.  This has
been covered extensively.  The EXT3 rock solid reliability was actually
the result of a hack designed to fix another problem.  The inadvertent
side effect was that all data was flushed out to disk every few seconds,
5 IIRC.  This made EXT3 very reliable, at the cost of performance.  The
bug was fixed and the hack removed in EXT4.  Then users and application
developers started complaining about the lack of reliability of EXT4.
EXT3 was "so reliable" that app devs stopped using fsync thinking it was
no longer needed, that EXT3 had magically solved the data on disk issue.

Google "o_ponies" for far more information.  Or simple read this:
http://sandeen.net/wordpress/uncategorized/coming-clean-on-o_ponies/

> so even ext4 seems a bit reckless to me. I did compare

That's because you became acclimated to a broken filesystem, where, very
unusually, what was broken actually provided a beneficial side effect.

> XFS when it was configured to RAID1, and it was slightly better. Most
> of what this machine will be doing is single-threaded. But XFS is not
> an option for testing on an LV right now since the whole VG is sitting
> on an RAID10 at the default 512k chunk size, and XFS doesn't support
> larger than 256k chunks while maintaining optimal su and sw. I may

Sure it does.  You simply end up with less than optimal log journal
performance due to hotspots.  If your workload is not metadata heavy
it's not an issue.  If your workload involves mostly allocation and
files are stripe width size or larger, then you reap the benefit of
alignment.  If not, you don't.  And, if allocations are small, or the
workload is not allocation, you will likely decrease performance due to
FS alignment.

Worth noting, for the umpteenth time, is that the current md 512KB
default chunk size is insanely high, not suitable for most workloads,
and you should never use it.  See the archives of this list, the XFS
archives, Google, etc, to understand the relationship between
chunk/strip size, spindle count, workload allocation write patterns, and
IO hot spots.

But as you are stuck with EXT4, this is academic.  But, hopefully this
information may have future value to you, and others.

-- 
Stan

