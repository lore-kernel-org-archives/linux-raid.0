From: David Greaves <david@dgreaves.com>
Subject: Re: raid1 on HDD + RAM ?
Date: Tue, 30 Sep 2008 21:43:51 +0100
Message-ID: <48E28F87.4010701@dgreaves.com>
References: <20080930174926.5fdad7f1@szpak>	<48E25D65.2010208@dgreaves.com> <20080930212107.3175f888@szpak>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080930212107.3175f888@szpak>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Janek Kozicki wrote:
> David Greaves said:     (by the date of Tue, 30 Sep 2008 18:09:57 +0100)
> 
>>> They would automatically sync on boot-up of the computer.
>> You'd need to create and --add the ramdisk...
> 
> ok, I'll figure this out :)
> 
> 
> 
>>> I'm asking because an ultra-fast READ and normal WRITE would be
>>> useful for me...
>> Also look at the --write-mostly and --write-behind options in mdadm.
> 
> thanks, this is great news for me. For real use I will need to
> repartition my hard drive - to create another partition for that.
> 
> But just for testing - will it work if mdadm will use LVM partition,
> which is already on top of mdadm raid ?
yes, absolutely.

md works with *any* block device.

> Or maybe just use some huge file as a loopback device? 
> 
> Which testing method is better?
Since you are intending not to use the device then they should be the same.
I'd use an lvm partition though.

David



-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
