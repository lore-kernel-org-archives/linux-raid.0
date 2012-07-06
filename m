From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [patch 2/3 v4]raid1: read balance chooses idlest disk for SSD
Date: Thu, 5 Jul 2012 23:45:16 -0300
Message-ID: <CABYL=Tq=+Hk-w2khUt40yq+Nadr8-LbHBSUottw87FrbWMDv2g@mail.gmail.com>
References: <20120705092057.GB27956@kernel.org>
	<CABYL=TqgOmuL4JLT1-pmUWgeVHH+veuNB4K5BSW5=zW0iL6C_Q@mail.gmail.com>
	<CANejiEUMg_WFh-G+EpSbkGHnDgBAVF605T+ttv4aj3EEXu3yWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANejiEUMg_WFh-G+EpSbkGHnDgBAVF605T+ttv4aj3EEXu3yWg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

well, i=B4m thinking something like elevators, they have some files to
configure options at /sys/block/sda/xxxx, it=B4s a nice interface...
echo and cat to configure the elevator or sysctl...

check this example of md in a old linux kernel (i don=B4t remember
version maybe 2.6.18)



#cd /sys/block/md0/md
# ls -l
-rw-r--r-- 1 root root 4096 Jul  5 23:39 array_state
--w------- 1 root root 4096 Jul  5 23:39 bitmap_set_bits
-rw-r--r-- 1 root root 4096 Jul  5 23:39 chunk_size
-rw-r--r-- 1 root root 4096 Jul  5 23:39 component_size
-r--r--r-- 1 root root 4096 Jul  5 23:39 degraded
drwxr-xr-x 2 root root    0 Jul  5 23:39 dev-sda1 <<<<=3D=3D=3D=3D=3D
drwxr-xr-x 2 root root    0 Jul  5 23:39 dev-sdb1 <<<<=3D=3D=3D=3D=3D
-rw-r--r-- 1 root root 4096 Jul  5 23:39 layout
-rw-r--r-- 1 root root 4096 Jul  5 23:39 level
-rw-r--r-- 1 root root 4096 Jul  5 23:39 metadata_version
-r--r--r-- 1 root root 4096 Jul  5 23:39 mismatch_cnt
--w------- 1 root root 4096 Jul  5 23:39 new_dev
-rw-r--r-- 1 root root 4096 Jul  5 23:39 raid_disks
lrwxrwxrwx 1 root root    0 Jul  5 23:39 rd2 -> dev-sda1
lrwxrwxrwx 1 root root    0 Jul  5 23:39 rd3 -> dev-sdb1
-rw-r--r-- 1 root root 4096 Jul  5 23:39 reshape_position
-rw-r--r-- 1 root root 4096 Jul  5 23:39 resync_start
-rw-r--r-- 1 root root 4096 Jul  5 23:39 safe_mode_delay
-rw-r--r-- 1 root root 4096 Jul  5 23:39 suspend_hi
-rw-r--r-- 1 root root 4096 Jul  5 23:39 suspend_lo
-rw-r--r-- 1 root root 4096 Jul  5 23:39 sync_action
-r--r--r-- 1 root root 4096 Jul  5 23:39 sync_completed
-rw-r--r-- 1 root root 4096 Jul  5 23:39 sync_force_parallel
-rw-r--r-- 1 root root 4096 Jul  5 23:39 sync_max
-r--r--r-- 1 root root 4096 Jul  5 23:39 sync_speed
-rw-r--r-- 1 root root 4096 Jul  5 23:39 sync_speed_max
-rw-r--r-- 1 root root 4096 Jul  5 23:39 sync_speed_min


# ls dev-sda1/ -l
total 0
lrwxrwxrwx 1 root root    0 Jul  5 23:40 block -> ../../../sda/sda1
-rw-r--r-- 1 root root 4096 Jul  5 23:40 errors
-rw-r--r-- 1 root root 4096 Jul  5 23:40 offset
-rw-r--r-- 1 root root 4096 Jul  5 23:40 size
-rw-r--r-- 1 root root 4096 Jul  5 23:40 slot
-rw-r--r-- 1 root root 4096 Jul  5 23:40 state
--->>> maybe here we could put a file called: "raid1_read_balance_disk_=
speed"


maybe we could save this information at md metadata? i don=B4t know how
it works, just a idea, instead saving it at sysctl, use md metadata
informations...

--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
