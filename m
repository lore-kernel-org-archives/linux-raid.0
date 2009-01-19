From: thomas62186218@aol.com
Subject: Re: Roadmap for md/raid ???
Date: Mon, 19 Jan 2009 14:03:57 -0500
Message-ID: <8CB487FD08E50F2-152C-7B6@webmail-dx12.sysops.aol.com>
References: <18763.7881.300921.177207@notabene.brown> <20081230191250.70701c5c@absurd> <18803.53032.383350.741460@nbeee.brown> <20090119122505.GB23623@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090119122505.GB23623@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: keld@dkuug.dk, neilb@suse.de
Cc: janek_listy@wp.pl, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I agree with Keld on the need for RAID 10 expansion and increasing RAID=
=20
10 performance. Those are the hottest issues I see right now.

-Thomas


-----Original Message-----
=46rom: Keld J=C3=B8rn Simonsen <keld@dkuug.dk>
To: Neil Brown <neilb@suse.de>
Cc: Janek Kozicki <janek_listy@wp.pl>; linux-raid@vger.kernel.org
Sent: Mon, 19 Jan 2009 4:25 am
Subject: Re: Roadmap for md/raid ???










I would like to see some enhancements to  the raid code:

1. removal of need to set the readahead to say 32 MiB for certain
   raid types to get the desired performance

2. getting resync and other performance up for raid10, possibly
   using bigger buffers.

3. growing raid10.

I wonder where this is placed in the roadmap. Neil?

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html





--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
