From: Daniel Brahneborg <basic@wtnord.net>
Subject: Re: Software RAID-5 safe under 2.6 kernel?
Date: Sat, 3 Jan 2004 16:11:56 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040103161156.C20392@nettis.grimsta>
References: <16c.28512ce2.2d28301d@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16c.28512ce2.2d28301d@aol.com>; from AndyLiebman@aol.com on Sat, Jan 03, 2004 at 09:47:57AM -0500
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 03, 2004 at 09:47:57AM -0500, AndyLiebman@aol.com wrote:
> Is there any "definitive word" about whether it's safe to use software RAID-5 
> under the released version of the 2.6 kernel? I have heard about various 
> problems on this list. Are they now resolved? Are there specific configurations to 
> watch out for? If anybody has this information, it might be nice to post it. 

A definite word for the 2.4 kernel, especially when using SATA,
would also be welcome.

From my own experiences, the SATA chipsets from Silicon Image
and VIA has problems with both RAID1 and RAID5, even though
normal file systems work fine.

/Basic

