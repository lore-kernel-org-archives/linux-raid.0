From: NeilBrown <neilb@suse.de>
Subject: Preparing for mdadm-3.3
Date: Mon, 24 Jun 2013 17:18:18 +1000
Message-ID: <20130624171818.71a9688a@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FDPNKFs8N+Y=fqtqNieuq3y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/FDPNKFs8N+Y=fqtqNieuq3y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi all,
 it has been way too long since an mdadm release.  So I'm hoping to pull one
 together over the next few weeks.  It will be mdadm-3.3
 My goal is to have it out by 25th July (i.e. one month).

 To this end I have tagged "mdadm-3.3-rc1" in my git tree and pushed it out
 in the hope that people might test it.
 You can "git pull" or "git clone" from
     git://neil.brown.name/mdadm/

 of if you really like tar files:

http://git.neil.brown.name/git?p=3Dmdadm.git;a=3Dsnapshot;h=3Drefs/tags/mda=
dm-3.3-rc1;sf=3Dtgz

 Now would be a good time to test anything your are interested in, or remind
 me of something you wanted that hasn't been done yet, or send me your mdadm
 patches that you have been meaning to send me but never seem to get around
 to it.

 Some of the new things in mdadm-3.3 are:

- Reshape various arrays without needing backup file.  This is done by
  changing the 'data_offset' so we never need to write any data back over
  where it was before.
- "--assemble --update=3Dmetadata" can convert a 0.90 array to a 1.0 array.
- bad-block-logs are supported (but not heavily tested yet)
- "--assemble --update=3Drevert-reshape" can be used to undo a reshape that=
 has
  just been started but isn't really wanted.  This also needs lots of testi=
ng.
- improved locking between --incremental and --assemble
- uses systemd to run "mdmon" if systemd is configured to do that.
- kernel names of md devices can be non-numeric. e.g. "md_home" rather than
  "md0".  This will probably confuse lots of other tools, so you need to
      echo CREATE names=3Dyes >> /etc/mdadm.conf
  or the feature will not be used.  (you also need a reasonably new kernel).
- "--stop" can be given a kernel name instead of a device name. i.e
    mdadm --stop md4
  will work even if /dev/md4 doesn't exist.
- "--detail --export" has some information about the devices in the array
- --dump and --retstore can be used to backup and restore the metadata on an
  array.

and lots of bugfixes and other little changes.

I somehow got unsubscribed from linux-raid (again) a few weeks back, so if
anything was sent to the list and not me that I should know about, now might
be a good time to resend that too.

Thanks,
NeilBrown

--Sig_/FDPNKFs8N+Y=fqtqNieuq3y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcfyujnsnt1WYoG5AQIPUA//XZt73FZL7HgicQpOgGo4nJYnEjqaGGAu
cwnVnzdq7xsPg7C8VVcpaVr3/giVjL3k8MuIMEyA0cK2pUzVJOYun3VYPvWmH9Xl
+L89qZKv9DupLMU/f2WpF+v68yUAbqfeo2itLYN1DffCWRCnHF1z8R2SVE75cTlV
c8lKq9c6srl4xRH0SPnGjC93/TqUWfyZETXrUgOj/JfqstDfAQIye0Q8v6vRYY6e
LAYdunCDGToGcc8B0+lxDZWC3M6okymKKYA0wogvp7KRfCxP+7XW9Y6Jk0JPxPVh
xo7Nzo0dLNfOAgvvpCGhUziqkHXTm2JGs9qNcqI1+GG/4H5sEs8VUMAGonK174iP
IT6mphEoxbMT5ndTQ3srFo9o+Z1lLdyeZfOEe2ev50YuUEzP3nTN2T/FKWnD4tv6
ULvtoMF8x+zTXg/W61nzWIwI8BHA5E7LYSmQDPY/YrO8mjQTVr49W8rehr9hbE6o
WJB92PaPDQutl8z3OFDgcBt2TItpxA5rcDtfbiPSOXUKqbcemQ+D7wAlTZ6Pixqb
l8f+jHnOSoxrD2UAqqanJoVaPX8H7qlb6ZCb9FTgHMKyDqmO5TJuwf3YS750tua1
5++NnCRAIqZAppqL49RC33Dt7JYQUUCxyIB0/UUJxoTcClNZwr+5UbB+HIVsBAeK
1fa//qeNpTQ=
=42v8
-----END PGP SIGNATURE-----

--Sig_/FDPNKFs8N+Y=fqtqNieuq3y--
