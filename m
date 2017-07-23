From: Veljko <veljko3@gmail.com>
Subject: Re: Linear device of two arrays
Date: Sun, 23 Jul 2017 12:05:27 +0200
Message-ID: <20170723100518.GA5988@obsidian.example.com>
References: <87van15j9b.fsf@notabene.neil.brown.name>
 <e394625b-18d7-d141-3957-3c16c9bc6e44@gmail.com>
 <87o9sn232n.fsf@notabene.neil.brown.name>
 <1eefd627-1aba-a795-05f0-d2106d3a62a3@gmail.com>
 <87shhyzhg5.fsf@notabene.neil.brown.name>
 <38e015fa-a07c-8f1a-3a04-384d973966be@gmail.com>
 <87d18uydir.fsf@notabene.neil.brown.name>
 <be3ba727-2456-3507-e6d8-5b46d8b64339@gmail.com>
 <cc2ff16e-5368-b828-6acc-6698d6e0b521@gmail.com>
 <871sp8xeey.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871sp8xeey.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2017-Jul-23 09:03, NeilBrown wrote:
> The UUID you give to mount is the UUID of the filesystem, not of the
> device (or array) which stores the filesystem.
> 
> One of the problems with use 1.0 metadata (or 0.90) is that the first
> component device looks like it contains the same filesystem as the whole
> array.   I think this is what is causing your confusion.

Yes, I mixed up those two. Now is all clear.

> This all depends on the details of the particular distro you are using.
> You don't, in general, need arrays to be listed in mdadm.conf.  A
> particular distro could require it though.
> 
> If you run
>    mdadm -Es
> 
> It will show a sample mdadm.conf which should contain /dev/md/3 - the
> new raid10, and /dev/md/4.
> You could add those lines to mdadm.conf, then
>    mdadm --assemble /dev/md/3
>    mdadm --assemble /dev/md/4
> and it should get assembled.  Then you should be able to mount the large
> filesystem successfully.

Well, I feel much better now that I do have arrays listed in mdadm.conf
and in /dev.

Thanks very much for your help, Neil!

Regards,
Veljko

