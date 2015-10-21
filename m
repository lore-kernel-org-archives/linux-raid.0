From: Phil Turmel <philip@turmel.org>
Subject: Re: How to recover after md crash during reshape?
Date: Wed, 21 Oct 2015 08:18:12 -0400
Message-ID: <56278284.5020306@turmel.org>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
 <874mhl2ed3.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <874mhl2ed3.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <nfbrown@novell.com>, andras@tantosonline.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Neil,

On 10/20/2015 09:35 PM, Neil Brown wrote:

> Nothing dumb about that - you don't need a --backup option.
> If you did, mdadm would have complained.
> 
> You only need --backup when the size of the array is unchanged or
> decreasing.

> mdadm reads the first few stripes and stores them somewhere in each of
> the spares.  md (in the kernel) then reads those stripes again and
> writes them out in the new configuration.  It appears that one of the
> writes failed, others might have succeeded.  This may not have corrupted
> anything (the first few blocks are in the same position for both the old
> and new layout) but it might have done.

> If you do want to look for the backup, it is around about the middle of
> the device and has some metadata which contains the string
> "md_backup_data-1".  If you find that, you are close to getting the
> backup data back.

Hmmm.  This feature has advanced beyond my last look at the code.  I was
under the impression the backup option was only optional when mdadm
could move the data offset.  Does this new algorithm apply to v0.90
metadata, a v3.2 kernel, and v3.2.5 mdadm?

Phil

