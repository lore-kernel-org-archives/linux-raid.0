From: Neil Brown <neilb@suse.de>
Subject: Re: RAID MIA.  Again.  (Kinda.)
Date: Sat, 6 Mar 2010 07:37:03 +1100
Message-ID: <20100306073703.2e44d2f6@notabene.brown>
References: <ef2f0a4210283390480f4adbd9a547de.squirrel@webmail.jots.org>
	<20100305075016.51e98363@notabene.brown>
	<b305ada429c44b2b62b03c101f7ecf0a.squirrel@webmail.jots.org>
	<20100305123028.55a34c14@notabene.brown>
	<a65d84c03d315f1aea40641238f25625.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a65d84c03d315f1aea40641238f25625.squirrel@webmail.jots.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 5 Mar 2010 10:24:55 -0500 (EST)
"Ken D'Ambrosio" <ken@jots.org> wrote:

> On Thu, March 4, 2010 8:30 pm, Neil Brown wrote:
> > Try this:
> >
> >
> > cat /etc/fstab cat /etc/mdadm.conf mdadm -Esvv mdadm -Asv blkid -p /dev/md*
> >
> > And include all the output.
> 
> See attached.  Note that fstab is essentially irrelevant; I'd mounted by
> hand, and was going to add the entry after I got the server back in the
> server room.

So fdisk says there is no partition table on /dev/md0, but
but blkid said there is an XFS filesystem there.
So maybe you never partitioned /dev/md0?  
What happens if you

   mount /dev/md0 /somewhere

??

NeilBrown
