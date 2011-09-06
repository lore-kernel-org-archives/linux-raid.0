From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] FIX: Cannot continue reshape if incremental assembly is used
Date: Tue, 6 Sep 2011 14:34:42 -0700
Message-ID: <CAA9_cme3X1T+nE4+-ADHJ-MkOtywKbKmN7Gw=BngjePMK5wssg@mail.gmail.com>
References: <20110901131839.3293.49295.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110901131839.3293.49295.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, Sep 1, 2011 at 6:18 AM, Lukasz Dorau <lukasz.dorau@intel.com> w=
rote:
> Description of the bug:
> Interrupted reshape cannot be continued using incremental assembly.
> Array becomes inactive.
>
> Cause of the bug:
> Reshape tried to continue with insufficient number of disks
> added by incremental assembly (tested using capacity expansion).
>
> Solution:
> During reshape adding disks to array should be blocked until
> minimum required number of disks is ready to be added.

Can you provide a script test-case to reproduce the problem?

> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
> =A0Assemble.c | =A0 39 +++++++++++++++++++++++++++++++++++++++
> =A01 files changed, 39 insertions(+), 0 deletions(-)
>
> diff --git a/Assemble.c b/Assemble.c
> index 25cfec1..da43162 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1531,6 +1531,45 @@ int assemble_container_content(struct supertyp=
e *st, int mdfd,
>
> =A0 =A0 =A0 =A0if (sra)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sysfs_free(sra);
> + =A0 =A0 =A0 if (content->reshape_active) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int disks_counter =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int required_disks;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 required_disks =3D content->array.raid_=
disks;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* check if disks are removed */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (content->delta_disks < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 required_disks +=3D con=
tent->delta_disks;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Count devices available for assembla=
tion.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 * =A0In case of incremental assemblatio=
n during reshape
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 * =A0allow to add disks only if require=
d minimum number of disks
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 * =A0is already collected to avoid asse=
mblation problem.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 * =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (dev =3D content->devs; dev; dev =3D=
 dev->next) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dev->disk.raid_disk=
 >=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 disks_c=
ounter++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* allow for degradation */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (content->array.level) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 6:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 required_disks--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 4:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 5:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 required_disks--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* check now, if number of disks allows=
 for assemblation
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 * =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (disks_counter < required_disks) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (verbose >=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf=
(stderr, Name
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ": %s not assembled with %d devices "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 "(required disks for assemblation: %i).\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 chosen_name, disks_counter,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 required_disks);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_subarray(content);
> + =A0 =A0 =A0 }

Checking that the expected number of disks is available is something
the existing code already does, so I don't understand why we need
another open-coded check?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
