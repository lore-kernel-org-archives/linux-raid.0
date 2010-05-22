From: Luca Berra <bluca@comedia.it>
Subject: Re: blkid and partition problem
Date: Sat, 22 May 2010 08:15:03 +0200
Message-ID: <20100522061503.GA12294@maude.comedia.it>
References: <AANLkTilFZtEDC9au165SQSsj7U1B2f_XOA4kY_4hbE0j@mail.gmail.com> <AANLkTilu5tG3GwgyZY8Cqo7VpNRlFOT3YZUIMx77lZX8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTilu5tG3GwgyZY8Cqo7VpNRlFOT3YZUIMx77lZX8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 21, 2010 at 07:31:50PM -0700, Tim Bostrom wrote:
>/dev/sdm:
>          Magic : a92b4efc
>        Version : 1.2
....

>/dev/sdj1:
>          Magic : a92b4efc
>        Version : 0.90.00
probably you have two superblocks on /dev/sdm
one at the beginning of sdm version 1.2, and one at the end of sdm1
(version 0.90) and md finds the first one.

you should be able to fix that by issuing
mdadm --zero-superblock /dev/sdm
partx -a /dev/sdm
mdadm /dev/md2 -a /dev/sdm1

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
