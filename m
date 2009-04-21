From: Luca Berra <bluca@comedia.it>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Tue, 21 Apr 2009 09:06:02 +0200
Message-ID: <20090421070602.GB13520@maude.comedia.it>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <20090417070841.GA29681@boogie.lpds.sztaki.hu> <18924.1768.721791.765727@notabene.brown> <20090421063401.GB23231@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090421063401.GB23231@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Apr 21, 2009 at 08:34:01AM +0200, Gabor Gombas wrote:
>On Mon, Apr 20, 2009 at 03:23:52PM +1000, Neil Brown wrote:
>
>> How does LVM manage metadata???  I assume it stored the metadata on
>> the device.  Which is what mdadm does.
>
>It stores a backup of the metadata under /etc after every changes it
>makes. It is like if "mdadm --create" have automatically added the array
>to /etc/mdadm.conf etc.
that could be interesting (automatically updating mdadm.conf on create,
maybe via an option)

>> But as devices can move between machines.....
>
>With LVM, moving a volume group means running
>vgchange/vgexport/pvscan/vgimport/vgchange, so it's not like "it just
>works". So if there are any name conflicts, you must explicitely run
>vgrename before the new VG can be activated.
yes, but vgexport/vgimport is optional, and the target audience for
array mobilit don't want to export the array before moving, they just
want to unplug it from a and replug into b.

>> > How about introducing /dev/md/by-uuid/... (or similar) and teaching
>> > people that if they want to transparently carry their arrays from one
>> > host to another, then they should always refer to it by UUID?
>> 
>> This already exists, though it might be distro-dependant.
>>   /dev/disk/by-id/md-uuid-xxxxx
>
>But that requrires the MD device to already be present therefore does
>not help solving the name clash issue.
>
>What I propose is that "mdadm --assemble" should accept "UUID=..."
>instead of the MD device name. Then mdadm could ignore the
>name/homehost, and create the device node with a name
>(/dev/md/by-uuid/...) that will never clash with arrays using
>traditional names.

i dont know how much we gain by hiding the md<minor> device, at least
while the kernel is not able to work completely without minors

see /proc/mdstat or /sys/block/md...

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
