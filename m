From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Another new users' guide to installing Linux software RAID 10
Date: Wed, 20 Aug 2008 00:21:45 +0200
Message-ID: <20080819222145.GA6261@rap.rap.dk>
References: <923541.95602.qm@web88303.mail.re4.yahoo.com> <48AAFD7A.2070606@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48AAFD7A.2070606@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 19, 2008 at 06:06:02PM +0100, John Robinson wrote:
> On 19/08/2008 15:25, Bruce Miller wrote:
> >Another article has appeared on a mainstream Linux web site which aims to 
> >smooth the installation of Linux RAID 10 for beginners:
> >http://howtoforge.com/install-ubuntu-with-software-raid-10
> >
> >As someone who merely lurks on this list and almost never posts, I do not 
> >dare to assess the accuracy or soundness of this article. But Howtoforge 
> >has a certain popularity among users who are not full-time IT 
> >professionals.
> >
> >It might be useful if one of the experts on this site looked at the 
> >article; if you find it worthwhile, perhaps a link could be added to 
> >wiki.linux-raid.osdl.org.
> 
> I don't claim to be an expert, but...
> 
> 1. "Raid 10 is the fastest RAID level that also has good redundancy 
> too". This isn't necessarily true.
> 
> 2. The configuration suggested will crash if any disc crashes, because 
> it has swap on raw disc partitions.
> 
> 3. The configuration suggested cannot reboot if the first disc crashes 
> because /boot is on a raw partition on the first disc only.
> 
> If I've got this all wrong, please let me know...

I think you are right.

Also it is claimed that you need 4 disk drives to do it, while you can
run raid10 with just 2 drives. 

And he does not mention our wiki nor raid10,f2.

Best regards
keld
