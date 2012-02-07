From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: imsm raid is always readonly on boot
Date: Tue, 07 Feb 2012 17:09:32 +0100
Message-ID: <4F314CBC.8010102@redhat.com>
References: <4F3111D9.2060303@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3111D9.2060303@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/07/12 12:58, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> i'm running 3.0.18 as kernel (renamed to 2.6.40) and mdadm 3.2.2.
> 
> I'm trying to get an intel fake raid running but it is always set to
> readonly on boot after running
> mdadm --assemble --scan --run --force --auto=yes
> 
> But i've absolutely no idea why.
> 
> My mdadm.conf:
> # by default (built-in), scan all partitions (/proc/partitions) and all
> # containers for MD superblocks. alternatively, specify devices to scan,
> using
> # wildcards if desired.
> #DEVICE partitions containers
> 
> # auto-create devices with Debian standard permissions
> CREATE owner=root group=disk mode=0660 auto=yes
> 
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <ignore>
> 
> # instruct the monitoring daemon where to send mail alerts
> MAILADDR root
> 
> # definitions of existing MD arrays
> ARRAY metadata=imsm UUID=24cdb70d:101f4c4b:23dfa5cb:3f176b6a
> ARRAY /dev/md126 container=24cdb70d:101f4c4b:23dfa5cb:3f176b6a member=0
> UUID=84aa9982:ed593d80:ee7c7f53:e2944038
> 
> 
> ~# cat /sys/block/md126/md/array_state
> readonly
> 
> What's wrong? Thanks!

/dev/md126 looks to be the container, not the actual raid device, from
what your mdadm.conf says.

What does your /proc/mdstat say?

Cheers,
Jes

