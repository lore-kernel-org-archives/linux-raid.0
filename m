From: berk walker <berk.walker@verizon.net>
Subject: Re: raid 1 fails twice
Date: Tue, 14 Dec 2004 02:01:06 -0500
Message-ID: <41BE8FB2.60602@verizon.net>
References: <Pine.LNX.4.33.0412132220580.25904-100000@pandora.is.bizsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.33.0412132220580.25904-100000@pandora.is.bizsystems.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Robinton <michael@insulin-pumpers.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Robinton wrote:

>I have a 2.4 linux raid 1 on an ASUS mother board. One of the drives
>failed yesterday and a couple of hours ago I replaced it with a spare I had
>on the shelf. Now, when the re-sync should be complete I find the new
>drive also failed and making noise that indicates the controller thrashing
>the drive arm around (clink, clink, clink). The controllers are integrated
>into the mbrd so I would not expect them to fail without other problems
>manifesting themselves. Anyone care to take a guess at what's going on,
>I'm stumped? In all other respects the system seems to perform normally.
>It is a production web server on-line 24x7
>
>2 20gig WD205AA
>SIS 5518 chipset
>
>Michael
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>
I would suggest swap in a new cable, if still bad try M/B. I have had 
Azus M/Bs with bad IDE controllers.
b-
