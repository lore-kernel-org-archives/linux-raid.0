From: Nix <nix@esperi.org.uk>
Subject: Re: Care and feeding of RAID?
Date: Sat, 09 Sep 2006 16:58:56 +0100
Message-ID: <87r6ylkp4v.fsf@hades.wkstn.nix>
References: <44FD722C.7050608@waldoware.com> <44FDB66D.8060202@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FDB66D.8060202@waldoware.com> (Paul Waldo's message of "5 Sep 2006 18:40:10 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Paul Waldo <pwaldo@waldoware.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5 Sep 2006, Paul Waldo uttered the following:
> What about bitmaps?  Nobody has mentioned them.  It is my
> understanding that you just turn them on with "mdadm /dev/mdX -b
> internal".  Any caveats for this?

Notably, how many additional writes does it incur? I have some RAID
arrays using drives which are quiet *until* you access them, and which
then make a bloody racket. The superblock updates are bad enough, but
bitmap updates, well, I don't really like seeing one write turned into
twelve-odd disk hits that much (just a back-of-the-envelope guess for a
three-disk RAID-5 array).

-- 
`In typical emacs fashion, it is both absurdly ornate and
 still not really what one wanted.' --- jdev
