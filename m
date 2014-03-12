From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Linux software-RAID and bootloader
Date: Wed, 12 Mar 2014 10:49:04 -0600
Message-ID: <01893F58-0959-4CAF-AAD6-09467D565A23@colorremedies.com>
References: <CAJx5YvGGM7yziWQEefs=_Wte4jy13w1x1oG6MuUOggSgTfodMQ@mail.gmail.com> <67153819-285E-430A-A745-A96D6ECDA4DB@colorremedies.com> <CAJx5YvF7t=suX8jzQso4cjPPqFgCgBDXiop9i47F+C2A2KtR=g@mail.gmail.com> <20C9589F-7F5F-49D0-916E-9A6AA6B833BA@colorremedies.com> <CAE6VuKH2E0rMVZAg8ugjR8BRmknyUNS_D8EOOr4UjBbFsuVeOg@mail.gmail.com> <4C7B5B3C-5603-4346-BDDC-40ABBB2CD45E@colorremedies.com> <CAJx5YvEtPip5P-y_bnn5hebGnJ97hwBSyww3tq4BB=rAreMgLQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJx5YvEtPip5P-y_bnn5hebGnJ97hwBSyww3tq4BB=rAreMgLQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin T <m4rtntns@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mar 12, 2014, at 10:06 AM, Martin T <m4rtntns@gmail.com> wrote:

> Chris,
> 
> thank you for a good explanation! However, if I use
> partitions(/dev/sda1, /dev/sdb2, etc) as block devices and thus write
> mdadm metadata v1.2 not to gap after the MBR, but to an area from 4KB
> from the beginning of the partition, then how is it ensured that I
> don't overwrite anything?

There is no assurance, you have to know that the partition you're writing to doesn't already contain information you want to keep. Creating an array is usually a destructive process.

Upon creation of the array, it appears as a logical block device with a designation, e.g. /dev/md0. That's what you format, and that's what you write data to. Yes if you write directly to the member of an array it's bad news for either the mdadm metadata or portions of your data, or both, so don't write to member devices again.


> I mean mdadm isn't using regular OS calls
> for writing data to file-system, is it?

No. The kernel md driver operates as a layer in between the SCSI block device layer and the file system. So simplistically from top to bottom: application, application libraries, file system, md, SCSI/libata, controller, drive.

> I understand that it writes
> this metadata similarly to dd utility and doesn't understand if it's
> overwriting any files or not?

I think it'll sense certain existing data and ask if you really want to proceed, but that's a gift if it does. By the way make sure you save your mdadm create command somewhere safe, if you ever have a problem down the road it's a good idea to know what command was used in case metadata is somehow overwritten.

> Or the other way around, if I create a
> file-system(for example ext3 or ext4), then how does the mke2fs
> utility know that it should not use the area at the beginning of the
> partition?

Because you don't use mkfs on those partitions. You mkfs on the md device. That md device isn't exactly the same size as adding up all sectors from all members, it's slightly smaller to account for the metadata areas, and an optional internal bitmaps. Those things aren't accessible, and can't be overwritten, from the md device, e.g. /dev/md0. They only exist on the member devices, e.g. /dev/sda1, /dev/sdb1, etc.


Chris Murphy

