From: Kanoa Withington <kanoa@cfht.hawaii.edu>
Subject: RE: Scrub?
Date: Fri, 6 Aug 2004 09:44:27 -1000 (HST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.55.0408060941560.14130@umi.cfht.hawaii.edu>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01153143@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01153143@otce2k03.adaptec.com>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Derek Listmail Acct <listmail@oversimplified.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 6 Aug 2004, Salyzyn, Mark wrote:
> Just reading the entire array should correct the bad blocks, so reverse
> the sense of the dd:
>
> 	dd if=/dev/md0 of=/dev/null bs=200b
>
> to find and replace the bad blocks (making the assumption that md works
> like the H/W RAID cards).

In this case software RAID does not work like the H/W cards. Finding
an unreadable block that way in a software array would cause it to go
into a degraded state.

-Kanoa
