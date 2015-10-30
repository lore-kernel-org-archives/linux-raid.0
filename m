From: Phil Turmel <philip@turmel.org>
Subject: Re: Reconstruct a RAID 6 that has failed in a non typical manner
Date: Fri, 30 Oct 2015 14:31:57 -0400
Message-ID: <5633B79D.4000009@turmel.org>
References: <1874721715.14008052.1446134381481.JavaMail.zimbra@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1874721715.14008052.1446134381481.JavaMail.zimbra@inria.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Clement Parisot <clement.parisot@inria.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good afternoon, Clement, Marc,

On 10/29/2015 11:59 AM, Clement Parisot wrote:
> we've got a problem with our old RAID 6.

> After an electrical maintenance, 2 of our HDD came in fail state. An alert was sent that said everything was reconstructing.

> md1 reconstruction works but md2 failed as a 3rd HDD seems to be broked. A new disk has been successfully added to replace a failed one.
> All of the disks of md2 changed to Spare state. We rebooted the server but it was worse.

> As you can see, RAID is in "active, FAILED, Not Started" State. We tried to add the new disk, re-add the previously removed disks as they appears to have no errors.
> 2/3 of the disks should still contains the datas. We want to recover it.

Your subject is inaccurate.  You've described a situation that is
extraordinarily common when using green drives.  Or any modern desktop
drive -- they aren't rated for use in raid arrays.  Please read the
references in the post-script.

> I tried procedure on RAID_Recovery wiki
>   mdadm --assemble --force /dev/md2 /dev/sda /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn /dev/sdo /dev/sdp
> but it failed.
> mdadm: failed to add /dev/sdg to /dev/md2: Device or resource busy
> mdadm: failed to RUN_ARRAY /dev/md2: Input/output error
> mdadm: Not enough devices to start the array.

Did you run "mdadm --stop /dev/md2" first?  That would explain the
"busy" reports.

Before proceeding, please supply more information:

for x in /dev/sd[a-p] ; mdadm -E $x ; smartctl -i -A -l scterc $x ; done

Paste the output inline in your response.

Phil

[1] http://marc.info/?l=linux-raid&m=139050322510249&w=2
[2] http://marc.info/?l=linux-raid&m=135863964624202&w=2
[3] http://marc.info/?l=linux-raid&m=135811522817345&w=1
[4] http://marc.info/?l=linux-raid&m=133761065622164&w=2
[5] http://marc.info/?l=linux-raid&m=132477199207506
[6] http://marc.info/?l=linux-raid&m=133665797115876&w=2
[7] http://marc.info/?l=linux-raid&m=142487508806844&w=3
[8] http://marc.info/?l=linux-raid&m=144535576302583&w=2



