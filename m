From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: can't add a larger spare for a failed smaller disk
Date: Sun, 25 Jun 2017 19:55:16 +0100
Message-ID: <59500714.5050407@youngman.org.uk>
References: <CAAK+==bmLQ6EGm806+feV=PGp1xB7vMwtEXXD3dJZA8fHn-osQ@mail.gmail.com>
 <CAFCYAsePbzqj7=0BORYGSvQFAOY9SCDAfX1hQmj-8gH2dFj3WA@mail.gmail.com>
 <CAAK+==YbNyjFryhDmJe2Y67rcGzZKvaKX2BaEJzZTuMTN98jRw@mail.gmail.com>
 <CAFCYAsexbWzffTdouwjQQf0=ZrSx+67c3rWtHcTX9K0nZ5Uuxw@mail.gmail.com>
 <CAAK+==Y1h9GPw-5jmtnXKNPP6aYz3ezKre-MKSPvW9Sbjv7hdQ@mail.gmail.com>
 <CAFCYAsdDdBVxFuj1S_5vOTNO3KN0mqA+hjbD99Ea53AadXuMFA@mail.gmail.com>
 <CAAK+==YioRVH4LAYVHmfuF41+T-emBwoMawp4xBPyowYTp9_tA@mail.gmail.com>
 <CAAK+==bH6JcdtXYGhf+zJ_g1XvzKUnNEyTfpcdgDnuJ8WhmG3w@mail.gmail.com>
 <CAAK+==Y_P8hdhRoHnbGK7NujMYe2ERs6wztA-7CP_4MpZxZTRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAK+==Y_P8hdhRoHnbGK7NujMYe2ERs6wztA-7CP_4MpZxZTRw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hubert Reevez <hubereevez@gmail.com>, Jeff Johnson <jeff.johnson@aeoncomputing.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/06/17 19:32, Hubert Reevez wrote:
> All seems to went good, but data offset are not equal on sdc and sdg,
> should I grow ? or something else ? thanks again
> 
That's normal on an array to which "things have happened".

If you grow or shrink or do other things which need to move data around,
the operation moves the data to a new offset to avoid having to have a
backup file.

And it does this on a per-disk basis, so if you if you change the raid
type, or you add a disk, or you do whole bunch of assorted operations,
the data could end up shuffled back and forth all over the place.

Bottom line - it's expected behaviour, don't worry.

Have you read the raid wiki? I get the impression you're not that au
fait with how raid works - a little bit of study might not go amiss :-)
> 
> md0 : active raid6 sdf[0] sdg[6] sdb[4] sde[3] sda[2] sdc[7]
> 5860548608 blocks super 1.2 level 6, 512k chunk, algorithm 2 [6/6] [UUUUUU]
> 
> 
> mdadm -E : https://pastebin.com/hs7F5Ppi

Cheers,
Wol

