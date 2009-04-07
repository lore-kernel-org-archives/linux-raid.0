From: Luca Berra <bluca@comedia.it>
Subject: Re: [Patch] mdadm: move mdadm.map file into /dev/md
Date: Tue, 7 Apr 2009 12:55:21 +0200
Message-ID: <20090407105520.GA29222@maude.comedia.it>
References: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com> <87tz51dmmu.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87tz51dmmu.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Apr 07, 2009 at 08:05:29AM +0200, Goswin von Brederlow wrote:
>Doug Ledford <dledford@redhat.com> writes:
>
>> Originally, mdadm used /var/run/mdadm/mdadm.map file to store the
>> temporary mappings of incrementally added devices to device names.
>> Unfortunately, this breaks incremental assembly if used early in the
>> booting process.  Specifically, root may still be read only.  Since
>> incremental assembly is largely a udev specific feature, and udev
>> needs a writable /dev tmpfs mount even when root is still read only,
>> it's safer to put our mdadm.map file in /dev/md so that we can write
>> to the map file no matter how early in the boot process we are
>> attempting to use incremental assembly.
>
>What about /lib/init/rw?

What is that?, i never heard of '/lib/init/rw' before

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
