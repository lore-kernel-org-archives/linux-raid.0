From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: WD Red vs Black drives for RAID1
Date: Mon, 16 Nov 2015 18:07:28 +0000
Message-ID: <564A1B60.8050708@youngman.org.uk>
References: <22090.1097.258820.65463@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22090.1097.258820.65463@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16/11/15 16:28, John Stoffel wrote:
> 
> Guys,
> 
> I'm starting to get tons of errors on my various mixed 1 and 2Tb
> drives I have in a bunch of RAID 1 mirrors, generally triple mirrors.
> It's time to start replacing them and I think I want to either go with
> the WD Black 4Tb or the WD Red 4Tb drives.  And with a pair of 500Gb
> SSDs to use with lvmcache for speedup.
> 
> Any comments?
> 
I'm running Seagate Barracudas in a mirror (probably similar to the
Blacks). I haven't come across reports of problems IN A MIRROR
CONFIGURATION.

However, I want to go Raid 5 (or 6) at some point, and all the advice is
DON'T BUY DESKTOP DRIVES (ie Barracudas, Blacks, Greens) if that's the
route you're planning on going down. So I've got to replace my
Barracudas :-(

If you want to go 5 or 6 (which might get you better response speeds too
- I don't know), then Reds are your only choice. (Or Seagate NAS,
because I'm a Seagate guy that's the route I might go.)

Because desktop drives don't support proper error recovery, it's all too
easy for what should be a little problem to trash the array - if you
follow the list I'd say well over half the "help my array is trashed"
threads here are caused because the person used desktop drives.

The price difference isn't *that* much - I suspect a lot of people here
will say if reliability trumps performance, pay extra for Red or NAS drives.

Cheers,
Wol
