From: Raz <raziebe@gmail.com>
Subject: raid0 hashing funtion
Date: Sun, 3 May 2009 16:29:11 +0300
Message-ID: <5d96567b0905030629s3e1ec55coa9f0fc5fb0a3ce2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Hello
I am reading the raid0 code, and I do not understand what is the
rational behind this hashing and spacing ?
I am asking because I am working on the chunk size restrictions.
in raid0_make_request the zone calculation is as follows:

      {
              sector_t x = sector >> conf->sector_shift;
              sector_div(x, (u32)conf->spacing);
              zone = conf->hash_table[x];
      }
        while (sector >= zone->zone_start + zone->sectors)
                zone++;

I replaced it with the code :
        zone = &conf->strip_zone[0];
        while (sector >= zone->zone_start + zone->sectors)
                zone++;
and all is fine .  why do we need the hashing/spacing complication ?
thank you
raz
