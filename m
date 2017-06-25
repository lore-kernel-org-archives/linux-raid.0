From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: can't add a larger spare for a failed smaller disk
Date: Mon, 26 Jun 2017 00:30:38 +0100
Message-ID: <22864.18334.727159.279431@tree.ty.sabi.co.uk>
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
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAK+==Y_P8hdhRoHnbGK7NujMYe2ERs6wztA-7CP_4MpZxZTRw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> All seems to went good, but data offset are not equal on sdc
> and sdg, should I grow ? or something else ? thanks again

That "works" if it works, but can be a very dangerous situation
as the space available for data is different on the various RAID
set members, as if the disks were of sligtly different sizes.

http://www.sabi.co.uk/Notes/linuxStor.html#stHintsMD
