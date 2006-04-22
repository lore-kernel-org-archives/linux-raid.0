From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: data recovery on raid5
Date: Sat, 22 Apr 2006 18:42:33 -0300
Message-ID: <17482.41801.445052.11179@fisica.ufpr.br>
References: <444A7C99.80006@abhost.net>
	<62b0912f0604221248s653843bfx363f346c7ef31a94@mail.gmail.com>
	<444A8D04.20809@abhost.net>
	<62b0912f0604221322k25c96c37q2bee9361a6316c1b@mail.gmail.com>
	<444A92CF.70401@abhost.net>
	<62b0912f0604221338m6b9fc06do61d78ffa622523bc@mail.gmail.com>
	<444A9841.8070202@abhost.net>
	<62b0912f0604221417g3f539b9aub9c4fa82ab78faaf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0604221417g3f539b9aub9c4fa82ab78faaf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich (molle.bestefich@gmail.com) wrote on 22 April 2006 23:17:
 >Jonathan wrote:
 >> thank you thank you thank you thank you thank you thank you

Nice job Molle!

 >np.
 >(wait, does that mean I won't get my money? ;-))

At least you showed someone a new meaning of "support"...

Is it my turn now? Just look at this:

md1 : active raid5 sdp2[15](F) sdo2[16](F) sdn2[13] sdm2[12] sdl2[11] sdk2[10] sdj2[9] sdi2[8] sdh2[17](F) sdg2[18](F) sdf2[5] sde2[4] sdd2[3] sdc2[2] sdb2[1] sda2[0]
      4198656 blocks level 5, 128k chunk, algorithm 2 [15/12] [UUUUUU__UUUUUU_]
      
md3 : active raid5 sdp5[15](F) sdo5[16](F) sdn5[13] sdm5[12] sdl5[11] sdk5[10] sdj5[9] sdi5[8] sdh5[17](F) sdg5[18](F) sdf5[5] sde5[4] sdd5[3] sdc5[2] sdb5[1] sda5[0]
      588487424 blocks level 5, 128k chunk, algorithm 2 [15/12] [UUUUUU__UUUUUU_]
      
md4 : active raid5 sdp6[15](S) sdo6[16](F) sdn6[13] sdm6[12] sdl6[11] sdk6[10] sdj6[9] sdi6[8] sdh6[17](F) sdg6[18](F) sdf6[5] sde6[4] sdd6[3] sdc6[2] sdb6[1] sda6[0]
      2141065472 blocks level 5, 128k chunk, algorithm 2 [15/12] [UUUUUU__UUUUUU_]

This is a 15-array + spare where 3 or 4 disks dropped, *very* likely
because of these miserable crappy sata power connectors :-( :-( It's
unbelievable that the industry changes from a working standard to an
unreliable trash in such common and widespread devices...

I'm trying to get enough stamina to put the damn thing back on line...
Or at least try to :-(
