From: dean gaudet <dean@arctic.org>
Subject: Re: raid5 hang on get_active_stripe
Date: Tue, 30 May 2006 18:46:15 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605301844180.21977@twinlark.arctic.org>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
 <Pine.LNX.4.56.0603061156140.26994@lion.drogon.net>
 <5d96567b0603060456h5f2c3cc8me790c86b74e1f854@mail.gmail.com>
 <4415F400.5030808@ucolick.org> <17429.64926.100005.904328@cse.unsw.edu.au>
 <Pine.LNX.4.64.0605110758100.25283@twinlark.arctic.org>
 <Pine.LNX.4.64.0605171137350.29929@twinlark.arctic.org>
 <17522.29813.189944.397154@cse.unsw.edu.au> <Pine.LNX.4.64.0605260903270.7952@twinlark.arctic.org>
 <17527.38282.35857.117651@cse.unsw.edu.au> <Pine.LNX.4.64.0605270834240.30550@twinlark.arctic.org>
 <17529.37347.782285.77442@cse.unsw.edu.au> <Pine.LNX.4.64.0605291354260.30134@twinlark.arctic.org>
 <17531.35050.632471.433333@cse.unsw.edu.au> <Pine.LNX.4.64.0605301713480.11178@twinlark.arctic.org>
 <17532.59212.364233.765155@cse.unsw.edu.au> <Pine.LNX.4.64.0605301758380.21977@twinlark.arctic.org>
 <17532.62343.933852.982391@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17532.62343.933852.982391@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 31 May 2006, Neil Brown wrote:

> On Tuesday May 30, dean@arctic.org wrote:
> > 
> > actually i think the rate is higher... i'm not sure why, but klogd doesn't 
> > seem to keep up with it:
> > 
> > root@neemlark:~# grep -c kblockd_schedule_work /var/log/messages
> > 31
> > root@neemlark:~# dmesg | grep -c kblockd_schedule_work
> > 8192
> 
> # grep 'last message repeated' /var/log/messages
> ??

um hi, of course :)  the paste below is approximately correct.

-dean

