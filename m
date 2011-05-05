From: David Brown <david@westcontrol.com>
Subject: Re: mdadm raid1 read performance
Date: Thu, 05 May 2011 09:26:45 +0200
Message-ID: <iptjde$92f$1@dough.gmane.org>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>	<20110504105822.21e23bc3@notabene.brown>	<BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>	<4DC0F2B6.9050708@fnarfbargle.com>	<BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com>	<BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>	<20110505094538.0cef02cc@notabene.brown>	<BANLkTi=W=DNdqOBiGwbu67P1EgoEqNy+sg@mail.gmail.com>	<BANLkTimNxTnf2xW8hbEWK2iA6axqjnjT+A@mail.gmail.com>	<BANLkTi=2WCfoXTtyRzpBN06ph6HCsy_ShQ@mail.gmail.com> <BANLkTinoK0fhm-a7QAu5UdJNhbRO+mv2Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinoK0fhm-a7QAu5UdJNhbRO+mv2Jw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/05/2011 02:40, Liam Kurmos wrote:
> Cheers Roberto,
>
> I've got the gist of the far layout from looking at wikipedia. There
> is some clever stuff going on that i had never considered.
> i'm going for f2 for my system drive.
>
> Liam
>

For general use, raid10,f2 is often the best choice.  The only 
disadvantage is if you have applications that make a lot of synchronised 
writes, as writes take longer (everything must be written twice, and 
because the data is spread out there is more head movement).  For most 
writes this doesn't matter - the OS caches the writes, and the app 
continues on its way, so the writes are done when the disks are not 
otherwise used.  But if you have synchronous writes, so that the app 
will wait for the write to complete, it will be slower (compared to 
raid10,n2 or raid10,o2).

The other problem with raid10 layout is booting - bootloaders don't much 
like it.  The very latest version of grub, IIRC, can boot from raid10 - 
but it can be awkward.  There are lots of how-tos around the web for 
booting when you have raid, but by far the easiest is to divide your 
disks into partitions:

sdX1 = 1GB
sdX2 = xGB
sdX3 = yGB

Put all your sdX1 partitions together as raid1 with metadata layout 
0.90, format as ext3 and use it as /boot.  Any bootloader will work fine 
with that (don't forget to install grub on each disk's MBR).

Put your sdX2 partitions together as raid10,f2 for swap.

Put the sdX3 partitions together as raid10,f2 for everything else.  The 
most flexible choice is to use LVM here and make logical partitions for 
/, /home, /usr, etc.  But you can also partition up the md device in 
distinct fixed partitions for /, /home, etc. if you want.

Don't try and make sdX3 and sdX4 groups and raids for separate / and 
/home (unless you want to use different raid levels for these two 
groups).  Your disks are faster near the start (at the outer edge of the 
disk), so you get the best speed by making the raid10,f2 from almost the 
whole disk.

mvh.,

David


