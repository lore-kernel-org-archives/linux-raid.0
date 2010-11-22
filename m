From: Neil Brown <neilb@suse.de>
Subject: Re: Autorebuild, new dynamic udev rules for hot-plugs
Date: Mon, 22 Nov 2010 16:02:01 +1100
Message-ID: <20101122160201.24ad85f8@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>
	<20101117212242.5ad7b210@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
	<66C59AD0932712458090B447266D638C0109E0E1E7@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66C59AD0932712458090B447266D638C0109E0E1E7@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

On Fri, 19 Nov 2010 15:12:19 +0000
"Hawrylewicz Czarnowski, Przemyslaw"
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> Hi,
> 
> I would like to present another patch for our autorebuild tree (it should be applied on the top of Autorebuild series, as devel-3.2 is not stable yet). Dan Williams proposed to reduce overhead associated with passing each hot-plugged block device to mdadm, using just the devices described in policies via mdadm.conf file.
> See patch below for details, comments are as always very welcome.

I am in general in favour of this approach.
It has the benefit that it can very easily be not-used if there turn out to
be problems with it.

Four comments.

1/ I wouldn't write a file in /lib/udev/rules.d/
  I think it should be written to "/dev/.udev/rules.d/"
  which is referred to as the "temporary rules directory"
  in the udev documentation.

2/ I would be good to process the type=disk or type=part part of the
   policy into the rules file as well.

3/ I'm not very comfortable with hard-coding the name of the
   file to be created in the rules.d directory.  Maybe usage could be
      --activate-domains=63-md-whatever

