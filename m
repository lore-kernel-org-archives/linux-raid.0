From: Luca Berra <bluca@comedia.it>
Subject: Re: md autodetection
Date: Mon, 21 Mar 2005 20:01:29 +0100
Message-ID: <20050321190129.GB27541@percy.comedia.it>
References: <423E8094.7050809@netuse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <423E8094.7050809@netuse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 21, 2005 at 09:06:44AM +0100, Nils-Henner Krueger wrote:
>I've got a few questions about raid autodetection at boot time.

i usually have a single answer, don't use it.
but i see you are struck with rh, so...


>To use a mirrored boot device, I have to use raid autodetection
>to have the md devices running early enough?
yes

>To have autodection recognise a disk device, it has to run after
>the appropriate device driver, right?
yes

>In my current setup, running RHEL3 with kernel 2.4.21, I have
>the system installed on a scsi disk. The scsi driver ist loaded
was that an _is_ or an _isn't_ ???

>as module and added to the initrd.
>Currently raid autodection takes place long before the scsi
>device driver is loaded:
redhats' mkinitrd reruns autodetection after module loading.
....

>Is there a way to run raid autodection (again?) later in the
>boot sequence to detect not only IDE devices but other things
>like scsi, too?

you better use mdadm instead.
i even wrote a tool, mdassemble which is shipped with mdadm and is
suited for replacing autodetection in initrds.

>Last question:  :-)
>Is it possible to make a distinction between some md-devices which
>should be detected and started by raid autodetection and others which
>should be left untouched?
autodetection only considers type fd partition, mdadm and raidstart
don't actually care.



-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
