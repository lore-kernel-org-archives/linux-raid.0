From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID5 problem with multiple Promise PDC20269 controllers
Date: Tue, 29 Oct 2002 19:08:35 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210291908.35581.roy@karlsbakk.net>
References: <3DBD54FA.20709@base2technology.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3DBD54FA.20709@base2technology.com>
To: Chris Hirsch <chris@base2technology.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 28 October 2002 16:17, Chris Hirsch wrote:
> This is probably more of a hardware question than RAID but since there
> has to be somebody in the same boat as myself....
>
> I'm trying to do a RAID5 setup with 3 IDE disks connected to IDE1/IDE2
> on a Promise  ULTRA133 TX2. Fine..works great with only two disks. So I
> bring in my 3rd disk on the second PDC20269 and I get kernel lockups and
> fun stuff when the array tries to rebuild or activate. I've tried deja
> and there seems to be some issues with multiple cards but I can't seem
> to find any resolutions. This is a RH 8.0 box using 2.4.18.

strange ...

I'm running 20269's (or was that 68's?) with four drives each, and it works 
fine

-- 
Roy Sigurd Karlsbakk, Datavaktmester
ProntoTV AS - http://www.pronto.tv/
Tel: +47 9801 3356

Computers are like air conditioners.
They stop working when you open Windows.

