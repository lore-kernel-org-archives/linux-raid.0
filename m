From: Luca Berra <bluca@comedia.it>
Subject: Re: [Patch] mdadm: move mdadm.map file into /dev/md
Date: Mon, 6 Apr 2009 21:36:04 +0200
Message-ID: <20090406193604.GB18829@maude.comedia.it>
References: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Apr 06, 2009 at 10:52:10AM -0400, Doug Ledford wrote:
> Originally, mdadm used /var/run/mdadm/mdadm.map file to store the temporary 
> mappings of incrementally added devices to device names.  Unfortunately, 
> this breaks incremental assembly if used early in the booting process.  
> Specifically, root may still be read only.  Since incremental assembly is 
> largely a udev specific feature, and udev needs a writable /dev tmpfs mount 
> even when root is still read only, it's safer to put our mdadm.map file in 
> /dev/md so that we can write to the map file no matter how early in the 
> boot process we are attempting to use incremental assembly.
>


since we are at it, what about using a #define for the file path?

L.




-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
