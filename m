From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: patches for mdadm 1.8.0 (auto=dev and stacking of devices)
Date: Sun, 23 Jan 2005 19:46:29 +0300
Message-ID: <41F3D4E5.1020300@tls.msk.ru>
References: <20050123151305.GB15317@percy.comedia.it> <20050123152819.GE24350@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050123152819.GE24350@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree wrote:
> On 2005-01-23T16:13:05, Luca Berra <bluca@comedia.it> wrote:
> 
>>the first one adds an auto=dev parameter
>>rationale: udev does not create /dev/md* device files, so we need a way
>>to create them when assembling the md device.
> 
> Am I missing something but shouldn't this be fixed by having udev +
> hotplug create the /dev entry correctly?

There's a chicken-n-eggs problem here.  In order for mdadm to create
an md device (so it will be noticed by udev/hotplug), it have to open
the control device, which, in case of md, is just any /dev/mdN.  But
before first array gets assembled, there's NO mdN entries in /dev.

mdadm tries to open /dev/md1 to get control interface, which isn't
created automatically. When an array actually gets created, it will
be noticied by hotplug/udev as it should be (provided everything is
set up correctly ofcourse).

BTW, is there a real need to do that?  In theory, one might just
create the necessary /dev/md1 from within startup script...

/mjt
