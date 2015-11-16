From: Phil Turmel <philip@turmel.org>
Subject: Re: WD Red vs Black drives for RAID1
Date: Mon, 16 Nov 2015 13:28:12 -0500
Message-ID: <564A203C.1020309@turmel.org>
References: <22090.1097.258820.65463@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22090.1097.258820.65463@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/16/2015 11:28 AM, John Stoffel wrote:
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

The data sheet for the Blacks implies that they do *not* have TLER, also
known as ERC.  This is vital for proper operation out-of-the-box in any
Linux Raid environment, with the exception of raid0.

Search the archives for "timeout mismatch" for detailed explanations why
this is important.

The Red family does have ERC and will work properly.

Phil

