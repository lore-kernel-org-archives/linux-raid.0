From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID 5 questions
Date: Sun, 1 Aug 2004 11:33:50 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040801093349.GB6768@percy.comedia.it>
References: <1091325475.2374.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1091325475.2374.11.camel@localhost>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Aug 01, 2004 at 11:27:56AM +0930, Ninti Systems wrote:
>Q1: Is it true that Linux can't/shouldn't boot off a RAID 5 array?
it cannot no boot loader can load the kernel from a striped (or raid
3/4/5/6) device
create a small raid 1 array spanning the 4 disks and use it for /boot

>Q2: The four disks have identical manufacturer, model and size, but two
>are brand new while two have had NTFS filesystems on them. Accordingly,
>if I run hdparm -g on them, two disks have these specs:
>
>geometry = 2498/255/63, sectors = 40132503, start = 0
...
>geometry = 39813/16/63, sectors = 40132503, start = 0
>
>Is this an issue with software RAID? 
no, nevertheless if you wipe the partition table on the to 'used' disks
linux will see them just like the 'new' ones.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
