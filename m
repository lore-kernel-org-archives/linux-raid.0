From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [Fwd: "Enhanced" MD code avaible for review]
Date: Wed, 17 Mar 2004 14:28:59 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4058A6FB.6080602@pobox.com>
References: <405899E8.8070806@pobox.com> <20040317183756.GA23667@lst.de> <2241002704.1079549645@aslan.btc.adaptec.com> <20040317190117.GA23968@lst.de> <2260532704.1079550351@aslan.btc.adaptec.com> <20040317190916.GA24118@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040317190916.GA24118@lst.de>
To: Christoph Hellwig <hch@lst.de>
Cc: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>, linux-raid@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids


(added linux-kernel to CC, where IMO the discussion on wider issues belongs)

Christoph Hellwig wrote:
> On Wed, Mar 17, 2004 at 12:05:51PM -0700, Justin T. Gibbs wrote:
>>I'm aware of Neil's past comments on the subject, but I was not aware
>>of a more full discussion on what this means in terms of lost functionality
>>for Linux.  I would like to have that discussion.  I'm more than willing
>>to adjust our strategy once that discussion takes place and a consensus
>>is reached.
> 
> 
> We're not far enough to actually removing functionlly yet.  For that
> early userspace needs to get a little more mature and more widely used.
> 
> We're not going to add more functionaly like that. though.

If early userspace isn't ready, it sounds like a choice between 
"nothing" and "it works".

We want a clean, tasteful solution, sure.  But I think we can work 
within the confines of the existing 2.6 API, and not postpone this stuff 
under early userspace is ready.

<rant>
Overall... the storage industry finally got off their ass and created a 
vendor-neutral RAID format, and they're actually using it.  Linux users 
don't deserve to be left out in the cold until 2.7.x klibc stuff is in, 
since they will be buying such RAID hardware right now.

I got into the Linux kernel game years ago in a large part because of 
precisely this -- getting Linux users going on hardware that would 
otherwise be Windows-only, without my help.  (or would otherwise be a 
grotty and buggy vendor driver, without my help:))
</rant>

	Jeff



