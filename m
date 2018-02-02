From: Fisher <fisherthepooh@protonmail.com>
Subject: mdadm stuck in monitoring reshape after reboot
Date: Thu, 01 Feb 2018 22:07:33 -0500
Message-ID: <4Bnds82DuD4p8CnbCH3S5XJ-m2zKGb64EUE01-g_o52ezVxI9Km5R_6EMq6W-Fxer1XGUnGNtoU4DqzH6cPS9T7qfvSC2I1vb-FnR07uKD0=@protonmail.com>
Reply-To: Fisher <fisherthepooh@protonmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I was trying to reshape my 3 drives RAID5 to 4 dirves RAID6, and the was a =
power outage,=20

Here's my command to restart reshape after reboot, my mdadm version is 3.3

mdadm /dev/md1 -AfR /dev/sdb3 /dev/sdc3 /dev/sdd3 /dev/sdh3 --backup-file=
=3D/home/user/backup/reshape_backup   =20

but I found reshape stuck at same progress for hours. After a few tries and=
 adding logs, I found mdadm stuck at select in sysfs_wait

=09while (completed < max_progress && completed < wait_point) {
=09=09/* Check that sync_action is still 'reshape' to avoid
=09=09 * waiting forever on a dead array
=09=09 */
=09=09/* skip... */
=09=09sysfs_wait(fd, NULL);
=09=09^^^^^^^^^^^^^^^^^^^^^
=09=09if (sysfs_fd_get_ll(fd, &completed) < 0)
=09=09=09goto check_progress;
=09}
=09
and this is because during monitoring reshape mdadm got "delayed" at first =
reading sync_completed, and mdadm found new_sync_max is different from max_=
progress which was still calculating from the begining, so the variable *fr=
ozen was set and " sysfs_set_num(info, NULL, "sync_max", max_progress);  " =
would never execute since then. That's why mdadm would enter sysfs_wait whe=
n max_progress reached sync_completed and kernel still had the old value of=
 max_progress.

why would mdadm read sync_completed just right in the transaction of curr_r=
esync between value 2 to value 3 every time I restarted reshape?=20

I add some log in kernel and in mdadm


<kernel log>

[   43.685260] [array_state_store] md1: entering ...=20
[   43.690043] [array_state_store] md1: from active
[   43.694636] [array_state_store] md1: restart_array start from active
[   43.700986] md: md1 switched to read-write mode.
[   43.705775] [md_seq_show] md1: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dhere=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   43.749593] [md_do_sync] md1: entering ....
[   43.753769] [md_do_sync] md1: last sync action =3D reshape
[   43.759055] [md_do_sync] md1: reshape !!
[   43.762960] [md_do_sync_0] md1:  mddev->curr_resync set to 2
[   43.772833] [md_do_sync_0] md1, mddev2 =3D md1 in
[   43.799217] [md_update_sb] md1: sysfs_notify sync_completed
[   43.799441] [md_seq_show] md1: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dhere=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   43.799540] [sync_completed_show] md1: mddev->curr_resync =3D 2
[   43.799540] [sync_completed_show] md1: return delayed                   =
            <----- mdadm got delayed here
[   43.849369] [md_do_sync] md1: leave normally
[   43.849370] md: reshape of RAID array md1
[   43.849370] md: minimum _guaranteed_  speed: 200000 KB/sec/disk.
[   43.849371] md: using maximum available idle IO bandwidth (but not more =
than 500000 KB/sec) for reshape.
[   43.849371] md: Reshaping started: md1
[   43.849379] md: using 128k window, over a total of 966807552k.
[   43.849380] [md_do_sync_3] md1 : mddev->curr_resync set to 3
[   43.849391] [md_do_sync_0] md1: sysfs_notify sync_completed
[   43.849408] [reshape_request_2] before sysfs_notify sync_completed
[   43.849409] [reshape_request_2] after sysfs_notify sync_completed
[   43.849410] [md_do_sync] md1: j =3D 25739264, mddev->resync_max =3D 2573=
9264
[   43.849410] [md_do_sync] md1: before wait_event_interruptible
[   43.849418] [sync_completed_show] md1: mddev->curr_resync_completed =3D =
25739264, resync =3D 25739264
[   43.849479] [md_seq_show] md1: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dhere=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   43.849579] [sync_completed_show] md1: mddev->curr_resync_completed =3D =
25739264, resync =3D 25739264


