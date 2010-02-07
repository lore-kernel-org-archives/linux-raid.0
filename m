From: Neil Brown <neilb@suse.de>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Mon, 8 Feb 2010 10:06:03 +1100
Message-ID: <20100208100603.157a69fd@notabene.brown>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	<1263242294-5353-3-git-send-email-dledford@redhat.com>
	<20100119110930.107ca42e@notabene>
	<4B55F138.7060008@redhat.com>
	<20100204174009.6072ec07@notabene.brown>
	<4B6B15B3.8030205@redhat.com>
	<4B6F3B1D.9020008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B6F3B1D.9020008@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org, initramfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, martin f krafft <madduck@debian.org>, Michal Marek <mmarek@suse.de>, Bill Nottingham <notting@redhat.com>
List-Id: linux-raid.ids

On Sun, 07 Feb 2010 23:13:49 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

> Both of which is needlessly complicated and fragile. So as for as I'm concerned
> Fedora and the next RHEL will have these files under /dev. And if upstream
> does not want this, then we will just keep patching mdadm / mdmon to do this
> till the end of time. Note that /dev is already (ab)used in the same way
> for passing dhcp leases from the initramfs to the running system when / lives
> on a network device, and a few other state things which need to be passed
> between the initramfs and the real root.
> 
> Pretty? No but effective and simple, and anytime you have this state passing
> problem the most likely solution you will end up with, because it is
> KISS and KISS is good.


You admit that /dev is being abused, yet you seem proud of it.   Odd.  Maybe
I misunderstand.

Your dhcp lease example is perfect (thanks!) for demonstrating that something
is needed beyond devices.  i.e. some sort of generic place to pass files from
'before' and 'after' pivot root is needed.
The thing I like about /lib/init/rw is that it is clearly admitting this need
and trying to address it.  I have no particular attachment to the name (and
would much rather use /var/run!) but it is the honesty and forward thinking
that I like.
By contrast /dev/.udev seems dishonest (as it tries to hide) and not forward
thinking (as it appear to be udev specific).
If it was /dev/udev or /dev/UDEV it would be better.
If it was /dev/RUN/udev it would be better still.
Though I would really like the carry-over filesystem to be 
   /init
and it contain 'dev' and 'var/run' and anything else needed,
and after pivotroot, the interesting parts are bind mounted to their final
home.
   mount --bind /init/dev /dev


Yes.  "Keep it simple" is very important.  So is being generic and
forward-looking.  I haven't seen much evidence of being forward looking in
the various suggestions and reference examples that have been put forward.

Yes, the only difference among a lot of the options put forward is the name
of a directory.  Are names really so important.  Emphatically YES.  They
guide the way people think.  Bad names confuse people, good names educate
people.

So my leaning is still to default to the best name currently available which
seems to be /lib/init/rw, and to make it easy to choose a distro-specific
name at compile time.
