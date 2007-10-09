From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: very degraded RAID5, or increasing capacity by adding discs
Date: Tue, 9 Oct 2007 16:44:36 +0200
Message-ID: <20071009164436.50dbd7ae@absurd>
References: <20071008211313.6cd8bbb5@absurd>
	<470A846B.9090805@sauce.co.nz>
	<20071009002550.12b9b26d@absurd>
	<20071009004636.112c886e@absurd>
	<18186.63033.185101.385806@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18186.63033.185101.385806@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown said:     (by the date of Tue, 9 Oct 2007 13:32:09 +1000)

> On Tuesday October 9, janek_listy@wp.pl wrote:
> > 
> > Problems at step 4.: 'man mdadm' doesn't tell if it's possible to
> > grow an array to a degraded array (non existant disc). Is it possible?
> 
> Why not experiment with loop devices on files and find out?
> 
> But yes:  you can grow to a degraded array providing you specify a
> --backup-file.

Thanks! I'll test this on loopback devices :)


-- 
Janek Kozicki                                                         |
