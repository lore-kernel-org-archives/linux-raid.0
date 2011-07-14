From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdadm.8: Disk coercion with IMSM metadata.
Date: Thu, 14 Jul 2011 12:26:49 +1000
Message-ID: <20110714122649.5bd2c91e@notabene.brown>
References: <20110713101702.26642.74636.stgit@maciek.naruszewicz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110713101702.26642.74636.stgit@maciek.naruszewicz>
Sender: linux-raid-owner@vger.kernel.org
To: "maciej.naruszewicz" <maciej.naruszewicz@intel.com>
Cc: wojciech.neubauer@intel.com, adam.kwolek@intel.com, krzysztof.wojcik@intel.com, ed.ciechanowski@intel.com, linux-raid@vger.kernel.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, 13 Jul 2011 12:17:02 +0200 "maciej.naruszewicz"
<maciej.naruszewicz@intel.com> wrote:

> From: maciej.naruszewicz <maciej.naruszewicz@intel.com>
> 
> Actual sizes of disks from different producers may vary,
> even though they are claimed to have the same amount of
> space

Are you sure about this?

It was my understanding that some industry association has arranged an
agreement so that this does not happen.

http://www.idema.org/wp-content/plugins/download-monitor/download.php?id=1223

Do you have actual evidence that different drives from different
manufacturers have similar but not identical sizes?

NeilBrown




>        Since creating arrays using IMSM metadata doesn't
> support resizing arrays yet, there might be problems when
> replacing a disk with a slightly smaller one.
> 
> For the time being, disk coercion will not be implemented
> for IMSM, however it would be a good idea to inform the
> user how to deal with it. Our suggestion is to mention it
> in the manual page under the -z option and advise the user
> to create arrays using a little less space than the disks
> have.
> 
> Additionally, the part 'This value can not be used
> with CONTAINER metadata such as DDF and IMSM.' was not
> clear and was replaced.
> 
> Signed-off-by: maciej.naruszewicz <maciej.naruszewicz@intel.com>
> ---
>  mdadm.8.in |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 7e8981e..2690e2d 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -440,9 +440,16 @@ problems the array can be made bigger again with no loss with another
>  .B "\-\-grow \-\-size="
>  command.
>  
> -This value can not be used with
> -.B CONTAINER
> -metadata such as DDF and IMSM.
> +Actual sizes of disks from different manufacturers may slightly differ, even if
> +they are said to have the same amount of space. Changing array's size with the 
> +.B "\-\-grow \-\-size="
> +command is not supported yet by external metadatas such as DDF and IMSM. Creating RAID
> +arrays with the
> +.B \-z
> +option is advised so that the array's size is a bit smaller than the actual maximum
> +available data disk's size. Otherwise, replacing a disk in an array with the 'same'
> +disk from a different manufacturer is not guaranteed to be always possible due to
> +difference in device sizes. 
>  
>  .TP
>  .BR \-Z ", " \-\-array\-size=
> 
> ---------------------------------------------------------------------
> Intel Technology Poland sp. z o.o.
> z siedziba w Gdansku
> ul. Slowackiego 173
> 80-298 Gdansk
> 
> Sad Rejonowy Gdansk Polnoc w Gdansku, 
> VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
> numer KRS 101882
> 
> NIP 957-07-52-316
> Kapital zakladowy 200.000 zl
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.

