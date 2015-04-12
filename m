From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: RAID 5 "magicaly" become a RAID0
Date: Sun, 12 Apr 2015 17:28:32 -0500
Message-ID: <CAAMCDeex88LLR--OTdJ0GxRwZbOkXu=7d+UFJT+GE=mAhf+Ndw@mail.gmail.com>
References: <D150B36B.8EE37%marchesseau@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D150B36B.8EE37%marchesseau@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas MARCHESSEAU <marchesseau@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Add a "--force" to the --assemble command and it should force the
other 2 online even though they are a bit off on events.

=46rom my understanding that may been some of the last data written
could be lost/corrupted (those last 4 events on those 2 disks).

I would probably also suggest getting another disk and going to raid6,
raid5 is pretty scary if disks start going bad.

On Sun, Apr 12, 2015 at 4:42 PM, Thomas MARCHESSEAU
<marchesseau@gmail.com> wrote:
> Hi team ,
>
> Like probably lot of  new subscriber , i mail you, guys,  for help .
>
> I=C4=85m running a raid5 on 7 HDD for several month now ( and years o=
n other
> system) without problem .
> last week i had a crash disk (sdg)  , i=C4=85ve add a new drive (sdi)=
  and
> rebuild ..  Works fine , and i dont think this is the cause of my tod=
ay
> problem.
>
> Yesterday , i=C4=85v upgraded my ubuntu 14.10 , and the system warm m=
e with a
> message that i can=C4=85t recall and rewrite exactly , but something =
like :
> md127 doesn=C4=85t not match with /etc/mdadm/mdadm.conf ,  blah blah =
, run
> /usr/share/mdadm/mkconf , and fix /etc/mdadm/mdadm.conf
>
> i=C4=85ve done it , and reboot , all looks good .
> All the drive have been rename after reboot ( orginal sdg was extract=
 form
> the bay )
>
> I=C4=85ve setup a rsync of my most important data on a external drive=
 this
> night, who partially failed  (only 25% ha been backuped , bad luck ) =
 ,
> (probably) because  this morning  i have re-inserted by mistake the f=
aulty
> drive ( for information , i think the drive was in fact ok , the sata
> connector was a bit disconnect )
>
> I did not pay attention of the situation at the moment , but few hour
> later , i ssh my filer and my =C2=AB home =C2=BB  (on the raid partit=
ion) was not
> available anymore .
> I didn=C4=85t try to fschk or any thing else than :
>
> Mdadm =E2=80=B9stop /dev/md127
> mdadm --assemble /dev/md127 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/=
sdf
> /dev/sdg /dev/sdh
> mdadm: /dev/md127 assembled from 5 drives - not enough to start the a=
rray.
>
>
> So i=C4=85ve read a bunch of usefull link , one of them :) ,
> https://raid.wiki.kernel.org/index.php/RAID_Recovery  , says , don=C4=
=85t do
> stupid thing until drop a mail on linux-raid mailling =C5=A0 so i=C4=85=
m here  .
>
> i=C4=85ve collected  this usefull info :
> mdadm --examine /dev/sd[a-z] | egrep 'Event|/dev/sd'
> /dev/sda: (system HDD )
> /dev/sdb:
>          Events : 21958
> /dev/sdc:
>          Events : 21958
> /dev/sdd:
>          Events : 21958
> /dev/sde:
>          Events : 21958
> /dev/sdf:
>          Events : 21958
> /dev/sdg:
>          Events : 21954  <=E2=80=B9 here
> /dev/sdh:
>          Events : 21954  <=E2=80=B9 and here
>
>
>
> i=C4=85ve also a full copy of mdadm =E2=80=B9examine
>
> The strange thing is that  my raid array is now seen as a RAID0 in
> mdadm --detail /dev/md127
> /dev/md127:
>         Version :
>      Raid Level : raid0
>   Total Devices : 0
>
>           State : inactive
>
>
> But individually all drive in mdadm =E2=80=B9examine , are RAID 5 mem=
ber .
>
> Anyone for help  ?
>
> i=C4=85 was on the way to perform a
> mdadm --create --assume-clean =E2=80=B9level=3D5 --raid-devices=3D7 -=
-size=3D11720300544
> /dev/md127 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev=
/sdh
>
> Which looks a bit stupid before ask for help
>
> Regards thomas
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
