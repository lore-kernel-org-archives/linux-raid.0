From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 5 "magicaly" become a RAID0
Date: Sun, 12 Apr 2015 20:18:32 -0400
Message-ID: <552B0B58.8050102@turmel.org>
References: <D150B36B.8EE37%marchesseau@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D150B36B.8EE37%marchesseau@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas MARCHESSEAU <marchesseau@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Thomas,

On 04/12/2015 05:42 PM, Thomas MARCHESSEAU wrote:
> Hi team ,
>=20
> Like probably lot of  new subscriber , i mail you, guys,  for help .
>=20
> I=B9m running a raid5 on 7 HDD for several month now ( and years on o=
ther
> system) without problem .
> last week i had a crash disk (sdg)  , i=B9ve add a new drive (sdi)  a=
nd
> rebuild ..  Works fine , and i dont think this is the cause of my tod=
ay
> problem.

Agreed.  Probably not related.

> Yesterday , i=B9v upgraded my ubuntu 14.10 , and the system warm me w=
ith a
> message that i can=B9t recall and rewrite exactly , but something lik=
e :
> md127 doesn=B9t not match with /etc/mdadm/mdadm.conf ,  blah blah , r=
un
> /usr/share/mdadm/mkconf , and fix /etc/mdadm/mdadm.conf
>=20
> i=B9ve done it , and reboot , all looks good .
> All the drive have been rename after reboot ( orginal sdg was extract=
 form
> the bay ) =20

Yes, you cannot trust drives to keep their names through upgrades.  The
names are pseudo-random during boot.

You should know that md127 is the default name chosen by mdadm when
assembling an array for which it doesn't know any other name.  Followed
by md126, then md125 and so on.  You really should give your arrays
other names.  Most commonly starting with md0 or md1.

> I=B9ve setup a rsync of my most important data on a external drive th=
is
> night, who partially failed  (only 25% ha been backuped , bad luck ) =
 ,
> (probably) because  this morning  i have re-inserted by mistake the f=
aulty
> drive ( for information , i think the drive was in fact ok , the sata
> connector was a bit disconnect )
>=20
> I did not pay attention of the situation at the moment , but few hour
> later , i ssh my filer and my =AB home =BB  (on the raid partition) w=
as not
> available anymore .

You should collect your 'dmesg' and post it here.  Or cut and paste fro=
m
it anything related to your drives or array.

> I didn=B9t try to fschk or any thing else than :
>=20
> Mdadm =8Bstop /dev/md127
> mdadm --assemble /dev/md127 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/=
sdf
> /dev/sdg /dev/sdh=20
> mdadm: /dev/md127 assembled from 5 drives - not enough to start the a=
rray.
>=20
>=20
> So i=B9ve read a bunch of usefull link , one of them :) ,
> https://raid.wiki.kernel.org/index.php/RAID_Recovery  , says , don=B9=
t do
> stupid thing until drop a mail on linux-raid mailling =8A so i=B9m he=
re  .
>=20
> i=B9ve collected  this usefull info :
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
>          Events : 21954  <=8B here
> /dev/sdh:
>          Events : 21954  <=8B and here

In general, people on this list want to see the full --examine reports.
 As do I.

Also, you need to record which drive serial numbers correspond to which
device roles, just in case.  You can show the smartctl data along with
the examines like so:

for x in /dev/sd[b-h] ; do mdadm -E $x ; smartctl -iA -l scterc $x ;
done > report.txt

Then paste report.txt into your next mail.

> The strange thing is that  my raid array is now seen as a RAID0 in
> mdadm --detail /dev/md127
> /dev/md127:
>         Version :=20
>      Raid Level : raid0
>   Total Devices : 0
>=20
>           State : inactive

It didn't start, so that info isn't meaningful.

> But individually all drive in mdadm =8Bexamine , are RAID 5 member .
>=20
> Anyone for help  ?

Your array should be fixable.  The use of "mdadm --assemble --force" as
recommended by Roger is likely to work.  But it won't be enough if you
don't also figure out why the array stopped after a few hours.  That
sounds like a common problem with raid5 rebuilds.

> i=B9 was on the way to perform a
> mdadm --create --assume-clean =8Blevel=3D5 --raid-devices=3D7 --size=3D=
11720300544
> /dev/md127 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev=
/sdh
>=20
> Which looks a bit stupid before ask for help

Yes, this is what the wiki means when it refers to doing something
stupid.  Any form of --create is destructive and should only be
attempted when all other attempts have failed.

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