<mdadm log>
log without function name ahead, mostly from function "progress_reshape"
Also, I let progress_reshape check mdstat before it reads sync_completed.

[mdstat_read] mdname =3D md1
[mdstat_read_0] mdname =3D md1, (w =3D active), active
[mdstat_read_2] mdname =3D md1,=20
[mdstat_read_3] mdname =3D md1, w =3D blocks, in_devs =3D 0
[mdstat_read_6] mdname =3D md1, (w =3D resync=3DPENDING), resync
[mdstat_read_12] mdname =3D md1, (w =3D resync=3DPENDING), RESYNC_PENDING
[init] backup point =3D 51478528
part =3D 0, before going to progress_reshape, wait_point =3D 3867230208
bsb.arraystart =3D 0, bsb.length =3D 0
backup point =3D 51478528
read_offset =3D 25739264, write_offset =3D 25739264, write_range =3D 1024
nedd_back =3D 3867230208
[init_0] max_progress =3D 51478528
target =3D 262144
[1] suspend_point =3D 524288
[1] max_progress =3D 524288
[7] max_progress =3D 262144
[before] wait_point =3D 3867230208
[after] wait_point =3D 1933615104
set sync_max 262144
[sysfs_set_str] n =3D -1, error =3D 16, Device or resource busy
after set sync_max kernel_sync_max =3D 25739264
[mdstat_read] mdname =3D md1
[mdstat_read_0] mdname =3D md1, (w =3D active), active
[mdstat_read_2] mdname =3D md1,=20
[mdstat_read_3] mdname =3D md1, w =3D blocks, in_devs =3D 0
[mdstat_read_6] mdname =3D md1, (w =3D resync=3DDELAYED), resync
[mdstat_read_11] mdname =3D md1, (w =3D resync=3DDELAYED), RESYNC_DELAYED
[sysfs_fd_get_ll] n =3D 8, errno =3D 13, Permission denied
[sysfs_fd_get_ll] ep (delayed
) =3D=3D buf (delayed
)
cannot read completed, ret1 =3D 1937339183, errno =3D 13
[progress_reshape] The abort might only be temporary, ret1 =3D 9, ret2 =3D =
-57, buf =3D 51478528

before wait
before read
all good again
new_sync_max =3D 25739264, max_progress =3D 262144
out progress reshape, rv =3D 1, sra->reshape_progress =3D 51478528
part =3D 0, before going to progress_reshape, wait_point =3D 3867230208
bsb.arraystart =3D 0, bsb.length =3D 0
backup point =3D 51478528
read_offset =3D 25739264, write_offset =3D 25739264, write_range =3D 1024
nedd_back =3D 3867230208
[init_0] max_progress =3D 51478528
target =3D 262144
[1] suspend_point =3D 1048576
[1] max_progress =3D 1048576
[7] max_progress =3D 524288
[before] wait_point =3D 3867230208
[after] wait_point =3D 1933615104
frozen!!, will not set sync_max
after set sync_max kernel_sync_max =3D 25739264
[mdstat_read] mdname =3D md1
[mdstat_read_0] mdname =3D md1, (w =3D active), active
[mdstat_read_2] mdname =3D md1,=20
[mdstat_read_3] mdname =3D md1, w =3D blocks, in_devs =3D 0
[mdstat_read_7] mdname =3D md1, (w =3D reshape), reshape
[mdstat_read_10] mdname =3D md1, (w =3D 1.3%),
completed ( 25739264 ) , max_progress (524288) , wait_point (1933615104), b=
egin_time =3D 1471.000000
need_backup =3D 3867230208, info->reshape_progress =3D 51478528
leaving advancing!!!!
out progress reshape, rv =3D 1, sra->reshape_progress =3D 51478528
part =3D 0, before going to progress_reshape, wait_point =3D 3867230208
bsb.arraystart =3D 0, bsb.length =3D 0
backup point =3D 51478528
read_offset =3D 25739264, write_offset =3D 25739264, write_range =3D 1024
nedd_back =3D 3867230208
[init_0] max_progress =3D 51478528
target =3D 262144
[1] suspend_point =3D 1572864
[1] max_progress =3D 1572864
[7] max_progress =3D 786432
[before] wait_point =3D 3867230208
[after] wait_point =3D 1933615104
frozen!!, will not set sync_max
after set sync_max kernel_sync_max =3D 25739264

Thanks,
