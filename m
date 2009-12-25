From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: linear RAID
Date: Fri, 25 Dec 2009 19:44:43 +0530
Message-ID: <37d33d830912250614i99cb464h47a66ecf1fa64bc2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,


  struct linear_private_data
  {
          sector_t                array_sectors;
          dev_info_t              disks[0];
          struct rcu_head         rcu;
  };


linear_conf( ) {

=2E...
 conf =3D kzalloc (sizeof (*conf) + raid_disks*sizeof(dev_info_t),
                         GFP_KERNEL);

=2E..
}

How do these two go together?

--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
