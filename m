From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: Deleting mdadm RAID arrays
Date: Tue, 5 Feb 2008 13:27:17 +0100
Message-ID: <20080205132717.238c4312@szpak>
References: <200802051142.19625.admin@domeny.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200802051142.19625.admin@domeny.pl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Marcin Krol said:     (by the date of Tue, 5 Feb 2008 11:42:19 +0100)

> 2. How can I delete that damn array so it doesn't hang my server up in a loop?

dd if=/dev/zero of=/dev/sdb1 bs=1M count=10

I'm not using mdadm.conf at all. Everything is stored in the
superblock of the device. So if you don't erase it - info about raid
array will be still automatically found.

-- 
Janek Kozicki                                                         |
