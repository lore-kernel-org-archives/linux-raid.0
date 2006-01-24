From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Problems with multiple Promise SATA150 TX4 cards
Date: Tue, 24 Jan 2006 13:11:52 +0400
Message-ID: <43D5EF58.9010807@wasp.net.au>
References: <Pine.LNX.4.44.0601240132560.32305-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0601240132560.32305-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Christopher Smith <csmith@nighthawkrad.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
>> So, I bought another TX4 card and another 4 SATA drives and plonked them 
>> in the machine, thinking it would be as easy as the last time I did it 
>> (going from 4 to 8 drives).
> 
> 4 drives is easy; 8 is pushing it; 12 requires a fairly heroic system...

I have 3 cards with 12 drives in one box, and 4 card with 15 drives in another.
They work just dandy. They are not the fastest machines in the world, and the PCI but sometime 
groans under the strain, but it's reliable and error-free.

>> The first problem is that the Promise cards' onboard BIOS(es) only 
>> recognise(s) (or, at least, list) 8 of the 12 drives in the machine at 
>> boot.  However, once Linux has booted it detects all three cards and all 
>> twelve drives, so this is a relatively insignificant issue.
> 
> sounds like a spinup time on marginal power to me.

No, it's a limitation of the Promise BIOS on the cards, it will only detect a maximum of 8 drives. I 
had a quick convo with tech support from Promise over this and they told me they don't support more 
than one card in a machine in any case. (Which is odd given they advertise the ability to RAID-5 
across 2 cards!)

I used the BIOS detection to get to the drives in DOS once (when I was playing with SpinRite) and 
found the easiest way to get to the last drives was just to pop the 1st 4 out of their hotswap cages 
and re-boot. The BIOS just registers the first 8 drives it can find.

<snipped the rest about power issues>

Which could all be good stuff, but I doubt it in this case. If the PSU can happily spin up 12 drives 
at once, then while they are actually running the load is significantly less. Unless it's a nasty 
cheap PSU I'd look elsewhere. Given the problem can be triggered by "Additionally, a dd to only 
/dev/sd[abcd] with no other system activity also produces the errors - again within seconds.", 
implying the other drives are idle and consuming minimum power, I'd be looking elsewhere.

Can you send an lspci -vv please? I did have some strange problems with the BIOS setting up weird 
timing modes on some of the cards. This did not present a reliability problem for me, just 
performance however.

My 1st quick and dirty test would be to boot with a UP kernel. (Only because that is all I have 
also) And to try a vanilla kernel.org kernel rather than the Redhat one. (I have one machine on 
2.6.10 and one on 2.6.15-git11. Both are solid)

bklaptop:~>ssh storage1 uname -a
Linux storage1 2.6.15-git11 #1 Sun Jan 15 22:25:19 GST 2006 i686 GNU/Linux
bklaptop:~>ssh srv uname -a
Linux srv 2.6.10 #4 Mon Feb 14 23:10:38 GST 2005 i686 GNU/Linux

Are you using the cards in standard PCI 33Mhz Slots? I recall an issue a while ago where someone had 
a big problem with the cards in 66Mhz Slots.

Another test I'd like you to try if you would, is place one or two drives on each controller, so you 
only have 3 in the system.. and then try to reproduce the error.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
