From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: Redundancy check using "echo check > sync_action": error
 reporting?
Date: Sun, 16 Mar 2008 16:14:51 +0100
Message-ID: <20080316161451.0d17fd22@szpak>
References: <47DD2CD7.2090802@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47DD2CD7.2090802@tuxes.nl>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bas van Schaik said:     (by the date of Sun, 16 Mar 2008 15:21:11 +0100)

> As we speak, I'm trying to debug a real weird type of filesystem
> corruption in a quite complex layered system with networking involved:

AFAIK, even for the simplest case where corruption happens between a
head and a disk platter during write operation - the RAID has no way
to detect that. Unless it discovers later that the checksum on
another disk is wrong, and it is automatically updated to reflect the
corrupted data. Does it produce a message during resync in such case?
Someone here should be able to answer this.

-- 
Janek Kozicki                                                         |
