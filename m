From: David Vuorio <vuorio@kth.se>
Subject: Re: Configure speed of checkarray in mdadm?
Date: Sun, 17 May 2009 11:22:11 +0200
Message-ID: <4A0FD743.6060308@kth.se>
References: <49FDB2E2.6000300@kth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49FDB2E2.6000300@kth.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Vuorio wrote:
> When my monthly RAID check is triggered (I have two SATA disks in a
> RAID1 setup) it consumes a significant amount of resources, essentially
> freezing the system for the most part.

Hmm,

I had missed some vital parts of the md man page for some reason, and
apparently wasn't persistent enough in Googling either...

Well, /proc/sys/dev/raid/speed_limit_{min,max} should be enough for my
purposes. Problem solved, I guess.

Kind regards,

/David
