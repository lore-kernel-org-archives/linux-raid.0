From: Kanoalani Withington <kanoa@cfht.hawaii.edu>
Subject: Re: RAID backup - mtx w/ tcl
Date: Fri, 04 Oct 2002 12:22:03 -1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D9E148B.7050302@cfht.hawaii.edu>
References: <Pine.LNX.3.96.1021004144923.10481C-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Alvin Oga <aoga@maggie.linux-consulting.com>
Cc: Illtud Daniel <illtud.daniel@llgc.org.uk>, Effrem Norwood <enorwood@effrem.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, jbradford@dial.pipex.com, jakob@unthought.net, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Alvin,

Funny, when I searched for it on the web I didn't find anything. The 
original was written by Leonard Zubkoff and subsequently modified by 
Eric Lee Green. I never got it to work for me until around version 
1.2.15. I emailed Eric to see what's up with it but in the meantime I 
put my latest copy of it on my anonymous ftp server:

ftp.cfht.hawaii.edu:/pub/daprog/kanoa/mtx-1.2.16rel.tar.gz

Its got a GPL so that must be O.K.

It is great software. Basically it uses the scsi generic device to 
provide command line access to the device robotics so you can move 
tapes, use the export slots and barcode readers etc in a tape or optical 
jukebox.  It's a snap to then write archive and backup scripts that can 
pick and track tapes in the library.

When I first started writing scripts instead of buying $10k+ software 
packages I was using JBdriver, a commercial product that cost me nearly 
$2k (comparatively a good deal) which does the same thing. When they 
wanted another $1k to switch from a solaris box to a linux box I ditched 
it for mtx which works better and faster. It also installed in less than 
5min.

I wonder what happened to it?

-Kanoa

Alvin Oga wrote:

>
>hi ya kanoalani
>
>are ya willing to release that mtx code ??
>( well more like where can i find it )
>
>i'd like to add it to the collection
>	http://www.Linux-Backup.net/app.gwif.html
>	
>thanx
>alvin
>
>On Fri, 4 Oct 2002, Kanoalani Withington wrote:
>
>...
>
>>I agree it's a total racket. I've spent an appalling amount of money on 
>>this stuff over the years considering how simple it is. Last year I 
>>finally built mtx, the open source tape library driver, and wrote my own 
>>software in tcl scripts for a new archiving system. It really is that 
>>simple, I don't know how they can charge so much for thier software, 
>>especially when some it is junk to begin with.
>>
>>-Kanoa
>>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


