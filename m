From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: dm: raid456 basic support
Date: Fri, 17 Jun 2016 12:14:05 +0300
Message-ID: <20160617091405.GA25609@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[ No idea why it's only just now complaining about issues from 2011... ]

Hello NeilBrown,

The patch 9d09e663d550: "dm: raid456 basic support" from Jan 13,
2011, leads to the following static checker warning:

	drivers/md/dm-raid.c:1217 parse_raid_params()
	warn: no lower bound on 'value'

drivers/md/dm-raid.c
  1211                                  return -EINVAL;
  1212                          }
  1213                          if (!value || (value > MAX_SCHEDULE_TIMEOUT)) {

value is an int.  MAX_SCHEDULE_TIMEOUT is LONG_MAX.  Should it be
INT_MAX?  What about negatives?

  1214                                  rs->ti->error = "daemon sleep period out of range";
  1215                                  return -EINVAL;
  1216                          }
  1217                          rs->md.bitmap_info.daemon_sleep = value;
  1218                  } else if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_DATA_OFFSET))) {
  1219                          /* Userspace passes new data_offset after having extended the the data image LV */
  1220                          if (test_and_set_bit(__CTR_FLAG_DATA_OFFSET, &rs->ctr_flags)) {
  1221                                  rs->ti->error = "Only one data_offset argument pair allowed";
  1222                                  return -EINVAL;
  1223                          }
  1224                          /* Ensure sensible data offset */
  1225                          if (value < 0) {
  1226                                  rs->ti->error = "Bogus data_offset value";
  1227                                  return -EINVAL;
  1228                          }
  1229                          rs->data_offset = value;
  1230                  } else if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_DELTA_DISKS))) {
  1231                          /* Define the +/-# of disks to add to/remove from the given raid set */
  1232                          if (test_and_set_bit(__CTR_FLAG_DELTA_DISKS, &rs->ctr_flags)) {
  1233                                  rs->ti->error = "Only one delta_disks argument pair allowed";
  1234                                  return -EINVAL;
  1235                          }
  1236                          /* Ensure MAX_RAID_DEVICES and raid type minimal_devs! */
  1237                          if (!__within_range(abs(value), 1, MAX_RAID_DEVICES - rt->minimal_devs)) {
  1238                                  rs->ti->error = "Too many delta_disk requested";
  1239                                  return -EINVAL;
  1240                          }
  1241  
  1242                          rs->delta_disks = value;
  1243                  } else if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_STRIPE_CACHE))) {
  1244                          if (test_and_set_bit(__CTR_FLAG_STRIPE_CACHE, &rs->ctr_flags)) {
  1245                                  rs->ti->error = "Only one stripe_cache argument pair allowed";
  1246                                  return -EINVAL;
  1247                          }
  1248  
  1249                          if (!rt_is_raid456(rt)) {
  1250                                  rs->ti->error = "Inappropriate argument: stripe_cache";
  1251                                  return -EINVAL;
  1252                          }
  1253  
  1254                          rs->stripe_cache_entries = value;
  1255                  } else if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_MIN_RECOVERY_RATE))) {
  1256                          if (test_and_set_bit(__CTR_FLAG_MIN_RECOVERY_RATE, &rs->ctr_flags)) {
  1257                                  rs->ti->error = "Only one min_recovery_rate argument pair allowed";
  1258                                  return -EINVAL;
  1259                          }
  1260                          if (value > INT_MAX) {
                                            ^^^^^^^
Here we're using INT_MAX.

  1261                                  rs->ti->error = "min_recovery_rate out of range";
  1262                                  return -EINVAL;
  1263                          }
  1264                          rs->md.sync_speed_min = (int)value;
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This looks like negatives are intentional...  A few lines later as well.

drivers/md/dm-raid.c:1274 parse_raid_params() warn: no lower bound on 'value'

regards,
dan carpenter
