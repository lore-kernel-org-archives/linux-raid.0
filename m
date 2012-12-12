From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: Find the mirror and sriping disks
Date: Wed, 12 Dec 2012 08:47:48 -0600
Message-ID: <6963DD27-7D1F-42FE-B444-58D5B40974D3@redhat.com>
References: <1354863631.73810.YahooMailNeo@web190604.mail.sg3.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1354863631.73810.YahooMailNeo@web190604.mail.sg3.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kks Kbase <kks.kbase@yahoo.in>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10

I also verified the layout of the various algorithms by writing a sequence of characters (A, B, C...) in stripe-width/chunk sizes.  Then I used 'hexdump -c' to look at each disk.  Works well.

 brassow

On Dec 7, 2012, at 1:00 AM, Kks Kbase wrote:

> Hi Folks,
> 
> I have setup S/w raid level 10 with 6 disks. May I know how to find the mirrored and striped disks on my raid 10?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

