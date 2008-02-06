From: David Greaves <david@dgreaves.com>
Subject: Re: Deleting mdadm RAID arrays
Date: Wed, 06 Feb 2008 11:22:00 +0000
Message-ID: <47A99858.70103@dgreaves.com>
References: <200802051142.19625.admin@domeny.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200802051142.19625.admin@domeny.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Marcin Krol <admin@domeny.pl>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Marcin Krol wrote:
> Hello everyone,
> 
> I have had a problem with RAID array (udev messed up disk names, I've had RAID on
> disks only, without raid partitions)

Do you mean that you originally used /dev/sdb for the RAID array? And now you
are using /dev/sdb1?

Given the system seems confused I wonder if this may be relevant?

David

