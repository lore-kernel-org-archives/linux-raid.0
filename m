From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid 5 on linux --againnnn (sorryy it's big)
Date: Fri, 25 Jul 2003 15:46:36 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16160.50236.215350.204806@gargle.gargle.HOWL>
References: <59553.202.158.96.2.1059108792.power.web.id@mail2.oke.net.id>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from c4c3m@oke.net.id on Friday July 25
To: c4c3m@oke.net.id
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 25, c4c3m@oke.net.id wrote:
> this is the messages from faulty machine:
> #mdadm.static -Eb /dev/sdc*
> 
> ARRAY /dev/md4 level=raid5 num-devices=3 UUID=12a3daa6:98bc6aca:98d38bed:
> 414bad01
> devices=/dev/sdc9
> ARRAY /dev/md3 level=raid5 num-devices=3 UUID=5c4fb8f2:7aad3154:83515188:
> 5945a00b
> devices=/dev/sdc8
> ARRAY /dev/md2 level=raid5 num-devices=3 UUID=31788297:ac6dab84:1dc952b3:
> fec35535
> devices=/dev/sdc7
> ARRAY /dev/md1 level=raid5 num-devices=3 UUID=ed01ad73:e4a5e4d0:90eb9b59:
> 15e5c3c0
> devices=/dev/sdc6
> ARRAY /dev/md8 level=raid5 num-devices=3 UUID=1708a6d1:96874201:39d9f451:
> bed35249
> devices=/dev/sdc13
> ARRAY /dev/md7 level=raid5 num-devices=3 UUID=f385575d:d3185f42:37e7d321:
> 4784a76c
> devices=/dev/sdc12
> ARRAY /dev/md6 level=raid5 num-devices=3 UUID=cdcae134:499035b2:e539a33a:
> 636fa315
> devices=/dev/sdc11
> ARRAY /dev/md5 level=raid5 num-devices=3 UUID=59f4a4fc:40471289:9d6e0430:
> 44f950a1
> devices=/dev/sdc10
> ARRAY /dev/md9 level=raid5 num-devices=3 UUID=3b2e48f6:efb0795d:6fa8e6c7:
> 18e6d984
> devices=/dev/sdc1,/dev/sdc3,/dev/sdc4

Thanks.
After you sent me separately the whole set of information (/dev/sd*,
not just /dev/sdc* ... why didn't you send it to the list too like I
keep asking?).

It appears that your machine crashed and when it came back up, sdb and
sdc weren't accessable, so all the arrays got confused by the absense
of sdb and sdc.
You can fix it all up using the "-Af" or  "--assemble --force" options
to mdadm.
so

   mdadm -Af /dev/md1 /dev/sd[abc]6
   mdadm -Af /dev/md3 /dev/sd[abc]8
   mdadm -Af /dev/md4 /dev/sd[abc]9
   mdadm -Af /dev/md5 /dev/sd[abc]10
   mdadm -Af /dev/md6 /dev/sd[abc]11

should make it mostly happy again.
This will make all of the raid5 array out of just two drives, the
'best' two in each case.
Then you can add the third in. e.g.
  mdadm /dev/md1 -a /dev/sdc6   
    Note: this assumes it was sdc6 that was left out. You should
    check (mdadm -D /dev/md1 is a good way) and add in the missing
    drive.

NeilBrown
