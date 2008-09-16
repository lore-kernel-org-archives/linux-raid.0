From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Slow RAID5 build on ata_piix vs. fast on sata_mv
Date: Wed, 17 Sep 2008 11:11:56 +1200
Message-ID: <48D03D3C.9000309@sauce.co.nz>
References: <20080908175021.GA7730@nexus.edgeofthenet.org> <20080908213222.GB9484@nexus.edgeofthenet.org> <20080916031601.GC24791@nexus.edgeofthenet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080916031601.GC24791@nexus.edgeofthenet.org>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Michael <rmichael-raid@edgeofthenet.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Interesting, as I have just received 4 of theses drives.

Can you tell me the version of both the faulty and good firmware?

Regards,

Richard

Richard Michael wrote:
> I'll reply to myself again, since I've solved the issue and figure it
> might as well go into archives somewhere. :)
> 
> After discovering Adaptec acknowledged an issue these (and related)
> drives on their controllers and provides updated drive firmware on their
> website, I guess-timated a drive issue.  I obtained the new SN05
> firmware directly from Seagate and the drives are performing much faster
> on the Intel controller.
> 
> For good measure, I flashed the other three drives (on the Marvell
> chipset controller), and they're still fine too.
> 
> Richard
