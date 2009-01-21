From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Performance question
Date: Wed, 21 Jan 2009 20:14:52 +0100
Message-ID: <20090121191452.GA4752@lazy.lzy>
References: <20090117171806.GA9432@lazy.lzy> <20090117220849.GB29866@rap.rap.dk> <20090119181253.GA4290@lazy.lzy> <20090121001503.GA26587@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090121001503.GA26587@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

[--detail vs. --examine]
> --detail looks at the running arrays, while --examine most
> likely (depending on mdadm.conf) looks at all partitions
> on the system. 
> 
> Given that the arrays are just created in the installation process, and
> the active running arrays are most likely the ones you want your system
> to know of, I think --detail is the better. --examine does on two of my
> systems generate info that are in conflict and not suitable for a
> mdadm.conf file, such as two /dev/md1 with different UUIDs.

yes, but I noticed that with "--detail" and an
array (RAID-1) resyincing, it reports "spares=1"
too, while when the array is in sync, it prints
the correct geometry.
So, I was wondering, since I also noticed that
"--examine" produces the arrays with /dev/md/"name",
so if two arrays have same name, it ends up with
the same device.
Is this maybe a bug of mdadm?

[metadata position]
> To me it does not matter that much, except for the booting device.
> Each partition in the booting device must look like a normal (ext3)
> partition, as grub and lilo does not know of raids, and just treats
> a booting partition as a standalone partition. So here you should use
> 0.90 metadata, which is put at the end of the array.

Well, I was a bit mixing up things with this question.
In the back of my head the question was:

What about performances, RAID-10 f2, bitmap (important)
and metadata 1.0 vs. 1.1?

This could be a further test for performances. It would
be interesting to know if it is better to have the
metadata at the beginning or at the end of a RAID-10 f2,
with two HDs, having the bitmap enabled.
Or if it does not matter at all.

Reading around I found different "opinions" about bitmap
and performances, but I did not find a "convincing" test.

Thanks again.

Different item of the wiki, I run into it today.
Maybe the "initrd" description could be updated, since
it uses "mdassemble", while the "initrd" I have uses
directly "mdadm -As --auto=yes ..." (I do not remember
the full line).

Hope this helps,

bye,

-- 

piergiorgio
