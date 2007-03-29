From: Neil Brown <neilb@suse.de>
Subject: Re: md bitmaps on 2.6.16.y
Date: Thu, 29 Mar 2007 16:27:15 +1000
Message-ID: <17931.23619.480126.872286@notabene.brown>
References: <20070326172713.GE19673@coraid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ed L. Cashin on Monday March 26
Sender: linux-raid-owner@vger.kernel.org
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 26, ecashin@coraid.com wrote:
> I have been testing an md RAID 1 created using mdadm 2.6.1 on a
> 2.6.16.35 kernel, and the initial results are encouraging.  (The
> 2.6.16.y kernel is a long-term stable branch, unlike most stable
> kernels, which are maintained only until the next stable branch
> becomes active.)
> 
> I see bitmap-related patches with fixes for later kernels being
> discussed in the linux-raid mailing list, but I do not see
> bitmap-related patches in the ChangeLogs for the 2.6.16.y kernel.  My
> hope is that these fixes are only part of the natural churn in the
> newer kernel branches and are not needed for the 2.6.16.y kernels.
> 
> Are there any known issues that would make the use of md bitmaps in a
> 2.6.16.y kernel problematic?  I do see an important RAID 1 fix in
> 2.6.16.40, so I know that 2.6.16.35 isn't good enough.


While I try to remember to back-port any significant and relevant
bugfixes to 2.6.16, I do forget sometimes.. and 2.6.16 isn't really my
focus of development.

If you would like to generate a list of bitmap bugfixes in later
kernels, I could check and let you know how relevant they are for
2.6.16.

NeilBrown
