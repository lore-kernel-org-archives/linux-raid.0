From: David Brown <david@westcontrol.com>
Subject: Re: [md PATCH 00/16] hot-replace support for RAID4/5/6
Date: Wed, 26 Oct 2011 08:38:00 +0200
Message-ID: <j88a5v$cnd$1@dough.gmane.org>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/10/2011 03:43, NeilBrown wrote:
> The following series - on top of my for-linus branch which should appear in
> 3.2-rc1 eventually - implements hot-replace for RAID4/5/6.  This is almost
> certainly the most requested feature over the last few years.

Fantastic news - well done, and thanks for all your work (and to the 
other md developers too, of course).

> I hope to submit this together with support for RAID10 (and maybe some
> minimal support for RAID1) for Linux-3.3. By the time it comes out
> mdadm-3.3 should exist will full support for hot-replace.
>

Hot-replace for RAID1 is surely just a normal "add", a resync, a "fail", 
and a "remove"?  So support here should be mainly about the consistency, 
such as supporting the same "replaceable" tag.  RAID10, I imagine, would 
be more complicated.

mvh.,

David

