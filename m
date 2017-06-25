From: Hubert Reevez <hubereevez@gmail.com>
Subject: Re: can't add a larger spare for a failed smaller disk
Date: Sun, 25 Jun 2017 20:32:30 +0200
Message-ID: <CAAK+==Y_P8hdhRoHnbGK7NujMYe2ERs6wztA-7CP_4MpZxZTRw@mail.gmail.com>
References: <CAAK+==bmLQ6EGm806+feV=PGp1xB7vMwtEXXD3dJZA8fHn-osQ@mail.gmail.com>
 <CAFCYAsePbzqj7=0BORYGSvQFAOY9SCDAfX1hQmj-8gH2dFj3WA@mail.gmail.com>
 <CAAK+==YbNyjFryhDmJe2Y67rcGzZKvaKX2BaEJzZTuMTN98jRw@mail.gmail.com>
 <CAFCYAsexbWzffTdouwjQQf0=ZrSx+67c3rWtHcTX9K0nZ5Uuxw@mail.gmail.com>
 <CAAK+==Y1h9GPw-5jmtnXKNPP6aYz3ezKre-MKSPvW9Sbjv7hdQ@mail.gmail.com>
 <CAFCYAsdDdBVxFuj1S_5vOTNO3KN0mqA+hjbD99Ea53AadXuMFA@mail.gmail.com>
 <CAAK+==YioRVH4LAYVHmfuF41+T-emBwoMawp4xBPyowYTp9_tA@mail.gmail.com> <CAAK+==bH6JcdtXYGhf+zJ_g1XvzKUnNEyTfpcdgDnuJ8WhmG3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAK+==bH6JcdtXYGhf+zJ_g1XvzKUnNEyTfpcdgDnuJ8WhmG3w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All seems to went good, but data offset are not equal on sdc and sdg,
should I grow ? or something else ? thanks again


md0 : active raid6 sdf[0] sdg[6] sdb[4] sde[3] sda[2] sdc[7]
5860548608 blocks super 1.2 level 6, 512k chunk, algorithm 2 [6/6] [UUUUUU]


mdadm -E : https://pastebin.com/hs7F5Ppi
