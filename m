From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/6] md: Remove the hash tables from raid0 V2 -- Introduction.
Date: Sat, 16 May 2009 21:53:54 +1000
Message-ID: <18958.43346.399343.631536@notabene.brown>
References: <1242393498-7528-1-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Friday May 15
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 15, maan@systemlinux.org wrote:
> As mentioned by Neil, the raid0 hash table does probably not add
> any value and contains some rather strange code that manipulates the
> various sector counts needed to maintain this table.
> 
> This patch series against Neil's for-next tree as of yesterday removes
> the hash table from the raid0 code.

Thanks.
All applied, and pushed out to
   git://neil.brown.name/md for-next

I've added a couple more patches to remove a couple of fields from 
struct strip_zone.  I'll post them shortly for comment.

And thanks for finding the memory leak!

NeilBrown
