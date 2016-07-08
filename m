From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: dm: raid456 basic support
Date: Fri, 8 Jul 2016 17:13:02 +0300
Message-ID: <20160708141302.GT32247@mwanda>
References: <20160617091405.GA25609@mwanda>
 <87mvltf1d0.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87mvltf1d0.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-raid.ids

Oops.  Sorry.  No, that won't help.  We're looking at different code,
hence the confusion.  I'm working off linux-next.

The problem is commit 6e20902e8f9e ('dm raid: fix failed
takeover/reshapes by keeping raid set frozen') where we changed "value"
to unsigned to int, but forgot to add underflow checks.

The warnings are:

drivers/md/dm-raid.c:1217 parse_raid_params() warn: no lower bound on 'value'
drivers/md/dm-raid.c:1264 parse_raid_params() warn: no lower bound on 'value'
drivers/md/dm-raid.c:1274 parse_raid_params() warn: no lower bound on 'value'


drivers/md/dm-raid.c
  1147                  if (kstrtoint(arg, 10, &value) < 0) {
                                               ^^^^^^
Set here.

  1148                          rs->ti->error = "Bad numerical argument given in raid params";
  1149                          return -EINVAL;
  1150                  }
  1151  
  1152                  if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_REBUILD))) {
  1153                          /*
  1154                           * "rebuild" is being passed in by userspace to provide
  1155                           * indexes of replaced devices and to set up additional
  1156                           * devices on raid level takeover.
  1157                           */
  1158                          if (!__within_range(value, 0, rs->raid_disks - 1)) {
  1159                                  rs->ti->error = "Invalid rebuild index given";
  1160                                  return -EINVAL;
  1161                          }
  1162  
  1163                          if (test_and_set_bit(value, (void *) rs->rebuild_disks)) {
  1164                                  rs->ti->error = "rebuild for this index already given";
  1165                                  return -EINVAL;
  1166                          }
  1167  
  1168                          rd = rs->dev + value;
  1169                          clear_bit(In_sync, &rd->rdev.flags);
  1170                          clear_bit(Faulty, &rd->rdev.flags);
  1171                          rd->rdev.recovery_offset = 0;
  1172                          set_bit(__CTR_FLAG_REBUILD, &rs->ctr_flags);
  1173                  } else if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_WRITE_MOSTLY))) {
  1174                          if (!rt_is_raid1(rt)) {
  1175                                  rs->ti->error = "write_mostly option is only valid for RAID1";
  1176                                  return -EINVAL;
  1177                          }
  1178  
  1179                          if (!__within_range(value, 0, rs->md.raid_disks - 1)) {
  1180                                  rs->ti->error = "Invalid write_mostly index given";
  1181                                  return -EINVAL;
  1182                          }
  1183  
  1184                          set_bit(WriteMostly, &rs->dev[value].rdev.flags);
  1185                          set_bit(__CTR_FLAG_WRITE_MOSTLY, &rs->ctr_flags);
  1186                  } else if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_MAX_WRITE_BEHIND))) {
  1187                          if (!rt_is_raid1(rt)) {
  1188                                  rs->ti->error = "max_write_behind option is only valid for RAID1";
  1189                                  return -EINVAL;
  1190                          }
  1191  
  1192                          if (test_and_set_bit(__CTR_FLAG_MAX_WRITE_BEHIND, &rs->ctr_flags)) {
  1193                                  rs->ti->error = "Only one max_write_behind argument pair allowed";
  1194                                  return -EINVAL;
  1195                          }
  1196  
  1197                          /*
  1198                           * In device-mapper, we specify things in sectors, but
  1199                           * MD records this value in kB
  1200                           */
  1201                          value /= 2;
  1202                          if (value > COUNTER_MAX) {
  1203                                  rs->ti->error = "Max write-behind limit out of range";
  1204                                  return -EINVAL;
  1205                          }
  1206  
  1207                          rs->md.bitmap_info.max_write_behind = value;
  1208                  } else if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_DAEMON_SLEEP))) {
  1209                          if (test_and_set_bit(__CTR_FLAG_DAEMON_SLEEP, &rs->ctr_flags)) {
  1210                                  rs->ti->error = "Only one daemon_sleep argument pair allowed";
  1211                                  return -EINVAL;
  1212                          }
  1213                          if (!value || (value > MAX_SCHEDULE_TIMEOUT)) {
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Not checked for negatives.

  1214                                  rs->ti->error = "daemon sleep period out of range";
  1215                                  return -EINVAL;
  1216                          }
  1217                          rs->md.bitmap_info.daemon_sleep = value;

regards,
dan carpenter
