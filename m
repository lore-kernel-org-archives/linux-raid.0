From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: Giving top priority to a rebuild instead of serving userland?
Date: Mon, 9 Jan 2012 22:40:49 +0200
Message-ID: <CAGRgLy65r4DsK0_tL57J9=iB+JvDiZ-0ZxZfbtkC44TcQvRa2Q@mail.gmail.com>
References: <20120109142116.GA34289@cons.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120109142116.GA34289@cons.org>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Cracauer <cracauer@cons.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Have you tried to play with:
/proc/sys/dev/raid/speed_limit_max
/proc/sys/dev/raid/speed_limit_min
/sys/block/mdXXX/md/sync_speed_min
/sys/block/mdXXX/md/sync_speed_max

=46or me these work very well. You can also set min > max, in which cas=
e
max is totally ignored.
According to the kernel code, md keeps submitting sync requests until
it reaches the minimum speed, and then it checks the "userland" IO and
the high speed limit.

Alex.


On Mon, Jan 9, 2012 at 4:21 PM, Martin Cracauer <cracauer@cons.org> wro=
te:
> I am doing a resize on a 4 x 1 TB raid5 array (going to 5x 1 TB).
>
> When there is no userland I/O it reports about 1000 minutes to
> rebuild. =A0However, minor amount of userland demand makes it shoot u=
p
> to 3500-4000 as the rebuild puts it's own interests behind.
>
> However, the I/O there is garbage, in this case a disk-noisy web
> browser. =A0Can I tell md to give priority to it's rebuild and serve
> userland as it pleases with -say- a maximum of 10% rebuild time
> increase? Yes I know that'll make the system very sluggy.
>
> I would be finished already but overnight I left a browser tab open
> that caused according to iostat 400-500 Blk_wrtn contiguously. =A0Tha=
t
> is when *not* actually using the browser (I'll report that as a bug).
> Now I am still at 38% rebuild. =A0Didn't seem worth the price I payed=
 :-)
>
> Martin
> --
> %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
> Martin Cracauer <cracauer@cons.org> =A0 http://www.cons.org/cracauer/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
