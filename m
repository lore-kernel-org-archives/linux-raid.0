From: "Brian C. Lane" <bcl@redhat.com>
Subject: Re: [parted-devel] [PATCH 1/2] Add nonfs partition type 0xda
 (#1263835)
Date: Fri, 9 Oct 2015 11:35:26 -0700
Message-ID: <20151009183526.GT2984@lister.brianlane.com>
References: <1443654419-3714-1-git-send-email-bcl@redhat.com>
 <560EB887.6060302@ubuntu.com>
 <20151008214916.GK2984@lister.brianlane.com>
 <5617D701.1010109@ubuntu.com>
 <20151009162111.GR2984@lister.brianlane.com>
 <5617F80C.5050407@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5617F80C.5050407@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Susi <psusi@ubuntu.com>
Cc: parted-devel@lists.alioth.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 09, 2015 at 01:23:24PM -0400, Phil Susi wrote:
> On 10/9/2015 12:21 PM, Brian C. Lane wrote:
> > I think their thinking is that 0x80 implies a filesystem.
> > 
> > I really don't see any harm in adding it, if you don't want to use it,
> > don't.
> 
> I don't like adding things that serve no purpose and only confuse users.
>  People end up running around with their hair on fire asking which type
> they should use, and if it just doesn't bloody matter, why confuse them
> and make the manual longer by giving them the choice?  Keep it simple.
> 
> To put it another way, seeing the option there makes people think they
> need to use it for some reason, after all, why else would it be there?
> And if that isn't true, then you have just created FUD.
> 

It does have purpose, as described in the bug. And most users won't pay
any attention to it. The vast majority of them care about 'boot' and
that's it.

-- 
Brian C. Lane | Anaconda Team | IRC: bcl #anaconda | Port Orchard, WA (PST8PDT)
