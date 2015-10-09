From: Phil Susi <psusi@ubuntu.com>
Subject: Re: [parted-devel] [PATCH 1/2] Add nonfs partition type 0xda
 (#1263835)
Date: Fri, 9 Oct 2015 13:23:24 -0400
Message-ID: <5617F80C.5050407@ubuntu.com>
References: <1443654419-3714-1-git-send-email-bcl@redhat.com>
 <560EB887.6060302@ubuntu.com> <20151008214916.GK2984@lister.brianlane.com>
 <5617D701.1010109@ubuntu.com> <20151009162111.GR2984@lister.brianlane.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151009162111.GR2984@lister.brianlane.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Brian C. Lane" <bcl@redhat.com>
Cc: parted-devel@lists.alioth.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/9/2015 12:21 PM, Brian C. Lane wrote:
> I think their thinking is that 0x80 implies a filesystem.
> 
> I really don't see any harm in adding it, if you don't want to use it,
> don't.

I don't like adding things that serve no purpose and only confuse users.
 People end up running around with their hair on fire asking which type
they should use, and if it just doesn't bloody matter, why confuse them
and make the manual longer by giving them the choice?  Keep it simple.

To put it another way, seeing the option there makes people think they
need to use it for some reason, after all, why else would it be there?
And if that isn't true, then you have just created FUD.

