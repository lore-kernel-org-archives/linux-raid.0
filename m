From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Paranoid mode for RAID-1 ?
Date: Mon, 27 Apr 2015 18:18:57 +1000
Message-ID: <553DF0F1.8060608@websitemanagers.com.au>
References: <972437107.22507366.1430116679975.JavaMail.zimbra@laposte.net> <553DDBB3.2010306@websitemanagers.com.au> <553DE20E.2020605@hesbynett.no> <alpine.DEB.2.02.1504270925480.16871@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1504270925480.16871@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/04/15 17:35, Mikael Abrahamsson wrote:
> On Mon, 27 Apr 2015, David Brown wrote:
>
>> btrfs has data checksums like that.  Like Neil, I question the 
>> necessity for harddisks, but such checksums are lower cost than 
>> reading the data twice from two disks (as they are stored as part of 
>> the metadata that you already read), and can offer some protection 
>> against serious hardware problems.  (Checksums like this cannot 
>> easily be implemented in a transparent block device such as md raid - 
>> it is more practical to have them as part of the filesystem, as done 
>> with btrfs.)
>
> Only way I can imagine this being done would be for instance to add a 
> 4KiB block for every 128KiB chunk or something like that, and perhaps 
> have a smaller checksum for each 4KiB block within that 128KiB chunk.
>
> I doubt anyone would be interested in putting efforts into creating 
> this though as it would have "interesting" performance drawbacks, and 
> that work is probably better spent by making sure that btrfs and/or 
> zfs gets more development/testing than it is to put that effort into 
> md. I personally prefer md to be fairly "simple" so we have as few 
> bugs as possible in it, I'd say that md generally works and the number 
> of developers working heroically on its current incarnation is barely 
> enough to make sure that the codebase works as well as it must 
> considering the critical function it serves for a lot of us.
>
> This has been discussed before and nobody has shown interest in 
> actually developing code for it, so we're still at the feature request 
> and "brainstorming about design" state, and without actual coder(s) 
> willing to actually implement, it's not going to get further than this 
> stage.
>
Speaking of which, I'm not convinced that we should spend that developer 
time on each and every FS (eg, duplicated effort for btrfs, zfs, and any 
others that do the same). It also means you must remove MD Raid, to 
allow the FS to directly access each of the underlying devices. 
Obviously, there are advantages in both methods.

As you and others said, without someone willing to implement/write this 
feature, then it isn't going to happen.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
