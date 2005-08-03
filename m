From: Raz Ben Jehuda <razb@bitband.com>
Subject: Re: 3ware raid question
Date: Wed, 03 Aug 2005 09:50:12 +0300
Message-ID: <1123051812.5046.7.camel@localhost.localdomain>
References: <3800555526607650241@unknownmsgid>
	 <602f2f2b05080213272aec2685@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <602f2f2b05080213272aec2685@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jason Leach <jason.leach@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I know that some raid management information is save on the disks.
But I am using 250 GB disks at minimum dd'ing this amount
would be too long. Has know the exact position of where to
dd ?
On Tue, 2005-08-02 at 13:27 -0700, Jason Leach wrote:
> Raz:
>  
>  The 3ware (at least my 9500S-8) keeps the info about the disk and how
> it fits into the RAID array on the disk;  I think in the DCB is used
> for this.  You can (and I have) unplug the disks, then connect them to
> different ports and the array will still work fine.
>  
>  When you are adding a disk from a different array it probably has the
> DCB from that array.  This is conflicting with your new array. I would
> do as the Dan suggests, and clear the disk.
>  
>  Jason.
> 
> On 8/2/05, Dan Stromberg <strombrg@dcs.nac.uci.edu> wrote: On Tue,
> 2005-08-02 at 13:52 +0300, Raz Ben-Jehuda(caro) wrote:
> 
> > i have encountered a weired feature of 3ware raid.
> > When i try to put inside an existing raid a disk which
> > belonged to a different 3ware raid if fail. 
> > Any idea anyone ?
> 
> Two thoughts:
> 
> 1) Maybe test the disk in another machine and see if it's still good
> 
> 2) Maybe wipe the disk clean in another machine with something like:
> 
>         dd if=/dev/zero of=/dev/sdb 
> 
> ...but be very careful to get the right disk (IE, you may not
> need /dev/sdb, you might need /dev/hdd or a number of other
> possibilities).
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Raz
Long live the penguin

