From: Marnitz Gray <marnitz@xdesigns.co.za>
Subject: Re: Seeking help fixing a failed array
Date: Mon, 26 May 2014 09:10:44 +0200
Message-ID: <CAGcAkBJCbjwCQO-UU5kmQb_7Ly5ThxxhMJba9ftOn566VbbR9A@mail.gmail.com>
References: <CAGcAkBKnp8J5zGuwgVv98zMrDLVPZWAi57rqpgLW6VByAcm94g@mail.gmail.com>
	<alpine.DEB.2.02.1405241129020.29282@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1405241129020.29282@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Mikael

Thanks for the reply

On Sat, May 24, 2014 at 11:36 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Fri, 23 May 2014, Marnitz Gray wrote:
>
>> Hello good people of linux-raid.
>
>
> Your output seems to indicate that you have one drive with an event count
> that is 6 events off the others. This most likely means it's safe to use
> --assemble --force in order to make this get accepted.

Thanks, as per my original email I get an error message: "...assembled
from 3 drives and 1 spare - not enough to start the array ". Am I
doing something wrong?


>
> You didnt' state if you had space for more drives in your system, but you
> seem to have a recent mdadm and hopefully then a recent kernel, hook up the
> new drive to the system at the same time as the old one, add it as a spare,
> and use mdadm --replace. Then it'll online-replace the drive you want to
> change without degrading the array. This is a lot safer procedure.

Thanks. I do not have space for any other drives in the system.
I did not know about --replace, in hindsight I should've done some
research first! Thanks for the info though!

>
> Also consider going RAID6 if at all possible, you could do that when you're
> done replaceing all the drives with 3TB ones.

Thanks again, the plan was to replace all the drives and then convert
it to raid 6.

>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se

Regards,
Marnitz Gray
