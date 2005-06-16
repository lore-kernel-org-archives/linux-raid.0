From: Harry Mangalam <hjm@tacgi.com>
Subject: Re: Smart and SATA with FC4
Date: Thu, 16 Jun 2005 10:51:27 -0700
Message-ID: <200506161051.27648.hjm@tacgi.com>
References: <42B1A8EB.6060805@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42B1A8EB.6060805@ucolick.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Patrik Jonsson <patrik@ucolick.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

on the unpatched kernel, have you tried forcing the smartctl to see the disks 
as ATA devices:

smartctl -a -d ata /dev/sd[etc]
            ^^^^^^
Using Ubuntu's 2.6.10-5-amd64-generic (unsure if it has been patched), I was 
surprised that this worked great, including being able to force long tests to 
the disks.

harry (my mileage DOES vary) mangalam


On Thursday 16 June 2005 9:29 am, you wrote:
> Hello all,
>
> I just installed a machine running Fedora Core 4 x86_64
> (2.6.11-1.1369_FC4 kernel) and I'd like to get smartmontools to work
> with my 8-drive SATA array. According to the smartmontools web page and
> previous emails in this list you have to patch
> the kernel, so I got the patch called "2.6.11-libata-dev1.patch.gz"
> from the libata-dev patchset web page and I'm trying to apply it, but
> the patching fails and even after I (think) that I've manually resolved
> the problems, the kernel won't compile.
>
> Can some kind soul outline the sequence of events necessary to patch the
> kernel and get it to work? I've tried both smartmontools 5.32 and 5.33.
> Is one or the other necessary? Or maybe the problem is the FC4 kernel,
> which already has a bunch of patches applied?
>
> Thanks,
>
> /Patrik Jonsson
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Cheers, Harry
Harry J Mangalam - 949 856 2847 (vox; email for fax) - hjm@tacgi.com 
            <<plain text preferred>>
