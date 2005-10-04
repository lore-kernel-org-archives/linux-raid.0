From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: Checking the sanity of SATA disks
Date: Tue, 04 Oct 2005 10:32:32 -0700
Message-ID: <1128447152.17447.69.camel@seki.nac.uci.edu>
References: <20051004142913.GK6594@strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051004142913.GK6594@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@lug.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


You may be better off using smart, but if you want to go through all the
blocks in a device without making your load skyrocket, I have two
solutions for you:

reblock (check the "-s" option):
http://dcs.nac.uci.edu/~strombrg/reblock.html

slowdown in combination with dd:
http://dcs.nac.uci.edu/~strombrg/slowdown/

HTH :)

On Tue, 2005-10-04 at 14:29 +0000, Andy Smith wrote:
> Hello,
> 
> I have a home fileserver with 4 SATA disks in a RAID 5.  As I am
> sure you are aware, SATA devices in Linux currently cannot be
> queried for SMART info, so I can't do SMART health checks of these
> devices.
> 
> Also there is still the tendency for Linux Software RAID to kick
> devices out of the array as soon as there is any error on them.
> 
> I really don't want to be in the situation where a drive dies, I fit
> a new one, and during the resync another device is kicked out
> because of spontaneously finding a bad sector.
> 
> I tried simply doing a
> 
>         dd if=/dev/sd[abcd] of=/dev/null
> 
> To check each disk in a very unsubtle fashion, but it drives the
> load average on the machine way way up (like to 20+) and makes it
> very unresponsive (wait several minutes for a keypress to be
> acknowledged), even if I run it under nice -n 19.
> 
> I don't notice any performance problems on this server during normal
> day to day use, and while it's not particularly beefy it is an AMD
> Sempron 1.8GHz so I am surprised that simply reading from one disk
> causes these performance issues.
> 
> I know this isn't right, so has anyone got any advice in the way of
> tracking down which part of the system is at fault, possibly
> off-list if it's too offtopic?
> 
> Thanks,
> Andy

