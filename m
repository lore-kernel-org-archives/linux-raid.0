From: David Greaves <david@dgreaves.com>
Subject: Re: raid1 on HDD + RAM ?
Date: Tue, 30 Sep 2008 18:09:57 +0100
Message-ID: <48E25D65.2010208@dgreaves.com>
References: <20080930174926.5fdad7f1@szpak>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080930174926.5fdad7f1@szpak>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Janek Kozicki wrote:
> Hi,
> 
> It's possible to have a ramdisk device.
yes

> Would it make any sense in
> doing raid1 using a common HDD and a ramdisk?
It sounds interesting if you have a need...

md just uses block devices so there shouldn't be a problem.


> They would automatically sync on boot-up of the computer.
You'd need to create and --add the ramdisk...

> I'm asking because an ultra-fast READ and normal WRITE would be
> useful for me...

Also look at the --write-mostly and --write-behind options in mdadm.

David

-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
