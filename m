From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 15:12:56 -0500
Message-ID: <4DD6CB48.6050701@hardwarefreak.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD65C18.5090804@gmail.com> <20110520200100.GF4759@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110520200100.GF4759@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/20/2011 3:01 PM, Andy Smith wrote:

> It's a shame; maybe there will be disks with battery-backed cache
> one day.

You'll never see a cache DRAM BBU built into a drive.  If this *concept*
were to be implemented it would be done with flash and a capacitor
instead of a BBU.  The capacitor would be sized to hold just enough
juice to power the ASIC, flash chip, and related circuitry, and write
the cache DRAM contents to the flash chip after sensing power to the
card has been lost.

Many higher end RAID cards already have flash backup of the cache DRAM
in addition to, in instead of, a BBU.

-- 
Stan
