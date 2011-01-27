From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Dynamic hot-plug udev rules for policies
Date: Thu, 27 Jan 2011 13:19:23 +1000
Message-ID: <20110127131923.66165416@nbeee.brown>
References: <905EDD02F158D948B186911EB64DB3D176F91C29@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176F91C29@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Tue, 25 Jan 2011 15:59:32 +0000
"Labun, Marcin" <Marcin.Labun@intel.com> wrote:

> Neil,
> Please consider this patch that once was discussed and I think agreed
> with in general direction. It was sent a while ago but somehow did
> not merged into your devel3-2. This patch enables hot-plug of so
> called bare devices (as understand by domain policies rules in
> mdadm.conf). Without this patch we do NOT serve hot-plug of bare
> devices at all.
> 
> Thanks,
> Marcin Labun
> 
> Subject was: FW: Autorebuild, new dynamic udev rules for hot-plugs
> 
> >From c0aecd4dd96691e8bfa6f2dc187261ec8bb2c5a2 Mon Sep 17 00:00:00
> >2001
> From: Przemyslaw Czarnowski
> <przemyslaw.hawrylewicz.czarnowski@intel.com> Date: Thu, 23 Dec 2010
> 16:35:01 +0100 Subject: [PATCH] Dynamic hot-plug udev rules for
> policies Cc: linux-raid@vger.kernel.org, Williams, Dan J
> <dan.j.williams@intel.com>, Ciechanowski, Ed
> <ed.ciechanowski@intel.com>
> 
> When introducing policies, new hot-plug rules were added to support
> bare disks. Mdadm was started for each hot plugged block device
> to determine if it could be used as spare or as a replacement member
> for degraded array.
> This patch introduces limitation of range of devices that are handled
> by mdadm.
> It limits them to the ones specified in domains associated with
> the actions: spare-same-port, spare and spare-force.
> In order to enable hot-plug for bare disks one must update udev rules
> with command
> 
>         mdadm --activate-domains[=filename]
> 
> Above command writes udev rule configuration to stdout. If 'filename'
> is given output is written to the file provided as parameter. It is up
> to system administrator what should be done later. To make such rule
> permanent (i.e. remain after reboot) rule should be writen to
> /lib/udev/rules.d directory. Other cases will just need to write it to
> /dev/.udev/rules.d directory where temporary rules lies. One should be
> aware of the meaning of names/priorities of the udev rules.
> 
> After mdadm.conf is changed one is obliged to re-run
> "mdadm --activate-domains" command in order to bring the system
> configuration up to date.
> All hot-plugged disks containing metadata are still handled by
> existing rules.
> 
> Signed-off-by: Przemyslaw Czarnowski
> <przemyslaw.hawrylewicz.czarnowski@intel.com> ---
>  ReadMe.c |    1 +
>  mdadm.c  |   18 ++++++++
>  mdadm.h  |    2 +
>  policy.c |  141
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 4
> files changed, 162 insertions(+), 0 deletions(-)
> 
> diff --git a/ReadMe.c b/ReadMe.c
> index 5714849..cf41fa5 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -110,6 +110,7 @@ struct option long_options[] = {
>      {"detail-platform", 0, 0, DetailPlatform},
>      {"kill-subarray", 1, 0, KillSubarray},
>      {"update-subarray", 1, 0, UpdateSubarray},
> +    {"activate-domains", 2, 0, ActivateDomains},
> 
>      /* synonyms */
>      {"monitor",   0, 0, 'F'},
> diff --git a/mdadm.c b/mdadm.c
> index 2ffe94f..f3021cc 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -106,6 +106,7 @@ int main(int argc, char *argv[])
>         int auto_update_home = 0;
>         char *subarray = NULL;
>         char *remove_path = NULL;
> +       char *udev_filename = NULL;
> 
>         int print_help = 0;
>         FILE *outf;
> @@ -234,6 +235,7 @@ int main(int argc, char *argv[])
>                                 }
>                                 subarray = optarg;
>                         }
> +               case ActivateDomains:
>                 case 'K': if (!mode) newmode = MISC; break;
>                 case NoSharing: newmode = MONITOR; break;
>                 }
> @@ -929,6 +931,20 @@ int main(int argc, char *argv[])
>                         }
>                         devmode = opt;
>                         continue;
> +               case O(MISC, ActivateDomains):
> +                       if (devmode && devmode != opt) {
> +                               fprintf(stderr, Name ":
> --ActivateDomains must"
> +                                                    " be the only
> option.\n");
> +                       } else {
> +                               if (udev_filename)
> +                               fprintf(stderr, Name ": only specify
> one udev "
> +                                                    "rule filename.
> %s ignored.\n",
> +                                       optarg);
> +                               else
> +                                       udev_filename = optarg;
> +                       }
> +                       devmode = opt;
> +                       continue;
>                 case O(MISC,'t'):
>                         test = 1;
>                         continue;
> @@ -1493,6 +1509,8 @@ int main(int argc, char *argv[])
>                                                 free_mdstat(ms);
>                                         } while (!last && err);
>                                         if (err) rv |= 1;
> +                               } else if (devmode ==
> ActivateDomains) {
> +                                       rv =
> Activate_Domains(udev_filename); } else {
>                                         fprintf(stderr, Name ": No
> devices given.\n"); exit(2);
> diff --git a/mdadm.h b/mdadm.h
> index 36124de..1242015 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -311,6 +311,7 @@ enum special_options {
>         Bitmap,
>         RebuildMapOpt,
>         InvalidBackup,
> +       ActivateDomains
>  };
> 
>  /* structures read from config file */
> @@ -1031,6 +1032,7 @@ extern int CreateBitmap(char *filename, int
> force, char uuid[16], unsigned long long array_size,
>                         int major);
>  extern int ExamineBitmap(char *filename, int brief, struct supertype
> *st); +extern int Activate_Domains(char *rule_name);
>  extern int bitmap_update_uuid(int fd, int *uuid, int swap);
>  extern unsigned long bitmap_sectors(struct bitmap_super_s *bsb);
> 
> diff --git a/policy.c b/policy.c
> index ba976db..81d3e70 100644
> --- a/policy.c
> +++ b/policy.c
> @@ -764,3 +764,144 @@ int policy_check_path(struct mdinfo *disk,
> struct map_ent *array) fclose(f);
>         return rv == 5;
>  }
> +
> +/* invocation of udev rule file */
> +char udev_template_start[] =
> +"# do not edit this file, it will be overwritten on update\n"
> +"\n"
> +"SUBSYSTEM!=\"block\", GOTO=\"md_autorebuild_end\"\n"
> +"\n"
> +"ENV{ID_FS_TYPE}==\"linux_raid_member\",
> GOTO=\"md_autorebuild_end\"\n"
> +"ENV{ID_FS_TYPE}==\"isw_raid_member\",
> GOTO=\"md_autorebuild_end\"\n" +"\n"; +
> +/* ending of udev rule file */
> +char udev_template_end[] =
> +"\n"
> +"LABEL=\"md_autorebuild_end\"\n"
> +"\n";
> +
> +/* find rule named rule_type and return its value */
> +char *find_rule(struct rule *rule, char *rule_type)
> +{
> +       while (rule) {
> +               if (rule->name == rule_type)
> +                       return rule->value;
> +
> +               rule = rule->next;
> +       }
> +       return NULL;
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
> +       char line[1024];
> +       char *r = find_rule(rule, rule_path);
> +       if (!r)
> +               return -1;
> +
> +       snprintf(line, sizeof(line) - 1, UDEV_RULE_FORMAT, r);
> +       return write(fd, line, strlen(line));
> +}
> +
> +/* Generate single entry in udev rule basing on POLICY line found in
> config
> + * file. Take only those with paths, only first occurrence if paths
> are equal
> + * and if actions supports handling of spares (>=act_spare_same_slot)
> + */
> +int generate_entries(int fd)
> +{
> +       struct pol_rule *loop, *dup;
> +       char *loop_value, *dup_value;
> +       int duplicate;
> +       int written = 0;
> +
> +       for (loop = config_rules; loop; loop = loop->next) {
> +               if (loop->type != rule_policy && loop->type !=
> rule_part)
> +                       continue;
> +               duplicate = 0;
> +
> +               /* only policies with paths and with actions
> supporting
> +                * bare disks are considered */
> +               loop_value = find_rule(loop->rule, pol_act);
> +               if (!loop_value || map_act(loop_value) <
> act_spare_same_slot)
> +                       continue;
> +               loop_value = find_rule(loop->rule, rule_path);
> +               if (!loop_value)
> +                       continue;
> +               for (dup = config_rules; dup != loop; dup =
> dup->next) {
> +                       if (dup->type != rule_policy && loop->type !=
> rule_part)
> +                               continue;
> +                       dup_value = find_rule(dup->rule, pol_act);
> +                       if (!dup_value || map_act(dup_value) <
> act_spare_same_slot)
> +                               continue;
> +                       dup_value = find_rule(dup->rule, rule_path);
> +                       if (!dup_value)
> +                               continue;
> +                       if (strcmp(loop_value, dup_value) == 0) {
> +                               duplicate = 1;
> +                               break;
> +                       }
> +               }
> +
> +               /* not a dup or first occurrence */
> +               if (!duplicate) {
> +                       if (write_rule(loop->rule, fd) == -1)
> +                               return 0;
> +                       written++;
> +               }
> +       }
> +       return written;
> +}
> +
> +/* Activate_Domains routine creates dynamic udev rules used to handle
> + * hot-plug events for bare devices (and making them spares)
> + */
> +int Activate_Domains(char *rule_name)
> +{
> +       int fd = 0;
> +       int rv;
> +       char udev_rule_file[PATH_MAX];
> +
> +       if (rule_name)
> +               fd = creat(udev_rule_file,
> +                          S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);

Hmmm... udev_rule_file is not initialised!   I don't think you tested
this very well.

I've fixed this an various other things, including making the option
   --udev-rules

and applied it.

Thanks,
NeilBrown


> +       else
> +               fd = dup(fileno(stdout));
> +       if (fd == -1)
> +               return 1;
> +
> +       /* write static invocation */
> +       if (write(fd, udev_template_start,
> +               sizeof(udev_template_start) - 1) == -1) {
> +               close(fd);
> +               if (rule_name)
> +                       unlink(udev_rule_file);
> +               return 1;
> +       }
> +
> +       /* iterate, if none created or error occurred, remove file */
> +       rv = generate_entries(fd);
> +       if (rv <= 0) {
> +               close(fd);
> +               if (rule_name)
> +                       unlink(udev_rule_file);
> +               return rv == -1 ? -1 : 0;
> +       }
> +
> +       /* write ending */
> +       if (write(fd, udev_template_end, sizeof(udev_template_end) -
> 1) == -1) {
> +               close(fd);
> +               if (rule_name)
> +                       unlink(udev_rule_file);
> +               return 1;
> +       }
> +
> +       close(fd);
> +       return 0;
> +}
> --
> 1.7.1
> 
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Hawrylewicz
> Czarnowski, Przemyslaw Sent: Thursday, December 23, 2010 4:44 PM To:
> Neil Brown Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech;
> Ciechanowski, Ed; Williams, Dan J Subject: RE: Autorebuild, new
> dynamic udev rules for hot-plugs
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Hawrylewicz Czarnowski,
> > Przemyslaw Sent: Tuesday, November 23, 2010 6:02 PM
> > To: Neil Brown
> > Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Ciechanowski,
> > Ed; Labun, Marcin; Czarnowska, Anna; Williams, Dan J
> > Subject: RE: Autorebuild, new dynamic udev rules for hot-plugs
> >
> > > -----Original Message-----
> > > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > > owner@vger.kernel.org] On Behalf Of Neil Brown
> > > Sent: Tuesday, November 23, 2010 2:17 AM
> > > To: Williams, Dan J
> > > Cc: Hawrylewicz Czarnowski, Przemyslaw;
> > > linux-raid@vger.kernel.org; Neubauer, Wojciech; Ciechanowski, Ed;
> > > Labun, Marcin; Czarnowska, Anna
> > > Subject: Re: Autorebuild, new dynamic udev rules for hot-plugs
> > >
> > > On Mon, 22 Nov 2010 16:11:41 -0800
> > > Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > > On 11/22/2010 3:50 PM, Hawrylewicz Czarnowski, Przemyslaw wrote:
> > > > >> Four comments.
> > > > >>
> > > > >> 1/ I wouldn't write a file in /lib/udev/rules.d/
> > > > >>    I think it should be written to "/dev/.udev/rules.d/"
> > > > >>    which is referred to as the "temporary rules directory"
> > > > >>    in the udev documentation.
> > > > > I am not sure if it is what we are looking for. Temporary
> > > > > means they
> > > disappear after reboot. It is OK as cold-plug does not need
> > > support for bare disks (or maybe I am wrong?). But in such case,
> > > one who wants to use autorebuild should invoke mdadm
> > > --activate-domains for example in /etc/init.d/local.boot or
> > > somewhere else. Second idea here is to use
> > > ActivateDomain() when one starts monitor with autorebuild enabled.
> > > Which one? I would prefer to leave it as it was written initially
> > > (considering comment #4). Then, if one removes policies from
> > > config, invoking -- activate-domains should reset/remove rules
> > > (but see #3)
> > > >
> > > > The intent was always to have this be something reinitialized
> > > > at boot. Putting these in the temporary rule directory also
> > > > precludes them from being added to the initramfs where they are
> > > > not needed / potentially confusing.
> > > >
> > > > The other intent was to only match the pci paths for the
> > > > controllers we cared about.  That does not appear to be a part
> > > > of this patch.
> > >
> > > Can you define "we cared about".  Don't we care about everything
> > > listed
> > in
> > > mdadm.conf??
> > >
> > >
> > > >
> > > > >
> > > > >>
> > > > >> 2/ I would be good to process the type=disk or type=part
> > > > >> part of the policy into the rules file as well.
> > > > > OK
> > > > >
> > > > >>
> > > > >> 3/ I'm not very comfortable with hard-coding the name of the
> > > > >>     file to be created in the rules.d directory.  Maybe usage
> > > > >> could
> > be
> > > > >>        --activate-domains=63-md-whatever
> > > > > Good idea, but only if we store our rules
> > > > > in /dev/.udev/rules.d.
> > > Otherwise it would be difficult to maintain all generated rules
> > > and
> > remove
> > > the old ones... I would leave default if not given by user, but
> > > one can pass any file name.
> > > >
> > > > The issue is that this namespace belongs to the distro and since
> > > > they need to modify initscripts to turn this feature on might as
> > > > well dump the entirety of the naming responsibility to the user.
> > > >
> > > > >> 4/ I don't think it is good to have an incomplete file in
> > > > >> rules.d
> > that
> > > udev
> > > > >>     might accidentally read.  We should create the file with
> > > > >> a name
> > > with a
> > > > >>     leading '.' (assuming udev ignores those, I haven't
> > > > >> checked) and
> > > then
> > > > >>     rename it after it has been completely written.
> > > > > You're right. In theory, such partial udev rules are excluded
> > > > > when
> > udev
> > > can't interpret them properly. I have looked into udev's sources
> > > and
> > found
> > > that it looks for "*.rules" files. All other file extensions are
> > > ignored. Files with leading dots are also omitted. I would prefer
> > > to create<name>.temp file and then rename it into<name>.rules.
> > > >
> > > > There must be an existing convention for this sort of the thing,
> > > > if so let's not invent another one.
> > I haven't found anything similar. Just mountall, but it writes
> > single line in one "shot"... Both options with extension or with
> > leading dot will work.
> >
> > >
> > > We could avoid both these issues by just writing the new rules
> > > file to stdout.
> > > When when the init script gets it wrong, it isn't our fault :-)
> > I like that idea at this stage. Later on we might develop better
> > solution (see below)
> >
> > >
> > > But I don't really like that.  At least there should be a simple
> > > and uniform way to propagate any mdadm.conf changes into udev.
> > >
> > > Maybe the name of the rules file should be given in mdadm.conf,
> > > and e.g. mdadm --check-config
> > > would report any syntax errors, report any inconsistencies with
> > > current arrays, and update the udev file if necessary..
> > >
> > > Maybe leave that for 3.2.1, and just support '--activate-
> > domains=filename'
> > > for now.
> > Let me extend this thought a little. As I mentioned above I like the
> > idea of writing rule to stdout. Or if somebody wants to pass a file
> > name, just write the file in current directory - similar to the way
> > one creates mdadm.conf with mdadm --examine (but with small
> > improvement:).
> Replying to my last post I would like to present new patch based on
> the above scheme. I also want to raise the discussion again, as this
> thread is dead for a while...
> 
> Please comment.
> 
> > But the general problem is to find "simple and uniform way".
> > Something distro-independent. Rules should be prepared once, right
> > after config file is finished. Fire and forget:) We need to handle
> > hot/cold-plug events for action=spare, and hot-plug events for
> > actions=spare-same-slot. Considering we use temporary udev rules
> > directory they need to be regenerated each reboot, putting attention
> > at the moment when we have to do it so we handle all cases. What
> > options then?
> >
> > As a last resort, maybe just a note in man pages with possibilities,
> > leaving implementation to user/admin?
> >
> > >
> > > ???
> > >
> > > NeilBrown
> > >
> > >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-raid" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

