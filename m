From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: RE: [PATCH 1/2] imsm: delete subarray functionality
Date: Thu, 1 Apr 2010 22:29:07 +0100
Message-ID: <66C59AD0932712458090B447266D638CD3CE3014@irsmsx504.ger.corp.intel.com>
References: <66C59AD0932712458090B447266D638CD3C7EAF4@irsmsx504.ger.corp.intel.com>
 <20100401060922.GA15461@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100401060922.GA15461@maude.comedia.it>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

>-----Original Message-----
>From: Luca Berra [mailto:bluca@comedia.it]
>Sent: Thursday, April 01, 2010 8:09 AM
>To: Hawrylewicz Czarnowski, Przemyslaw
>Cc: Neil Brown; linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski,
>Ed
>Subject: Re: [PATCH 1/2] imsm: delete subarray functionality
>
>On Wed, Mar 31, 2010 at 09:50:40PM +0100, Hawrylewicz Czarnowski,
>Przemyslaw wrote:
>>Patch also adds some utilities to simple sysfs manipulation and
>>to allow locking of map file during updates.
>a 38k patch is very difficult to review, i would have split it. the
>utilities would have been a candidate for a different patch
>also there are some changes i would define either bug-fixes or cleanup
>they should be in a different patch.
my point was to put both function and application together. It is OK
for me to split some utils to separate patch/es.

>you forgot to update the man pages.
yeah, you are absolutely right. It is a must.

>
>
>>diff --git a/Kill.c b/Kill.c
>>index e738978..e5d5dcb 100644
>>--- a/Kill.c
>>+++ b/Kill.c
>>@@ -79,3 +79,61 @@ int Kill(char *dev, struct supertype *st, int force,
>int quiet, int noexcl)
>>        close(fd);
>>        return rv;
>> }
>>+
>>+
>>+int Kill_Subarray(mddev_dev_t devlist, int force, int quiet, struct
>mddev_ident_s *ident)
>>+{
>>+       int     rv;
>>+       struct array_dev_list *dl = NULL;
>>+       int i, found;
>>+       struct mdinfo info;
>>+
>>+       if ((dl = check_devices(devlist, force, quiet, "imsm")) == NULL) {
>>+               return 1;
>>+       }
>i dont know if other container types will ever support removing (or
>renaming) subarrays. but i am not sure that forcing imsm here versus
>checking the existance of ss->delete_subarray function is better.
>....
As far as I know, it is applicable only for imsm superblock.

>
>>diff --git a/mapfile.c b/mapfile.c
>>index 366ebe3..fe885c5 100644
>>--- a/mapfile.c
>>+++ b/mapfile.c
>the above is a candidate for a separate patch
>....
>
>>diff --git a/mdstat.c b/mdstat.c
>>index 4a9f370..bb6179d 100644
>>--- a/mdstat.c
>>+++ b/mdstat.c
>ditto
>....
>
>>diff --git a/sysfs.c b/sysfs.c
>>index ebf9d8a..a2353d9 100644
>>--- a/sysfs.c
>>+++ b/sysfs.c
>ditto
>....
>
>>diff --git a/util.c b/util.c
>>index d292a66..f1d30f3 100644
>>--- a/util.c
>>+++ b/util.c
>as above, but also:
as mentioned I am OK to split it up.
>
>>+char *dev2devname(int maj, int min, char *buf)
>what is this for, completeness? it is unused in your code
>...
to be removed, it is not used any more...

>
>> int mdmon_pid(int devnum)
>>@@ -1502,7 +1523,11 @@ int mdmon_pid(int devnum)
>>        char pid[10];
>>        int fd;
>>        int n;
>>-       sprintf(path, "%s/%s.pid", pid_dir, devnum2devname(devnum));
>>+       char *devname = devnum2devname(devnum);
>>+
>>+       sprintf(path, "%s/%s.pid", pid_dir, devname);
>>+       free(devname);
>>+
>>        fd = open(path, O_RDONLY | O_NOATIME, 0);
>>
>>        if (fd < 0)
>why?
devnum2devname returns strdup, so it allocates memory which needs 
to be released.

>
>>+int validate_super(struct supertype *st, char *name, int quiet, char
>*meta_type)
>>+{
>>+       if (st == NULL) {
>>+               if (!quiet && name)
>>+                       fprintf(stderr, Name ": Unrecognised md component
>device - %s\n", name);
>>+               return 1;
>>+       }
>>+
>>+       if.  (meta_type && strcmp(st->ss->name, meta_type)) {
>>+               if (!quiet)
>>+                       fprintf(stderr, Name ": Subarray delete not
>supported for '%s' superblock\n",
>>+                               st->ss->name);
>i believe this error message belongs to the caller actually even two
>levels above, not to the utility function.
Ok, needs to be changed to more generic message

>
>....
>
>>+struct array_dev_list *check_devices(mddev_dev_t devlist, int force, int
>quiet, char *meta_type)
><snip>
>
>>+               if (validate_super(st, dv->devname, quiet, "imsm")) {
>i believe it should read:
>                if (validate_super(st, dv->devname, quiet, meta_type)) {
good catch. 

>
>
>regards,
>L.
>--
>Luca Berra -- bluca@comedia.it
>           Communication Media & Services S.r.l.
>    /"\
>    \ /     ASCII RIBBON CAMPAIGN
>     X        AGAINST HTML MAIL
>    / \

Thank you for valuable input.

--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer

