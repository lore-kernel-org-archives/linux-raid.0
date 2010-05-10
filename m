From: Neil Brown <neilb@suse.de>
Subject: Re: Searching, but not finding...
Date: Tue, 11 May 2010 09:22:18 +1000
Message-ID: <20100511092218.71cbc69d@notabene.brown>
References: <AANLkTik7Ekdhv5qGMzyMu0Q5XhKq7JbaxZFLX6SKl5Zu@mail.gmail.com>
	<AANLkTinwZPdZw_kUEaV4wHRAI4n0hstu970_lyU04jt_@mail.gmail.com>
	<20100511065417.204d585e@notabene.brown>
	<AANLkTikUVXZXHmBzzn3WtqEYID8Si0nw7T_wjz5D32Xm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikUVXZXHmBzzn3WtqEYID8Si0nw7T_wjz5D32Xm@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Boggs <BecauseImAwesome@Live.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 10 May 2010 15:49:20 -0700
Daniel Boggs <BecauseImAwesome@Live.com> wrote:

> Question:
>=20
> If I use:
>=20
> >>> echo repair > /sys/block/mdX/md/sync_action
>=20
> to start a check action, then stop it with
>=20
> >>> echo idle > /sys/block/mdX/md/sync_action
>=20
> and later start it up again. =C2=A0Will it start again from the
> "beginning", or is it able to pick up where it left off?

Yes .. if you have a recent enough kernel.

When you write 'idle' you should find the current sector stored in 'syn=
c_min'.
When you write 'repair' again it will start from the value in 'sync_min=
'.
Obviously if you stop and restart the array you will loose this value u=
nless
you store it in a file somewhere and recover it.


>=20
> Essentially if I find the repair/sync action causes too much of a
> performance hit, could I have it run only during hours that I know th=
e
> array will not be in use and still have the array checked in its
> entirety, or is the only way to accomplish that to let the action run
> from start to finish?

You can also reduce the impact by slowing down the scan using sync_spee=
d_min
and sync_speed_max.   'min' is an upper limit to the speed when other I=
O is
happening, and 'max' is an upper limit when there is no other IO.

NeilBrown


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
