From: Neil Brown <neilb@suse.de>
Subject: Re: very degraded RAID5, or increasing capacity by adding discs
Date: Tue, 9 Oct 2007 13:32:09 +1000
Message-ID: <18186.63033.185101.385806@notabene.brown>
References: <20071008211313.6cd8bbb5@absurd>
	<470A846B.9090805@sauce.co.nz>
	<20071009002550.12b9b26d@absurd>
	<20071009004636.112c886e@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Janek Kozicki on Tuesday October 9
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 9, janek_listy@wp.pl wrote:
> 
> Problems at step 4.: 'man mdadm' doesn't tell if it's possible to
> grow an array to a degraded array (non existant disc). Is it possible?

Why not experiment with loop devices on files and find out?

But yes:  you can grow to a degraded array providing you specify a
--backup-file.

However I don't recommend it.  I would never recommend having a
degraded array by design.  It should only ever happen due to a
failure, and should last only until you can get a replacement
rebuilt. 

Remember that a degraded raid5 has a greater risk of data loss than a
single drive.

> 
> 
> PS: the fact, that degraded array will be unsafe for the data is an
> intented motivating factor for buying next drive ;)

:-)

NeilBrown
