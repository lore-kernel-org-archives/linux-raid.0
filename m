From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: Removing devices from RAID-5
Date: Thu, 14 Jun 2007 14:27:26 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.0706141419450.5806@gheavc.wnzcbav.cig>
References: <m3ejkel7yy.fsf@shadow.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m3ejkel7yy.fsf@shadow.org.uk>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 14 Jun 2007, Rich Walker wrote:

> 
> Hi,
> 
> I've been having some problems with a machine, and now want to reduce
> the number of drives in the array.
> 
> It started out as an array of 160GB drives, but over time they have
> mostly been replaced by 250GB drives:

If you've been having trouble with a machine, doing risky stuff like 
restructuring raids and/or putting them in degraded mode (even 
temporarily) is a bad idea. That said, ...
 
If you had another 250G disk available you could do it, but it would 
involve the creation of a new array and use of pvmove. You said you 
could knock the space down to just 3x160 which is 480G which 2x250 
should be able to cover.

Assuming you had another 250G to play with (you only need it 
temporarily):

1. remove one 250G from array
2. make new array from second drive and the one you just removed 
   (/dev/mdNEW) (degraded 2/3 raid5)
3. add new array to volume group 
4. use pvmove or whatever to move all physical extents from /dev/md1 to 
   /dev/mdNEW
5. When complete, disable /dev/md1, remove /dev/md1 from LVM
   (don't forget to zero the superblocks, that one always bites me)
6. take one of the now-available 250's and add it to /dev/mdNEW,
   allowing it to reconstruct
7. You now have a 3x250 RAID5 and 2 unused drives, with no
   downtime (except adding a new 250G)
8. Update mdadm.conf and other files as necessary.
9. Since you only needed a 250G drive temporarily, you could play games 
   with fault+remove of the "borrowed" drive and replace it or whatever 
   you want to do...

Otherwise, I don't think you can use mdadm to accomplish this.

--
Jon Nelson <jnelson-linux-raid@jamponi.net>
