From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: Split-Brain Protection for MD arrays
Date: Tue, 13 Dec 2011 11:50:24 +0200
Message-ID: <CAGRgLy5=8TOKdJYvBof87CGA3d_pkqTMwqdRmO0gU_Yj7ivmTg@mail.gmail.com>
References: <CAGRgLy6=-naSGJw_tgiD5=ab7gWxyeQ2ysu-yCKa064Jih+cfA@mail.gmail.com>
	<201112122118.28351.plr.vincent@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201112122118.28351.plr.vincent@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vincent Pelletier <plr.vincent@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Vincent,
thanks for reviewing.

> I would suggest one thing:
> Use a fixed increment for "metadata version" number.
Yes, that is what's happening in MD. The doc was confusing about the
"timestamp" part.

> Admitedly, fixed increment exposes user to problems if he decides to
> independently run two halves of a split brain, start making their data
> diverge, reach a point (controlable) where version number is at some
> convenient value and then let the array assemble itself and burst in fire.
> Though, user has to jump through hoops to reach this.

Yes, so for that case I was thinking that once the user decides to
ignore the split-brain warning and still go ahead with the assemble,
then drives that are not accessible at that point will not be used
from now on ("external entity" should take care about that). The doc
mentions that as well.

Thanks,
 Alex.
