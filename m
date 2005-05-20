From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bug report: mdadm -E oddity
Date: Fri, 20 May 2005 07:29:11 -0400
Message-ID: <1116588551.23785.18.camel@compaq-rhel4.xsintricity.com>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com>
	 <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com>
	 <17029.12773.197506.463977@cse.unsw.edu.au>
	 <1116262011.13780.79.camel@compaq-rhel4.xsintricity.com>
	 <17037.36080.896276.555805@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17037.36080.896276.555805@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Answering this email first, then I'll go back to the other one.

On Fri, 2005-05-20 at 17:08 +1000, Neil Brown wrote:
> On Monday May 16, dledford@redhat.com wrote:
> > On Sat, 2005-05-14 at 09:01 +1000, Neil Brown wrote:
> > > 
> > > So there are little things that could be done to smooth some of this
> > > over, but the core problem seems to be that you want to use the output
> > > of "--examine --scan" unchanged in mdadm.conf, and that simply cannot
> > > work.
> > 
> > Well, also keep in mind that the documentation on mdadm touts the fact
> > that is meant to be run without a config file.  I'm perfectly happy to
> > do that, but -A mode combined with --scan mode only assembles and starts
> > arrays in the config file.  As I mentioned in a previous email, I guess
> > I could do something like mdadm -Es | mdadm -c - -As -device=partitions
> > but that just seems kinda silly given that all that is needed is for the
> > assemble mode to start all devices found and we already know how to find
> > them in the -E mode.  Maybe either changing -As mode to assemble
> > everything regardless of config file or adding another flag to assemble
> > mode to do the same.
> 
> It isn't meant to say that mdadm "Should" be run without a config
> file.  Just that mdadm "can" be run without a config file, in stark
> contrast to raidtools that requires a config file even for stopping an
> array.   Maybe I should tone down that part of the man page.
> 
> I don't like having a "blindly start everything" function for mdadm
> for exactly the same reason as I don't like the in-kernel
> "autodetect".   It is too easy for things to go wrong.
> 
> Suppose I have two computers with raid arrays.  One dies so I shut
> down the other, plug all drives into the working one, and bring it up
> again.
> A "blindly start everything" function could get confused and pick the
> wrong array to be the root filesystem, or hit other snags.

Yes it could, especially if your filesystems have identical labels and
now mount is confused by which one to mount.

> That is why in my previous email with my example for version-1 usage I
> included a host name in the "set_name".  Hopefully the
> start-everything script would have access to a host name (via dhcp or
> command line or something) and would get that scenario right.
> 
> I really DON'T WANT people to
>   mdadm -Es | mdadm -c - -As -device=partitions
> 
> I want them to
>   mdadm -Es >> /etc/mdadm.conf
>   edit /etc/mdadm.conf
>     think about what should be there
> 
> just as they
>    edit /etc/fstab
>      think about what should be there.
> 
> Is that unreasonable?

You brought up the fstab analogy in your last email too, and I can
somewhat see that analogy, but the other side of the argument is that
people don't have to edit a disk tab to get their disk devices, they
just show up.  Fstab is at a higher level.  Md devices are disk devices
as far as users are concerned, and to a certain extent they just want
them to be there.

I had actually put some thought into this over the last week.  One thing
I had thought about is that most modern hardware has some way of getting
at a serial number (i386 and x86_64 have cpuid serial numbers, I think
Sparc has an openfirmware serial number, etc).  I thought that it might
be useful to create an arch specific serial number routine that would be
accessible by the kernel at boot time, then when creating an array with
version 0.90 superblocks you have a 128bit UUID, so what about encoding
the upper 32 bits as the serial number and only auto starting arrays
that have the right serial number in the UUID?  That would avoid the
problem that you spoke of earlier with moving disks around.  You could
also make mdadm capable of doing an update=serial-number operation to
permanently move an array from one machine to another.  In the event
that a machine dies and you move a / array to another machine and just
want it to work, the presence of the UUID= in an ARRAY line for the /
array would override the mismatched serial number so you can start the
array for the / partition in the initrd, and then the remaining ARRAY
lines would result in the other known arrays getting started as well.
If a user wants to make things match, which wouldn't strictly be
required, then they run mdadm --update on the arrays for the new serial
number.  Anyway, just a thought.

-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford


