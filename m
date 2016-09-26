From: keld@keldix.com
Subject: Re: Linux raid wiki - setting up a system - advice wanted :-)
Date: Mon, 26 Sep 2016 10:17:28 +0200
Message-ID: <20160926081727.GA28217@www5.open-std.org>
References: <57E83EA8.9060809@youngman.org.uk> <CAOW94uvBEWZP4aN3jJT7ya68As6XGXPO1oJWFFPQnRmGg41ffg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOW94uvBEWZP4aN3jJT7ya68As6XGXPO1oJWFFPQnRmGg41ffg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Parada <advanceandconquer@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi

If you do not have a partition table, you cannot  have different partitions
on the disks.

It is in many cases a good idea to have different types of raids,
and partitions for different purposes, and this is where MD RAID has some
advantages over HW RAID. For instance you want a /boot a /root a Swap and one or more
data partitions.

And then different RAID types suits the different purposes, like RAID1, RAID10 and RAID5.

Best regards
Keld

On Sun, Sep 25, 2016 at 08:59:27PM -0400, Francisco Parada wrote:
> Hi Wols,
> 
> Based on my own experience, you can do it without trashing the array.
> However, I should note, that I have never done it this way to an array
> that I was booting from.  But, as long as you've set up GPT to account
> for the 2MB boundary.  If you use "parted" or the graphical
> equivalent, "gparted", you can account for that in newer drives above
> the 2TerraByte capacity anyway with 1MB instead of 2MB.  So if you add
> a little extra padding, say 3MB (2MB for your grub, 1MB for a blank
> section that all drives above 2TB require), you should be in good
> shape.
> 
> Perhaps someone else can chime in also, to confirm.
> 
> On Sun, Sep 25, 2016 at 5:16 PM, Wols Lists <antlists@youngman.org.uk> wrote:
> > This is a great way for learning lots about raid :-)
> >
> > I'm planning a section on setting up a new system, and I need to know
> > what will happen if you give entire drives to mdadm.
> >
> > Does it leave the first 2 megs empty? Basically, what I'm asking is if I do
> >
> > mdadm --create /dev/md/bigarray -add /dev/sda /dev/sdb /dev/sdc
> >
> > (note I am passing the entire drive, not the first partition) and then I
> > install grub on those drives, will I trash the array?
> >
> > Cheers,
> > Wol
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
