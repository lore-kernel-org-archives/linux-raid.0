From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: upgrading a RAID array in-place with larger drives.  request
 for review of my approach?
Date: Mon, 01 Dec 2014 09:42:10 +0000
Message-ID: <547C37F2.1030400@youngman.org.uk>
References: <1417402553.1412807.197119853.0D7A911E@webmail.messagingengine.com> <20141201090814.GA3772@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141201090814.GA3772@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/12/14 09:08, Robin Hill wrote:
> If it is doable (see comment above), it'll be simpler to just
> partition the disks to the final size (or skip partitioning at all)
> - md will quite happily accept larger devices added to an array
> (though it doesn't use the extra space). Otherwise, your initial
> steps are correct - though if you have a spare bay (or even a
> USB/SATA adapter), you can add the drive as a spare and then use
> "mdadm --replace" (you may need a newer version of mdadm for this)
> command to flag one of the existing array members for replacement.
> This will do a direct copy of the data from the existing disk to
> the new one and is quicker (and safer) than fail/add.

I upgraded a (raid 1) system by just adding the new, larger, disk. I
think I swapped a 500Gb for a 1TB, so replaced my 400Gb partitions
with 900Gb partitions. I then grew the array, followed by growing the
partition. Worked fine.

Cheers,
Wol
