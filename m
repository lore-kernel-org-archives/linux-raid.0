From: David Dougall <davidd@et.byu.edu>
Subject: Re: Nearest mdadm equivalent of kernel RAID autostart code?
Date: Fri, 21 Jan 2005 10:01:26 -0700 (MST)
Message-ID: <Pine.LNX.4.58.0501210952480.23996@lewis.et.byu.edu>
References: <csra7t$21h$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <csra7t$21h$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matthew Bloch <matthew@bytemark.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I came up with a small script that I used a while back.  I don't have it
now.  It looked something like:
echo "DEVICE partitions" > /etc/mdadm.conf
mdadm -Ebsc partitions >> /etc/mdadm.conf
mdadm -A --scan

--David Dougall



On Fri, 21 Jan 2005, Matthew Bloch wrote:

> Hi there,
>
> After a lot of compiling static kernels, I'm building a generic one for our
> particular mix of servers, so the md code is now modular.  I didn't realise
> that I'd lose the automatic array assembly functionality, though I
> appreciate reasons for trying to deprecate it.
>
> Can anyone suggest a better shell equivalent of the array assembly
> functionality that I can use with a modular md?  So far I've got:
>
> for DEV in 0 1 2 3 4 5 6 7 ; do
>   mdadm -Ac partitions -m $DEV /dev/md$DEV
> done
>
> But this seems a bit slow as it tears through every device in /dev on each
> call (about 30 seconds per mdadm call).  I don't want to have RAID
> configuration files on each server if I can avoid it, as I know that all
> the info I need will be in the relevant discs' superblocks.
>
> Any better ideas for doing the job?
>
> --
> Matthew Bloch                             Bytemark Hosting
>                                 http://www.bytemark.co.uk/
>                 phone UK: 0845 004 3 004 US: 1-877 BYTEMAR
>           Dedicated Linux hosts from 15ukp ($26) per month
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
