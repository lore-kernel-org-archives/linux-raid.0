From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: telling mdadm to use spare drive.
Date: Fri, 9 Nov 2007 10:50:49 +0100
Message-ID: <20071109105049.6e5d9e6a@absurd>
References: <20071104170502.6db7fcb1@absurd>
	<87bqa6jtxc.fsf@informatik.uni-tuebingen.de>
	<20071107182602.61162e00@absurd>
	<47320E4F.3070308@sauce.co.nz>
	<20071108212804.771c39ac@absurd>
	<47338058.4080908@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47338058.4080908@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Richard Scobie said:     (by the date of Fri, 09 Nov 2007 10:32:08 +1300)

> This was the bug I was thinking of:
> 
> http://marc.info/?l=linux-raid&m=116003247912732&w=2

This bug says that it only with mdadm 1.x:

   "If a drive is added to a raid1 using older tools
    (mdadm-1.x or raidtools) then it will be included
    in the array without any resync happening."

But I have here:

# mdadm --version
mdadm - v2.5.6 - 9 November 2006

maybe I stumbled on another bug?

-- 
Janek Kozicki                                                         |
