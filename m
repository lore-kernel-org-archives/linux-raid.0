From: Jake Thomas <thomasj10@georgefox.edu>
Subject: Re: Device Unusable At Startup
Date: Sun, 12 Aug 2012 16:59:25 -0700
Message-ID: <CACO8viqZO9bbdYtZMT3E0oMfWUjAzps1uNq7rBm419eXtt6bCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

sudo mdadm --create /dev/answers --level=1 --raid-devices=2
/dev/blog,/dev/linux-raid@vger.kernel.org

Thanks for the responses Neil!

   I did try the following kernel parameter:

md-mod.start_dirty_degraded=1

   Does my kernel simply not honor that parameter? I'll try and look
into my initial ramdisk and see some of these scripts you're talking
about.

Ok, I'll post more after I look at what you talked about.

Jake
