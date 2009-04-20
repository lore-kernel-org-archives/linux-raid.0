From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Mon, 20 Apr 2009 16:08:00 +1000
Message-ID: <18924.4416.635979.452887@notabene.brown>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com>
	<cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com>
	<18899.61151.445765.360191@notabene.brown>
	<51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com>
	<18919.64597.426128.498393@notabene.brown>
	<D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
	<20090418081239.GB2124@maude.comedia.it>
	<F43DC4EB-8E83-4284-A2BE-85EF146AE956@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Saturday April 18
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Luca Berra <bluca@comedia.it>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Saturday April 18, dledford@redhat.com wrote:
> 
> I've been thinking about this, and this is the method I would suggest.
> 
> Add two new keywords to the mdadm.conf file:
> 
> ASSEMBLE
> INCREMENTAL
> 
> Allow each of those keywords to have one of three set values:
> None - Don't attempt to assemble any arrays regardless of whether or  
> not they are in the mdadm.conf file or not
> Known - Only assemble arrays with a matching array line
> All - Attempt to assemble any array found
> 
> The combination of the two options and the three settings would allow  
> you to control mdadm behavior for both array assembly modes  
> independently.  That, combined with my previous patch, should allow  
> arrays to assemble well, with known names, allow you to control auto  
> assembly by udev, and in the event that your machine just exports  
> volumes to other machines for their use, stop assembly entirely.

Why "None"??  Why would you use "None" rather than "Known" with an
empty list of arrays?

Why have two options: ASSEMBLE and INCREMENTAL ??
If what circumstance would you use different settings for these two
options.

I current have two patches sitting in my scratch queue.  I am by no
means committed to them.

One allows you to have e.g.

  ARRAY ignore UUID=foo:bar:dead:beef

with the meaning that auto-assembly will ignore that array.  If you
run

  mdadm --assemble /dev/md/thing --uuid foo:bar:dead:beef

it will still assemble the array, but any auto-assembly will ignore
it.

The other allows you to say:

 AUTO -ddf -0.90 +all

which means don't auto-assemble any 'ddf' or '0.90' array, but do
auto-assemble anything else that is recognised.
You might want to use dmraid for ddf??

If you just have

  AUTO -all

then it won't auto-assemble anything, which is much like your
  ASSEMBLE  Known
  INCREMENTAL Known

NeilBrown
