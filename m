From: "Joe Landman" <joe.landman@gmail.com>
Subject: Re: question on how to (correctly) build an initrd for a root disk on a RAID1
Date: Tue, 28 Oct 2008 22:49:27 -0400
Message-ID: <9f5edc120810281949w477fb376l6ca1b6e96bb6f791@mail.gmail.com>
References: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com>
	 <20081027071613.GA8197@maude.comedia.it>
	 <9f5edc120810270534j3d969d2s18c1017755990c30@mail.gmail.com>
	 <20081028064354.GD7764@percy.comedia.it>
	 <9f5edc120810280520i3ff4855fne765069beeca27e9@mail.gmail.com>
	 <9f5edc120810281842q7421ea92of6c466693f8f5b7f@mail.gmail.com>
	 <9f5edc120810281903y67c0b56eia869d76cfa048ce3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9f5edc120810281903y67c0b56eia869d76cfa048ce3@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 28, 2008 at 10:03 PM, Joe Landman <joe.landman@gmail.com> wrote:
> On Tue, Oct 28, 2008 at 9:42 PM, Joe Landman <joe.landman@gmail.com> wrote:
>> Update:
>
> capture is at http://pastebin.com/f57b6ba19  .  I think I see part of
> the problem

Update 2: It appears that the issue is a buggy mkinitrd.  v5.1.19.6-28
does not put the mdadm.conf into the initrd, and may rely upon
something being built into the kernel that our kernel did not have
built in.

Replacing this mkinitrd with 6.0.19-4 (by doing lots of rpmbuild 's
against FC8/9 packages and installing), we did in fact see the
mdadm.conf get explicitly added in during the mkinitrd.

/sbin/mdadm -> /tmp/initrd.Jz3686/sbin/mdadm
/etc/mdadm.conf -> /tmp/initrd.Jz3686/etc/mdadm.conf

Upon reboot, it works.

[root@jackrabbitm ~]# uname -r
2.6.23.14
[root@jackrabbitm ~]# mount
/dev/md0 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
tmpfs on /dev/shm type tmpfs (rw)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)

[root@jackrabbitm ~]# rpm -qa | grep -i mkinitrd
mkinitrd-devel-6.0.19-4
mkinitrd-6.0.19-4

While this works, this is not a solution I want to hand to our
users/customers.  Could someone toss me a pointer as to who owns
mkinitrd at RHEL/Centos so I can report this?  Basically this is not a
linux-raid bug, but a bug in the mkinitrd assumptions (or possibly
something that needs to be built into the kernel which is not
explicitly indicated in mkinitrd).

Thanks for all the pointers/suggestions.
