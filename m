From: "Robin Bowes" <robin-lists@robinbowes.com>
Subject: Re: AW: Raid 1 vs 5 ?
Date: Wed, 9 Jun 2004 16:50:41 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <55951.194.60.85.4.1086796241.squirrel@194.60.85.4>
References: <FA095C015271B64E99B197937712FD0227A85D@freedom.grz.icomedias.com>   
    <a06002007bcecbfe09c54@[10.0.0.10]>
    <27453.194.60.85.4.1086793052.squirrel@194.60.85.4>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27453.194.60.85.4.1086793052.squirrel@194.60.85.4>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, June 9, 2004 15:57, Robin Bowes said:
>
> One esoteric variation I may play around with (just because I can!) is to create Array 1
> from just two disks and create Array 2 as Raid0+1 from four parititions to give better
> performance for swap. I'm not sure if this is even possible.

Of course, I could always just do what Martin suggested initially, i.e. create a couple
of RAID1 arrays and stripe the swap across them.

R.
-- 
http://robinbowes.com

