From: Corey McGuire <coreyfro@coreyfro.com>
Subject: Re: Bizarre RAID "failure"
Date: Tue, 2 Mar 2004 08:56:53 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403020856.53518.coreyfro@coreyfro.com>
References: <1077230692.28817.485.camel@s8n-1.thereinc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1077230692.28817.485.camel@s8n-1.thereinc.com>
Content-Disposition: inline
To: Tom Maddox <tmaddox@thereinc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I don't know if this till help, but I was having lots of trouble with my promise controllers until 2.4.23... before that, they were locking up drives all the time.  I had one drop out entirely, with two drives.  I had to rebuild a raid5 with two dead drives.

Once I upgraded, I stopped having such trouble.

One more thing I might add, I too had 3 promise controllers and that was hard to manage as well.  I moved two drives to my onboard controller which not only made things a bit less flaky (I am assuming 33% less flaky) but also seemed to speed things up (later VIA chipsets take the HDD controller off of the PCI bus, and three PCI HDD controllers can easily saturate that.)

On Thursday 19 February 2004 02:44 pm, Tom Maddox wrote:
> Hi, all,
> 
> I'm encountering a bizarre problem with software RAID 5 under Linux that
> I'm hoping someone on this list can help me solve or at least
> understand.
> 
> I've got a box running Red Hat 7.3 with SGI's 2.4.18 XFS 1.1 kernel. 
> It's using three FastTrak TX 2000 (PDC20271) cards in non-RAID mode with
> three Western Digital 200 GB drives.  I'm using those controllers
> because they were handy and they support large drives.  The drives are
> in an XFS-formatted RAID 5 array using md, which has never given me
> problems before.  In this case, however, I'm running into some seriously
> anomalous behavior.
> 
> If the system goes down unexpectedly (e.g., because of a power failure),
> the RAID array comes back up dirty and begins to rebuild itself, which
> is odd enough on its own.  What's worse is that, whenever this happens,
> the rebuild hangs at about 2.4%.  When it reaches that point, the array
> becomes totally nonresponsive--I can't even query its status with mdadm
> or any other tool, although I can use "cat /proc/mdstat" to see the
> status of the rebuild.  Any command that attempts to access the RAID
> drive hangs.
> 
> My assumption would normally be that there's a hardware failure
> somewhere, but I've swapped out each component individually (including
> cables!) and the same problem keeps happening.
> 
> Has anyone seen this behavior before, and can you recommend a solution?
> 
> Thanks,
> 
> Tom
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
