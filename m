From: Luca Berra <bluca@comedia.it>
Subject: Re: Bug or not?  Same array reports different/transformed UUID
	depending on check-method used.
Date: Tue, 21 Jun 2011 07:42:58 +0200
Message-ID: <20110621054258.GA22391@maude.comedia.it>
References: <1308328189.28028.1464311105@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1308328189.28028.1464311105@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 17, 2011 at 09:29:49AM -0700, jeffs_linux@123mail.org wrote:
>I suppose I should split this into its own thread rather than burying it
>in my other.
>
>Question first:
>
>  I have two arrays attached to my Linux box.  Two methods of checking
>  for arrays UUIDs give different results.  Why, and can I reply on
>  these arrays?
>
>Details follow:
>
>Checking with,
>
> mdadm --incremental --rebuild-map
I don't think this is a valid method for checking array uuid.

> cat /dev/.mdadm/map
>  md126 0.90 52f5b43c:e83f7e2a:be6ad32e:0536ab0e /dev/md/0_0
>  md127 1.2  79fb7ad4:289bfae5:86c535ff:202960f2 /dev/md127
>
>Staring at those UUIDs, I notice that one array's UUIDs match exactly
>for the two methods of checking,
>
> /dev/.mdadm/map       /dev/md/0_0  52f5b43c:e83f7e2a:be6ad32e:0536ab0e
> mdadm --detail --scan /dev/md/0_0  52f5b43c:e83f7e2a:be6ad32e:0536ab0e
>
>but the OTHER array's two UUIDs
>
> /dev/.mdadm/map       /dev/md127   79fb7ad4:289bfae5:86c535ff:202960f2
> mdadm --detail --scan /dev/md127   d47afb79:e5fa9b28:ff35c586:f2602920
>
>are 'transforms' of one another; e.g.,
...
>Why are /dev/md127's UUIDs, unlike /dev/md/0_0's, reporting mis-matched
>& 'transformed'?
>
mdadm internally stores an uuid as an array of four 32bit integers
on disk it is different.
superblock version 0 (md0_0) stores 4 32bit values in host endian order(*)
(little-endian on x86)
superblock version 1 (md127) stores 16 8bit values in human readable
format (humans at least in western world countries are big endian)

The map_file, on the contrary, is always read and written as 4 32bit
values in host endian order, so on x86 machines you will find it
swapped.

Summary: the mapfile is for mdadm internal use only, use mdadm commands
(--detail, --examine) to obtain data.

(*) http://en.wikipedia.org/wiki/Endianness


L.

-- 
Luca Berra -- bluca@comedia.it
