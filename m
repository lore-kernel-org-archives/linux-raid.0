From: John Lange <john.lange@bighostbox.com>
Subject: Re: Hard drive Reliability?
Date: Thu, 20 May 2004 08:31:05 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1085059864.16945.19.camel@localhost>
References: <Pine.LNX.4.44.0405200801180.19972-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0405200801180.19972-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2004-05-20 at 07:15, Mark Hahn wrote:
> you imply that vendors are knowingly shipping half their product
> that will die within even a 1yr warranty period, and then have 
> to be replaced at significant cost to the vendor.  I really can't 
> see why you think they're so stupid!  the alternate explanation,
> which fits the data (such as it is) perfectly well is that the 
> supply chain damages the drives.

This is certainly possible, however, you imply that the vendors are
knowingly shipping their drives through supply chains which damage the
drives and then have to be replaced at significant cost to the vendor.
Or alternatively, are knowingly packaging the drives so poorly they are
damaged in shipping. Either way I'm not letting the vendors off the hook
so easily.

I also can debunk this another way. I have two identical drives which
came out of the same shipping carton which were still in their original
plastic "shell packaging". Not impossible that one drive was poorly
handled after it was removed from the carton but also not likely.

And third, if you go to the drives web site link I provided, they make a
big deal out of how "tough" their drives are specifically in regard to
how well they withstand all kinds of hardship during shipping.

So again, the consumer is being misled.

> > away. Shipping new drives and having a support call to install them can
> > get very expensive not to mention down time.
> 
> so install a hot spare or two or three.

Again, a somewhat reasonable thing to do if you are aware that you need
to do this but certainly nothing from the vendor has prepared us for
that necessity. Only repeated drive failures has started to bring us to
the realization this is no longer optional.

I say "somewhat" because if you intend to have all drives cooled
properly their is often enough space for more than 2-3 drives. In this
specific example the drives are in a drive mounting bay which sits
directly in front of a large fan. There is probably room for one more
drive at most.

BTW, smartctl reports the drive has never gone above 40C (well below its
operating maximum of 60C). This case was selected partly because it had
a fan in front of the drives. The point being it did not overheat while
in service.

So we are left with the "damaged in handling" option which I find very
unlikely OR the poor option that it was poor quality to begin with.

> 
> > senseless in any office with more than about 2 desktops. LTSP (
> > www.ltsp.org ) all the way!
> 
> actually, I considered using ltsp when I built my diskless cluster,
> but once I looked, I could find no real value-add there.  instead,
> I run export an unmodified RH dist as a readonly root, boot with 
> the usual dhcp/pxe/tftp tools, and have /var in tmpfs.

You are correct that LTSP is mostly it is just a repackaging of X though
they are adding more all the time. For example access to removable media
on the client etc.

Whether you do standard remote X or LTSP, the point is NO hard drives on
the desktop is the only way to go!

The solutions are ironic, either DOUBLE the number of hard drives on the
clients or eliminate them all together!

Regards,

John Lange

