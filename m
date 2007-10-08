From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: very degraded RAID5, or increasing capacity by adding discs
Date: Tue, 9 Oct 2007 00:25:50 +0200
Message-ID: <20071009002550.12b9b26d@absurd>
References: <20071008211313.6cd8bbb5@absurd>
	<470A846B.9090805@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <470A846B.9090805@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard Scobie said:     (by the date of Tue, 09 Oct 2007 08:26:35 +1300)

> No, but you can make a degraded 3 drive array, containing 2 drives and 
> then add the next drive to complete it.
> 
> The array can then be grown (man mdadm, GROW section), to add the fourth.

Oh, good. Thanks, I must've been blind that I missed this.
This completely solves my problem.

-- 
Janek Kozicki                                                         |
