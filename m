From: Bryan Wintermute <bryanwintermute@gmail.com>
Subject: RAID 5 - One drive dropped while replacing another
Date: Tue, 1 Feb 2011 15:27:50 -0800
Message-ID: <AANLkTikSjLhoUM5f2ibqCUmo8XF-tsrhxZ7oieg08dtD@mail.gmail.com>
References: <AANLkTinXTYds442gPrs9a9vKtWTo4OcDHDEzvO0njvyv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinXTYds442gPrs9a9vKtWTo4OcDHDEzvO0njvyv@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a RAID5 setup with 15 drives. One drive died, so I purchased a
replacement and added it to the array. During this process, however,
another drive dropped. Upon further inspection, the second failed
drive has some bad sectors that appears to be keeping mdadm from
completing the recovery. If I remove the replacement drive, thus
keeping mdadm from recovering, the array functions and most of the
data is intact (save for the occasional missing files and folders).
Mdadm is able to recover for about 30 seconds to 1 minute before it
drops the drive and quits the recovery. Is there anything I can do to
get around these bad sectors or force mdadm to ignore them to at least
complete the recovery? I don't care about losing some of the data, but
it'd be nice to not lose all of it.

I'm running Ubuntu 10.04 LTS x64 with=A0mdadm - v2.6.7.1 - 15th October=
 2008

Please let me know if you need any more information.

Thank you for your time and any help,
Bryan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
