From: Anders Nielsen <anielsen@diku.dk>
Subject: Re: How to change the preferred minor
Date: 11 Apr 2002 17:07:58 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1018537678.1902.88.camel@localhost>
References: <1018431578.10844.32.camel@anders>
	<15540.57161.433718.491297@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15540.57161.433718.491297@notabene.cse.unsw.edu.au>
To: Linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

tor, 2002-04-11 kl. 02:56 skrev Neil Brown:
> On  April 10, anielsen@diku.dk wrote:
> > When I try to boot my box with disks which previously was configured in
> > other machines md tries to autodetect which array should have a given
> > minor number.
> > 
> > I use the wonderful :-) mdadm -E and I can see a preferred minor value
> > which is very nice, but since more than one array is competing for the
> > same minor number it is kind of difficult for me to figure out what to
> > put in my /etc/fstab.
> > 
> > Therefore my question is: how do I change the preferred minor value on a
> > array so I can prevent conflicts? I would of course like to be able to
> > use mdadm for this job :-)
> 
> This would be one of the reasons that I neither use nor recommend RAID
> autostart.  It is too dependant on the preferred-minor which is hard
> to change.
> I guess I could add an option to mdadm to change the preferred-minor
> as it could be useful, but I'm not highly motivated.  Maybe a
> --rewrite-superblock option to --assemble...
> 
> I recommend that you enumerate the uuids of your arrays, create
> /etc/mdadm.conf to say which uuid matches which /dev/md? and use 
>  mdadm --assemble --scan
> to assemble your arrays.
> 
> NeilBrown


I see that the method you recommend is more flexible since there are
more uuids than minor numbers :-)

But I am not sure how I disable autostart and replace it with mdadm -A
--scan so I could use some help.

I am using Redhat 7.2. I guess I have to change an initscript or
something.

Thanks,
 Anders



