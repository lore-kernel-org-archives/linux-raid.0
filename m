From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Thu, 31 Jan 2013 15:48:42 -0700
Message-ID: <BC51013D-AF5E-4934-9BE4-435EBAD69B30@colorremedies.com>
References: <510A4AAE.6000009@evilazrael.de> <20130131113820.GA20536@cthulhu.home.robinhill.me.uk> <510A6E54.5050001@evilazrael.de> <CAF3D534-D907-4A88-AFAF-EA9B97C1D8BF@colorremedies.com> <20130131221007.GA1447@cthulhu.home.robinhill.me.uk> <88758108-9333-4224-9006-8E44E717AB29@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <88758108-9333-4224-9006-8E44E717AB29@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: Christoph Nelles <evilazrael@evilazrael.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 31, 2013, at 3:40 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> So the disk to possibly dd to another is the one with the write error, sdg1. But only if the idea is to not use --assume-clean. That way a reassemble can rebuild, and not encounter another write error on that drive.

I meant resync.

But isn't a resync a state where md assumes parity is dirty and must be recreated? If so, what happens when sdj1 encounters UREs? If there's untrusted parity, does md just use what it has, or does it stop the array?



Chris Murphy

