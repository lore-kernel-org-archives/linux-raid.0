From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Multi-layer raid status
Date: Fri, 2 Feb 2018 14:24:49 +0000
Message-ID: <5A7474B1.1020807@youngman.org.uk>
References: <5A708F8E.2040604@hesbynett.no>
 <87372k2aix.fsf@notabene.neil.brown.name> <5A744054.4060305@hesbynett.no>
 <5A7448AF.3050108@youngman.org.uk> <5A744C4B.7030704@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A744C4B.7030704@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/02/18 11:32, David Brown wrote:
> You already do that during a scrub.  You don't want to do it during
> normal operations - unless you have a usage pattern with mostly big
> reads, you will cripple performance.  A small performance drop is
> acceptable if it can be shown to significantly improve reliability - but
> making every read a full stripe read will give you random read
> performance closer to that of a single disk than a raid array.

Unless integrity is more important than speed?

Unless (like in your own example) you know there's a problem and you
want to find it?

Yup I know it will knacker performance - I said so. But there are plenty
of use cases where it would actually be very useful, and probably the
lesser of two evils.

(Actually, re-reading your original email, it actually sounds like the
right thing to do would be to call hdparm to mark the sector bad on sda,
rather than use badblocks, so it will rewrite and clear itself. And this
is also a perfect example of where my technique would be useful - it's
probably not the raid-5 parity block that gets corrupted, therefore the
data itself has been corrupted, therefore my utility would find the
damaged file for you so you could recover from backup. A scrub at the
raid-5 level would just "fix" the parity and leave you with a corrupted
file waiting to blow up on you.)

Cheers,
Wol
