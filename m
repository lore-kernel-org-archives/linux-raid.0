From: Luca Berra <bluca@comedia.it>
Subject: Re: patches for mdadm 1.8.0 (auto=dev and stacking of devices)
Date: Sun, 23 Jan 2005 20:14:15 +0100
Message-ID: <20050123191415.GF15317@percy.comedia.it>
References: <20050123151305.GB15317@percy.comedia.it> <20050123152819.GE24350@marowsky-bree.de> <41F3D4E5.1020300@tls.msk.ru> <20050123170009.GD15317@percy.comedia.it> <5d8dc2-utu.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5d8dc2-utu.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jan 23, 2005 at 07:52:53PM +0100, Peter T. Breuer wrote:
>Luca Berra <bluca@comedia.it> wrote:
>> I believe the correct solution to this would be implementing a char-misc

<snip>

>Making special device files "on demand" requires the cooperation of the
>driver and devfs (and since udev apparently replaces devfs, udev). One
>would need to add the code to the driver.

devfs just created 256 /dev/md/<minor> entries, and that was obnoxyous,
besides now we have mdp devices, and one of the aims of udev was
avoiding /dev pollution with un-needed nodes.

>> >BTW, is there a real need to do that?  In theory, one might just
>> >create the necessary /dev/md1 from within startup script...
>> I would have done it in a script if --auto was not implemented, the
>> changes to have auto=dev are not big, mostly man page and indenting.
>
>I'm not sure I follow that. If I understand you, --auto was what you
>added to mdadm to make the special device files.
nope,
--auto was added by Neil some time ago, it is mostly needed for mdp
devices, i just added the "dev" option to --auto.

>Personally I would prefer there to be no unannounced making of device
>files, but yours is an extra flag so it does no harm in that sense.
>However, I think it is a mistaken addition.  You can see that by asking
>yourself why EVERY control utility does not have that option in it.
>Hdparm?  Fdisk?
>
>The answer is: because it's (a) silly, (b) none of its business. And
>the same applies here. If the sysadmin does not want a dev file, then
>let him be. If he wants one, let him make it.
you should have told Neil back then.

>However, as a matter of convenience, I would prefer that the driver
>made the devices in /dev or /sys or wherever if it can. I don't recall
>if the code is there or not!
yes, but then you would need the char device trick.

>Is there a udev document anywhere? I searched in 2.6.8.1 and found
>nothing (I won't burden you with the details of my obviously too
>cursory search).
>
ftp://ftp.kernel.org/pub/linux/utils/kernel/hotplug

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
