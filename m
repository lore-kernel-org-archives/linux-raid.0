From: Neil Brown <neilb@suse.de>
Subject: Re: RAID MIA.  Again.  (Kinda.)
Date: Fri, 5 Mar 2010 07:50:16 +1100
Message-ID: <20100305075016.51e98363@notabene.brown>
References: <ef2f0a4210283390480f4adbd9a547de.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ef2f0a4210283390480f4adbd9a547de.squirrel@webmail.jots.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 4 Mar 2010 11:12:29 -0500 (EST)
"Ken D'Ambrosio" <ken@jots.org> wrote:

> Hey, all.  I had a problem a month or so ago where I had three mirrors,
> and one of them went AWOL after a system migration.  Finally got as much
> as I could back, created a RAID-5 of four of the 1.5 TB disks, put
> everything on it, recovered more from backup, and was feeling pretty good.
> 
> Then the power went out.
> 
> Now, now RAID-5.  Or, rather, mdadm sees that there are RAID partitions,
> and starts; fdisk shows me an unpartitioned disk.  Which is, essentially,
> the exact same thing I had happen last time.  (Except that, this time, I
> *know* my mdadm.conf is correct, because it hasn't changed -- but, for the
> hell of it, I did a "mdadm --detail --scan", and it matches.)
> 
> WTF?  Am I too stupid for software RAID?  Is there something really
> obvious I'm missing?  Any help at all would be most graciously accepted.

You missed the bit where you provide concrete information rather than
vaguaries.

I'm guessing that you created the array over whole-devices, and then
partitioned the array - is that correct?
If fdisk shows you an unpartitioned array, maybe just the partition table is
corrupt.   Seems strange.

To so that I/we don't have to guess, please give exact commands that you run
and the exact output so we have access to the same information as you.

Too much data is much much better than not enough.

NeilBrown

