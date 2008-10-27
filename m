From: "Joe Landman" <joe.landman@gmail.com>
Subject: Re: question on how to (correctly) build an initrd for a root disk on a RAID1
Date: Mon, 27 Oct 2008 14:08:49 -0400
Message-ID: <9f5edc120810271108s3a42b318k4029fe65e752ee91@mail.gmail.com>
References: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com>
	 <20081027071613.GA8197@maude.comedia.it>
	 <9f5edc120810270534j3d969d2s18c1017755990c30@mail.gmail.com>
	 <4905EE05.9070108@redhat.com>
	 <1225130177.26510.3.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1225130177.26510.3.camel@firewall.xsintricity.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Brendan Conoboy <blc@redhat.com>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Oct 27, 2008 at 1:56 PM, Doug Ledford <dledford@redhat.com> wrote:
> On Mon, 2008-10-27 at 10:36 -0600, Brendan Conoboy wrote:
>> Joe Landman wrote:

[...]

> Keep in mind that mkinitrd senses what it needs to boot the machine from
> the currently running setup.  So, if you run mkinitrd with a root raid
> array, it should detect that it needs to start the md raid device, copy
> mdadm.static and mdadm.conf to the initrd, and add the appropriate lines
> to the initrd script.  If you aren't running the md raid array (maybe

It did not copy mdadm.static or mdadm.conf.  Interesting.  I added the
"-x" argument, and
instrumented the handleraid function so I could see what it was doing.
 It looks like I
have to dig into this deeper.

> it's a raid1 and you just mounted a bare member long enough to create an
> initrd for instance), then it won't.  But, since the system works with a
> centos provided kernel, and not with the custom kernel, I'm guessing
> that this isn't the issue, that mkinitrd is just fine, and instead the
> custom kernel's config is somehow fubar'ed and that's what's causing all
> the problems.

Hmmm... not likely.  My rationale for that is that the same kernel
(identical .config) runs perfectly
in this mode (software RAID1) on a Ubuntu/Debian machine (the exact
same machine, e.g. same physical hardware, different OS load, as it
turns out).  Moreover, this kernel has been in production for months
at many  sites with nary a peep as to problems (it actually solves
other problems for users with stock kernels).

Will dig into this more, and let people know what I find.  It seems
the consensus is that there should be an mdadm.conf and mdadm.static
in the initrd, and I'll see if the mkinitrd generates this correctly
or not.  Note that I didn't see this in the default initrd, I will
look again.



>
> --
> Doug Ledford <dledford@redhat.com>
>              GPG KeyID: CFBFF194
>              http://people.redhat.com/dledford
>
> Infiniband specific RPMs available at
>              http://people.redhat.com/dledford/Infiniband
>
>
