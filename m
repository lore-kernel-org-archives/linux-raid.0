From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Man pages update for policy framework
Date: Mon, 31 Jan 2011 11:41:32 +1100
Message-ID: <20110131114132.03f63e52@notabene.brown>
References: <20110128172957.12802.62262.stgit@gklab-128-080.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110128172957.12802.62262.stgit@gklab-128-080.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 28 Jan 2011 18:29:57 +0100 Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> Includes description of POLICY line in /etc/mdadm.conf
> and of changes in Monitor and Incremental related to autorebuild.
> 
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
> ---
>  mdadm.8.in   |   37 +++++++++++++++++++++--
>  mdadm.conf.5 |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 124 insertions(+), 5 deletions(-)

Applied, thanks.

NeilBrown

> 
> diff --git a/mdadm.8.in b/mdadm.8.in
> index ac87b47..f87578d 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -1330,6 +1330,11 @@ The device name given should be a kernel device name such as "sda",
>  not a name in
>  .IR /dev .
>  
> +.TP
> +.BR \-\-path=
> +Only used with \-\-fail. Allows the failed device to be automatically replaced
> +by a new device without metadata if it appears at specified path.
> +
>  .SH For Monitor mode:
>  .TP
>  .BR \-m ", " \-\-mail
> @@ -1401,6 +1406,18 @@ alert for every array found at startup.  This alert gets mailed and
>  passed to the alert program.  This can be used for testing that alert
>  message do get through successfully.
>  
> +.TP
> +.BR \-\-no\-sharing
> +Allows to run monitoring without moving spares between arrays.
> +Only one monitoring process started with
> +.B \-\-scan
> +is allowed.
> +Any subsequent call of
> +.B mdadm \-F \-\-scan
> +must also use
> +.B \-\-no\-sharing
> +option.
> +
>  .SH ASSEMBLE MODE
>  
>  .HP 12
> @@ -1951,6 +1968,8 @@ As well as reporting events,
>  may move a spare drive from one array to another if they are in the
>  same
>  .B spare-group
> +or
> +.B domain
>  and if the destination array has a failed drive but no spares.
>  
>  If any devices are listed on the command line,
> @@ -2057,6 +2076,8 @@ notices that an array is degraded when it first sees the array.
>  .B MoveSpare
>  A spare drive has been moved from one array in a
>  .B spare-group
> +or
> +.B domain
>  to another to allow a failed drive to be replaced.
>  (syslog priority: Info)
>  
> @@ -2109,6 +2130,7 @@ For
>  to move spares from one array to another, the different arrays need to
>  be labeled with the same
>  .B spare-group
> +or the spares must be allowed to migrate through matching POLICY domains
>  in the configuration file.  The
>  .B spare-group
>  name can be any string; it is only necessary that different spare
> @@ -2125,6 +2147,11 @@ first.
>  If the removal succeeds but the adding fails, then it is added back to
>  the original array.
>  
> +If the spare group for degraded array is not defined mdadm will look
> +at the rules of spare migration specified by POLICY lines
> +in /etc/mdadm.conf and then follow similar steps as above if a matching
> +spare is found.
> +
>  .SH GROW MODE
>  The GROW mode is used for changing the size or shape of an active
>  array.
> @@ -2307,9 +2334,10 @@ adds the device to the array and conditionally starts the array.
>  
>  Note that
>  .I mdadm
> -will only add devices to an array which were previously working
> -(active or spare) parts of that array.  It does not currently support
> -automatic inclusion of a new drive as a spare in some array.
> +will always add devices to an array which were previously working
> +(active or spare) parts of that array. The support for automatic
> +inclusion of a new drive as a spare in some array requires
> +a configuration through POLICY in config file.
>  
>  The tests that
>  .I mdadm
> @@ -2341,7 +2369,8 @@ then only that style of metadata is accepted, otherwise
>  .I mdadm
>  finds any known version of metadata.  If no
>  .I md
> -metadata is found, the device is rejected.
> +metadata is found, the device may be still added to an array
> +as a spare if POLICY allows.
>  
>  .ig
>  .IP +
> diff --git a/mdadm.conf.5 b/mdadm.conf.5
> index e677ba9..75a911f 100644
> --- a/mdadm.conf.5
> +++ b/mdadm.conf.5
> @@ -418,6 +418,78 @@ The known metadata types are
>  .BR ddf ,
>  .BR imsm .
>  
> +.TP
> +.B POLICY
> +Allows to specify what automatic behavior is allowed on devices newly
> +appearing in the system and provides a way of marking spares that can
> +be moved to other array as well as the migration domains.
> +.I Domain
> +can be defined through
> +.I policy
> +line by specifying a domain name for a number of paths from
> +.BR /dev/disk/by-path/ .
> +A device may belong to several domains. Domain of an array is a union
> +of domains of all devices in that array. A spare can be automatically
> +moved from one array to another if the set of the destination array's
> +.I domains
> +contains all the
> +.I domains
> +of the new disk or if both arrays have the same
> +.IR spare-group .
> +
> +To update hot plug configuration it is necessary to execute
> +.B mdadm \-\-udev\-rules
> +command after changing config file
> +
> +Key words used in
> +.I POLICY
> +line and supported values:
> +
> +.RS 7
> +.TP
> +.B domain=
> +any arbitrary string
> +.TP
> +.B metadata=
> +0.9 1.x ddf or imsm
> +.TP
> +.B path=
> +file glob matching anything from 
> +.B /dev/disk/by-path
> +.TP
> +.B action=
> +include, re-add, spare, spare-same-slot, or force-spare
> +
> +.P
> +The
> +.I action
> +item determines the automatic behavior allowed for devices matching the
> +.I path
> +in the same line. If a device matches several lines with different
> +.I  actions
> +then the most permissive will apply. The ordering of policy lines
> +is irrelevant to the end result.
> +.TP
> +.B include
> +allows adding a disk to an array if metadata on that disk matches that array
> +.TP
> +.B re-add
> +will include device in the array if it appears to be a current member
> +or a member that was recently removed
> +.TP
> +.B spare
> +as above and additionally: if the device is bare it will
> +become a spare (for metadata the same line)
> +.TP
> +.B spare\-same\-slot
> +as above and additionally if given slot was used by an array that went
> +degraded recently and the device plugged in has no metadata then it will
> +be automatically added to that array (or it's container)
> +.TP
> +.B force-spare
> +as above and the disk will become a spare in remaining cases
> +.RE
> +
>  .SH EXAMPLE
>  DEVICE /dev/sd[bcdjkl]1
>  .br
> @@ -456,7 +528,25 @@ ARRAY /dev/md5 uuid=19464854:03f71b1b:e0df2edd:246cc977
>  ARRAY /dev/md/home UUID=9187a482:5dde19d9:eea3cc4a:d646ab8b
>  .br
>             auto=part
> -
> +.br
> +POLICY domain=domain1 metadata=imsm path=pci-0000:00:1f.2-scsi-*
> +.br
> +           action=spare
> +.br
> +POLICY domain=domain1 metadata=imsm path=pci-0000:04:00.0-scsi-[01]*
> +.br
> +           action=include
> +.br
> +# One domain comprising of devices attached to specified paths is defined.
> +.br
> +# Bare device matching first path will be made an imsm spare on hot plug.
> +.br
> +# If more than one array is created on devices belonging to domain1 and
> +.br
> +# one of them becomes degraded, then any imsm spare matching any path for
> +.br
> +# given domain name can be migrated.
> +.br
>  MAILADDR root@mydomain.tld
>  .br
>  PROGRAM /usr/sbin/handle\-mdadm\-events

