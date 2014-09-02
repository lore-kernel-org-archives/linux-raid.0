From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: raid1 data corruption during resync
Date: Tue, 2 Sep 2014 11:59:02 -0500
Message-ID: <134CC4D5-9DD4-4624-B227-BBFBA02FEFD1@redhat.com>
References: <20A5228D-DD63-4A6C-B2C6-B0C38996E636@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20A5228D-DD63-4A6C-B2C6-B0C38996E636@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eivind Sarto <eivindsarto@gmail.com>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, majianpeng@gmail.com
List-Id: linux-raid.ids


On Aug 29, 2014, at 2:29 PM, Eivind Sarto wrote:

> I am seeing occasional data corruption during raid1 resync.
> Reviewing the raid1 code, I suspect that commit 79ef3a8aa1cb1523cc231=
c9a90a278333c21f761 introduced a bug.
> Prior to this commit raise_barrier() used to wait for conf->nr_pendin=
g to become zero.  It no longer does this.
> It is not easy to reproduce the corruption, so I wanted to ask about =
the following potential fix while I am still testing it.
> Once I validate that the fix indeed works, I will post a proper patch=
=2E
> Do you have any feedback?
>=20
> =97 drivers/md/raid1.c	2014-08-22 15:19:15.000000000 -0700
> +++ /tmp/raid1.c	2014-08-29 12:07:51.000000000 -0700
> @@ -851,7 +851,7 @@ static void raise_barrier(struct r1conf=20
> 	 *    handling.
> 	 */
> 	wait_event_lock_irq(conf->wait_barrier,
> -			    !conf->array_frozen &&
> +			    !conf->array_frozen && !conf->nr_pending &&
> 			    conf->barrier < RESYNC_DEPTH &&
> 			    (conf->start_next_window >=3D
> 			     conf->next_resync + RESYNC_SECTORS),

I've been through the description of the mentioned commit and briefly l=
ooked at the code.  I don't understand the changes or the algorithm qui=
te yet, but wouldn't the change you are proposing here eliminate the be=
nefit that the commit was trying to provide?  Wouldn't it simply return=
 the behavior to the old way?

I think the point of the commit is to allow nominal I/O to run concurre=
ntly to resync I/O as long as it is not done to 'window' in which the r=
esync I/O is running.  By adding the check for nr_pending, wouldn't you=
 be blocking recovery from taking place if there are any nominal I/O's =
outstanding - even if they are not to the same area of the device?

CC'ing patch author to get his thoughts as well.

 brassow--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
