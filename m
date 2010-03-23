From: Luca Berra <bluca@comedia.it>
Subject: Re: [PATCH] (Re: Questions regarding startup of imsm container)
Date: Tue, 23 Mar 2010 15:22:11 +0100
Message-ID: <20100323142211.GA10484@maude.comedia.it>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com> <20100323080419.GA9374@maude.comedia.it> <7db987b31003230558l5993817fwb283c66bbf3633e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7db987b31003230558l5993817fwb283c66bbf3633e9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 23, 2010 at 06:58:33AM -0600, Randy Terbush wrote:
>On Tue, Mar 23, 2010 at 2:04 AM, Luca Berra <bluca@comedia.it> wrote:
>>> # mdadm --version
>>> mdadm - v3.1.2 - 10th March 2010
>>>
>>> # mdadm -Es
>>> ARRAY metadata=imsm UUID=30223250:76fd248b:50280919:0836b7f0
>>> ARRAY /dev/md/Volume0 container=30223250:76fd248b:50280919:0836b7f0
>>> member=0 UUID=8a4ae452:da1e7832:70ecf895:eb58229c
>>>
>>> # ls -l /dev/md/
>>> total 0
>>> lrwxrwxrwx 1 root root 6 Mar 22 20:54 0 -> ../md0
>>> lrwxrwxrwx 1 root root 8 Mar 22 20:54 127 -> ../md127
>>> lrwxrwxrwx 1 root root 8 Mar 22 20:54 Volume0_0 -> ../md127
>>>
>>> As you can see, the name for the link in /dev/md does not agree with
>>> the name that the Examine is coming up with.
>>
>> please read mdadm.conf manpage, under the section "HOMEHOST"
>
>If I understand this correctly, I think there still may be a problem
>as I am not clear on how I could have set the homehost in the metadata
>for this imsm array. The Volume0 is provided by imsm and is configured
>in the option ROM.
>
>The underlying question here is should the ARRAY entry in mdadm.conf
>be changed to reflect the on disk name of the device, or is the
>startup process munging that entry when it processes mdadm.conf to
>strip the _0.

As far as i understand there is no way to set the homehost into imsm
metadata, so auto_assembly will consider the array a foreign one and
append _x to it.

>I'll try setting HOMEHOST <ignore> to see if I am getting expected results.
>
>I seem to have some problems with startup still as I have the
>following entry where the container is now md127. Was md0 when
>originally created.

i believe this also is normal, since there is no place in imsm metadata
to store a persistent minor.

># cat /proc/mdstat
>Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
>md126 : active raid5 sdb[3] sdc[2] sdd[1] sde[0]
>      2930280448 blocks super external:/md127/0 level 5, 64k chunk,
>algorithm 0 [4/4] [UUUU]
>
>md127 : inactive sde[3](S) sdb[2](S) sdc[1](S) sdd[0](S)
>      9028 blocks super external:imsm
>
>unused devices: <none>

personally i did never care, since i mount all fs by uuid so auto
assembly works for me.
you could try defining the array in mdadm.conf, in this case it should
not be considered foreign any more and it will be named Volume0.

>I am also running into a problem where fsck will crash during boot on
>the ext4 filesystems that this array contains. No problem running fsck
>after the boot process has completed so have not seemed to find the
>magic with order of startup for this device.
no idea about that, sorry

L.


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
