From: Neil Brown <neilb@suse.de>
Subject: Re: How to recreate a dmraid RAID array with mdadm
Date: Thu, 18 Nov 2010 12:28:47 +1100
Message-ID: <20101118122847.1530d86c@notabene.brown>
References: <BAY148-w65577551281F75C185BEBEF380@phx.gbl>
	<20101117141514.759d9eea@notabene.brown>
	<BAY148-w18A88E7D84CE0213B44F26EF380@phx.gbl>
	<20101118111149.7b5004a2@notabene.brown>
	<BAY148-w607755AA342EF4ACCCC9A5EF390@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w607755AA342EF4ACCCC9A5EF390@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids

On Wed, 17 Nov 2010 19:56:10 -0500
Mike Viau <viaum@sheridanc.on.ca> wrote:


> I am running the same version, from a Debian Squeeze package which I presume is the same.
> 
> mdadm -V
> 
> mdadm - v3.1.4 - 31st August 2010

Yes, should be identical to what I am running.
> 
> >
> > and see how that works.
> > Just
> > make
> > ./mdadm -Asvv
> 
> Regardless, I did recompile (attached is the make output -- no errors) and got similar mdadm output:
> 
> ./mdadm -Asvv
> mdadm: looking for devices for further assembly
> mdadm: no RAID superblock on /dev/md126p1
> mdadm: /dev/md126p1 has wrong uuid.
> mdadm: no RAID superblock on /dev/md/OneTB-RAID1-PV
> mdadm: /dev/md/OneTB-RAID1-PV has wrong uuid
....
> mdadm: cannot open device /dev/sdb: Device or resource busy
> mdadm: /dev/sdb has wrong uuid.
> mdadm: cannot open device /dev/sda: Device or resource busy
> mdadm: /dev/sda has wrong uuid.

The arrays are clearly currently assembled.  Trying to assemble them again is
not likely to produce a good result :-)  I should have said to "./mdadm -Ss"
first.

Could you apply this patch and then test again with:

 ./mdadm -Ss
 ./mdadm -Asvvv

Thanks,
NeilBrown

diff --git a/Assemble.c b/Assemble.c
index afd4e60..11323fa 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -344,9 +344,14 @@ int Assemble(struct supertype *st, char *mddev,
 		if (ident->uuid_set && (!update || strcmp(update, "uuid")!= 0) &&
 		    (!tst || !tst->sb ||
 		     same_uuid(content->uuid, ident->uuid, tst->ss->swapuuid)==0)) {
-			if (report_missmatch)
+			if (report_missmatch) {
+				char buf[200];
 				fprintf(stderr, Name ": %s has wrong uuid.\n",
 					devname);
+				fprintf(stderr, " want %s\n", __fname_from_uuid(ident->uuid, 0, buf, ':'));
+				fprintf(stderr, " have %s\n", __fname_from_uuid(content->uuid, 0, buf, ':'));
+				fprintf(stderr, " metadata=%s\n", tst->ss->name);
+			}
 			goto loop;
 		}
 		if (ident->name[0] && (!update || strcmp(update, "name")!= 0) &&
