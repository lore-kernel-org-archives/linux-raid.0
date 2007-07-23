From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Subject: Re: [RFH] Partition table recovery
Date: Mon, 23 Jul 2007 10:41:46 +0200
Message-ID: <20070723084146.GP22998@lug-owl.de>
References: <200707200813.03553.a1426z@gawab.com> <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org> <200707220710.31402.a1426z@gawab.com> <20070722162802.GA20174@thunk.org> <46A46399.5090406@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gblAvmLjk8yGG9If"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46A46399.5090406@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rene Herman <rene.herman@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


--gblAvmLjk8yGG9If
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-07-23 10:15:21 +0200, Rene Herman <rene.herman@gmail.com> wrot=
e:
> /*
>  * Public Domain 2007, Rene Herman
>  */
>=20
> #define _LARGEFILE64_SOURCE
>=20
> #include <stdlib.h>
> #include <stdio.h>
> #include <stdint.h>
> #include <string.h>
>=20
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <sys/ioctl.h>
> #include <unistd.h>
> #include <fcntl.h>
>=20
> enum {
> 	DOS_EXTENDED   =3D 0x05,
> 	WIN98_EXTENDED =3D 0x0f,
> 	LINUX_EXTENDED =3D 0x85,
> };
>=20
> struct partition {
>         uint8_t boot_ind;
> 	uint8_t head;

Different indention.

> 	uint8_t sector;
> 	uint8_t cyl;
>         uint8_t sys_ind;
> 	uint8_t end_head;
> 	uint8_t end_sector;
> 	uint8_t end_cyl;
>         uint32_t start;
>         uint32_t size;

As multibyte on-disk variables, these will need LE/BE conversion.

> } __attribute__((packed));
>=20
> struct entry {
> 	uint8_t flags;
> 	uint8_t type;
> 	uint16_t __1;
> 	uint64_t start;
> 	uint32_t size;

Dito.

> } __attribute__((packed));
>=20
> enum {
> 	ENTRY_FLAG_PRIMARY  =3D 0x01,
> 	ENTRY_FLAG_BOOTABLE =3D 0x80,
> };
>=20
> struct backup {
> 	uint8_t signature[8];
> 	uint16_t type;
> 	uint8_t heads;
> 	uint8_t sectors;
> 	uint8_t count;
> 	uint8_t __1[3];
> 	struct entry table[31];
> } __attribute__((packed));
>=20
> #define BACKUP_SIGNATURE "PARTBAK1"
>=20
> enum {
> 	BACKUP_TYPE_MBR =3D 1,
> };
>=20
> struct backup backup =3D {
> 	.signature =3D BACKUP_SIGNATURE,
> 	.type	   =3D BACKUP_TYPE_MBR,
> };
>=20
> #define ARRAY_SIZE(arr) (sizeof arr / sizeof arr[0])
>=20
> int is_extended(struct partition *partition)
> {
> 	int ret =3D 0;
>=20
> 	switch (partition->sys_ind) {
> 	case DOS_EXTENDED:
> 	case WIN98_EXTENDED:
> 	case LINUX_EXTENDED:
> 		ret =3D 1;
> 	}
> 	return ret;
> }
>=20
> unsigned char *get_sector(int fd, uint64_t n)
> {
> 	unsigned char *sector;
>=20
> 	if (lseek64(fd, n << 9, SEEK_SET) < 0) {
> 		perror("lseek64");
> 		return NULL;
> 	}
> 	sector =3D malloc(512);
> 	if (!sector) {
> 		fprintf(stderr, "malloc: out of memory\n");
> 		return NULL;
> 	}
> 	if (read(fd, sector, 512) !=3D 512) {
> 		perror("read");
> 		free(sector);
> 		return NULL;
> 	}
> 	return sector;
> }
>=20
> void put_sector(unsigned char *sector)
> {
> 	free(sector);
> }
>=20
> #define TABLE_OFFSET (512 - 2 - 4 * sizeof(struct partition))
>=20
> inline struct partition *table(unsigned char *sector)
> {
> 	return (struct partition *)(sector + TABLE_OFFSET);
> }
>=20
> int do_sector(int fd, uint32_t offset, uint32_t start)
> {
> 	unsigned char *sector;
> 	struct partition *cur;
> 	struct partition *ext =3D NULL;
> 	int ret =3D 0;
>=20
> 	sector =3D get_sector(fd, offset + start);
> 	if (!sector)
> 		return -1;
>=20
> 	if (sector[510] !=3D 0x55 || sector[511] !=3D 0xaa) {
> 		ret =3D -1;
> 		goto out;
> 	}
> 	for (cur =3D table(sector); cur < table(sector) + 4; cur++) {
> 		struct entry *entry;
>=20
> 		if (!cur->size)
> 			continue;
>=20
> 		cur->end_head +=3D 1;
> 		if (backup.heads < cur->end_head)
> 			backup.heads =3D cur->end_head;
>=20
> 		cur->end_sector &=3D 0x3f;
> 		if (backup.sectors < cur->end_sector)=20
> 			backup.sectors =3D cur->end_sector;
>=20
> 		if (is_extended(cur)) {
> 			if (!offset) {
> 				ret =3D do_sector(fd, cur->start, 0);
> 				if (ret < 0)
> 					goto out;
> 			} else if (!ext)
> 				ext =3D cur;
> 			continue;
> 		}
> 		if (backup.count =3D=3D ARRAY_SIZE(backup.table)) {
> 			fprintf(stderr, "do_sector: out of space!\n");
> 			ret =3D -1;
> 			goto out;
> 		}
> 		entry =3D backup.table + backup.count++;
>=20
> 		entry->flags =3D cur->boot_ind;
> 		if (!offset)
> 			entry->flags |=3D ENTRY_FLAG_PRIMARY;
>=20
> 		entry->type  =3D cur->sys_ind;
> 		entry->start =3D cur->start + start;
> 		entry->size  =3D cur->size;

LE/BE issues here...

> 	}
> 	if (ext)
> 		ret =3D do_sector(fd, offset, ext->start);
>   out:
> 	put_sector(sector);
> 	return ret;
> }
>=20
> void show_backup(void)
> {
> #ifdef DEBUG
>=20
> 	int i;
>=20
> 	fprintf(stderr, "signature: ");
> 	for (i =3D 0; i < 8; i++)
> 		fprintf(stderr, "%c", backup.signature[i]);
> 	fprintf(stderr, "\n");
>=20
> 	fprintf(stderr, "     type: %d\n", backup.type);
> 	fprintf(stderr, "    heads: %d\n", backup.heads);
> 	fprintf(stderr, "  sectors: %d\n", backup.sectors);
> 	fprintf(stderr, "    count: %d\n", backup.count);
>=20
> 	for (i =3D 0; i < backup.count; i++) {
> 		fprintf(stderr, "\n");
> 		fprintf(stderr, "%2d: flags: %02x\n", i, backup.table[i].flags);
> 		fprintf(stderr, "%2d:  type: %02x\n", i, backup.table[i].type);
> 		fprintf(stderr, "%2d: start: %llu\n", i, backup.table[i].start);
> 		fprintf(stderr, "%2d:  size: %u\n", i, backup.table[i].size);

You'll output wrong values here, depending on your host system.

> 	}
> #endif
> }
>=20
> int main(int argc, char *argv[])
> {
> 	int fd;
> 	struct stat buf;
>=20
> 	if (argc !=3D 2) {
> 		printf("%s <blkdev>\n", argv[0]);
> 		return EXIT_FAILURE;
> 	}
> 	fd =3D open(argv[1], O_RDONLY);
> 	if (fd < 0) {
> 		perror("open");
> 		return EXIT_FAILURE;
> 	}
> 	if (fstat(fd, &buf) < 0) {
> 		perror("stat");
> 		return EXIT_FAILURE;
> 	}
> 	if (!S_ISBLK(buf.st_mode))
> 		fprintf(stderr, "warning: not a block device\n");
> =09
> 	if (do_sector(fd, 0, 0) < 0)
> 		return EXIT_FAILURE;
>=20
> 	if (close(fd) < 0) {
> 		perror("close");
> 		return EXIT_FAILURE;
> 	}
> 	if (write(STDOUT_FILENO, &backup, sizeof backup) !=3D sizeof backup) {
> 		perror("write");
> 		return EXIT_FAILURE;
> 	}
>=20
> 	show_backup();
>=20
> 	return EXIT_SUCCESS;
> }

Looks like a useful program, but you'd definively fix the LE/BE
issues. If you do that, it'll be able to even run on BE machines, too.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:               Tr=C3=A4ume nicht von Dein Leben: Lebe Deinen T=
raum!
the second  :

--gblAvmLjk8yGG9If
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGpGnJHb1edYOZ4bsRArtiAJ9MxMI5ww6KN3RmlUxriKkrplRt+gCfewoU
eW2GnqaGqdFeTmhrpaNwgr8=
=YkPU
-----END PGP SIGNATURE-----

--gblAvmLjk8yGG9If--
