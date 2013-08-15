From: ariel.work@fmgirl.com
Subject: Re: Request for help with "1st time through" RAID array renaming
Date: Wed, 14 Aug 2013 17:22:59 -0700
Message-ID: <1376526179.7584.9941035.0A00CCA2@webmail.messagingengine.com>
References: <1376497589.7879.9787867.21A861C2@webmail.messagingengine.com>
 <1376501238.20717.9810207.70E4DA12@webmail.messagingengine.com>
 <20130815094636.3f804c9f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130815094636.3f804c9f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

> As the man page says, super-minor is only relevant for 0.90 metadata, and
> updating it is automatic for 2.6 and later.  So this step is not needed.

Okay.  I wan't sure what that meant :-/

> > 	mdadm --uuid=xxx... --update=name --name=server1_boot   
> > 	--homehost="<none>" --assemble /dev/md0  /dev/sd[ab]1
> > 	mdadm --uuid=yyy... --update=name --name=server1_root   
> > 	--homehost="<none>" --assemble /dev/md1  /dev/sd[ab]2
> > 	mdadm --uuid=zzz... --update=name --name=server1_storage
> > 	--homehost="<none>" --assemble /dev/md2  /dev/sd[cdef]1
> 
> This should work and do what you expect, though "--assemble" needs to
> come first.

Yeah, I got that figured out :-)  Need to set the mode.

> And if you are explicitly listing the devices (/dev/sd[ab]1), then giving
> the uuid as well is fairly pointless (though it doesn't hurt).

Now that I think about it, makes sense.

> > How's that look?
> Mostly good.

Okay.  So I took a swipe at it with the corrections you suggested.

After `mkinitrd` and `shutdown -r now` I've now gotten an "md127" in
there?

	cat /proc/mdstat | grep md
		md0 :   active raid1  sda1[0] sdb1[1]
		md127 : active raid1  sda2[0] sdb2[2]
		md2 :   active raid10 sdc1[0] sdf1[3] sde1[2] sdd1[1]

	mdadm -D -s
		ARRAY /dev/md0   metadata=0.90                          
		 UUID=xxx
		ARRAY /dev/md127 metadata=1.0  name=<none>:server_root  
		 UUID=yyy
		ARRAY /dev/md2   metadata=1.2 
		name=<none>:server_storage UUID=zzz

Where my

cat /etc/mdadm.conf
	...
	HOMEHOST <ignore>
	ARRAY /dev/md0 level=raid1  num-devices=2 metadata=0.90         
	                  UUID=xxx
	ARRAY /dev/md1 level=raid1  num-devices=2 metadata=1.00
	name=<none>:server_root    UUID=yyy
	ARRAY /dev/md2 level=raid10 num-devices=4 metadata=1.02
	name=<none>:server_storage UUID=zzz

So the process seems to NOT blow things up.  That's filed away now!

And, "/dev/md0" and "/dev/md2" seem to be properly named/reporting in
the mdadm, but not "/dev/md1".

Did I screw up the mdadm.conf?  And SHOULD I have set a HOMEHOST to
begin with ? (Fuzzy on when that's useful)

Ariel
