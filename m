From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Multi-layer raid status
Date: Fri, 2 Feb 2018 15:03:01 +0000
Message-ID: <5A747DA5.2030801@youngman.org.uk>
References: <5A708F8E.2040604@hesbynett.no>
 <87372k2aix.fsf@notabene.neil.brown.name> <5A744054.4060305@hesbynett.no>
 <5A7448AF.3050108@youngman.org.uk> <5A744C4B.7030704@hesbynett.no>
 <5A7474B1.1020807@youngman.org.uk> <5A747AC1.8030206@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A747AC1.8030206@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/02/18 14:50, David Brown wrote:
> What are these cases?  We have already eliminated the rebuild situation
> I described.  And in particular, which use-cases are you thinking of
> where you not be better off with alternative integrity improvements
> (like higher redundancy levels) without killing performance?
> 
In particular, when you KNOW you've got a damaged raid, and you want to
know which files are affected. The whole point of my technique is that
either it uses the raid to recover (if it can) or it propagates a read
error back to the application. It does NOT "fix" the data and leave a
corrupted file behind.

>> > 
> That does not make sense.  The bad block list described by Neil will do
> the job correctly.  hdparm bad block marking could also work, but it
> does so at a lower level and the sector is /not/ corrected
> automatically, AFAIK.  It also would not help if the raid1 were not
> directly on a hard disk (think disk partition, another raid, an LVM
> partition, an iSCSI disk, a remote block device, an encrypted block
> device, etc.).
> 
Nor does the bad block list correct the error automatically, if that's
true then. The bad blocks list fakes a read error, the hdparm causes a
real read error. When the raid-5 scrub hits, either version triggers a
rewrite.

Thing about the bad-block list, is that that disk block is NOT
rewritten. It's moved, and that disk space is LOST. With hdparm, that
block gets rewritten, and if the rewrite succeeds the space is recovered.

Cheers,
Wol

