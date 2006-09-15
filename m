From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: libata hotplug and md raid?
Date: Fri, 15 Sep 2006 21:38:05 +0200
Message-ID: <c384c5ea0609151238v52e348f1m31eb8d26f31adabb@mail.gmail.com>
References: <c384c5ea0609130311t4005e5aam153251fc6bbbdfb8@mail.gmail.com>
	 <4507E2A9.7070306@emc.com> <4507E641.7090508@gmail.com>
	 <c384c5ea0609140524ofed0dd8v6f1b89a6b4d67f75@mail.gmail.com>
	 <20060914232304.GB2616@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060914232304.GB2616@suse.de>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Tejun Heo <htejun@gmail.com>, Ric Wheeler <ric@emc.com>, linux-raid@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Hello all,

On 9/15/06, Greg KH <gregkh@suse.de> wrote:
> On Thu, Sep 14, 2006 at 02:24:45PM +0200, Leon Woestenberg wrote:
> > On 9/13/06, Tejun Heo <htejun@gmail.com> wrote:
> > >Ric Wheeler wrote:
> > >> Leon Woestenberg wrote:
> > >>> In short, I use ext3 over /dev/md0 over 4 SATA drives /dev/sd[a-d]
> > >>> each driven by libata ahci. I unplug then replug the drive that is
> > >>> rebuilding in RAID-5.
> > ...
> > So the question remains: How will hotplug and md work together?
> > ...
> > How does md and hotplug work together for current hotplug devices?
>
> The answer to both of these questions is, "not very well."  Me and Kay
> have been talking with Neil Brown about this and he agrees that it needs
> to be fixed up.  That md device needs to have proper lifetime rules and
> go away proper.  Hopefully it gets fixed soon.
>

I will try to catch any kernel work on this so that I can pick it up
for testing.

For the moment, I'll try to make this work as best as possible using
udev rules and userspace (mdadm). I suppose I can act on both unplugs
and plugs, both before and after the event, is that true?

Regards,

Leon Woestenberg.

-- 
Leon
