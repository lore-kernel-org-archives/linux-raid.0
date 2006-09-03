From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: Feature Request/Suggestion - "Drive Linking"
Date: Sun, 3 Sep 2006 17:59:51 +0300
Message-ID: <5b170a7d0609030759u2b145237m85757ec649f86488@mail.gmail.com>
References: <1156868468.5611.102.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1156868468.5611.102.camel@localhost>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Bortnak <linux-raid@moro.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> This way I could get the replacement in and do the resync without
> actually having to degrade the array first.

<snip>

> 2) This sort of brings up a subject I'm getting increasingly paranoid
> about. It seems to me that if disk 1 develops a unrecoverable error at
> block 500 and disk 4 develops one at 55,000 I'm going to get a double
> disk failure as soon as one of the bad blocks is read

Here's an alternate description. On first 'unrecoverable' error, the
disk is marked as FAILING, which means that a spare is immediately
taken into use to replace the failing one. The disk is not kicked, and
readable blocks can still be used to rebuild other blocks (from other
FAILING disks).

The rebuild can be more like a ddrescue type operation, which is
probably a lot faster in the case of raid6, and the disk can be
automatically kicked after the sync is done. If there is no read
access to the FAILING disk, the rebuild will be faster just because
seeks are avoided in a busy system.

Personally I feel this is a good idea, count my vote in.

- Tuomas

-- 
VGER BF report: U 0.505245
