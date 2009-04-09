From: Doug Ledford <dledford@redhat.com>
Subject: Re: mdadm udev rules change
Date: Thu, 9 Apr 2009 15:20:50 -0400
Message-ID: <A9A53B64-720E-48DF-8377-5FCFDA2D6A7A@redhat.com>
References: <3B6F676A-5ADD-4741-8269-D7D655C4E21E@redhat.com> <18908.21182.706667.310243@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-72--995354775"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18908.21182.706667.310243@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-72--995354775
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 8, 2009, at 3:31 AM, Neil Brown wrote:
> On Monday April 6, dledford@redhat.com wrote:
>> I'm not attaching a patch for this because it's so simple.  Long  
>> story
>> short, watching both add and change events in udev rules is bad for  
>> md
>> devices.  Specifically, the kernel will generate a change event on
>> things like array stop, and on things like fdisk close.  In the case
>> of array stop, it can result in the array being assembled again
>> immediately.  In the case of fdisk close, the situation is worse.
>> Let's say you stop all the md devices on some block device in order  
>> to
>> repartition.  You run fdisk, change the partition table, then issue a
>> write of the table.  The write of the table triggers the change event
>> *before* the kernel updates the partition table in memory for the
>> block device, causing udev to rerun the incremental rules on the old
>> partition table and restart all the arrays you just stopped with the
>> old partition table layout, at which point the kernel is unable to
>> reread the partition table.  So, once you've enable incremental
>> assembly, it becomes apparent that what we really want is to only
>> start devices on add, not on add|change.
>
> So you aren't really talking about events on md devices, but rather on
> events that might become components of md devices - correct?
> So in udev-md-raid.rules we currently have
> ....
> ACTION!="add|change", GOTO="md_end"
>
> # import data from a raid member and activate it
> #ENV{ID_FS_TYPE}=="linux_raid_member", IMPORT{program}="/sbin/mdadm  
> --examine --export $tempnode", RUN+="/sbin/mdadm --incremental  
> $env{DEVNAME}"
> # import data from a raid set
> KERNEL!="md*", GOTO="md_end"
> ......
>
> And you are saying that if we uncomment the "#ENV{...." line, then we
> only want it to fire on add devices.  So something like:
>
> ....
> ACTION!="add|change", GOTO="md_end"
> +ACTION=="change", GOTO="no_incr"
>
> # import data from a raid member and activate it
> #ENV{ID_FS_TYPE}=="linux_raid_member", IMPORT{program}="/sbin/mdadm  
> --examine --export $tempnode", RUN+="/sbin/mdadm --incremental  
> $env{DEVNAME}"
> # import data from a raid set
> +LABEL="no_incr"
> KERNEL!="md*", GOTO="md_end"
> ......
>
> Is that correct?
>
> Your explanation certainly seems reasonable.

As I was reading through this, I certainly thought the above  
implementation was reasonable, and then I got this new bug report:

https://bugzilla.redhat.com/show_bug.cgi?id=495034

So, mdadm-3.0-0.devel3.5 leaves the default udev rules file in place  
and only defines a little 70-mdadm-incremental.rules that only does  
the incremental assembly.  That file only watches for add events.  The  
earlier mdadm that the user says doesn't have the bug replaces the  
existing rules file entirely and uncomments the incremental part.   
Long story short, it would appear the add|change in the normal rules  
file is possible responsible for a long string of these:

# udevadm monitor
....
UDEV  [1239266575.473953] change   /devices/virtual/block/md5 (block)
UEVENT[1239266575.510739] change   /devices/virtual/block/md5 (block)
UDEV  [1239266575.516114] change   /devices/virtual/block/md5 (block)
UEVENT[1239266575.552984] change   /devices/virtual/block/md5 (block)
....

I would do some investigation on your own machines, but given udev  
change semantics, I think the proper course of action is simply to not  
watch changes.


--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-72--995354775
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAkneSpIACgkQQ9aEs6Ims9irdgCfbT8f3XqmdfG7f4cYYQ1P1fJn
ZMAAn2Fcswls6iNIBOkTF3XQNhAyILtn
=pVS3
-----END PGP SIGNATURE-----

--Apple-Mail-72--995354775--