4/ I don't think it is good to have an incomplete file in rules.d that udev
   might accidentally read.  We should create the file with a name with a
   leading '.' (assuming udev ignores those, I haven't checked) and then
   rename it after it has been completely written.

Other than that, it looks pretty good.

Thanks,
NeilBrown

> 
> Date: Thu, 18 Nov 2010 01:19:52 +0100
> Subject: [PATCH] New dynamic hot-plug udev rules for policies
> 
> When introducing policies, new hot-plug rules were added to support
> bare disks. Mdadm was started for each hot plugged block device
> to determine if it could be used as spare or as a replacement member for
> degraded array.
> This patch introduces limitation of range of devices that are handled
> by mdadm. It limits them to the ones specified in domains associated 
> with the actions: spare-same-port, spare and spare-force.
> In order to enable hot-plug for bare disks one must update udev rules
> with command
> 
> 	mdadm --activate-domains
> 
> After mdadm.conf is changed one is obliged to re-run
> "mdadm --activate-domains" command in order to bring the system
> configuration up to date.
> All hot-plugged disks containing metadata are still handled by existing
> rules.
> 
> Note: this patch is just a proposition to minimize overhead of using mdadm for
> each plugged block device. If accepted, it will be incorporated in
> previous implementation of hot-plug for bare disks.
> 
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
> ---
>  Makefile           |    2 +
>  ReadMe.c           |    1 +
>  mdadm.c            |    4 ++
>  mdadm.h            |    9 +++-
>  policy.c           |  137 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  udev-md-raid.rules |    5 +-
>  6 files changed, 154 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 2b88818..eeae8e1 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -73,9 +73,11 @@ MAP_FILE = map
>  MDMON_DIR = /dev/.mdadm
>  # place for autoreplace cookies
>  FAILED_SLOTS_DIR = /dev/.mdadm/failed-slots
> +UDEV_RULES_DIR = $(DESTDIR)/lib/udev/rules.d
>  DIRFLAGS = -DMAP_DIR=\"$(MAP_DIR)\" -DMAP_FILE=\"$(MAP_FILE)\"
>  DIRFLAGS += -DMDMON_DIR=\"$(MDMON_DIR)\"
>  DIRFLAGS += -DFAILED_SLOTS_DIR=\"$(FAILED_SLOTS_DIR)\"
> +DIRFLAGS += -DUDEV_RULES_DIR=\"$(UDEV_RULES_DIR)\"
>  CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(DIRFLAGS)
>  
>  # The glibc TLS ABI requires applications that call clone(2) to set up
> diff --git a/ReadMe.c b/ReadMe.c
> index 54a1998..f17b8a1 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -110,6 +110,7 @@ struct option long_options[] = {
>      {"detail-platform", 0, 0, DetailPlatform},
>      {"kill-subarray", 1, 0, KillSubarray},
>      {"update-subarray", 1, 0, UpdateSubarray},
> +    {"activate-domains", 0, 0, ActivateDomains},
>  
>      /* synonyms */
>      {"monitor",   0, 0, 'F'},
> diff --git a/mdadm.c b/mdadm.c
> index c9a172a..b5403cf 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -228,6 +228,7 @@ int main(int argc, char *argv[])
>  				}
>  				subarray = optarg;
>  			}
> +		case ActivateDomains:
>  		case 'K': if (!mode) newmode = MISC; break;
>  		case NoSharing: newmode = MONITOR; break;
>  		}
> @@ -841,6 +842,7 @@ int main(int argc, char *argv[])
>  		case O(MISC, DetailPlatform):
>  		case O(MISC, KillSubarray):
>  		case O(MISC, UpdateSubarray):
> +		case O(MISC, ActivateDomains):
>  			if (devmode && devmode != opt &&
>  			    (devmode == 'E' || (opt == 'E' && devmode != 'Q'))) {
>  				fprintf(stderr, Name ": --examine/-E cannot be given with ");
> @@ -1421,6 +1423,8 @@ int main(int argc, char *argv[])
>  						free_mdstat(ms);
>  					} while (!last && err);
>  					if (err) rv |= 1;
> +				} else if (devmode == ActivateDomains) {
> +					rv = Activate_Domains();
>  				} else {
>  					fprintf(stderr, Name ": No devices given.\n");
>  					exit(2);
> diff --git a/mdadm.h b/mdadm.h
> index 9b4a1a8..171aa69 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -101,6 +101,11 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
>  #define FAILED_SLOTS_DIR "/dev/.mdadm/failed-slots"
>  #endif /* FAILED_SLOTS */
>  
> +/* UDEV_RULES_DIR is the place, where udev holds its rules */
> +#ifndef UDEV_RULES_DIR
> +#define UDEV_RULES_DIR "/lib/udev/rules.d"
> +#endif /* UDEV_RULES_DIR */
> +
>  #include	"md_u.h"
>  #include	"md_p.h"
>  #include	"bitmap.h"
> @@ -289,7 +294,8 @@ enum special_options {
>  	KillSubarray,
>  	UpdateSubarray, /* 16 */
>  	IncrementalPath,
> -	NoSharing
> +	NoSharing,
> +	ActivateDomains
>  };
>  
>  /* structures read from config file */
> @@ -971,6 +977,7 @@ extern int CreateBitmap(char *filename, int force, char uuid[16],
>  			unsigned long long array_size,
>  			int major);
>  extern int ExamineBitmap(char *filename, int brief, struct supertype *st);
> +extern int Activate_Domains(void);
>  extern int bitmap_update_uuid(int fd, int *uuid, int swap);
>  extern unsigned long bitmap_sectors(struct bitmap_super_s *bsb);
>  
> diff --git a/policy.c b/policy.c
> index daee52a..e4c53d5 100644
> --- a/policy.c
> +++ b/policy.c
> @@ -753,3 +753,140 @@ void domain_free(struct domainlist *dl)
>  		free(head);
>  	}
>  }
> +
> +/* invocation of udev rule file */
> +char udev_template_start[] =
> +"# do not edit this file, it will be overwritten on update\n"
> +"\n"
> +"SUBSYSTEM!=\"block\", GOTO=\"md_autorebuild_end\"\n"
> +"\n"
> +"ENV{ID_FS_TYPE}==\"linux_raid_member\", GOTO=\"md_autorebuild_end\"\n"
> +"ENV{ID_FS_TYPE}==\"isw_raid_member\", GOTO=\"md_autorebuild_end\"\n"
> +"\n";
> +
> +/* ending of udev rule file */
> +char udev_template_end[] =
> +"\n"
> +"LABEL=\"md_autorebuild_end\"\n"
> +"\n";
> +
> +/* find rule named rule_type and return its value */
> +char *find_rule(struct rule *rule, char *rule_type)
> +{
> +	while (rule) {
> +		if (rule->name == rule_type)
> +			return rule->value;
> +
> +		rule = rule->next;
> +	}
> +	return NULL;
> +}
> +
> +#define UDEV_RULE_FORMAT \
> +"ACTION==\"add\", KERNEL!=\"md*\" ENV{ID_PATH}==\"%s\" " \
> +"RUN+=\"/sbin/mdadm --incremental $env{DEVNAME}\", " \
> +"GOTO=\"md_autorebuild_end\"\n" \
> +
> +/* Write rule in the rule file. Use format from UDEV_RULE_FORMAT */
> +int write_rule(struct rule *rule, int fd)
> +{
> +	char line[1024];
> +	char *r = find_rule(rule, rule_path);
> +	if (!r)
> +		return -1;
> +
> +	snprintf(line, sizeof(line) - 1, UDEV_RULE_FORMAT, r);
> +	return write(fd, line, strlen(line));
> +}
> +
> +/* Generate single entry in udev rule basing on POLICY line found in config
> + * file. Take only those with paths, only first occurrence if paths are equal
> + * and if actions supports handling of spares (>=act_spare_same_slot)
> + */
> +int generate_entries(int fd)
> +{
> +	struct pol_rule *loop, *dup;
> +	char *loop_value, *dup_value;
> +	int duplicate;
> +	int written = 0;
> +
> +	for (loop = config_rules; loop; loop = loop->next) {
> +		if (loop->type != rule_policy)
> +			continue;
> +		duplicate = 0;
> +
> +		/* only policies with paths and with actions supporting
> +		 * bare disks are considered */
> +		loop_value = find_rule(loop->rule, pol_act);
> +		if (!loop_value || map_act(loop_value) < act_spare_same_slot)
> +			continue;
> +		loop_value = find_rule(loop->rule, rule_path);
> +		if (!loop_value)
> +			continue;
> +		for (dup = config_rules; dup != loop; dup = dup->next) {
> +			if (dup->type != rule_policy)
> +				continue;
> +			dup_value = find_rule(dup->rule, pol_act);
> +			if (!dup_value || map_act(dup_value) < act_spare_same_slot)
> +				continue;
> +			dup_value = find_rule(dup->rule, rule_path);
> +			if (!dup_value)
> +				continue;
> +			if (strcmp(loop_value, dup_value) == 0) {
> +				duplicate = 1;
> +				break;
> +			}
> +		}
> +
> +		/* not a dup or first occurrence */
> +		if (!duplicate) {
> +			if (write_rule(loop->rule, fd) == -1)
> +				return 0;
> +			written++;
> +		}
> +	}
> +	return written;
> +}
> +
> +#define AR_UDEV_RULE_FILE UDEV_RULES_DIR "/63-md-raid-autorebuild.rules"
> +
> +/* Activate_Domains routine creates dynamic udev rules used to handle
> + * hot-plug events for bare devices (and making them spares)
> + */
> +int Activate_Domains(void)
> +{
> +	int fd = 0;
> +	int rv;
> +
> +	fd = creat(AR_UDEV_RULE_FILE,
> +		S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
> +	if (fd == -1)
> +		return 1;
> +
> +	/* write static invocation */
> +	if (write(fd, udev_template_start,
> +		sizeof(udev_template_start) - 1) == -1) {
> +		close(fd);
> +		unlink(AR_UDEV_RULE_FILE);
> +		return 1;
> +	}
> +
> +	/* iterate, if none created or error occurred, remove file */
> +	rv = generate_entries(fd);
> +	if (rv <= 0) {
> +		close(fd);
> +		unlink(AR_UDEV_RULE_FILE);
> +		return rv == -1 ? -1 : 0;
> +	}
> +
> +	/* write ending */
> +	if (write(fd, udev_template_end, sizeof(udev_template_end) - 1) == -1) {
> +		close(fd);
> +		unlink(AR_UDEV_RULE_FILE);
> +		return 1;
> +	}
> +
> +	close(fd);
> +
> +	return 0;
> +}
> diff --git a/udev-md-raid.rules b/udev-md-raid.rules
> index 36dd51e..11057bb 100644
> --- a/udev-md-raid.rules
> +++ b/udev-md-raid.rules
> @@ -3,11 +3,10 @@
>  SUBSYSTEM!="block", GOTO="md_end"
>  
>  # handle potential components of arrays
> +ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="add", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
>  ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
> +ENV{ID_FS_TYPE}=="isw_raid_member", ACTION=="add", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
>  ENV{ID_FS_TYPE}=="isw_raid_member", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
> -# try incremental for each block device and not md. Most cases should not create
> -# unnecessary overhead, as no "heavy" disk operations are performed
> -ACTION=="add", KERNEL!="md*", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
>  
>  # handle md arrays
>  ACTION!="add|change", GOTO="md_end"

