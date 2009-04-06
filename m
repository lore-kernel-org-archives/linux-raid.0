From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Mon, 6 Apr 2009 10:47:00 -0400
Message-ID: <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-24-876499075"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18899.61151.445765.360191@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-24-876499075
Content-Type: multipart/mixed; boundary=Apple-Mail-23-876499054


--Apple-Mail-23-876499054
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 1, 2009, at 6:46 PM, Neil Brown wrote:

> On Wednesday April 1, jnelson-linux-raid@jamponi.net wrote:
>> ping?
>
> Oh yeah, that's right, I was going to reply to that - thanks for the
> reminder.
>
>>
>> On Tue, Mar 24, 2009 at 11:57 AM, Jon Nelson
>> <jnelson-linux-raid@jamponi.net> wrote:
>>>
>>> I have a raid1 comprised of a local physical device (/dev/sda) and a
>>> network block device (/dev/nbd0).
>>> When the machine hosting the network block device comes up, however,
>>> it creates /dev/md127.
>>> Why?
>
> Because you cannot please all the people, all the time.

Very true.

>
> People seem to want their arrays to auto-assemble - you know, just
> appear and do the right thing, read their mind probably, because
> creating config files is too hard.
> So I've endeavoured to make that happen.
>
> The biggest problem with auto-assembly is what to do if two arrays
> claim to have the same name. (e.g. /dev/md0) - which one wins.
> The 'homehost' is (currently) used to resolve that.  An array only
> gets to use the name it claims to have if it can show that it belongs
> to "this" host.  If it doesn't it still get assembled, but with some
> other more generic name.

FWIW, I happen to disagree with this method.  And I'm currently  
testing out a new algorithm for this in Fedora 11 beta.

The logic behind this in mdadm-3.0devel3 is basically "if the array  
exists in mdadm.conf or if it has this homehost, assemble using normal  
name, else use a random name".  However, in the world of movable  
arrays (think one of those 5 disk SATA raid towers that just has a  
single eSATA port and a port replicator, which can easily be moved  
from machine to machine), this doesn't work so well.  The problem is  
that when you assemble an array with a random number, you confuse  
users.  They might find the array eventually, but it's certainly not  
as easy as if the array used the name they expected.  In an attempt to  
get mdadm to not possibly conflict with local array names, the  
homehost method of selecting which array name to use causes confusion  
all the time, instead of only confusing users when a conflict actually  
occurs.  This doesn't make sense to me, so I redid the tests in mdadm  
to change this (this is exacerbated by the fact that if your array  
does not define a homehost, it gets treated as though it has a  
different homehost, so common version 0.90 arrays will always get  
assembled as a random number if they aren't in the mdadm.conf file  
whether they are meant for this host or not).

So, my logic goes like this:

Does the array match an array mdadm.conf via uuid?  If yes, use name  
from mdadm.conf.  If no, does the array match an entry in mdadm.conf  
via the standard super-minor/name mapping?  If yes, and that array  
line contains a uuid that doesn't match this entry, then use a random  
name because this is likely a conflict.  If yes and that line does not  
contain a uuid entry, then this is likely a match, but a poor one.   
Use the name, but don't like it.  If no, then this array didn't match  
the mdadm.conf file at all and is likely a foreign array.  However, if  
there is no mdadm.conf file, or if there is a mdadm.conf file and  
nothing in it used our name, then foreign or not, it likely won't  
conflict on name, so go ahead and use the standard name for this device.

I had to modify the match loop to store both uuid and name matches  
separately in order to support this logic.  There's some other changes  
that were necessary in order to make it work properly, and I had to  
change mdopen.c to automatically go from what we thought was a good  
name to a random name if a conflict on an array happens in order to  
avoid failed autoassembles.  However, I'm personally much happier with  
the results.  For example, I can define md0 in the mdadm.conf file,  
create two different md0 arrays, then attempt to autoassemble the one  
that isn't in mdadm.conf and it will automatically get a random name  
and when the one that is in mdadm.conf shows up it gets the right  
name.  I can also define to md0 arrays with neither of them in the  
mdadm.conf file and it will assemble the first as md0 and the second  
as name md0_0 with a random minor (I think, it's been a week or so  
since I did that testing).  Anyway, it works well, and it basically  
negates the need for homehost in my opinion.  And the fact that it  
only assembles an array with a random number when it truly needs to is  
something that will help to greatly reduce confusion of users, which  
is always a plus in my book.  I'll attach the patch for your review.   
I could have shortened the logic in the match tests to just what's  
needed to set things right, but I left the long version so people can  
see all the possible options and why a specific setting is chosen on  
any given option.  Oh, and the patch also loosens up the name matching  
somewhat so that if someone names their device /dev/md0, that matches  
super-minor 0, as does md0 and just plain 0.  The original match  
setup, at least for devices not in the mdadm.conf file with a name in  
the array line, would only match the array name if it was numeric only  
(aka, homehost:0 or just 0).  I found that to be overly restrictive  
and contrary to what a lot of people would expect should be entered in  
the name field of the superblock.

