From: Drew <drew.kay@gmail.com>
Subject: Re: Tools for Hardware Raid?
Date: Mon, 28 Dec 2009 07:45:37 -0800
Message-ID: <c268e4660912280745v3e405203la9e6f602361e6132@mail.gmail.com>
References: <1262014433.25079.212.camel@vibe>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1262014433.25079.212.camel@vibe>
Sender: linux-raid-owner@vger.kernel.org
To: Rick Bragg <lists@gmnet.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I have a Dell 1900 with a perc5 raid controller
<snip>
> I'm wondering how I can monitor the disks, etc...

Most hardware RAID manufacturers have software you can download that
interfaces with the raid controller to monitor and/or make changes to
the underlying controller.

At work we use IBM servers which have a java based app called
ServeRAID that allows me to monitor the underlying RAID array, as well
as create new arrays while the system is live, which I have set to
notify me if something goes wrong.

That said, I don't know about Dell but our IBM's also have an orange
indicator light on the drive bays so if a drive is kicked I can see it
first thing when I get into the office to swap tapes. That's usually
the first warning I get that something is amiss.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
