From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: RFC: Removal of hash table for Linear RAID
Date: Sun, 17 May 2009 11:40:30 +0530
Message-ID: <37d33d830905162310w1b90e8b2h185202643331342@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I suggest the removal of the hashing table and various other members
associated with it from the struct linear_private_data, which are used
majorly for faster searching of devices.

struct linear_private_data
  {
          struct linear_private_data *prev;       /* earlier version */
-          dev_info_t              **hash_table;
-          sector_t                spacing;
          sector_t                array_sectors;
-          int                     sector_shift;   /* shift before divi=
ding
-                                                  * by spacing
-                                                   */
          dev_info_t              disks[0];
  };



The reason for the same being that use of sector_div, spacing and
sector_shift involves lots of computations, which can be easily
avoided and we can achieve the same in a simpler way.

Also, in an environment where we hold a restriction to have a maximum
of 27 devices. I believe that a linear search would be faster or
atleast equal in time, if you take into consider the (time taken for
computations + search) while using the hash table as well.

Other than making the code simpler, IMO, this should also help shrink
the struct linear_private_data which might further help caching as
well.

Another enhancement to this can be to add a new member "nr_devices" (
number of devices ) to struct linear_private_data and use the same to
perform a binary search for the lokkup, as we know the sectors would
always be increasing as per we move ahead with devices.

Something like,

struct linear_private_data
  {
          struct linear_private_data *prev;       /* earlier version */
          sector_t                array_sectors;
          int                        nr_devices;
          dev_info_t              disks[0];
  };


And accordingly, which_dev( ) can use the same to make the search
faster and better.


Comments/suggestions please.

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
