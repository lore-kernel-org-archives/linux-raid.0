From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: Multiple disk failure, but slot numbers are corrupt and preventing assembly.
Date: Tue, 24 Apr 2007 14:44:18 +0200
Message-ID: <c384c5ea0704240544vd15e939kdf46bd75d341f30a@mail.gmail.com>
References: <c384c5ea0704231017i2fd01aceva845a2f61f0aae3@mail.gmail.com>
	 <462CF303.6030004@dgreaves.com>
	 <c384c5ea0704240004r176372e1nb384c06e558dd1f@mail.gmail.com>
	 <c384c5ea0704240017m6963deet58b28b67377e8f91@mail.gmail.com>
	 <462DC0B0.9010105@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <462DC0B0.9010105@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David,

thanks for all the advice so far.

On 4/24/07, David Greaves <david@dgreaves.com> wrote:
> Leon Woestenberg wrote:
> > On 4/24/07, Leon Woestenberg <leon.woestenberg@gmail.com> wrote:
> >> Hello,
> >>
> >> On 4/23/07, David Greaves <david@dgreaves.com> wrote:
> >> > There is some odd stuff in there:
> >> >
> >> [root@localhost ~]# mdadm -v --assemble --scan
> >> --config=/tmp/mdadm.conf --force
> >> [...]
> >> mdadm: no uptodate device for slot 1 of /dev/md0
> >> mdadm: no uptodate device for slot 2 of /dev/md0
> >> [...]
> >>
> > So, the problem I am facing is that the slot number (as seen with
> > --examine) is invalid on two and therefore they won't be recognized as
> > valid drives for the array.
> >
> > Is there any way to override the slot number? I could not find
> > anything in mdadm or mdadm.conf to override them.
> Yes --create, see my original reply.
>
> Essentially all --create does is create superblocks with the data you want (eg
> slot numbers). It does not touch other 'on disk data'.
> It is safe to run the *exact same* create command on a dormant array at any time
> after initial creation - the main side effect is a new UUID.
> (Neil - yell if I'm wrong).
>
In first instance we were searching for ways to tell mdadm what we
know about the array (through mdadm.conf) but from all advice we got
we have to take the 'usual' non-syncing-recreate approach.

We will try to make disk clones first. Will dd suffice or do I need
something more fancy that maybe copes with source drive read errors in
a better fashion?

Thanks,
-- 
Leon
