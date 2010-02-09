From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
	support handoff after pivotroot
Date: Mon, 8 Feb 2010 16:20:37 -0800
Message-ID: <4877c76c1002081620r77a39bes1ab139ad587f1f9b@mail.gmail.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	 <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com>
	 <20100204174009.6072ec07@notabene.brown> <4B6B15B3.8030205@redhat.com>
	 <e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>
	 <4B6DAC06.6060909@redhat.com>
	 <e9c3a7c21002061307le6f5d56ked4fa3711bdd2367@mail.gmail.com>
	 <4B702EA5.3030103@redhat.com> <20100209083838.6568cac0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100209083838.6568cac0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, initramfs@vger.kernel.org, martin f krafft <madduck@debian.org>, Michal Marek <mmarek@suse.de>, Hans de Goede <hdegoede@redhat.com>, Bill Nottingham <notting@redhat.com>
List-Id: linux-raid.ids

On Mon, Feb 8, 2010 at 1:38 PM, Neil Brown <neilb@suse.de> wrote:
> On Mon, 08 Feb 2010 10:32:53 -0500
> Doug Ledford <dledford@redhat.com> wrote:
>
>> On 02/06/2010 04:07 PM, Dan Williams wrote:
>>
>> > This comment makes me see Neil's argument in a different light,
>> > (hopefully I am not mischaracterizing it), but essentially we are
>> > waiting for the standards to catch up with this new class of progr=
am.
>> > FUSE, CUSE, and mdmon belong to a class of programs that move
>> > traditionally exclusive kernel space functionality to userspace.
>> > Debian's /lib/init/rw looks to be a response to this grey area of =
the
>> > standards (not that I have any familiarity with the LSB).
>>
>> So if we want to argue that the standards are simply behind the time=
s,
>> and we need to do something that makes sense regardless of the
>> standards, then I don't think anything in /dev or /lib makes sense. =
=A0The
>> files that need to be created pre-rw-root are varied in their type a=
nd
>> purpose between different things. =A0What we really need is simply a=
n
>> early boot /tmp area. =A0So, why not make a top level directory that
>> clearly delineates this nature? =A0Something like /pre-init or /earl=
y-tmp
>> or whatever? =A0Or possibly /tmp/pre-boot or /tmp/pre-init or
>> /tmp/pre-pivot-root (the pre-pivot-root naming is awfully linux
>> specific, so maybe /tmp/pre-init or /tmp/pre-boot would be better fo=
r
>> possible standards acceptance later)? =A0I was thinking that mdmon's=
 files
>> would be stuck there, but then I remembered that we are doing option=
 #3
>> for mdmon, restarting after the system is up and running, so only th=
e
>> mdmon instances from the initramfs would put their files there, the
>> final ones would be on the real /var/run area. =A0So, since as far a=
s I
>> know the mdmon .sock files were the only pre-boot files that couldn'=
t be
>> moved later (but effectively get moved by restarting mdmon after r/w
>> /var/run), any and all files in /tmp/pre-pivot-root should be remove=
d
>> once the system is up and running, and quite possibly the filesystem
>> could be entirely done away with. =A0At least then the naming would =
be to
>> Neil's satisfaction I think, and mine. =A0And personally, when the
>> standards are simply behind the times, I have no problem blazing ahe=
ad
>> and letting them catch up when they get off their asses.
>>
>>
>
> That's the spirit!!!
> Let's figure out what we really want/need, and just do it.
>
> Following my recent discovery that mdmon prevents /var from being unm=
ounted
> at shutdown, I wonder if we really want something generic that persis=
ts from
> very early boot to very late shutdown, rather than just the early-boo=
t part.
> So something like /var/run, but not dependent on /var and guaranteed =
to be
> in-memory (or swap) and created very early by initramfs.
>
> =A0 /run
> ???
> Trivial implementation for most distros would be to make it a symlink
> to /dev/run.
>
> I would prefer a name a little more descriptive than "/run" - somethi=
ng that
> reflects the idea that it is particularly for early-boot or late-shut=
down -
> but nothing comes to mind.
>
> I could probably actually live with "/dev/run" as the permanent home =
for the
> mdmon files: =A0/dev/run/mdmon/*.{sock,pid}
> It addresses most of the issues I had with the original suggestion (h=
idden
> files, non-generic approach) so the "cons" are weaker. =A0And I now u=
nderstand
> the "pros" better (races with cleaning /var/run, issues with unmounti=
ng /var
> etc).
>
> Anyone second the motion?
>
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

What about systems that have only devices known at compile/create time
and thus might be created with a fully static /dev for extra
simplicity.  We should not simply expect that /dev is read-write as a
system requirement.  This is one reason why my previous solutions
suggested using a known area and symlinking in an implementation
defined way that mdadm/mdmon didn't need to know about.

Maybe a good name for it is '/state' as in system state information.
It would be reasonable to expect it to be a ram/swap backed filesystem
for SMALL files to exist as a user-space state area for various
daemons and such.

However any information in there which is also potentially useful to
in-kernel code should probably be re-located to an entry exposed via
sysfs.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
