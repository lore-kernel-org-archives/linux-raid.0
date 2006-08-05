From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [PATCH 010 of 10] md: Allow the write_mostly flag to be set via sysfs.
Date: Sat, 5 Aug 2006 01:59:50 -0400
Message-ID: <170fa0d20608042259u3b6b75fah36c3777dfbf33fa6@mail.gmail.com>
References: <20060601150955.27444.patches@notabene>
	 <1060601051418.27661@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060601051418.27661@suse.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Aside from this write-mostly sysfs support, is there a way to toggle
the write-mostly bit of an md member with mdadm?  I couldn't identify
a clear way to do so.

It'd be nice if mdadm --assemble would honor --write-mostly...


On 6/1/06, NeilBrown <neilb@suse.de> wrote:
>
> It appears in /sys/mdX/md/dev-YYY/state
> and can be set or cleared by writing 'writemostly' or '-writemostly'
> respectively.
>
> Signed-off-by: Neil Brown <neilb@suse.de>
>
> ### Diffstat output
>  ./Documentation/md.txt |    5 +++++
>  ./drivers/md/md.c      |   12 ++++++++++++
>  2 files changed, 17 insertions(+)
>
> diff ./Documentation/md.txt~current~ ./Documentation/md.txt
> --- ./Documentation/md.txt~current~     2006-06-01 15:05:30.000000000 +1000
> +++ ./Documentation/md.txt      2006-06-01 15:05:30.000000000 +1000
> @@ -309,6 +309,9 @@ Each directory contains:
>               faulty   - device has been kicked from active use due to
>                           a detected fault
>               in_sync  - device is a fully in-sync member of the array
> +             writemostly - device will only be subject to read
> +                        requests if there are no other options.
> +                        This applies only to raid1 arrays.
>               spare    - device is working, but not a full member.
>                          This includes spares that are in the process
>                          of being recoverred to
> @@ -316,6 +319,8 @@ Each directory contains:
>         This can be written to.
>         Writing "faulty"  simulates a failure on the device.
>         Writing "remove" removes the device from the array.
> +       Writing "writemostly" sets the writemostly flag.
> +       Writing "-writemostly" clears the writemostly flag.
>
>        errors
>         An approximate count of read errors that have been detected on
>
> diff ./drivers/md/md.c~current~ ./drivers/md/md.c
> --- ./drivers/md/md.c~current~  2006-06-01 15:05:30.000000000 +1000
> +++ ./drivers/md/md.c   2006-06-01 15:05:30.000000000 +1000
> @@ -1737,6 +1737,10 @@ state_show(mdk_rdev_t *rdev, char *page)
>                 len += sprintf(page+len, "%sin_sync",sep);
>                 sep = ",";
>         }
> +       if (test_bit(WriteMostly, &rdev->flags)) {
> +               len += sprintf(page+len, "%swrite_mostly",sep);
> +               sep = ",";
> +       }
>         if (!test_bit(Faulty, &rdev->flags) &&
>             !test_bit(In_sync, &rdev->flags)) {
>                 len += sprintf(page+len, "%sspare", sep);
> @@ -1751,6 +1755,8 @@ state_store(mdk_rdev_t *rdev, const char
>         /* can write
>          *  faulty  - simulates and error
>          *  remove  - disconnects the device
> +        *  writemostly - sets write_mostly
> +        *  -writemostly - clears write_mostly
>          */
>         int err = -EINVAL;
>         if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
> @@ -1766,6 +1772,12 @@ state_store(mdk_rdev_t *rdev, const char
>                         md_new_event(mddev);
>                         err = 0;
>                 }
> +       } else if (cmd_match(buf, "writemostly")) {
> +               set_bit(WriteMostly, &rdev->flags);
> +               err = 0;
> +       } else if (cmd_match(buf, "-writemostly")) {
> +               clear_bit(WriteMostly, &rdev->flags);
> +               err = 0;
>         }
>         return err ? err : len;
>  }
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
