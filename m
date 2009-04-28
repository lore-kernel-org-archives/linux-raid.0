From: Luca Berra <bluca@comedia.it>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 28 Apr 2009 08:26:15 +0200
Message-ID: <20090428062615.GA20541@maude.comedia.it>
References: <1240574900.4507.2076.camel@ezra> <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49F68CE0.2010906@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 27, 2009 at 09:58:08PM -0700, H. Peter Anvin wrote:
>Goswin von Brederlow wrote:
>> 
>> Or grub2 could be thought to install itself into all MBRs of all
>> drives in a raid set.

this is what is usually done on grub 0.97, tought implementations i have
seen do suck a lot.

>... which is obviously completely wrong, given that that would break the
>whole RAID layer.

why?

>The right thing is to use a RAID-1 partition.

I see no big problem in reserving some space on all boot drives for a
smallish boot loader,
Maybe it is just a matter of defining an 1.3 metadata format which
leaves more room at the start of the device than 1.2 for this very
purpose.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
