From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: Multiple disk failure, but slot numbers are corrupt and preventing assembly.
Date: Fri, 27 Apr 2007 01:36:49 +0200
Message-ID: <c384c5ea0704261636r216d8ed6w6bf961f044e3caa6@mail.gmail.com>
References: <c384c5ea0704231017i2fd01aceva845a2f61f0aae3@mail.gmail.com>
	 <462CF303.6030004@dgreaves.com>
	 <c384c5ea0704240004r176372e1nb384c06e558dd1f@mail.gmail.com>
	 <c384c5ea0704240017m6963deet58b28b67377e8f91@mail.gmail.com>
	 <462DC0B0.9010105@dgreaves.com>
	 <c384c5ea0704240544vd15e939kdf46bd75d341f30a@mail.gmail.com>
	 <462FD6AF.3070403@tmr.com> <46310198.8090503@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46310198.8090503@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

On 4/26/07, David Greaves <david@dgreaves.com> wrote:
> Bill Davidsen wrote:
> > Leon Woestenberg wrote:
> >> We will try to make disk clones first. Will dd suffice or do I need
> >> something more fancy that maybe copes with source drive read errors in
> >> a better fashion?
> >
> > Yes to both. dd will be fine in most cases, and I suggest using noerror
> > to continue after errors, and oflag=direct just for performance. You
> > could use ddrescue, it supposedly copes better with errors, although I
>

OK, despite that we missed a deadline to present the on-disk data by
one day, one of my colleagues flew in to the remote machine,
dd_rescue'd four 500 GB disks to clones, cloned them again at the lab,
then did the 'mdadm create force missing' approach. Everything mounted
read-only cleanly and we could extract the data.

Thanks for helping us out on the details (Specify missing to not sync,
and --force to prevent spares, dd_rescue instead of dd). Especially
helping understand what happens at each step is precious.

Next time we will be more confidently doing this over SSH directly on
the subject, unless data recovery has highest priority and we take the
disk-over-airplane approach.

Kudo's!

Regards, Leon.
