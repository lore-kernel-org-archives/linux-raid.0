From: Johannes Segitz <johannes.segitz@gmail.com>
Subject: Re: Performance of a software raid 5
Date: Sun, 26 Apr 2009 19:03:41 +0200
Message-ID: <a5cd9eed0904261003w28a25a32n4d5017ee41d9e471@mail.gmail.com>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>
	 <49ED096E.1000002@anonymous.org.uk>
	 <a5cd9eed0904201710j5b05d9cam8a61b50f34eda2c0@mail.gmail.com>
	 <49ED18E6.1090301@anonymous.org.uk>
	 <a5cd9eed0904201805n1b52aafm206bda5a1afc0b5c@mail.gmail.com>
	 <15c92f8bd27d912e292c013fea2467e4.squirrel@neil.brown.name>
	 <a5cd9eed0904201904o29c02a8csb875ae68ba19e681@mail.gmail.com>
	 <18925.23969.113047.133385@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18925.23969.113047.133385@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 21, 2009 at 7:46 AM, Neil Brown <neilb@suse.de> wrote:
> I suspect you will see that improve when you add another drive that it
> isn't running degraded.

Well, i didn't but it doesn't really matter since the crypto layer slows
it down to a crawl

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md6 : active raid5 sdd1[0] sdc1[1] md7[3] md8[4] sde1[2]
      3907039232 blocks level 5, 256k chunk, algorithm 2 [5/5] [UUUUU]
      bitmap: 1/15 pages [4KB], 32768KB chunk

md7 : active raid0 sdg1[0] sda1[1]
      976767744 blocks 128k chunks

md8 : active raid0 sdh1[1] sdb1[0]
      976767744 blocks 128k chunks

So everything is okay now, no missing drive and the bad drive is now gone.

for d in /dev/sd[cde]1 /dev/md[678] /dev/mapper/daten bigfile
do
   echo $d
   dd if=$d of=/dev/null bs=1M count=1000
done

/dev/sdc1
1048576000 bytes (1.0 GB) copied, 6.13302 s, 171 MB/s
/dev/sdd1
1048576000 bytes (1.0 GB) copied, 12.2261 s, 85.8 MB/s
/dev/sde1
1048576000 bytes (1.0 GB) copied, 11.8026 s, 88.8 MB/s
/dev/md6
1048576000 bytes (1.0 GB) copied, 6.42977 s, 163 MB/s
/dev/md7
1048576000 bytes (1.0 GB) copied, 9.51655 s, 110 MB/s
/dev/md8
1048576000 bytes (1.0 GB) copied, 7.97321 s, 132 MB/s
/dev/mapper/daten
1048576000 bytes (1.0 GB) copied, 28.6309 s, 36.6 MB/s
bigfile
1048576000 bytes (1.0 GB) copied, 31.9715 s, 32.8 MB/s

So the raid works okay, although i'm not thrilled by 163 MB/s
read speed when i see what the underlying devices are capable
of. But the real bad drop seems to be the crypto and with
http://tynne.de/linux-crypto-speed in mind it seems quite a
reasonable speed, although i'm disappointed since i expected
more. Next time i won't expect but do better tests beforehand.

Thanks everyone for their help.
Johannes
