From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: future of raid 6
Date: Sun, 3 Sep 2017 22:03:14 +0100
Message-ID: <59AC6E12.7050902@youngman.org.uk>
References: <2811558.CnJCJrJZ21@markus>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2811558.CnJCJrJZ21@markus>
Sender: linux-raid-owner@vger.kernel.org
To: Markus <M4rkusXXL@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/09/17 19:28, Markus wrote:
> Hello!
> 
> I have one question (maybe more) regarding the raid development. Especially 
> raid 6 and better.
> I read in some articles[1] that raid 6 will become worse as the size of the 
> disks grow but the (unrecoverable) error rate and data rate do not improve as 
> much. (Rebuilds are likely to hit an unrecoverable error, not to mention the 
> long time it will take to rebuild raids with +10TB per drive.)
> They estimated 2019 (that was written ten years ago).
> 
> Is there already something in progress for the md-raid in linux kernel?
> 	If so what and where?
> 	If not, why? Is it not needed yet? Is md-raid itself depreciated?
> 	What is the future for redundant mass storage?
> 
Hard errors aren't that common (at least until a drive fails :-)

A hard error is a sector that cannot be read. A soft error is one that
works fine after a reset (however you define said reset). A consumer
10TB disk can return one soft error per complete pass and still be
passed "it's good, it's within spec".

(And I think a lot of hard errors are down to not looking after the
data. Just as DRAM decays over nano-seconds, so do hard drives decay
over time, exacerbated by nearby writes. A hard error could simply be
data that's been degaussed by nearby writes. Fail to deal with that with
eg scrubs, and a perfectly functional drive can trash your data :-(

IFF someone thinks it's worth it, we may add raid-6+ functionality (ie
more than two parity drives), but I suspect enterprise drives will
simply become more reliable as they get bigger (manufacturers will move
more and more error correction technology into the firmware).

Bear in mind enterprise drives are roughly four binary orders of
magnitude more reliable, so a 160TB should just about read completely
without error.

As for "is md-raid deprecated", well a lot of the filesystem guys would
like to do so, and I sort of agree with them - the more layers of
abstraction, the worse things are. But the opposite also holds true -
put raid into the filesystem itself and the complexity there can explode
- just witness the trouble higher raid has caused the btrfs folks.

In *MY* humble (very) opinion, unrecoverable errors are far less common
than people think, technology is improving, and "2019" is a lot further
off than two years. That said, we will probably need something more than
plain raid-6 once we start using having disks in the 50-80TB range.
Unless, of course, technology inside the drive improves which it
probably will.

Cheers,
Wol

