From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: [PATCH 1/2] man mdadm: add information for MDADM_EXPERIMENTAL flag
Date: Tue, 22 Mar 2011 13:10:06 +0000
Message-ID: <AANLkTi=dqmKeXeHH2wJUfv3wrXc5uLHVFaCnuNONvNFi@mail.gmail.com>
References: <20110322114634.30235.97064.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110322114634.30235.97064.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On 22 March 2011 11:46, Adam Kwolek <adam.kwolek@intel.com> wrote:
> Update man for MDADM_EXPERIMENTAL flag.
>
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>
> =C2=A0mdadm.8.in | =C2=A0 12 ++++++++++++
> =C2=A01 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 4b70e20..96945ae 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -2229,6 +2229,18 @@ in a container can be converted between levels=
 where those levels are
> =C2=A0supported by the container, and the conversion is on of those l=
isted
> =C2=A0above.
>
> +Grow functionality (e.g. expand number of raid devices) for Intel's
> +IMSM container format has experimental status. It is guarded by
> +.B MDADM_EXPERIMENTAL
> +environment variable. This is due to the following reasons:
> +
> +1. Native Intel's IMSM check-pointing is not fully implemented yet.
> +This causes IMSM incompatibility during grow process: grew array can=
not
> +be roamed between Windows(R) and Linux systems.
> +
> +2. Interrupting grow operation is not recommended, because
> +for Intel's IMSM container format it is not fully tested yet.
> +
> =C2=A0.SS SIZE CHANGES
> =C2=A0Normally when an array is built the "size" is taken from the sm=
allest
> =C2=A0of the drives. =C2=A0If all the small drives in an arrays are, =
one at a
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

My small modifications (spelling?), which might not be correct.

 mdadm.8.in |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 4b70e20..96945ae 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2229,6 +2229,18 @@ in a container can be converted between levels
where those levels are
 supported by the container, and the conversion is on of those listed
 above.

+Grow functionality (e.g. expand a number of raid devices) for Intel's
+IMSM container format has an experimental status. It is guarded by the
+.B MDADM_EXPERIMENTAL
+environment variable. This is due to the following reasons:
+
+1. Native Intel's IMSM check-pointing is not fully implemented yet.
+This causes IMSM incompatibility during the grow process: a grown arra=
y cannot
+roam between Windows(R) and Linux systems.
+
+2. Interrupting a grow operation is not recommended, because it
+has not been fully tested for Intel's IMSM container format yet.
+
 .SS SIZE CHANGES
 Normally when an array is built the "size" is taken from the smallest
 of the drives.  If all the small drives in an arrays are, one at a


// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
