From: Luca Berra <bluca@comedia.it>
Subject: Re: Linux software RAID vs. udev
Date: Tue, 4 May 2004 23:26:54 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040504212653.GB30691@percy.comedia.it>
References: <4092FCA6.2020103@backtobasicsmgmt.com> <16534.64452.67783.81354@cse.unsw.edu.au> <409708C4.6070905@backtobasicsmgmt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <409708C4.6070905@backtobasicsmgmt.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 03, 2004 at 08:06:44PM -0700, Kevin P. Fleming wrote:
>Hypothetically speaking, how would you feel about a solution where the 
>md driver also exposed a single "control" device (character device 
>presumably) where mdadm could do all its machinations? Something like 
>the device-mapper control interface is what I'm envisioning here, 
>although this starts to get into the dm/md overlap area...
this seems like a nice idea to me, i never liked using md0 as a control
device.

regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
