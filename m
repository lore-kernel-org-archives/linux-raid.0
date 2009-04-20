From: Luca Berra <bluca@comedia.it>
Subject: Re: what superblock to use
Date: Mon, 20 Apr 2009 16:17:02 +0200
Message-ID: <20090420141702.GC17461@maude.comedia.it>
References: <49EC7B22.8070805@lfarkas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49EC7B22.8070805@lfarkas.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 20, 2009 at 03:39:46PM +0200, Farkas Levente wrote:
>hi,
>what's the current recommended superblock to use for a newly created
>raid5-6 array with 6 pieces of 1tb disk? by default mdamd use 0.90. is
>it worth to change it to any 1.x format?
0.9 has some limitations that 1.x do not have, none apply in your case
max_components = 28
max_size of component=2TB

1.x lifts those limitation
my stance would be going to 1.2
1.1 puts the superblock at the start of the device, this will prevent
the kernel from finding a partition table or fs superblock on the first
component device
1.2 puts the superblock 4k from start, thus preventing anything that
tries to touch the mbr from damaging it.
if you put the sb at the start of the device lilo and grub wont be able
to boot from it, but then they won't be able to boot of a raid5/6
anyway.

>anyway is there any advantage of a raid6 over raid5+1spare disk? afaik
>raid5 will be faster and use less cpu and both case 2 disk can failed.
>thanks in advance.

raid6 prevents two possible risks in raid5+spare
first:
when using a spare, you are never certain it is in perfect
working order, smart may help, or it might not.
second: 
when a device fails a rebuild process starts using the spare drive
if during the rebuild a second device fails or has any error you risk
losing data.

the first problem could be solved by using raid5e, which md does not
support yet

the second can be minimized by 'scrubbing' via
/sys/block/md*/md/sync_action

regards,
L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
