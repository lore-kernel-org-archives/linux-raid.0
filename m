From: maarten van den Berg <maarten@vbvb.nl>
Subject: Re: Booting from a raid1 device ?
Date: Tue, 28 Oct 2003 00:02:38 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310280002.38968.maarten@vbvb.nl>
References: <20031027152554.7738.qmail@web14507.mail.yahoo.com> <3F9D412A.F68B1461@SteelEye.com> <200310272311.19232.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310272311.19232.dusty@strike.wu-wien.ac.at>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 27 October 2003 23:11, Hermann Himmelbauer wrote:
> On Monday 27 October 2003 17:00, Paul Clements wrote:
> > Don Jessup wrote:


> BTW, assuming I have md.o not as module but statically in the kernel, which
> bootloader would support RAID1? I heard LlLO does this job but does also
> grub - which I prefer - support Linux SW-RAID1?
>
> What about RAID5? Is there any bootloader that supports it?

It has been a while since I read it, but doesn't the Boot+Root+Raid+Lilo howto 
[google] go into those setups ?  It helped me a lot at the time...

A related question:  There are a lot of old and deprecated Raid howto's 
floating around the net, even about the antique version 0.4.  
Is there no mechanism that gets these (very confusing for a newbie!) old 
versions removed or upgraded ?  And is this Boot+Root+Raid+Lilo howto I 
mentioned deprecated, or not ? Shouldn't it be integrated into the 'official' 
Raid howto ? (Or at least, there could be links to each other in the howtos) 

Greetings,
Maarten


> 		Best Regards,
> 		Hermann

-- 
Yes of course I'm sure it's the red cable. I guarante[^%!/+)F#0c|'NO CARRIER
