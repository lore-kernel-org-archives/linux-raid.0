From: David Greaves <david@dgreaves.com>
Subject: Re: bonnie++ on md device causes reboot on new motherboard
Date: Tue, 03 Feb 2009 08:53:47 +0000
Message-ID: <4988061B.2020904@dgreaves.com>
References: <20090203041450.GA2107@sewage.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090203041450.GA2107@sewage.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matt Garman wrote:
> Anyone seen anything like this or have any ideas where I can start
> looking for more information?

netconsole?
http://www.mjmwired.net/kernel/Documentation/networking/netconsole.txt

At least then you may see what the error is.
And for a crash like this I'd contact your distro kernel team too (not sure
about lkml with 2.6.24 but probably)

David

-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