Since I'm sending this anyway, I'll send a couple other changes I made  
to our mdadm in separate mails.


--Apple-Mail-23-876499054
Content-Disposition: attachment;
	filename=mdadm-3.0-foreign.patch
Content-Type: application/octet-stream;
	x-unix-mode=0664;
	name="mdadm-3.0-foreign.patch"
Content-Transfer-Encoding: 7bit

--- mdadm-3.0-devel3/Incremental.c.foreign	2009-03-20 17:49:20.000000000 -0400
+++ mdadm-3.0-devel3/Incremental.c	2009-03-20 21:19:50.000000000 -0400
@@ -29,12 +29,14 @@
  */
 
 #include	"mdadm.h"
+#include	<ctype.h>
 
 static int count_active(struct supertype *st, int mdfd, char **availp,
 			struct mdinfo *info);
 static void find_reject(int mdfd, struct supertype *st, struct mdinfo *sra,
 			int number, __u64 events, int verbose,
 			char *array_name);
+static int compare_array_name(char *conf_name, char *sb_name);
 
 int Incremental(char *devname, int verbose, int runstop,
 		struct supertype *st, char *homehost, int autof)
@@ -48,8 +50,10 @@ int Incremental(char *devname, int verbo
 	 * 2/ Find metadata, reject if none appropriate (check
 	 *       version/name from args)
 	 * 3/ Check if there is a match in mdadm.conf
-	 * 3a/ if not, check for homehost match.  If no match, assemble as
-	 *    a 'foreign' array.
+	 * 3a/ Evalutate the quality of match and whether or not we have a
+	 * 	 conf file at all, and make a decision about whether or not
+	 * 	 to allow this array to keep its preferred name based upon 
+	 * 	 that
 	 * 4/ Determine device number.
 	 * - If in mdadm.conf with std name, use that
 	 * - UUID in /dev/md/mdadm.map  use that
@@ -78,7 +82,7 @@ int Incremental(char *devname, int verbo
 	 */
 	struct stat stb;
 	struct mdinfo info;
-	struct mddev_ident_s *array_list, *match;
+	struct mddev_ident_s *array_list, *match, *match_uuid, *match_name;
 	char chosen_name[1024];
 	int rv;
 	struct map_ent *mp, *map = NULL;
@@ -148,26 +152,42 @@ int Incremental(char *devname, int verbo
 	st->ss->getinfo_super(st, &info);
 	/* 3/ Check if there is a match in mdadm.conf */
 
+	name_to_use = strchr(info.name, ':');
+	if (name_to_use)
+		name_to_use++;
+	else
+		name_to_use = info.name;
 	array_list = conf_get_ident(NULL);
 	match = NULL;
+	match_uuid = NULL;
+	match_name = NULL;
 	for (; array_list; array_list = array_list->next) {
+		/* Check for matching uuid, then drop through to check and see
+		 * if we also have a matching name, and to catch cases of
+		 * matching names without a corresponding uuid match */
 		if (array_list->uuid_set &&
 		    same_uuid(array_list->uuid, info.uuid, st->ss->swapuuid)
-		    == 0) {
-			if (verbose >= 2 && array_list->devname)
+		    != 0)
+			match_uuid = array_list;
+		else if (array_list->uuid_set && verbose >= 2 &&
+			 array_list->devname)
 				fprintf(stderr, Name
 					": UUID differs from %s.\n",
 					array_list->devname);
-			continue;
-		}
+		/* If we match name, save it off separately so we can tell if
+		 * we matched uuid, name, or both, and if both, if they were
+		 * the same entry */
 		if (array_list->name[0] &&
-		    strcasecmp(array_list->name, info.name) != 0) {
-			if (verbose >= 2 && array_list->devname)
+		    compare_array_name(array_list->name, info.name))
+			match_name = array_list;
+		else if (array_list->name[0] && verbose >= 2 &&
+			 array_list->devname)
 				fprintf(stderr, Name
 					": Name differs from %s.\n",
 					array_list->devname);
+		if ((!match_uuid || match == match_uuid) &&
+		    (!match_name || match == match_name))
 			continue;
-		}
 		if (array_list->devices &&
 		    !match_oneof(array_list->devices, devname)) {
 			if (verbose >= 2 && array_list->devname)
@@ -197,7 +217,13 @@ int Incremental(char *devname, int verbo
 		/* FIXME, should I check raid_disks and level too?? */
 
 		if (match) {
-			if (verbose >= 0) {
+			if (match_uuid != match_name) {
+				if (match_uuid->devname)
+					fprintf(stderr, Name ": more than one "
+						"match for %s, using the UUID "
+						"match\n", match_uuid->devname);
+				match = match_uuid;
+			} else if (verbose >= 0) {
 				if (match->devname && array_list->devname)
 					fprintf(stderr, Name
 		   ": we match both %s and %s - cannot decide which to use.\n",
@@ -205,23 +231,52 @@ int Incremental(char *devname, int verbo
 				else
 					fprintf(stderr, Name
 						": multiple lines in mdadm.conf match\n");
+				return 2;
 			}
-			return 2;
 		}
 		match = array_list;
 	}
 
-	/* 3a/ if not, check for homehost match.  If no match, continue
-	 * but don't trust the 'name' in the array. Thus a 'random' minor
-	 * number will be assigned, and the device name will be based
-	 * on that. */
-	if (match)
+	/* 3a/ Decide if we got a good match, two matches, no matches, or a
+	 * likely foreign match.  I dropped the homehost test entirely because
+	 * it didn't seem to add any value whatsoever above and beyond what
+	 * these tests can do. */
+	if (match && match_uuid == match_name) {
+		/* found in conf, both name and uuid match */
 		trustworthy = LOCAL;
-	else if (homehost == NULL ||
-		 st->ss->match_home(st, homehost) != 1)
-		trustworthy = FOREIGN;
-	else
+	} else if (match_uuid && match_name) {
+		/* found both a name and a uuid match, but not on the same
+		 * entry, so prefer the uuid match (done above) */
 		trustworthy = LOCAL;
+	} else if (!match_uuid && match_name) {
+		/* no uuid match, but name match */
+		if (match_name->uuid_set) {
+			/* oops, name that matched had a uuid, it just wasn't
+			 * right, assume there is a local device with both
+			 * a matching name and uuid, so this needs a random
+			 * name */
+			trustworthy = FOREIGN;
+			match = NULL;
+		} else
+			/* matched name, and the matching entry in conf file
+			 * didn't include a uuid, and this uuid never showed
+			 * up anywhere else in the conf file, so consider it
+			 * a soft match and allow it...although users should
+			 * *REALLY* include the uuid on array lines in the
+			 * conf file */
+			trustworthy = LOCAL;
+	} else { /* no match at all */
+		if (!conf_exists())
+			/* If we don't even have a conf file, this is foreign,
+			 * but also not likely to conflict with anything
+			 * local, so let it keep its preferred name */
+			trustworthy = LOCAL;
+		else
+			/* We have a conf file, this didn't match any uuids
+			 * or names, so also not likely to conflict, let it
+			 * keep its own name */
+			trustworthy = LOCAL;
+	}
 
 	/* There are three possible sources for 'autof':  command line,
 	 * ARRAY line in mdadm.conf, or CREATE line in mdadm.conf.
@@ -240,11 +295,6 @@ int Incremental(char *devname, int verbo
 		return Incremental_container(st, devname, verbose, runstop,
 					     autof, trustworthy);
 	}
-	name_to_use = strchr(info.name, ':');
-	if (name_to_use)
-		name_to_use++;
-	else
-		name_to_use = info.name;
 
 	if ((!name_to_use || name_to_use[0] == 0) &&
 	    info.array.level == LEVEL_CONTAINER &&
@@ -797,3 +847,45 @@ int Incremental_container(struct superty
 	map_unlock(&map);
 	return 0;
 }
+
+static int compare_array_name(char *conf_name, char *sb_name)
+{
+	char *cptr, *sptr;
+	int conf_num = -1;
+
+	/* usage of the name variable in the superblock comes in several
+	 * flavors:
+	 * A) full md pathname (/dev/md0)
+	 * B) just the md name (md0)
+	 * C) just the md number (0)
+	 * D) all of the above, but with hostname: prefixed to it
+	 *
+	 * Depending on which of those variants we have, we need to alter
+	 * how we attempt to match the array name in the mdadm.conf file
+	 * which is always a full pathname.  We don't match on hostname:
+	 * though, so eliminate it from the equation.
+	 */
+
+	if ((sptr = strchr(sb_name, ':')) == NULL)
+		sptr = sb_name;
+	else
+		sptr++;
+
+	/* Do we have a full pathname in the superblock name field? */
+	if (strchr(sptr, '/'))
+		return !strcasecmp(conf_name, sptr);
+	/* If not, is it just a number or an md device name? */
+	else if (isdigit(sptr[0])) {
+		cptr = conf_name + strlen(conf_name);
+		while (cptr > conf_name && isdigit(cptr[-1]))
+			cptr--;
+		if (cptr[0])
+			conf_num = strtoul(cptr, NULL, 10);
+		return conf_num == strtoul(sptr, NULL, 10);
+	} /* fall through else, it's a device name but not a full path */
+
+	cptr = strcasestr(conf_name, sptr);
+	if (cptr)
+		return !strcasecmp(cptr, sptr);
+	return 0;
+}
--- mdadm-3.0-devel3/mdadm.h.foreign	2009-03-10 01:39:41.000000000 -0400
+++ mdadm-3.0-devel3/mdadm.h	2009-03-20 17:49:20.000000000 -0400
@@ -785,6 +785,7 @@ extern mddev_dev_t conf_get_devs(void);
 extern int conf_test_dev(char *devname);
 extern struct createinfo *conf_get_create_info(void);
 extern void set_conffile(char *file);
+extern int conf_exists(void);
 extern char *conf_get_mailaddr(void);
 extern char *conf_get_mailfrom(void);
 extern char *conf_get_program(void);
--- mdadm-3.0-devel3/mdopen.c.foreign	2009-03-20 19:02:38.000000000 -0400
+++ mdadm-3.0-devel3/mdopen.c	2009-03-20 19:02:43.000000000 -0400
@@ -159,7 +159,6 @@ int create_mddev(char *dev, char *name, 
 	strcpy(chosen, "/dev/md/");
 	cname = chosen + strlen(chosen);
 
-
 	if (dev) {
 		
 		if (strncmp(dev, "/dev/md/", 8) == 0) {
@@ -240,12 +239,14 @@ int create_mddev(char *dev, char *name, 
 	if (num < 0 && trustworthy == LOCAL && name) {
 		/* if name is numeric, use that for num
 		 * if it is not already in use */
-		char *ep;
-		num = strtoul(name, &ep, 10);
-		if (ep == name || *ep)
-			num = -1;
-		else if (mddev_busy(use_mdp ? (-1-num) : num))
-			num = -1;
+		char *e = name + strlen(name);
+		while (e > name && isdigit(e[-1]))
+			e--;
+		if (e[0]) {
+			num = strtoul(e, NULL, 10);
+			if (mddev_busy(use_mdp ? (-1-num) : num))
+				num = -1;
+		}
 	}
 
 	if (num < 0) {
--- mdadm-3.0-devel3/config.c.foreign	2009-03-10 01:39:41.000000000 -0400
+++ mdadm-3.0-devel3/config.c	2009-03-20 17:49:20.000000000 -0400
@@ -637,7 +637,7 @@ void homehostline(char *line)
 	}
 }
 
-
+int exists = 0;
 int loaded = 0;
 
 static char *conffile = NULL;
@@ -683,6 +683,7 @@ void load_conffile(void)
 	if (f == NULL)
 		return;
 
+	exists = 1;
 	loaded = 1;
 	while ((line=conf_line(f))) {
 		switch(match_keyword(line)) {
@@ -718,6 +719,13 @@ void load_conffile(void)
 /*    printf("got file\n"); */
 }
 
+int conf_exists(void)
+{
+	if (!loaded)
+		load_conffile();
+	return exists;
+}
+
 char *conf_get_mailaddr(void)
 {
 	load_conffile();

--Apple-Mail-23-876499054
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit



--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-23-876499054--

--Apple-Mail-24-876499075
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknaFeQACgkQQ9aEs6Ims9i1TQCggwXy3fpRj+f09fUs7oEQSlq/
UFAAmwfQ/55kcBj7mXy+PueHaotgMsvS
=gUI5
-----END PGP SIGNATURE-----

--Apple-Mail-24-876499075--
