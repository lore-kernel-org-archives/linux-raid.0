From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Swap initialised as an md?
Date: Sun, 12 Nov 2006 15:03:32 +0100
Message-ID: <20061112140332.GY28384@boogie.lpds.sztaki.hu>
References: <20061110102955.ljws9mgxf4o4kgw8@my.pengus.net> <455468CD.2050305@crc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <455468CD.2050305@crc.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Mogens Kjaer <mk@crc.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 10, 2006 at 12:55:57PM +0100, Mogens Kjaer wrote:

> If one of your disks fails, and you have pages in the swapfile
> on the failing disk, your machine will crash when the pages are
> needed again.

IMHO the machine will not crash just the application which the page
belongs to will be killed. Of course, if that application happens to be
init or your mission-critical daemon then the effect is not much
different from a crash...

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
