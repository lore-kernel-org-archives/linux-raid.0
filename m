From: Luca Berra <bluca@comedia.it>
Subject: Re: patches for mdadm 1.8.0 (auto=dev and stacking of devices)
Date: Sun, 23 Jan 2005 18:00:09 +0100
Message-ID: <20050123170009.GD15317@percy.comedia.it>
References: <20050123151305.GB15317@percy.comedia.it> <20050123152819.GE24350@marowsky-bree.de> <41F3D4E5.1020300@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41F3D4E5.1020300@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jan 23, 2005 at 07:46:29PM +0300, Michael Tokarev wrote:
>Lars Marowsky-Bree wrote:
>>On 2005-01-23T16:13:05, Luca Berra <bluca@comedia.it> wrote:
>>
>>>the first one adds an auto=dev parameter
>>>rationale: udev does not create /dev/md* device files, so we need a way
>>>to create them when assembling the md device.
>>
>>Am I missing something but shouldn't this be fixed by having udev +
>>hotplug create the /dev entry correctly?
>
>There's a chicken-n-eggs problem here.  In order for mdadm to create
>an md device (so it will be noticed by udev/hotplug), it have to open
>the control device, which, in case of md, is just any /dev/mdN.  But
>before first array gets assembled, there's NO mdN entries in /dev.
exactly

>mdadm tries to open /dev/md1 to get control interface, which isn't
>created automatically. When an array actually gets created, it will
>be noticied by hotplug/udev as it should be (provided everything is
>set up correctly ofcourse).

I believe the correct solution to this would be implementing a char-misc
/dev/mdadm device that mdadm would use instead of the block device,
like device-mapper does. Alas i have no time for this in the forseable
future.

>BTW, is there a real need to do that?  In theory, one might just
>create the necessary /dev/md1 from within startup script...
I would have done it in a script if --auto was not implemented, the
changes to have auto=dev are not big, mostly man page and indenting.

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
