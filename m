From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: raid reconstruction speed
Date: Thu, 19 Jan 2006 18:27:09 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0601191825370.20928-100000@coffee.psychology.mcmaster.ca>
References: <43D00E3A.5090102@h3c.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D00E3A.5090102@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> echo "10000" > /proc/sys/dev/raid/speed-limit-max (or similar?)
> 
> You can do that in /etc/rc.local or something to make sure it sticks,

echo "dev.raid.speed_limit_max = 10000" >> /etc/sysctl.conf
is another, perhaps nicer way to make the setting permanent.

