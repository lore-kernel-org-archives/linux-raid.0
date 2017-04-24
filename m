From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Mon, 24 Apr 2017 15:39:46 +0200
Message-ID: <20170424133946.GA7057@metamorpher.de>
References: <20170423144835.GB12093@metamorpher.de>
 <f353b7fc-a63a-5503-5cda-6a62698f69ae@powerlamerz.org>
 <20170423154240.GA3494@metamorpher.de>
 <718f75d1-b74f-f788-783a-6ffbdff275a8@powerlamerz.org>
 <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
 <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
 <20170424110455.GA4949@metamorpher.de>
 <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
 <20170424123706.GA6798@metamorpher.de>
 <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 24, 2017 at 02:54:50PM +0200, Patrik Dahlström wrote:
> What offset are you referring to here? The --data-offset to the mdadm
> --create command?

Yes, data offset...

> I don't think the disk was ever kicked out. The kernel reset the link
> and continued, I believe.

Okay.

Another thing you can check is, pick an arbitrary offset that does not 
have zeroes on the disks, and see if the XOR matches for 5, or 6 disks.

It should match for 6 for however far the grow progressed, 
and match for 5 afterwards.

Again with my example from before,

# for hexdump -C -n 16 -s 10000000 "$f"
00989680  30 30 30 30 30 30 30 30  32 61 38 39 36 38 30 0a  |000000002a89680.|
00989690                                                             ^^
00989680  30 30 30 30 30 30 30 30  32 61 38 39 36 38 30 0a  |000000002a89680.|
00989690                                                             ^^
00989680  30 30 30 30 30 30 30 30  32 62 30 39 36 38 30 0a  |000000002b09680.|
00989690                                                             ^^
00989680  30 30 30 30 30 30 30 30  32 62 38 39 36 38 30 0a  |000000002b89680.|
00989690                                                             ^^
00989680  30 30 30 30 30 30 30 30  32 63 30 39 36 38 30 0a  |000000002c09680.|
00989690                                                             ^^ 
00989680  30 30 30 30 30 30 30 30  32 63 38 39 36 38 30 0a  |000000002c89680.|
00989690                                                             ^^

2a ^ 2a ^ 2b ^ 2b ^ 2c = 2c OK for 6 disk area

# for hexdump -C -n 16 -s 90000000 "$f"
055d4a80  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
055d4a90                                                              ^^
055d4a80  30 30 30 30 30 30 30 31  35 32 35 34 61 38 30 0a  |000000015254a80.|
055d4a90                                                              ^^
055d4a80  30 30 30 30 30 30 30 31  35 32 64 34 61 38 30 0a  |0000000152d4a80.|
055d4a90                                                              ^^
055d4a80  30 30 30 30 30 30 30 31  35 33 35 34 61 38 30 0a  |000000015354a80.|
055d4a90                                                              ^^ 
055d4a80  30 30 30 30 30 30 30 31  35 33 64 34 61 38 30 0a  |0000000153d4a80.|
055d4a90                                                              ^^

25 ^ 2d ^ 35 ^ 3d = \0\0 OK for 5 disk area

(I did not intend for the parity to be zero in this example, 
 but that's just how it turned out to be...)

If you have a 5disk parity match in the zone that should be 6disks, 
then maybe one of your earlier mdadm create experiments started to 
sync the raid.

This would be yet another nail in your coffin.

Regards
Andreas Klauer
