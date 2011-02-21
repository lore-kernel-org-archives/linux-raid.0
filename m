From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 13:20:46 -0500
Message-ID: <4D62ACFE.4020401@cfl.rr.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>	<4D517F4F.4060003@gmail.com>	<4D5245DF.4020401@hardwarefreak.com>	<iiu4rc$9ju$1@dough.gmane.org> <AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com> <iiud2r$qci$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iiud2r$qci$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/9/2011 10:49 AM, David Brown wrote:
> I've been reading a little more about this.  It seems that the days of
> TRIM may well be numbered - the latest generation of high-end SSDs have
> more powerful garbage collection algorithms, together with more spare
> blocks, making TRIM pretty much redundant.  This is, of course, the most
> convenient solution for everyone (as long as it doesn't cost too much!).
> 
> The point of the TRIM command is to tell the SSD that a particular block
> is no longer being used, so that the SSD can erase it in the background
> - that way when you want to write more data, there are more free blocks
> ready and waiting.  But if you've got plenty of spare blocks, it's easy
> to have them erased in advance and you don't need TRIM.

It is not just about having free blocks ready and waiting.  When doing
wear leveling, you might find an erase block that has not been written
to in a long time, so you want to move that data to a more worn block,
and use the less worn block for more frequently written to sectors.  If
you know that sectors are unused because they have been TRIMed, then you
don't have to waste time and wear copying the junk there to the new
flash block.

TRIM is also quite useful for thin provisioned storage, which seems to
be getting popular.
