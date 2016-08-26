From: Phil Turmel <philip@turmel.org>
Subject: Re: Need Help with crashed RAID5 (that was rebuilding and then had
 SATA error on another drive)
Date: Thu, 25 Aug 2016 22:22:22 -0400
Message-ID: <f3d5add5-cfad-e33f-2f75-934189fa501d@turmel.org>
References: <CADDTLRB9z6J0F6+uO3k-u74qnjZxiagbNLWrg_tP5GSZt-Vd5A@mail.gmail.com>
 <215fd175-65b6-e24b-338f-0c44ae030573@websitemanagers.com.au>
 <CADDTLRBf9NPO6OuF4a3b+xffZgeZRqHRG+pJdPmbc9-Jat0HVQ@mail.gmail.com>
 <d6d3fe0d-3f9f-985f-9bfb-051428cf221b@websitemanagers.com.au>
 <57BBDA5B.3020706@gmail.com> <57BBDC15.5030301@gmail.com>
 <b8c6a380-7e6a-fda9-5834-b85271b26892@websitemanagers.com.au>
 <57BC61F7.8070102@gmail.com>
 <aca4e83f-9a3f-c200-7c16-3b5d9df52c1e@websitemanagers.com.au>
 <57BE450B.4030700@gmail.com>
 <56e86db5-456d-e9c1-339d-ba8903fe5dde@websitemanagers.com.au>
 <57BE52BC.6040908@gmail.com>
 <933228e0-bce4-ffad-f48d-034bf89bc07f@websitemanagers.com.au>
 <57BF9965.1020403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57BF9965.1020403@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ben <benjammin2068@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/25/2016 09:20 PM, Ben wrote:

> I read a lot of conflicting info on SCT/ERC online (well, TLER anyway)
> -- Adam likes it enabled. What say the rest of you?

Adam is correct, and it's not a matter of "like".  You either must have
it enabled, or you *must* apply the kernel driver timeout work-around
(180 seconds) for that drive.  Failure to do so results in crashed arrays.

Enterprise and NAS drives work out of the box.  Desktop/green drives do not.

Some reading assignments from old discussions (read whole threads if you
have time):

http://marc.info/?l=linux-raid&m=139050322510249&w=2
http://marc.info/?l=linux-raid&m=135863964624202&w=2
http://marc.info/?l=linux-raid&m=135811522817345&w=1
http://marc.info/?l=linux-raid&m=133761065622164&w=2
http://marc.info/?l=linux-raid&m=132477199207506
http://marc.info/?l=linux-raid&m=133665797115876&w=2
http://marc.info/?l=linux-raid&m=142487508806844&w=3
http://marc.info/?l=linux-raid&m=144535576302583&w=2

