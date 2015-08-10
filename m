From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Re-add not selecting drive for correct slot?
Date: Mon, 10 Aug 2015 19:10:55 +0100
Message-ID: <55C8E92F.5020700@youngman.org.uk>
References: <1817382.9YhZ7ff5Yl@balsa> <1526790.RuPxcltSBQ@nell> <alpine.DEB.2.02.1508101132070.11810@uplift.swm.pp.se> <2248170.b8F2naoiGF@balsa>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2248170.b8F2naoiGF@balsa>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/08/15 18:44, Thomas Fjellstrom wrote:
> On Mon 10 Aug 2015 11:35:13 AM Mikael Abrahamsson wrote:
>> On Sat, 8 Aug 2015, Thomas Fjellstrom wrote:
>>> I did try that :( It fails to assemble because it only sees sdc as a
>>> spare.
>>> Maybe because I did things with the old mdadm first, and did a --remove?
>>> That seems to have wiped out the "slot" information (it's -1) so the
>>> assemble force magic can't figure things out? Just a guess on my part.
>>
>> Unless someone else has a better idea, I'd say you're right. If you would
>> have unplugged the failed drive (so it disappeared completely), it could
>> probably have been re-added. So unless you have a copy of the old
>> superblock, your only way to proceed now is to use --create --assume-clean
>> and get all the parameters right (order, offsets etc). There are lots of
>> examples in the mailing list archives of people trying this and some
>> actually suceeding.
> 
> I think the only thing that would stop that from working is that there is data 
> in the bitmap. So if a assume clean is done, it might ignore that and cause 
> some extra corruption?

Which is why you use loopback devices. You'll need to look back at
previous posts to see how to do it, but you put a pseudo-layer over the
real disks (which never actually get written to), and you can then fsck
your array. If that comes up clean, you know you got the assemble
parameters right, and you can shut down the pseudo-array and assemble
the real array.
> 
> It'd be interesting to figure out if i can set that slot number manually or 
> with a tool. That might be a smarter/safer way of doing it.
> 
Better the pseudo way (which will definitely allow you to recover IF the
disk isn't corrupted) than trying your own stuff which might write to
the disk and make life harder/impossible to recover.

Cheers,
Wol
