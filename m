From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Is this expected RAID10 performance?
Date: Fri, 7 Jun 2013 02:51:35 -0500
Message-ID: <CAAMCDefb7TFXDOD7=aK-FjHVCQXMdiQKdz=CFJT4+q9rKR3KGA@mail.gmail.com>
References: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Looking up that disk on seagate's website, it lists the max sustained
transfer rate for that specific disk model of 140MB/second.

That would be on the outside of the disk were the most sectors are,
inside the disk will be less, and that is under perfect conditions.

So some of your initial bonnie++ results may be from caching affects.
and appear to be higher than possible given the disk model.

And it is also possible that running more disks at the same time
cannot be sustained by the on-board chipset.

Try reading the disk with something like this: "dd if=/dev/<device>
of=/dev/null bs=1M count=4096" and see what speed it reports as this
usually gets pretty close to raw disk speed and then trying doing 4 of
those at the same time to each of the devices and see if the rate
sustains with 4 running.

On Thu, Jun 6, 2013 at 6:52 PM, Steve Bergman <sbergman27@gmail.com> wrote:
> I have a Dell T310 server set up with 4 Seagate ST2000NM0011 2TB
> drives connected to the 4 onboard SATA (3Gbit/s) ports of the
> motherboard. Each drive is capable of doing sequential writes at
> 151MB/s and sequential reads at 204MB/s according to bonnie++. I've
> done an installation of Scientific Linux 6.4 (RHEL 6.4) and let the
> installer set up the RAID10 and logical volumes. What I got was a
> RAID10 device with a 512K chunk size, and ext4 extended options of
> stride=128 & stripe-width=256, with a filesystem block size of 4k. All
> of this seems correct to me.
>
> But when I run bonnie++ on the array (with ext4 mounted
> data=writeback,nobarrier)  I get a sequential write speed of only
> 160MB/s, and a sequential read speed of only 267MB/s. I've verified
> that the drives' write caches are enabled.
>
> "sar -d" shows all 4 drives in operation, writing 80MB/s during the
> sequential write phase, which agrees with the 160MB/s I'm seeing for
> the whole array. (I haven't monitored the read test with sar.)
>
> Is this about what I should expect? I would have expected both read
> and write speeds to be higher. As it stands, writes are barely any
> faster than for a single drive. And reads are only ~30% faster.
>
> Thanks for any info,
> Steve Bergman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