root@neemlark:~# egrep 'kblockd_schedule_work|last message repeated' /var/log/messages
May 30 17:05:09 localhost kernel: kblockd_schedule_work failed
May 30 17:05:59 localhost kernel: kblockd_schedule_work failed
May 30 17:08:16 localhost kernel: kblockd_schedule_work failed
May 30 17:10:51 localhost kernel: kblockd_schedule_work failed
May 30 17:11:51 localhost kernel: kblockd_schedule_work failed
May 30 17:12:46 localhost kernel: kblockd_schedule_work failed
May 30 17:12:56 localhost last message repeated 22 times
May 30 17:14:14 localhost kernel: kblockd_schedule_work failed
May 30 17:16:57 localhost kernel: kblockd_schedule_work failed
May 30 17:17:00 localhost last message repeated 83 times
May 30 17:17:02 localhost kernel: kblockd_schedule_work failed
May 30 17:17:33 localhost last message repeated 950 times
May 30 17:18:34 localhost last message repeated 2218 times
May 30 17:19:35 localhost last message repeated 1581 times
May 30 17:20:01 localhost last message repeated 579 times
May 30 17:20:02 localhost kernel: kblockd_schedule_work failed
May 30 17:20:02 localhost kernel: kblockd_schedule_work failed
May 30 17:20:02 localhost kernel: kblockd_schedule_work failed
May 30 17:20:02 localhost last message repeated 23 times
May 30 17:20:03 localhost kernel: kblockd_schedule_work failed
May 30 17:20:34 localhost last message repeated 1058 times
May 30 17:21:35 localhost last message repeated 2171 times
May 30 17:22:36 localhost last message repeated 2305 times
May 30 17:23:37 localhost last message repeated 2311 times
May 30 17:24:38 localhost last message repeated 1993 times
May 30 17:25:01 localhost last message repeated 702 times
May 30 17:25:02 localhost kernel: kblockd_schedule_work failed
May 30 17:25:02 localhost last message repeated 15 times
May 30 17:25:02 localhost kernel: kblockd_schedule_work failed
May 30 17:25:02 localhost last message repeated 12 times
May 30 17:25:03 localhost kernel: kblockd_schedule_work failed
May 30 17:25:34 localhost last message repeated 1061 times
May 30 17:26:35 localhost last message repeated 2009 times
May 30 17:27:36 localhost last message repeated 1941 times
May 30 17:28:37 localhost last message repeated 2345 times
May 30 17:29:38 localhost last message repeated 2367 times
May 30 17:30:01 localhost last message repeated 870 times
May 30 17:30:01 localhost kernel: kblockd_schedule_work failed
May 30 17:30:01 localhost last message repeated 45 times
May 30 17:30:02 localhost kernel: kblockd_schedule_work failed
May 30 17:30:33 localhost last message repeated 1180 times
May 30 17:31:34 localhost last message repeated 2062 times
May 30 17:32:34 localhost last message repeated 2277 times
May 30 17:32:36 localhost kernel: kblockd_schedule_work failed
May 30 17:33:07 localhost last message repeated 1114 times
May 30 17:34:08 localhost last message repeated 2308 times
May 30 17:35:01 localhost last message repeated 1941 times
May 30 17:35:01 localhost kernel: kblockd_schedule_work failed
May 30 17:35:02 localhost last message repeated 20 times
May 30 17:35:02 localhost kernel: kblockd_schedule_work failed
May 30 17:35:33 localhost last message repeated 1051 times
May 30 17:36:34 localhost last message repeated 2002 times
May 30 17:37:35 localhost last message repeated 1644 times
May 30 17:38:36 localhost last message repeated 1731 times
May 30 17:39:37 localhost last message repeated 1844 times
May 30 17:40:01 localhost last message repeated 817 times
May 30 17:40:02 localhost kernel: kblockd_schedule_work failed
May 30 17:40:02 localhost last message repeated 39 times
May 30 17:40:02 localhost kernel: kblockd_schedule_work failed
May 30 17:40:02 localhost last message repeated 12 times
May 30 17:40:03 localhost kernel: kblockd_schedule_work failed
May 30 17:40:34 localhost last message repeated 1051 times
May 30 17:41:35 localhost last message repeated 1576 times
May 30 17:42:36 localhost last message repeated 2000 times
May 30 17:43:37 localhost last message repeated 2058 times
May 30 17:44:15 localhost last message repeated 1337 times
May 30 17:44:15 localhost kernel: kblockd_schedule_work failed
May 30 17:44:46 localhost last message repeated 1016 times
May 30 17:45:01 localhost last message repeated 432 times
May 30 17:45:02 localhost kernel: kblockd_schedule_work failed
May 30 17:45:02 localhost kernel: kblockd_schedule_work failed
May 30 17:45:33 localhost last message repeated 1229 times
May 30 17:46:34 localhost last message repeated 2552 times
May 30 17:47:36 localhost last message repeated 2126 times
May 30 17:48:37 localhost last message repeated 2348 times
May 30 17:49:38 localhost last message repeated 1843 times
May 30 17:50:00 localhost last message repeated 796 times
May 30 17:50:01 localhost kernel: kblockd_schedule_work failed
May 30 17:50:32 localhost last message repeated 1238 times
May 30 17:51:33 localhost last message repeated 2374 times
May 30 17:52:34 localhost last message repeated 2366 times
May 30 17:53:35 localhost last message repeated 2195 times
May 30 17:54:36 localhost last message repeated 2345 times
May 30 17:55:01 localhost last message repeated 790 times
May 30 17:55:02 localhost kernel: kblockd_schedule_work failed
May 30 17:55:02 localhost last message repeated 49 times
May 30 17:55:02 localhost kernel: kblockd_schedule_work failed
May 30 17:55:02 localhost last message repeated 13 times
May 30 17:55:03 localhost kernel: kblockd_schedule_work failed
May 30 17:55:34 localhost last message repeated 1070 times
May 30 17:56:35 localhost last message repeated 2278 times
May 30 17:57:37 localhost last message repeated 2459 times
May 30 17:58:38 localhost last message repeated 2076 times
May 30 17:59:39 localhost last message repeated 1719 times
May 30 18:00:01 localhost last message repeated 654 times
May 30 18:00:03 localhost kernel: kblockd_schedule_work failed
May 30 18:00:34 localhost last message repeated 868 times
May 30 18:01:35 localhost last message repeated 1765 times
May 30 18:02:33 localhost last message repeated 1759 times
May 30 18:02:35 localhost kernel: kblockd_schedule_work failed
May 30 18:02:35 localhost last message repeated 9 times
May 30 18:02:35 localhost kernel: kblockd_schedule_work failed
May 30 18:02:35 localhost kernel: kblockd_schedule_work failed
May 30 18:02:35 localhost last message repeated 9 times
May 30 18:02:35 localhost kernel: kblockd_schedule_work failed
May 30 18:02:35 localhost last message repeated 4 times
May 30 18:02:36 localhost kernel: kblockd_schedule_work failed
May 30 18:02:36 localhost last message repeated 4 times
May 30 18:02:36 localhost kernel: kblockd_schedule_work failed
May 30 18:02:36 localhost last message repeated 10 times
May 30 18:02:36 localhost kernel: kblockd_schedule_work failed
May 30 18:02:36 localhost kernel: kblockd_schedule_work failed
May 30 18:02:37 localhost kernel: kblockd_schedule_work failed
May 30 18:02:37 localhost last message repeated 7 times
May 30 18:02:37 localhost kernel: kblockd_schedule_work failed
May 30 18:02:37 localhost kernel: kblockd_schedule_work failed
May 30 18:02:37 localhost kernel: kblockd_schedule_work failed
May 30 18:02:37 localhost kernel: kblockd_schedule_work failed
May 30 18:02:37 localhost kernel: kblockd_schedule_work failed
May 30 18:03:08 localhost last message repeated 842 times
May 30 18:04:09 localhost last message repeated 1828 times
May 30 18:04:15 localhost last message repeated 221 times
May 30 18:04:15 localhost kernel: kblockd_schedule_work failed
May 30 18:04:46 localhost last message repeated 1042 times
May 30 18:05:00 localhost last message repeated 551 times
May 30 18:05:01 localhost kernel: kblockd_schedule_work failed
May 30 18:05:32 localhost last message repeated 919 times
May 30 18:06:33 localhost last message repeated 2608 times
May 30 18:07:34 localhost last message repeated 2412 times
May 30 18:08:35 localhost last message repeated 2536 times
May 30 18:09:36 localhost last message repeated 2441 times
May 30 18:10:01 localhost last message repeated 812 times
May 30 18:10:01 localhost kernel: kblockd_schedule_work failed
May 30 18:10:01 localhost last message repeated 5 times
May 30 18:10:01 localhost kernel: kblockd_schedule_work failed
May 30 18:10:01 localhost last message repeated 16 times
May 30 18:10:02 localhost kernel: kblockd_schedule_work failed
May 30 18:10:33 localhost last message repeated 1311 times
May 30 18:11:34 localhost last message repeated 2396 times
May 30 18:11:45 localhost last message repeated 328 times
May 30 18:11:47 localhost kernel: kblockd_schedule_work failed
May 30 18:12:18 localhost last message repeated 1470 times
May 30 18:13:19 localhost last message repeated 2457 times
May 30 18:14:20 localhost last message repeated 2275 times
May 30 18:15:01 localhost last message repeated 1577 times
May 30 18:15:01 localhost kernel: kblockd_schedule_work failed
May 30 18:15:01 localhost last message repeated 6 times
May 30 18:15:02 localhost kernel: kblockd_schedule_work failed
May 30 18:15:33 localhost last message repeated 1241 times
May 30 18:16:37 localhost last message repeated 2487 times
May 30 18:17:01 localhost last message repeated 826 times
May 30 18:17:02 localhost kernel: kblockd_schedule_work failed
May 30 18:17:33 localhost last message repeated 1386 times
May 30 18:18:34 localhost last message repeated 2195 times
May 30 18:19:29 localhost last message repeated 1021 times
May 30 18:19:55 localhost last message repeated 62 times
May 30 18:20:04 localhost kernel: kblockd_schedule_work failed
May 30 18:20:39 localhost last message repeated 105 times
May 30 18:21:34 localhost last message repeated 189 times
May 30 18:22:45 localhost last message repeated 104 times
May 30 18:23:40 localhost last message repeated 170 times
May 30 18:24:15 localhost last message repeated 120 times
May 30 18:24:45 localhost kernel: kblockd_schedule_work failed
May 30 18:24:49 localhost last message repeated 13 times
May 30 18:25:19 localhost kernel: kblockd_schedule_work failed
May 30 18:25:25 localhost last message repeated 138 times
May 30 18:26:49 localhost last message repeated 113 times
May 30 18:27:35 localhost last message repeated 339 times
May 30 18:28:50 localhost last message repeated 108 times
May 30 18:29:35 localhost last message repeated 143 times
May 30 18:30:05 localhost kernel: kblockd_schedule_work failed
May 30 18:30:40 localhost last message repeated 55 times
May 30 18:31:50 localhost last message repeated 313 times
May 30 18:32:30 localhost last message repeated 236 times
May 30 18:32:36 localhost kernel: kblockd_schedule_work failed
May 30 18:32:36 localhost last message repeated 8 times
May 30 18:32:36 localhost kernel: kblockd_schedule_work failed
May 30 18:32:36 localhost last message repeated 11 times
May 30 18:32:36 localhost kernel: kblockd_schedule_work failed
May 30 18:32:36 localhost last message repeated 5 times
May 30 18:32:36 localhost kernel: kblockd_schedule_work failed
May 30 18:32:36 localhost last message repeated 3 times
May 30 18:32:36 localhost kernel: kblockd_schedule_work failed
May 30 18:32:36 localhost kernel: kblockd_schedule_work failed
May 30 18:32:36 localhost kernel: kblockd_schedule_work failed
May 30 18:32:50 localhost kernel: kblockd_schedule_work failed
May 30 18:33:15 localhost last message repeated 91 times
May 30 18:34:15 localhost last message repeated 86 times
May 30 18:34:50 localhost last message repeated 133 times
May 30 18:35:20 localhost kernel: kblockd_schedule_work failed
May 30 18:35:50 localhost last message repeated 245 times
May 30 18:36:35 localhost last message repeated 190 times
May 30 18:37:50 localhost last message repeated 372 times
May 30 18:38:25 localhost last message repeated 27 times
May 30 18:39:40 localhost last message repeated 188 times
May 30 18:40:00 localhost last message repeated 129 times
May 30 18:40:35 localhost kernel: kblockd_schedule_work failed
May 30 18:41:10 localhost last message repeated 76 times
May 30 18:42:20 localhost last message repeated 186 times
May 30 18:43:00 localhost last message repeated 154 times
