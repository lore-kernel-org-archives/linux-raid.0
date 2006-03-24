From: Jim Klimov <klimov@2ka.mipt.ru>
Subject: Re[2]: Concept problem with RAID1?
Date: Fri, 24 Mar 2006 19:15:20 +0300
Message-ID: <392345161.20060324191520@2ka.mipt.ru>
Reply-To: Jim Klimov <klimov@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello PFC,

Friday, March 24, 2006, 7:07:04 PM, you wrote:

P>      I think you would like something like this :

P>      A LVM (or dm- device mapper) layer which sits between the RAID layer and
P> the physical disks. This layer computes checksums as data is written to
P> the physical disks, and checks read data against these checksums.

P>      Problem is, where do you store the checksums ?
Why not store the checksums on the same device that stores the
blocks? For example, let a 64-kb (65536b) block of data store,
say, 65520 bytes of data and 16 bytes of checksum/digest and a
timestamp. If the hardware goes crazy and some bits (or more)
are mixed up, we can detect if the data is not trustworthy -
the checksum and/or data is screwed and they don't match each
other. A drawback is the impossibility to mount such a device
as-is, and some loss of performance in addressing/buffering
which I think is okay as a tradeoff for reliability.

A good thing (arguably) would be a capability of raid1 layer
to interact with this checksummed layer during rebuilds or even
casual work. If a block is found to be bad on one submirror,
it could be read (and re-written) from another, valid, copy
without remaking the whole metadevice.

-- 
Best regards,
 Jim Klimov                            mailto:klimov@2ka.mipt.ru

