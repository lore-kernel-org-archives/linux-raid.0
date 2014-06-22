From: George Duffield <forumscollective@gmail.com>
Subject: Adding a new drive to an array
Date: Sun, 22 Jun 2014 17:49:15 +0200
Message-ID: <CAG__1a6i-UsOJpy+5GdwV_a-cVDCi_F_5KztwkFbNUEONDhH5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've got a RAID5 array comprised of 4 x 3TB drives which is 97% full
and would like to grow the array by adding a 5th drive of the same
make/ model.

Looking at https://raid.wiki.kernel.org/index.php/Growing it seems the
approach (after partitioning the drive) is to:

1) add the drive to the pool: # mdadm --add /dev/md127 /dev/sdX1
2) grow the array: # mdadm --grow --raid-devices=3D5
--backup-file=3D~/grow_md127.backup  /dev/md127
3) edit mdadm.conf to include the 5th drive i.e. num-devices=3D5
4) determine raid stride size calculated with chunk / block
4) ensure the array is unmounted and resize ext4: # resize2fs -S
ascertained_stride_size -p /dev/md127

Is the above correct, apart from making sure I have a good backup and
do this via UPS power, are there any other considerations?


I'm also wondering whether there's a faster way to achieve the addition=
/resync

Looking at man mdadm it mentions:
--assume-clean
              Tell mdadm that the array pre-existed and is known to be
clean.  It can be useful when trying to recover from a major failure
as you can be sure that no data will be affected unless you actually
write to the array.  It can also be used when creating a
              RAID1 or RAID10 if you want to avoid the initial resync,
however this practice =E2=80=94 while normally safe =E2=80=94 is not re=
commended.  Use
this only if you really know what you are doing.

              When the devices that will be part of a new array were
filled with zeros before creation the operator knows the array is
actually clean. If that is the case, such as after running badblocks,
this argument can be used to tell mdadm the facts the opera=E2=80=90
              tor knows.

              When  an  array  is resized to a larger size with --grow
--size=3D the new space is normally resynced in that same way that the
whole array is resynced at creation.  From Linux version 3.0,
--assume-clean can be used with that command to avoid the auto=E2=80=90
              matic resync.


Does this mean that after partitioning the drive I can avoid the
entire resync operation by calling: # mdadm --grow --assume-clean
--raid-devices=3D5 --backup-file=3D~/grow_md127.backup  /dev/md127 ?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
