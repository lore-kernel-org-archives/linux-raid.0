From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Superblock Missing
Date: Mon, 4 Sep 2017 16:02:08 +0100
Message-ID: <59AD6AF0.8030506@youngman.org.uk>
References: <CAANkkp+3WwZvKu60LkU_0VpxZvZuNrrE=qDt=4DPc80AO+sgEg@mail.gmail.com>
 <20170902014333.GA26507@metamorpher.de>
 <CAANkkpK6jeFKr-Tz2Fzq-CTey0GJRmERy0W+DBHMVJct2JYfUQ@mail.gmail.com>
 <20170902164906.GA6823@metamorpher.de>
 <CAANkkp+DVzhPHEtMhmagSSO+J9cF3YwENADqCqBdXphsFE+Pmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAANkkp+DVzhPHEtMhmagSSO+J9cF3YwENADqCqBdXphsFE+Pmg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Mitchell <mr.david.mitchell@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/09/17 04:35, David Mitchell wrote:
> mdadm --stop /dev/md0
> mdadm --assemble --force /dev/md0 /dev/sdc1 /dev/sdd1 /dev/sde1
> 
> The array instantly loaded and went into a sync.  I let the sync
> complete overnight.    The file system on the raid array seems to be
> gone.
> 
> I'm looking for any hints on how I might get it back.
> 
> The array loads fine, but when I attempted to mount the array, it
> complains about not finding the file system

OoWwww!

I think you've just trashed one of the drives :-( The sync will have
overwritten one of the drives with parity calculated from the other two.

You've got two drives of valid data from a 3-drive raid-5 set, so the
data could be recovered, but it's going to be a long job.

Somebody else is going to have to chime in and tell you what to do, but
now is the time you really want your backup :-(

Cheers,
Wol
