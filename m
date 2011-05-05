From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: mdadm raid1 read performance
Date: Thu, 5 May 2011 12:41:57 +0200
Message-ID: <20110505104156.GA11441@www2.open-std.org>
References: <BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com> <4DC0F2B6.9050708@fnarfbargle.com> <BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com> <BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com> <20110505094538.0cef02cc@notabene.brown> <BANLkTi=W=DNdqOBiGwbu67P1EgoEqNy+sg@mail.gmail.com> <BANLkTimNxTnf2xW8hbEWK2iA6axqjnjT+A@mail.gmail.com> <BANLkTi=2WCfoXTtyRzpBN06ph6HCsy_ShQ@mail.gmail.com> <BANLkTinoK0fhm-a7QAu5UdJNhbRO+mv2Jw@mail.gmail.com> <iptjde$92f$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <iptjde$92f$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 05, 2011 at 09:26:45AM +0200, David Brown wrote:
> On 05/05/2011 02:40, Liam Kurmos wrote:
> >Cheers Roberto,
> >
> >I've got the gist of the far layout from looking at wikipedia. There
> >is some clever stuff going on that i had never considered.
> >i'm going for f2 for my system drive.
> >
> >Liam
> >
> 
> For general use, raid10,f2 is often the best choice.  The only 
> disadvantage is if you have applications that make a lot of synchronised 
> writes, as writes take longer (everything must be written twice, and 
> because the data is spread out there is more head movement).  For most 
> writes this doesn't matter - the OS caches the writes, and the app 
> continues on its way, so the writes are done when the disks are not 
> otherwise used.  But if you have synchronous writes, so that the app 
> will wait for the write to complete, it will be slower (compared to 
> raid10,n2 or raid10,o2).

Yes syncroneous writes would be significantly slower.
I have not seen benchmarks on it, tho.
Which applications typically use syncroneous IO?
Maybe not that many.
Do databases do that, eg postgresql and mysql?

> The other problem with raid10 layout is booting - bootloaders don't much 
> like it.  The very latest version of grub, IIRC, can boot from raid10 - 
> but it can be awkward.  There are lots of how-tos around the web for 
> booting when you have raid, but by far the easiest is to divide your 
> disks into partitions:
> 
> sdX1 = 1GB
> sdX2 = xGB
> sdX3 = yGB
> 
> Put all your sdX1 partitions together as raid1 with metadata layout 
> 0.90, format as ext3 and use it as /boot.  Any bootloader will work fine 
> with that (don't forget to install grub on each disk's MBR).
> 
> Put your sdX2 partitions together as raid10,f2 for swap.
> 
> Put the sdX3 partitions together as raid10,f2 for everything else.  The 
> most flexible choice is to use LVM here and make logical partitions for 
> /, /home, /usr, etc.  But you can also partition up the md device in 
> distinct fixed partitions for /, /home, etc. if you want.

there is a similar layout of your disks described in

https://raid.wiki.kernel.org/index.php/Preventing_against_a_failing_disk

> Don't try and make sdX3 and sdX4 groups and raids for separate / and 
> /home (unless you want to use different raid levels for these two 
> groups).  Your disks are faster near the start (at the outer edge of the 
> disk), so you get the best speed by making the raid10,f2 from almost the 
> whole disk.

Hmm, I think the root partition actually would have more accesses than
/home and other partitions, so it may be beneficial to give the fastest
disk sectors to a separate root partition. Comments?

best regards
Keld
