From: NeilBrown <nfbrown@novell.com>
Subject: Re: Write intent bitmap algorithm
Date: Mon, 23 May 2016 09:19:26 +1000
Message-ID: <87shx9of41.fsf@notabene.neil.brown.name>
References: <cd14f4dd-a88a-4089-9b07-f16a221e003c@default>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cd14f4dd-a88a-4089-9b07-f16a221e003c@default>
Sender: linux-raid-owner@vger.kernel.org
To: Ankur Bose <ankur.bose@oracle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, May 20 2016, Ankur Bose wrote:

> Hi All,
>
>      We are doing performance analysis of MD raid1 and wanted to know the=
 flow/algorithm of the writes with write intent bitmap.
> As per "man md" below lines gives the algo=20
>
> "Before  any write  request is honored, md will make sure that the corres=
ponding bit in the log is set.  After a period of time with no writes to an=
 area of the array, the corresponding bit will be cleared."
>
> Here we wanted to know after what period of time and what is the logic
> to calculate this period of time which MD does ?

When you create an array with a bitmap, or use --grow to add a bitmap,
you can provide the --delay option to give a delay in seconds (which
seems to not be documented in mdadm.8 :-(  Patches welcomem.

Alternately when the array is running you can inspected and change
   /sys/block/mdXXX/md/bitmap_time_base

Every this-many seconds a task runs in the kernel which marks any bits
with a count that recently reach zero as "should be written", updates
the on-disk bitmap to clear any bits that were marked "should be
written".

So a bit with an active-write count of zero will be cleared in the
non-disk bitmap between 1 and 2 delays after the count reaches zero.

>
> I see a function "void bitmap_daemon_work(struct mddev *mddev)" in bitmap=
.c file but trying to figure out the logic how it is used.

Yes, this is the task that is run every 'delay' or 'time_base' seconds.
The counter is offset bit 2 normally so when there are no active writes
bitmap_daemon_work will find a counter which is '2' and will change it
to '1'.  If it finds a counter that is '1' it will change it to '0' and
immediately clear the bit in the in-memory image of the bitmap.  Then it
will write out any pages of the bitmap which have changed.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXQj5+AAoJEDnsnt1WYoG55qEQAK+vEkIjHOFIc3X/Ujuv9o2l
7nd+69NVeHR3ArBoo2lVhZLJHeJ15kYPYOo+WIHRnYI5GHI7F8Z3QAR9L0Had3KK
qRH92ItLrtni7NN545JwhyXt/PueE0/3pYQ25FCyJYXg+fVl8kZ/mbfa9O3gdmoN
L5dMC+8InaOUqsFI5xvLAgNYCQT4MW7azDRvFwb+LQblreZo71eV7dvYBRRTVBLB
lElBR9Y39w4p3cn3KW8598nmnyVWoSHU/dwIfbmLecSs6JcT5SCPrI8esxA/e4Md
CyNkr0kBJvxHXBeK9wPVtmuU/Ft4j9h64/E9PUH8oTKgqr4WAkTfDyRuhgYANJ9q
SB5i3WuGSQ7yravcA/AqDZMwNLv+kIY7UXypRfvz33RFTOqMl70smUV7WJk84KS7
0hrn4IBKHNQyqb6gG5hd3D6g40HUqTnQM3CLkN2yF4efZbB0RwnEnRmN0emggpYo
hV6uDhaWpwuIJB8cFmANgOZGMFFKVbo8lqR7DYtcWVbOdwZreLE70ozY0ZwCzxbt
8g6ctHjGvupngFOJteS0UwlzVCOnFjkgs30sZKWb4b7OVkSnT+4oNYWcSiWNItBw
o34qoK0RaNLo9LPBkr+JDrXWOPE82fGvVAIv2NdlPYNFuuOHGTV+8jJdhVApYs4f
Pasv0G/kvYp3B+1p/otg
=QzhY
-----END PGP SIGNATURE-----
--=-=-=--
