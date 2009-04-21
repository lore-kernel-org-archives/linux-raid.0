From: Johannes Segitz <johannes.segitz@gmail.com>
Subject: Re: Performance of a software raid 5
Date: Tue, 21 Apr 2009 04:04:09 +0200
Message-ID: <a5cd9eed0904201904o29c02a8csb875ae68ba19e681@mail.gmail.com>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>
	 <49ED096E.1000002@anonymous.org.uk>
	 <a5cd9eed0904201710j5b05d9cam8a61b50f34eda2c0@mail.gmail.com>
	 <49ED18E6.1090301@anonymous.org.uk>
	 <a5cd9eed0904201805n1b52aafm206bda5a1afc0b5c@mail.gmail.com>
	 <15c92f8bd27d912e292c013fea2467e4.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15c92f8bd27d912e292c013fea2467e4.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 21, 2009 at 3:19 AM, NeilBrown <neilb@suse.de> wrote:
> Have you done any testing without the crypto layer to see what effect
> that has?
>
> Can I suggest:
>
> =A0for d in /dev/sd[gjk]1 /dev/md6 /dev/mapper/data bigfile
> =A0do
> =A0 =A0dd if=3D$d of=3D/dev/null bs=3D1M count=3D100
> =A0done
>
> and report the times.

tested it with 1gb instead of 100 mb

sdg
1048576000 bytes (1.0 GB) copied, 9.89311 s, 106 MB/s
sdj
1048576000 bytes (1.0 GB) copied, 10.094 s, 104 MB/s
sdk
1048576000 bytes (1.0 GB) copied, 8.53513 s, 123 MB/s
/dev/md6
1048576000 bytes (1.0 GB) copied, 11.4741 s, 91.4 MB/s
/dev/mapper/data
1048576000 bytes (1.0 GB) copied, 34.4544 s, 30.4 MB/s
bigfile
1048576000 bytes (1.0 GB) copied, 26.6532 s, 39.3 MB/s

so the crypto indeed slows it down (and i'm surprised that it's that
bad because i've read
it's not a big hit on current CPUs and the X2 isn't new but not that
old) but still read speed
from md6 is worse than from one drive alone

Johannes
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
