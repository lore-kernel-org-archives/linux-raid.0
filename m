From: Luca Berra <bluca@comedia.it>
Subject: Re: metadata 1.2
Date: Sun, 28 Mar 2010 08:58:31 +0200
Message-ID: <20100328065831.GA13933@maude.comedia.it>
References: <20100326194352.GA2474@lazy.lzy> <4877c76c1003261849k9219c1eq7e8ebde088b619df@mail.gmail.com> <20100327091658.GA2333@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100327091658.GA2333@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 27, 2010 at 10:16:58AM +0100, Piergiorgio Sartor wrote:
>So, would it be better to have a metadata 1.3 with a 32K
>offset for the superblock, so there could be enough space
>for something like grub2?
this was discussed nearly one year ago.
look for the thread "md extension to support booting from raid whole
disks". Unfortunately that thread turned to an holy war. But before
that, Neil said he planned on offering an option to reserve some space,
i believe after the superblock, to host non-raid data.

>Actually, I would like to propose metadata 2.0, or
>dual RAID, where the superblock is located somewhere
the issue would be, how do you locate that piece of metadata?

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
