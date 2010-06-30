From: Neil Brown <neilb@suse.de>
Subject: Re: How do I determine which drive should be in which slot?
Date: Wed, 30 Jun 2010 11:02:28 +1000
Message-ID: <20100630110228.3091ebf6@notabene.brown>
References: <loom.20100626T070913-497@post.gmane.org>
	<loom.20100629T082214-677@post.gmane.org>
	<20100629170209.126e6336@notabene.brown>
	<loom.20100629T175538-430@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20100629T175538-430@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Dave W <dave+gmane@wuertele.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 29 Jun 2010 16:00:57 +0000 (UTC)
Dave W <dave+gmane@wuertele.com> wrote:

> Neil Brown <neilb <at> suse.de> writes:
> 
> > > How can I tell mdadm to put them in the right slots?
> > 
> > This is very odd.... that should not happen.  I think I've seen a few reports
> > of something like that happening and I'm beginning to wonder if I broke
> > something subtle....
> > What kernel/mdadm version are you using.
> 
> # uname -a
> Linux fileserver.whome 2.6.27.24-170.2.68.fc10.i686 #1 SMP Wed May 20 23:10:16
> EDT 2009 i686 i686 i386 GNU/Linux
> # mdadm --version
> mdadm - v2.6.7.1 - 15th October 2008

Hmmm... I obviously didn't introduce it recently then.  That is a little bit
encouraging.

> 
> 
> > You should use "mdadm --examine" to see the configuration of the array, and
> > make sure that configuration is copied exactly when you creat a new array -
> > same chunk size, same layout, same metadata version etc.
> 
> I don't know what metadata version refers to.  I don't see it in the
> "mdadm --examine" output.

It is the "Version : " field.  0.90 in your case.

> 
> 
> > Keep a copy of the "mdadm --examine" output and compare it with the output
> > after runing the --create and make sure everything is still the same (e.g.
> > Data Offset could be changed - that would be awkward).
> 
> I also don't see Data Offset in the --examine output.  I wonder if I should
> upgrade to a newer mdadm?  Or is that something that I can only see if I
> run --examine on a running array?
> at the data looks OK.

"Data Offset" is only present in 1.x metadata.  As you have 0.90 you won't
see it and it cannot change. so you are safe from that.

--examine reports the same info whether the array is running or not.

> 
> > If 'fsck' fails, you might like to try again, re-arranging the devices that
> > you aren't sure of.
> 
> OK, it sounds like you're saying that the --create command won't hurt anything
> that I can't fix by running it again.  It is truly safe that way?

Almost.
If you run 
    --create --metadata=1.1
on devices what were part of a 0.90 array, then as the 1.1 superblock is
written at the start of the device, and 0.90 puts data at the start of the
device, you would get corruption.

But if you use the same --metadata= and use --assume-clean and don't specify
a bitmap, then --create will over-write the metadata but not touch the data
at all.


> 
> Here is the /proc/mdstat and the --examine output:

So you probably want

 mdadm --create /dev/md -l6 -n5 --chunk 64 --assume-clean --metadata=0.90 \
  /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

NeilBrown

