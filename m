From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: raid1 on HDD + RAM ?
Date: Tue, 30 Sep 2008 21:21:07 +0200
Message-ID: <20080930212107.3175f888@szpak>
References: <20080930174926.5fdad7f1@szpak>
	<48E25D65.2010208@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48E25D65.2010208@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David Greaves said:     (by the date of Tue, 30 Sep 2008 18:09:57 +0100)

> > They would automatically sync on boot-up of the computer.
> You'd need to create and --add the ramdisk...

ok, I'll figure this out :)



> > I'm asking because an ultra-fast READ and normal WRITE would be
> > useful for me...
> 
> Also look at the --write-mostly and --write-behind options in mdadm.

thanks, this is great news for me. For real use I will need to
repartition my hard drive - to create another partition for that.

But just for testing - will it work if mdadm will use LVM partition,
which is already on top of mdadm raid ?

Or maybe just use some huge file as a loopback device? 

Which testing method is better?


-- 
Janek Kozicki                                                         |
