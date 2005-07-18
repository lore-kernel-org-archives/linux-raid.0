From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: Re: Re: Re[2]: Bugreport mdadm-2.0-devel-1
Date: Tue, 19 Jul 2005 00:08:11 +0300
Message-ID: <69444850.20050719000811@netvision.net.il>
References: <1684363827.20050706121331@netvision.net.il>
 <17100.29413.164442.415932@cse.unsw.edu.au>
 <1892534227.20050707043013@netvision.net.il>
 <17103.10618.547298.274604@cse.unsw.edu.au>
 <17111.5969.741703.944406@cse.unsw.edu.au>
Reply-To: Maxim Kozover <maximkoz@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <17111.5969.741703.944406@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks much, Neil, will try.

Thanks,

Maxim.

NB> On Saturday July 9, neilb@cse.unsw.edu.au wrote:
>> On Thursday July 7, maximkoz@netvision.net.il wrote:
>> > Hi Neil!
>> > Thanks much for your help, array creation using devel-2 just works,
>> > however, the array can't be assembled again after it's stopped:(
>> 
>> Hmm, yeh, nor it can :-(
>> 
>> I'm not sure when I'll have time to look at this (I'm on leave at the
>> moment with family visiting and such) but I'll definitely get back to
>> you by Thursday if not before.

NB> Sorry for the delay.

NB> The following patch against -devel2 should fix these problems if
NB> (when?) you get more, please let me know.

NB> NeilBrown

NB> Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

NB> ### Diffstat output
NB>  ./Assemble.c |   13 ++++++++++++-
NB>  ./Query.c    |   33 +++++++++++++++++++--------------
NB>  ./mdadm.h    |    2 +-
NB>  ./super0.c   |    1 +
NB>  ./super1.c   |    4 ++--
NB>  5 files changed, 35 insertions(+), 18 deletions(-)

NB> diff ./Assemble.c~current~ ./Assemble.c
NB> --- ./Assemble.c~current~       2005-07-15 10:13:04.000000000 +1000
NB> +++ ./Assemble.c        2005-07-15 10:37:59.000000000 +1000
NB> @@ -473,6 +473,7 @@ int Assemble(struct supertype *st, char 
NB>                 if (!devices[j].uptodate)
NB>                         continue;
NB>                 info.disk.number = i;
NB> +               info.disk.raid_disk = i;
NB>                 info.disk.state = desired_state;
 
NB>                 if (devices[j].uptodate &&
NB> @@ -526,7 +527,17 @@ int Assemble(struct supertype *st, char 
 
NB>         /* Almost ready to actually *do* something */
NB>         if (!old_linux) {
NB> -               if (ioctl(mdfd, SET_ARRAY_INFO, NULL) != 0) {
NB> +               int rv;
NB> +               if ((vers % 100) >= 1) { /* can use different versions */
NB> +                       mdu_array_info_t inf;
NB> +                       memset(&inf, 0, sizeof(inf));
NB> +                       inf.major_version = st->ss->major;
NB> +                       inf.minor_version = st->minor_version;
NB> +                       rv = ioctl(mdfd, SET_ARRAY_INFO, &inf);
NB> +               } else 
NB> +                       rv = ioctl(mdfd, SET_ARRAY_INFO, NULL);
NB> +
NB> +               if (rv) {
NB>                         fprintf(stderr, Name ":
NB> SET_ARRAY_INFO failed for %s: %s\n",
NB>                                 mddev, strerror(errno));
NB>                         return 1;

NB> diff ./Query.c~current~ ./Query.c
NB> --- ./Query.c~current~  2005-07-07 09:19:53.000000000 +1000
NB> +++ ./Query.c   2005-07-15 11:38:18.000000000 +1000
NB> @@ -105,26 +105,31 @@ int Query(char *dev)
NB>         if (superror == 0) {
NB>                 /* array might be active... */
NB>                 st->ss->getinfo_super(&info, super);
NB> -               mddev = get_md_name(info.array.md_minor);
NB> -               disc.number = info.disk.number;
NB> -               activity = "undetected";
NB> -               if (mddev && (fd = open(mddev, O_RDONLY))>=0) {
NB> -                       if (md_get_version(fd) >= 9000 &&       
NB> -                           ioctl(fd, GET_ARRAY_INFO, &array)>= 0) {
NB> -                               if (ioctl(fd, GET_DISK_INFO, &disc) >= 0 &&
NB> -                                  
NB> makedev((unsigned)disc.major,(unsigned)disc.minor) == stb.st_rdev)
NB> -                                       activity = "active";
NB> -                               else
NB> -                                       activity = "mismatch";
NB> +               if (st->ss->major == 0) {
NB> +                       mddev = get_md_name(info.array.md_minor);
NB> +                       disc.number = info.disk.number;
NB> +                       activity = "undetected";
NB> +                       if (mddev && (fd = open(mddev, O_RDONLY))>=0) {
NB> +                               if (md_get_version(fd) >= 9000 &&
NB> +                                   ioctl(fd, GET_ARRAY_INFO, &array)>= 0) {
NB> +                                       if (ioctl(fd, GET_DISK_INFO, &disc) >= 0 &&
NB> +                                          
NB> makedev((unsigned)disc.major,(unsigned)disc.minor) == stb.st_rdev)
NB> +                                               activity = "active";
NB> +                                       else
NB> +                                               activity = "mismatch";
NB> +                               }
NB> +                               close(fd);
NB>                         }
NB> -                       close(fd);
NB> +               } else {
NB> +                       activity = "unknown";
NB> +                       mddev = "array";
NB>                 }
NB> -               printf("%s: device %d in %d device %s %s
NB> md%d.  Use mdadm --examine for more detail.\n",
NB> +               printf("%s: device %d in %d device %s %s %s. 
NB> Use mdadm --examine for more detail.\n",
NB>                        dev, 
NB>                        info.disk.number, info.array.raid_disks,
NB>                        activity,
NB>                        map_num(pers, info.array.level),
NB> -                      info.array.md_minor);
NB> +                      mddev);
NB>         }
NB>         return 0;
NB>  }

NB> diff ./mdadm.h~current~ ./mdadm.h
NB> --- ./mdadm.h~current~  2005-07-07 09:19:53.000000000 +1000
NB> +++ ./mdadm.h   2005-07-15 10:15:51.000000000 +1000
NB> @@ -73,7 +73,7 @@ struct mdinfo {
NB>         mdu_array_info_t        array;
NB>         mdu_disk_info_t         disk;
NB>         __u64                   events;
NB> -       unsigned int            uuid[4];
NB> +       int                     uuid[4];
NB>  };
 
NB>  #define Name "mdadm"

NB> diff ./super0.c~current~ ./super0.c
NB> --- ./super0.c~current~ 2005-07-07 09:19:53.000000000 +1000
NB> +++ ./super0.c  2005-07-15 11:27:12.000000000 +1000
NB> @@ -205,6 +205,7 @@ static void getinfo_super0(struct mdinfo
NB>         info->disk.major = sb->this_disk.major;
NB>         info->disk.minor = sb->this_disk.minor;
NB>         info->disk.raid_disk = sb->this_disk.raid_disk;
+       info->>disk.number = sb->this_disk.number;
 
NB>         info->events = md_event(sb);
 

NB> diff ./super1.c~current~ ./super1.c
NB> --- ./super1.c~current~ 2005-07-07 09:19:53.000000000 +1000
NB> +++ ./super1.c  2005-07-15 11:25:04.000000000 +1000
NB> @@ -278,7 +278,7 @@ static void getinfo_super1(struct mdinfo
 
NB>         info->disk.major = 0;
NB>         info->disk.minor = 0;
NB> -
+       info->>disk.number = __le32_to_cpu(sb->dev_number);
NB>         if (__le32_to_cpu(sb->dev_number) >= __le32_to_cpu(sb->max_dev) ||
NB>             __le32_to_cpu(sb->max_dev) > 512)
NB>                 role = 0xfffe;
NB> @@ -303,7 +303,7 @@ static void getinfo_super1(struct mdinfo
 
NB>         for (i=0; i< __le32_to_cpu(sb->max_dev); i++) {
NB>                 role = __le16_to_cpu(sb->dev_roles[i]);
NB> -               if (role == 0xFFFF || role < info->array.raid_disks)
NB> +               if (/*role == 0xFFFF || */role < info->array.raid_disks)
NB>                         working++;
NB>         }


