From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Bug report: mdadm -E oddity
Date: Fri, 20 May 2005 17:08:32 +1000
Message-ID: <17037.36080.896276.555805@cse.unsw.edu.au>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com>
	<1116004267.3974.35.camel@compaq-rhel4.xsintricity.com>
	<17029.12773.197506.463977@cse.unsw.edu.au>
	<1116262011.13780.79.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Monday May 16
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 16, dledford@redhat.com wrote:
> On Sat, 2005-05-14 at 09:01 +1000, Neil Brown wrote:
> > 
> > So there are little things that could be done to smooth some of this
> > over, but the core problem seems to be that you want to use the output
> > of "--examine --scan" unchanged in mdadm.conf, and that simply cannot
> > work.
> 
> Well, also keep in mind that the documentation on mdadm touts the fact
> that is meant to be run without a config file.  I'm perfectly happy to
> do that, but -A mode combined with --scan mode only assembles and starts
> arrays in the config file.  As I mentioned in a previous email, I guess
> I could do something like mdadm -Es | mdadm -c - -As -device=partitions
> but that just seems kinda silly given that all that is needed is for the
> assemble mode to start all devices found and we already know how to find
> them in the -E mode.  Maybe either changing -As mode to assemble
> everything regardless of config file or adding another flag to assemble
> mode to do the same.

It isn't meant to say that mdadm "Should" be run without a config
file.  Just that mdadm "can" be run without a config file, in stark
contrast to raidtools that requires a config file even for stopping an
array.   Maybe I should tone down that part of the man page.

I don't like having a "blindly start everything" function for mdadm
for exactly the same reason as I don't like the in-kernel
"autodetect".   It is too easy for things to go wrong.

Suppose I have two computers with raid arrays.  One dies so I shut
down the other, plug all drives into the working one, and bring it up
again.
A "blindly start everything" function could get confused and pick the
wrong array to be the root filesystem, or hit other snags.

That is why in my previous email with my example for version-1 usage I
included a host name in the "set_name".  Hopefully the
start-everything script would have access to a host name (via dhcp or
command line or something) and would get that scenario right.

I really DON'T WANT people to
  mdadm -Es | mdadm -c - -As -device=partitions

I want them to
  mdadm -Es >> /etc/mdadm.conf
  edit /etc/mdadm.conf
    think about what should be there

just as they
   edit /etc/fstab
     think about what should be there.

Is that unreasonable?

NeilBrown
