From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: fixes for 3.1.3 (was: Re: [mdadm GIT PULL] rebuild
 checkpoints...)
Date: Wed, 21 Jul 2010 11:04:04 -0700
Message-ID: <1279735444.25713.9.camel@dwillia2-linux>
References: <1274921452.17973.253.camel@dwillia2-linux>
	 <20100531113710.29e12d97@notabene.brown>
	 <AANLkTimgVuEIkB2s9rra5QS11YMUSpvSkBOcbzza44LX@mail.gmail.com>
	 <20100616163343.2c57de59@notabene.brown>
	 <1278032211.2179.24.camel@dwillia2-linux>
	 <20100706145043.107f7f76@notabene.brown>
	 <1278445909.3949.11.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1278445909.3949.11.camel@dwillia2-linux>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, Doug Ledford <dledford@redhat.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, linux-raid <linux-raid@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>
List-Id: linux-raid.ids

On Tue, 2010-07-06 at 12:51 -0700, Williams, Dan J wrote:
> On Mon, 2010-07-05 at 21:50 -0700, Neil Brown wrote:
> > I'm fairly seriously considering cutting a 3.1.3 shortly (Thursday?) so that
> > I have a clean slate to build the policy frame work and aim it for 3.2.0.
> > 
> > If you have anything that you would like to see included in (or addressed
> > for) 3.1.3, please let me know.
> > 
> 
> The pthread_create() vs clone(2) issue is still being discussed, but in
> the meantime using pthreads seems the safe thing to do.  So, here is
> that implementation and another trivial build-warning fixup.
> 

I've appended a patch to repair external metadata incremental assembly
that was broken by commit 3a6ec29a "Don't let incremental add devices to
active arrays."  So the pull request is now:

The following changes since commit 50526e9090d0c118b065840719bc9601be8af8b8:
  NeilBrown (1):
        super-0.90: don't write bitmap larger than 60K

are available in the git repository at:

  git://github.com/djbw/mdadm.git master

Dan Williams (3):
      mdmon: satisfy glibc tls abi requirements with pthreads
      imsm: fix a -O2 build warning
      Incremental: restore assembly for inactive containers, block active

 Incremental.c |   11 ++++++++++-
 Makefile      |   14 +++++++++++---
 mdadm.h       |    1 +
 mdmon.c       |   42 +++++++++++++++++++++++++++++++++++++++---
 super-intel.c |    4 ++--
 util.c        |    7 ++++++-
 6 files changed, 69 insertions(+), 10 deletions(-)


---
Incremental: restore assembly for inactive containers, block active

GET_ARRAY_INFO always succeeds on an inactive container, so we need to
be a bit more diligent about adding a disk to an active container.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 Incremental.c |   11 ++++++++++-
 mdadm.h       |    1 +
 util.c        |    7 ++++++-
 3 files changed, 17 insertions(+), 2 deletions(-)


diff --git a/Incremental.c b/Incremental.c
index 96bfcec..abfea24 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -376,7 +376,16 @@ int Incremental(char *devname, int verbose, int runstop,
 		 * statement about this.
 		 */
 		if (runstop < 1) {
-			if (ioctl(mdfd, GET_ARRAY_INFO, &ainf) == 0) {
+			int active = 0;
+			
+			if (st->ss->external) {
+				char *devname = devnum2devname(fd2devnum(mdfd));
+
+				active = devname && is_container_active(devname);
+				free(devname);
+			} else if (ioctl(mdfd, GET_ARRAY_INFO, &ainf) == 0)
+				active = 1;
+			if (active) {
 				fprintf(stderr, Name
 					": not adding %s to active array (without --run) %s\n",
 					devname, chosen_name);
diff --git a/mdadm.h b/mdadm.h
index 55e9e46..f1fe24f 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -930,6 +930,7 @@ extern int open_mddev(char *dev, int report_errors);
 extern int open_container(int fd);
 extern int is_container_member(struct mdstat_ent *ent, char *devname);
 extern int is_subarray_active(char *subarray, char *devname);
+int is_container_active(char *devname);
 extern int open_subarray(char *dev, struct supertype *st, int quiet);
 extern struct superswitch *version_to_superswitch(char *vers);
 
diff --git a/util.c b/util.c
index d22b0d0..1ce6a7a 100644
--- a/util.c
+++ b/util.c
@@ -1427,7 +1427,7 @@ int is_subarray_active(char *subarray, char *container)
 		if (is_container_member(ent, container)) {
 			char *inst = &ent->metadata_version[10+strlen(container)+1];
 
-			if (strcmp(inst, subarray) == 0)
+			if (!subarray || strcmp(inst, subarray) == 0)
 				break;
 		}
 	}
@@ -1437,6 +1437,11 @@ int is_subarray_active(char *subarray, char *container)
 	return ent != NULL;
 }
 
+int is_container_active(char *container)
+{
+	return is_subarray_active(NULL, container);
+}
+
 /* open_subarray - opens a subarray in a container
  * @dev: container device name
  * @st: supertype with only ->subarray set


