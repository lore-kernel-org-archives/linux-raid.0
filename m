From: Jure Pecar <pegasus@telemach.net>
Subject: Re:
Date: Tue, 4 Jun 2002 23:55:18 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020604235518.2cb7d7d7.pegasus@telemach.net>
References: <20020604154712.AD48D8347@phoenix.clouddancer.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 boundary="=.7/gcCXELj+7KAp"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020604154712.AD48D8347@phoenix.clouddancer.com>
To: Colonel <klink@clouddancer.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=.7/gcCXELj+7KAp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  4 Jun 2002 08:47:12 -0700 (PDT)
klink@clouddancer.com (Colonel) wrote:

> 
> True, I think that the point is that of the 5 possible 2 disk
> failures, 2 of them (in striped mirrors, not mirrored stripes) kill
> the array.  For RAID5, all of them kill the array.  But the fancy RAID
> setups are for _large_ arrays, not 4 disks, unless you are after the
> small write speed improvement (as I am).

going offtopic here ...
what kind of raid setup is the best for write intensive load like mail
queues & co?
 
> Plus any raid metadevice made of metadevices cannot autostart, which
> means tinkering during startup, which is only worth it for those large
> drive arrays.

hm? it does for me. probalby the redhat's rc.sysinit does the right
thing ... 

-- 


Jure Pecar

--=.7/gcCXELj+7KAp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)

iD8DBQE8/TdMOHUMrcOSg+8RApAiAJ99W2c93ggFRMpIJ/5tvEvF0tlLAQCgjeWq
+ia2+EQq1T2ASBva16GbU1U=
=EzXG
-----END PGP SIGNATURE-----

--=.7/gcCXELj+7KAp--

