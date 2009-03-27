From: Neil Brown <neilb@suse.de>
Subject: Re: Re-size RAID-10
Date: Fri, 27 Mar 2009 15:44:58 +1100
Message-ID: <18892.22986.266806.170097@notabene.brown>
References: <49CAA763.3050405@amfes.com>
	<18890.44223.469.924083@notabene.brown>
	<5d96567b0903260040u7269749y284b66c1f495c48@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz on Thursday March 26
Sender: linux-raid-owner@vger.kernel.org
To: Raz <raziebe@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 26, raziebe@gmail.com wrote:
> Neil Hello
> I will be grateful for your reply. Currently I am working on raid0
> code reshape.
>  1. Will you be working on this functionality in the near future ?

I have no plans for raid0 reshape or raid10 reshape.

>  2. Should I save the superblocks like mdadm does in the case of 1,4,5,6 ?

When the layout changes, you certainly have to update the superblock,
yes.


>  3. What is the heuristics of strip_zones ? why do we need them ?

To make maximum use of available space.

> 
> . non-power 2 raid0 chunk sizes.
>  4. Other than segments masks issues, why isn't possible ? can't i fix raid0
>   to support 3MB chunks with a segment of 1MB ?

There is no intrinsic reason why chunk sizes should be powers of two.
When I started working on the code that limit already existed and I
have never had any reason to remove it.

If you would like to create patches which provide support for
non-power-of-two chunk sizes, I will be happy to review them.

NeilBrown
