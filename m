From: Maarten <maarten@ultratux.net>
Subject: Re: 4 questions. Chieftec chassis case CA-01B, resync times, selecting ide driver module loading,  raid5 :2 drives on same ide channel
Date: Sun, 16 Jan 2005 19:22:48 +0100
Message-ID: <200501161922.48813.maarten@ultratux.net>
References: <crmt7e$8d6$1@sea.gmane.org> <200501101810.49798.maarten@ultratux.net> <200501161119.41349.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-8-i"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501161119.41349.mlaks@verizon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 16 January 2005 17:19, Mitchell Laks wrote:
> HI,
> I have 3 questions.
>
> 1) Maarten, Where did you buy the big chieftec chasis (CA-01B  i think) and
> what did you pay for it?  I have been using antec sx1000 chasis and yours
> looks better and bigger.

I paid 120 euro I think. The BA-01B is a bit cheaper but exactly the same 
except for the missing side window. I bought it at some local shop in the 
netherlands. However I went and bought a more powerful and ultrasilent Tagan 
480 W PSU to replace the 360W chieftec one. That Tagan PSU was more expensive 
than the chieftec case+psu together.
The case pleases me, but in all fairness the Antec cases are better in respect 
to details, this case has some mild sharp edges which I did not ever find 
with Antec.  But that is a minor detail( to me). Of course it's not as bad as 
with noname cheap case brands.  Overall I thought this case deserved a 5/5 
for design, a 5/5 for ingenuity, and a 4/5 for craftsmanship.
(Incidentally the Tagan PSU deserves a full 5/5 too)

The shop will ship in Holland, but not abroad AFAIK. And that would be 
cost-prohibitive anyway, this case is really a big sucker.

> 2) Also what are reasonable resync times for your big raid5 arrays?
> I had resync time or two days by accident recently for 4x 250 hard drives
> because i did not have dma enabled. that is solved, but i had switched to
> raid1 in the interm and now i am curious what others are used to.

Not sure. At first I built the array on a lowly old celeron-500 and the resync 
time of each of the 6 arrays was IIRC 50 minutes, so about 5 hours all told.
With the new case I also installed a much faster board, an athlon 1400, so 
resync now is at (about) 20 minutes for each array, but I admit I did not 
take notes there.

The other big array, consisting of whole-drive 160GB disks (5-1)x160GB=640GB 
did a resync in a little over 2 hours I think. Less than three, at any rate.

> 3) Also, i have a module driver question.
> I use a asus K8V-X motherboard. It has sata and parallel ide channels. I
> use the sata for my system and use the  parallel for data storage on ide
> raid. I am using  combining the 2 motherboard IDE cable channels with
> highpoint rocket133 cards to provide 2 more ide ata channels.

I myself now have in use:
The VIA onboard ATA channels
One Promise SATA TX2 150
Two noname SIL / silicon image SATA controllers
One Promise ATA Tx133

The onboard VIA SATA controller is left unused. I may use it later but it gave 
me some problems in the past so I went for the simplest solution now.

> I installed debian and it defaulted to using the hpt366 modules for the
> rocket133 controllers.
> I suspect (correct me if I am wrong) that the hpt302 on the highpoint
> website is the RIGHT module to use (I notice for instance that when I
> compare the hdparm settings on the western digital drives on the
> motherboard ide channels are set with more advanced dma settings "turned
> on" than   on the rocket133 controllers. Perhaps this is because it is
> using the 'incorrect hpt366' module?

I once had a mainboard with HPT cntr onboard, an older version though (266?). 
Since then I carefully avoided highpoint as well as I could... I will not buy 
one unless held at gunpoint. Same as with Sony, I hate that brand.

> Of course I would prefer to use the hpt302 module  (after i compile it...).
> So how do I get to insure that the system will use the hpt302 over the
> hpt366 that it seems to be chosing. If I
> 1) compile the module hpt302 from source
> 2) dump it in the /lib/modules/2.6.9-1-386/kernel/drivers/ide/pci directory
> 3) put a line hpt302 in the /etc/modules file (maybe at the top?)
> 4) put a line hpt302 at  the top of the file /etc/mkinitd/modules.
> 5) run mkinitrd to generate the new initrd.img
>
> will this insure that the module hpt302 is loaded on preference to the
> hpt366 module?

Sorry, I've no clue on that. Your story sounds reasonable, but why not start 
by getting the module compiled ?  Most times, that is the hard part.  If that 
succeeds and you can insmod it without probs, there is plenty of time to 
convince the kernel to load the right module I think. 

> 4) Maarten mentioned that he had a problem with 2 different drives on the
> same channel for raid5. What was the problem exactly with that.

The same problem everyone has.  If an IDE drive fails, it does not -as SCSI 
drives tend to do- leave the electrical IDE bus in a free/useable state.  So 
the other drive on that cable is still "good", but unreachable/dead for now.  
This obviously leads to a fatal 2-drive failure.  It doesn't matter the 
second drive's failure is only temporary; the md / ide code doesn't know 
that.
You can often restore the array manually, but this is not something that is 
done lightly, so really better to be avoided...  

Maarten

