From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: RFC: use TRIM data from filesystems to speed up array rebuild?
Date: Tue, 04 Sep 2012 15:11:26 -0400
Message-ID: <5046525E.10500@gmail.com>
References: <50464322.3010509@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50464322.3010509@genband.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Friesen <chris.friesen@genband.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/04/2012 02:06 PM, Chris Friesen wrote:
>
> Hi,
>
> I'm not really a filesystem guy so this may be a really dumb question.
>
> We currently have an issue where we have a ~1TB RAID1 array that is mostly 
> given over to LVM.  If we swap one of the disks it will rebuild everything, 
> even though we may only be using a small fraction of the space.
>
> This got me thinking.  Has anyone given thought to using the TRIM information 
> from filesystems to allow the RAID code to maintain a bitmask of used disk 
> blocks and only sync the ones that are actually used?
>
> Presumably this bitmask would itself need to be stored on the disk.
>
> Thanks,
> Chris
>

Device mapper has a "thin" target now that tracks blocks that are allocated or 
free (and works with discard).

That might be a basis for doing an focused RAID rebuild,

Ric

