From: Neil Brown <neilb@suse.de>
Subject: Re: Superblock V 1.2
Date: Mon, 15 Nov 2010 12:11:58 +1100
Message-ID: <20101115121158.20e2e53e@notabene.brown>
References: <20101107191507.GA31052@cons.org>
	<E9.7C.19545.72417DC4@cdptpa-omtalb.mail.rr.com>
	<20101107210852.GA77472@cons.org>
	<4CD71C77.4030400@anonymous.org.uk>
	<20101109163512.GA15649@cons.org>
	<4CD98021.2060501@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD98021.2060501@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Martin Cracauer <cracauer@cons.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 09 Nov 2010 17:08:49 +0000
John Robinson <john.robinson@anonymous.org.uk> wrote:

> On 09/11/2010 16:35, Martin Cracauer wrote:
> > John Robinson wrote on Sun, Nov 07, 2010 at 09:39:03PM +0000:
> [...]
> >> That's the other difference between 0.90 and 1.x metadata. In-kernel
> >> auto-assembly is only available for 0.90, and Neil Brown has made it
> >> clear that there will never be in-kernel auto-assembly for 1.x, and
> >> explained at length why. You need mdadm to start 1.x arrays, in your
> >> initrd if your root filesystem is on such an array. All modern distros
> >> create suitable initrds automatically. We are moving towards having
> >> array assembly handled by udev invoking mdadm as devices are discovered.
> >
> > That's good it know.  I still think that udev is a plot to destroy
> > Linux as we know it so I guess I'm gonna recreate this particular
> >   array :-)
> >
> > What do you do if you plug in a couple harddrives that have arrays on
> > them that you do not want assembled? Right now you just set them to a
> > partition type other than autodetect and you are good.
> 
> You can still do that, but the "right" way to do it (I think) is to use 
> the AUTO keyword and only to include the arrays you want assembled at 
> boot time in the mdadm.conf that goes into the initrd.

Yes, "auto" is the way to make this do what you want.  The problem is that
different people want different behaviours and it is impossible to please
everyone.
md arrays will normally be tagged with the name of the host they were created
on.  So if you have

  AUTO homehost -all

in mdadm.conf, then it should auto-assemble arrays that were created on
'this' host, and ignore the rest, which might be what you want.

When mdadm does auto-assemble an array that doesn't obviously belong to this
host, it tries to be careful and assembles it 'read-auto', which means that
it is completely read-only until you try to write to the array.  So no
recovery or resync happens.
Once you write to the array, md assumes that you are happy to have the array
assembled on this device, and allows any resync etc to start.

I would be nice if read-auto didn't claim the device, so you would still be
able to access the device 'normally' if you wanted to. But that is hard.
So if you plug some devices in and mdadm thinks like look like they might
belong to it, then it will claim them and you want be able to e.g. mkfs on
them.  But you can be sure they won't be been written to at all, and you can
"mdadm -S /dev/md/whatever" to get full access to your devices back.



> 
> > What do you do when udev maintainers in distributions screw up and
> > replace good udev entires with bad ones? That happened to me
> > repeatedly and is the major reason for the attitude above.
> 
> Oh dear, you've had a bad experience there then. I like udev. I disliked 
> the old huge /dev with gazillions of entries for devices you don't have, 
> and you still ended up using MAKEDEV or mknod whenever you added 
> something new. I did say "moving towards" because udev-based assembly 
> isn't 100% there yet, and I don't think any distros are trying to use 
> it. But the other great thing we will get with udev is hotplugging, 
> including the option to configure in advance auto-rebuilding of arrays, 
> something that hardware RAID adapters have always had but we still don't 
> for software RAID.

Yes, udev has its problems (doesn't everything?) but I think that in general
it is heading in the right direction.

And we are getting close to configurable auto-rebuilding on hot-plug.
mdadm-3.2 will have most of the code in place so some things will work, but
you can probably expect bugs in that release.

NeilBrown



> 
> Cheers,
> 
> John.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

