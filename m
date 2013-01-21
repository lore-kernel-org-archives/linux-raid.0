From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Suboptimal raid6 linear read speed
Date: Mon, 21 Jan 2013 06:24:37 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301210558380.12098@uplift.swm.pp.se>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us> <50F70DB7.6020104@hardwarefreak.com> <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se>
 <50F90857.3010305@hardwarefreak.com> <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se> <50F9D32F.7090606@hardwarefreak.com> <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se> <20732.17741.587765.199649@tree.ty.sabi.co.uk>
 <alpine.DEB.2.00.1301202155310.12098@uplift.swm.pp.se> <20732.26290.571133.210024@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20732.26290.571133.210024@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 20 Jan 2013, Peter Grandi wrote:

> complete recovery; some/most drives IIRC can return the sector
> content that has been reconstructed, which often is wrong in
> only a few bits.

This is not my experience. When I get UREs on a 4k drive, I get read error 
on 8 consecutive 512 byte blocks. This is the first time I've ever heard 
about someone claiming drives will give back information that is just a 
little bit wrong. Perhaps there should be such a command to tell the drive 
to "give me what you've got", but most of the time, this is undesireable.

Going back to the BER discussion.

I'm a network engineer. We count BER as "flipped bits rate", which is 
detected using CRC (ethernet does this). "under" this one can do g.709 FEC 
(forward error correction), which can detect flipped bits and still return 
a correct result to the CRC checksummer because there is enough other 
information (~10 percent overhead) to reconstruct the original 
information, thus passing the CRC check.

Typical rated ethernet BER is 10^-12. This means in 10^-12 bits sent on 
the wire, if a bit is flipped and a whole packet is thus list, it's still 
within specifications. Normally when one does things right, the BER is way 
better than 10^-12, the norm is to have a 10GE link running for months 
without a single user-detectable bit error.

In the articles I have read about how harddrives work, they all state that 
hdd manufacturers do very similar things. They store bits on the media 
with extra information so the drive can do FEC, they have a checksum, if 
the checksum doesn't match then the block is re-read, and if after a while 
no correct checksum block can be served, an URE is reported and the OS 
reports the read as failed. The advantage with 4k block drives is that FEC 
is more effective on larger blocks because errors usually turn up in 
bursts (one gets several flipped bits in a row), so having larger blocks 
means more flipped bits in a row can get corrected. ADSL2+ works in a 
similar way when one turns on 16ms interleaving, it smears out the bits 
over a longer time, so a 0.1ms disturbance (complete, no bits are correct) 
can be corrected using FEC.

Also, I do agree with you that RAID6 puts mechanical stress on the drives 
but my main failure scenario (own experience) is still single drive 
failure and then scattered UREs when reading from the other drives, which 
can be corrected by RAID6 parity during the resync. RAID6 is economical 
when using it with 10-12 drives, and fits my storage needs (as long as I 
get ~30 megabyte/s or better large file read/write performance from the 
array, I'm fine). Other workloads, as you say, might have other 
requirements.

A lot of people I see coming in on the IRC channel use RAID5 for their 
storage needs and they come in with UREs when reconstructing a failed 
drive. I'd say taking the array offline and using dd_rescue is something 
we have to recommend several times a month. This is why I keep 
recommending RAID6 over RAID5.

More reading:

http://www.high-rely.com/hr_66/blog/why-raid-5-stops-working-in-2009-not/

www.zdnet.com/blog/storage/why-raid-5-stops-working-in-2009/162

I still don't understand how these two articles seem to come to wildly 
different conclusions and the first one still claims the last one is 
correct :P Well, the zdnet one matches my own experiences with mine and 
other people I talk to.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
