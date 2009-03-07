From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Future of md multipath
Date: Sat, 07 Mar 2009 21:08:54 +0100
Message-ID: <E1Lg2pL-0003s6-4e@be1.7eggert.dyndns.org>
References: <cbHe8-JR-9@gated-at.bofh.it> <ccbYG-sd-9@gated-at.bofh.it> <ccluS-7IV-3@gated-at.bofh.it>
Reply-To: 7eggert@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@debian.org>, Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

martin f krafft <madduck@debian.org> wrote:
> also sprach Neil Brown <neilb@suse.de> [2009.03.05.0349 +0100]:

>> I'm in favour of deprecating it.  Whenever I hear of people using it I
>> suggest dm-multipath, but there could people I don't here about.
>> I think the upcoming mdadm-3.0 will need a compile-time option to
>> enable multipath, so people will only get it if they really really
>> want it.
> 
> How do you propose a distro to deal with this? Keep it enabled for
> a certain time (with a deprecation warning?) and then just to close
> the doors on users who still need it?

What about reverting the patch for their kernels until they release the
next major version, then drop it?

For users who compile their kernels, add "Deprecated" to the description,
and rename the CONFIG_.

