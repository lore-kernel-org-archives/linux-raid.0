From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Another new users' guide to installing Linux software RAID 10
Date: Tue, 19 Aug 2008 18:06:02 +0100
Message-ID: <48AAFD7A.2070606@anonymous.org.uk>
References: <923541.95602.qm@web88303.mail.re4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <923541.95602.qm@web88303.mail.re4.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/08/2008 15:25, Bruce Miller wrote:
> Another article has appeared on a mainstream Linux web site which aims to smooth the installation of Linux RAID 10 for beginners:
> http://howtoforge.com/install-ubuntu-with-software-raid-10
> 
> As someone who merely lurks on this list and almost never posts, I do not dare to assess the accuracy or soundness of this article. But Howtoforge has a certain popularity among users who are not full-time IT professionals.
> 
> It might be useful if one of the experts on this site looked at the article; if you find it worthwhile, perhaps a link could be added to wiki.linux-raid.osdl.org.

I don't claim to be an expert, but...

1. "Raid 10 is the fastest RAID level that also has good redundancy 
too". This isn't necessarily true.

2. The configuration suggested will crash if any disc crashes, because 
it has swap on raw disc partitions.

3. The configuration suggested cannot reboot if the first disc crashes 
because /boot is on a raw partition on the first disc only.

If I've got this all wrong, please let me know...

Cheers,

John.
