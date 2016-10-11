From: moft@fmailbox.com
Subject: Re: growing a RAID-10 array with mdadm 3.3.1+ ?
Date: Tue, 11 Oct 2016 11:37:17 -0700
Message-ID: <1476211037.1004490.752738017.68CF1E3E@webmail.messagingengine.com>
References: <1476206815.989242.752665505.6525EE00@webmail.messagingengine.com>
 <a09a7ce1-8adf-e00c-7787-eb7ccc1a9e63@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a09a7ce1-8adf-e00c-7787-eb7ccc1a9e63@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 11, 2016, at 11:29 AM, Anthony Youngman wrote:
> Growing an array is pretty safe, but like anything here, it does have  its dangers.
> 
> Second, what distro are you running? Is it a systemd-based distro?

Opensuse. Yes.

> feeling is that systemd is "to blame". 

I have no idea why that'd be the case.  That's the first time I've heard anybody suggest that.

> > *CAN* I safely grow/expand it?
> 
> Bugs excepted - yes you should be able to, without problems.

So grouwing 'far' layouts are now supported?  Do have a reference/source for that?

> > 	  This will always change data_offset, and will fail if there is no
> > 	  room for data_offset to be moved.

So a 'fail' means -- just won't start? as opposed to 'oops, it's now broken'?

> > So far I haven't found any specific "how to" for this process.
> 
> mdadm /dev/md0 --add /dev/sde1 /dev/sdf1
> mdadm --grow /dev/md0 --raid-devices=6
> 
> The first command will add your two drives as spares. The second will 
> make them part of the array. It's the second command that's the risky 
> one... and bearing in mind I don't know raid10, it might just add them 
> on the end and not need any reconstruction at all ...

Well, that's the missing critical detail here.

> > (1) The changelog refers to 'near' and 'offset' layouts, but doesn't mention 'far'.
> >
> > CAN I safely grow this layout=f2 array ?
> >
> > (2) If I can, what's the detailed procedure to do it?

Still need to understand the 'far' support, namely yes/no.

> I'll be interested in knowing how this pans out, too, so I can add it to 
> the wiki :-)

Thanks

Mike
